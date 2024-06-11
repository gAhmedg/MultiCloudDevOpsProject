provider "aws" {
      
        access_key = "AKIA6OBRKA3MMUNZRSFL"
        secret_key = "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"
}






resource "aws_s3_bucket" "terraform_state"{
    bucket = "ivolve-remote-statefile"
    lifecycle {
        prevent_destroy = true
  } 
  }

resource "aws_s3_bucket_versioning" "enable"{
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "ivolve-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}



