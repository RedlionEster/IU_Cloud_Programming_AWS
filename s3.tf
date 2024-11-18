# Create an S3 bucket for static website hosting
resource "aws_s3_bucket" "site_bucket" {
  bucket = "${var.project_name}-bucket-${random_id.bucket_id.hex}"

  tags = {
    Name = var.project_name
  }
}

# Generate a random ID to ensure bucket name uniqueness
resource "random_id" "bucket_id" {
  byte_length = 4
}

# Configure bucket as a static website
resource "aws_s3_bucket_website_configuration" "site_bucket_website" {
  bucket = aws_s3_bucket.site_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Upload website files
resource "aws_s3_object" "site_files" {
  for_each = fileset("${path.module}/website", "**/*")

  bucket       = aws_s3_bucket.site_bucket.id
  key          = each.value
  source       = "${path.module}/website/${each.value}"
  content_type = lookup(var.mime_types, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}

# Set bucket policy to allow CloudFront access
resource "aws_s3_bucket_policy" "site_bucket_policy" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = data.aws_iam_policy_document.site_bucket_policy.json
}

data "aws_iam_policy_document" "site_bucket_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.site_oai.iam_arn]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site_bucket.arn}/*"]
  }
}
