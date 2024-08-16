#!/bin/sh

set -e

if [[ ! -z "$COMPOSER_GITHUB" ]]; then
  echo "🔐 Authenticating composer with GitHub..."
  composer config --global github-oauth.github.com "$COMPOSER_GITHUB"
fi

if [[ ! -z "$COMPOSER_GITLAB" ]]; then
  echo "🔐 Authenticating composer with Gitlab..."
  composer config --global gitlab-token.gitlab.com "$COMPOSER_GITLAB"
fi
