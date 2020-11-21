resource "aws_s3_bucket_policy" "media" {
  bucket = "media.52poke.com"
  policy = jsonencode(
    {
      Id = "Policy52PokeMedia"
      Statement = [
        {
          Action = "s3:GetObject"
          Condition = {
            IpAddress = {
              "aws:SourceIp" = var.allow_ips
            }
          }
          Effect = "Allow"
          Principal = {
            AWS = "*"
          }
          Resource = "arn:aws:s3:::media.52poke.com/*"
          Sid      = "Allow from 52POKE"
        },
      ]
      Version = "2008-10-17"
    }
  )
}
