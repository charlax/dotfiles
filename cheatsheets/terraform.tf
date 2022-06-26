# aws_iam_role_policy is for inline policies
# aws_iam_role_policy_attachment is for attaching a (customer or AWS) managed policy
resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = ["firehose:PutRecord", "firehose:PutRecordBatch"]
    resources = [aws_kinesis_firehose_delivery_stream.stream.arn]
  }
}

resource "aws_iam_role_policy" "lambda" {
  role   = aws_iam_role.lambda.name
  policy = data.aws_iam_policy_document.this.json
}
