  resource "aws_ecr_repository" "ecr_repository_rewind" {
  name                 = "rewind/test-flask"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.default_tags
}
