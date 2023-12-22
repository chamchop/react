resource "aws_s3_bucket" "bucketed" {
  bucket = "www.${var.bucket_name}"
}

data "aws_s3_bucket" "selected-bucket" {
    bucket = aws_s3_bucket.bucketed.bucket
}

resource "aws_s3_object" "object-upload-html" {
    for_each = fileset("frontend/public/", "*.html")
    bucket = data.aws_s3_bucket.selected-bucket.bucket
    key = each.value
    source = "frontend/public/${each.value}"
    content_type = "text/html"
    etag = filemd5("frontend/public/${each.value}")
    acl = "public-read"
}

resource "aws_s3_object" "object-upload-jpg" {
    for_each = fileset("frontend/public/images/", "*.jpg")
    bucket = data.aws_s3_bucket.selected-bucket.bucket
    key = each.value
    source = "frontend/public/${each.value}"
    content_type = "image/jpg"
    etag = filemd5("frontend/public/images/${each.value}")
    acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website_config" {
    bucket = data.aws_s3_bucket.selected-bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.jpeg"
  }  
}

resource "aws_s3_bucket_versioning" "version-config" {
  bucket = data.aws_s3_bucket.selected-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_cors_configuration" "cors_config" {
  bucket = data.aws_s3_bucket.selected-bucket.bucket

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = [ "https://www.${var.domain_name}" ]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_control" {
    bucket = aws_s3_bucket.bucketed.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
    depends_on = [aws_s3_bucket_public_access_block.public_access_block]
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
    bucket = data.aws_s3_bucket.selected-bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket-acl" {
    depends_on = [
            aws_s3_bucket_ownership_controls.bucket_ownership_control,
            aws_s3_bucket_public_access_block.public_access_block,
        ]

    bucket = data.aws_s3_bucket.selected-bucket.id
    acl = "public-read"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = data.aws_s3_bucket.selected-bucket.id
    policy = data.aws_iam_policy_document.policy_doc_one.json
}

data "aws_iam_policy_document" "policy_doc_one" {
    statement {        
      sid = "AllowPublicRead"
      effect = "Allow"
      resources = [
        "arn:aws:s3:::www.${var.domain_name}",
        "arn:aws:s3:::www.${var.domain_name}/*",        
      ]
      actions = ["S3:GetObject"]
      principals {
        type = "*"
        identifiers = ["*"]
      }
    }
    depends_on = [aws_s3_bucket_acl.bucket-acl]
}