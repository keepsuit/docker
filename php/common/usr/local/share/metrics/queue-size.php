<?php

/**
 * Queue depth for autoscalers (KEDA metrics-api and friends).
 *
 * Served on a private port by the web server of this container, see
 * /etc/entrypoint.d/50-metrics.sh. Nothing routes that port from outside the
 * pod, so there is no authentication here.
 *
 * GET /_metrics/queue-size[?queues=high,default][&connection=redis]
 *  -> {"name":"high,default","size":42}
 *
 * Queues and connection are auto-discovered from the app when not given, so
 * apps need no configuration. Failures answer 500 on purpose: a scaler that
 * reads 0 from a broken app scales the workers away and jobs stop running.
 */

use Illuminate\Http\Request;
use Illuminate\Support\Arr;

ini_set('default_socket_timeout', '3');

header('Content-Type: application/json');

if (parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) !== '/_metrics/queue-size') {
    http_response_code(404);
    echo json_encode(['error' => 'not found']);

    return;
}

try {
    $basePath = getenv('APP_BASE_DIR') ?: '/app';

    require $basePath.'/vendor/autoload.php';

    $request = Request::capture();

    $app = require $basePath.'/bootstrap/app.php';
    $app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

    // A "queue" is a name, a comma separated list of names, or an array of either.
    $split = fn ($value) => collect(Arr::wrap($value))
        ->flatMap(fn ($item) => explode(',', (string) $item))
        ->map(fn (string $queue) => trim($queue))
        ->filter()
        ->values();

    $connection = $request->query('connection');
    $queues = $split($request->query('queues', []));

    if ($connection === null || $queues->isEmpty()) {
        // Detect queues from Horizon configuration
        $supervisors = collect(config('horizon.environments.'.$app->environment()) ?: [])
            ->map(fn (array $options, string $name) => array_merge(config("horizon.defaults.{$name}", []), $options))
            ->whenEmpty(fn () => collect(config('horizon.defaults') ?: []));

        foreach ($supervisors as $supervisor) {
            $queues = $queues->merge($split($supervisor['queue'] ?? []));
            $connection ??= $supervisor['connection'] ?? null;
        }
    }

    $connection ??= config('queue.default');

    $queues = $queues->unique()->values()
        ->whenEmpty(fn () => $split(config("queue.connections.{$connection}.queue", 'default')));

    $queue = $app->make('queue')->connection($connection);

    // Queue::size() is driver agnostic: on redis it counts pending + delayed +
    // reserved, on database every row in "jobs". No per-driver branching, and
    // delayed jobs are included so a scaled-to-zero worker still wakes up.
    echo json_encode([
        'name' => $queues->implode(','),
        'size' => $queues->sum(fn (string $name) => $queue->size($name)),
    ]);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
