variable "filename" { }
variable "function_name" { }
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "state" {
    filename = var.filename
    function_name = var.function_name
    role = aws_iam_role.iam_for_lambda.arn
    runtime = "nodejs12.x"
    handler = "lambda.handler"
}

resource "aws_cloudwatch_event_rule" "state" {
    name = "EC2_state_change"
    event_pattern = <<EOF
    {
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["*"]
  }
  }
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.state.name
  arn       = aws_lambda_function.state.arn
}