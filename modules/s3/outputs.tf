# ---- modules/s3/outputs
output "bucket_name" {
  value = aws_s3_bucket.anonymous_bucket.bucket
}
