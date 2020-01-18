resource "aws_api_gateway_rest_api" "prod_malasada" {
  name = "prod-malasada"
  binary_media_types = [
    "*/*"
  ]
  tags = {
    "STAGE" = "prod"
  }
}