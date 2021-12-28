
# Private Bucket
resource "aws_s3_bucket" "private" {
  bucket = "tfstate-pragmatic-terraform2"
  force_destroy = true

  versioning {
    enabled = true
  }
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Bucket policy
resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/* 
# Public Bucket
resource "aws_s3_bucket" "public" {
  bucket = "public-pragmatic-terraform"
  acl    = "public-read"
  force_destroy = true

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}
*/
