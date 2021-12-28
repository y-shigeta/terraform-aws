variable "name" {}
#variable "policy" {}
variable "identifier" {}

resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}

data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeRegions", "s3:*"] # リージョン一覧を取得する
    resources = ["*"]
  }
}

resource "aws_iam_policy" "default" {
  name   = var.name
  policy = data.aws_iam_policy_document.allow_describe_regions.json
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

output "iam_role_name" {
  value = aws_iam_role.default.name
}
