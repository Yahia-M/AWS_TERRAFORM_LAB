resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  //instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance-${terraform.workspace}"
  }
}
variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-08a6efd148b1f7504"
}
variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
  default     = "t2.micro"
}