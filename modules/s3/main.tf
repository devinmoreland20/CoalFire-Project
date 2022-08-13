# ---- modules/s3/main

resource "aws_s3_bucket" "anonymous_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = var.tags
  }
}
#we are using this resource becuase the acl block on the aws_s3_bucket is deprecated. 
resource "aws_s3_bucket_acl" "anonymous_bucket_acl" {
  bucket = aws_s3_bucket.anonymous_bucket.id
  acl    = var.acl
}

resource "aws_s3_bucket_public_access_block" "anonymous" { #need this resource or bucket will be open 
  bucket = aws_s3_bucket.anonymous_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "anonymous" {
  bucket = aws_s3_bucket.anonymous_bucket.id

  rule {
    id = "move images to glacier"
    filter {
      prefix = "Images/"
    }
    status = "Enabled"
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
  rule {
    id = "Delete Logs after '90 days"
    filter {
      prefix = "Logs/"
    }
    status = "Enabled"
    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket_object" "Logs" {
  bucket = aws_s3_bucket.anonymous_bucket.bucket
  key    = "Logs"
  source = "/dev/null"
}
resource "aws_s3_bucket_object" "Images" {
  bucket = aws_s3_bucket.anonymous_bucket.bucket
  key    = "Images"
  source = "/dev/null"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse_encrypt" {
  bucket = aws_s3_bucket.anonymous_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
