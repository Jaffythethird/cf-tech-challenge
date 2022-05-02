resource "aws_s3_bucket" "base" {
    
}

# Images folder
resource "aws_s3_object" "images_folder" {
    bucket = aws_s3_bucket.base.id
    key = "Images/"
    content_type = "application/x-directory"
}

resource "aws_s3_object" "logs_folder" {
    bucket = aws_s3_bucket.base.id
    key = "Logs/"
    content_type = "application/x-directory"
}

resource "aws_s3_bucket_lifecycle_configuration" "both" {
    bucket = aws_s3_bucket.base.id

    # Images folder
    rule {
        id = "images"

        filter {
            prefix = "Images/"
        }

        status = "Enabled"

        transition {
            days = 90
            storage_class = "GLACIER"
        }
    }

    # Logs folder
    rule {
        id = "logs"

        expiration {
            days = 90
        }

        filter {
            prefix = "Logs/"
        }

        status = "Enabled"
    }
}