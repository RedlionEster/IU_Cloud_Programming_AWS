variable "project_name" {
  description = "Name of the project"
  default     = "my-static-site"
}

variable "aws_region" {
  description = "AWS region for resource deployment"
  default     = "us-west-2"  # Update if needed
}
variable "mime_types" {
  type = map(string)
  default = {
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "gif"  = "image/gif"
  }
}