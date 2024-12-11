resource "aws_s3_bucket" "storage" {
  bucket = "docker-php-assets.keepsuit.com"
}

resource "aws_s3_bucket_public_access_block" "storage__bucket_public_access_block" {
  bucket = aws_s3_bucket.storage.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "storage__bucket_ownership_controls" {
  bucket = aws_s3_bucket.storage.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "storage__bucket_acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.storage__bucket_public_access_block,
    aws_s3_bucket_ownership_controls.storage__bucket_ownership_controls,
  ]
  bucket = aws_s3_bucket.storage.id
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "storage__cors" {
  bucket = aws_s3_bucket.storage.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "HEAD", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
  }
}

resource "aws_s3_bucket_policy" "storage__bucket_policy" {
  depends_on = [
    aws_s3_bucket_public_access_block.storage__bucket_public_access_block,
    aws_s3_bucket_ownership_controls.storage__bucket_ownership_controls,
  ]
  bucket = aws_s3_bucket.storage.id
  policy = data.aws_iam_policy_document.storage__bucket_policy_document.json
}

data "aws_iam_policy_document" "storage__bucket_policy_document" {
  statement {
    sid = "PublicReadMedia"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.storage.arn}/*",
    ]
  }
}

output "AWS_STORAGE_BUCKET" {
  value = aws_s3_bucket.storage.bucket
}

output "AWS_STORAGE_URL" {
  value = "https://s3.${aws_s3_bucket.storage.region}.amazonaws.com/${aws_s3_bucket.storage.bucket}"
}
