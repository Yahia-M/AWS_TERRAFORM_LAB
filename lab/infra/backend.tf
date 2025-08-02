// le code aui difinie le backend

terraform {
  backend "s3" {
    bucket = "bucket-backend-lab"
    key    = "terraform/state"
    region = "us-east-1"
    //dynamodb_table = "terraform-locks"
    encrypt = true
  }
}