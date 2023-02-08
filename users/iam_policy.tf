resource "aws_iam_group_policy_attachment" "handson-attach" {
  group      = aws_iam_group.handson.name
  policy_arn = aws_iam_policy.instance-connect.arn
}

resource "aws_iam_group_policy_attachment" "awspolicy-attach" {
  group      = aws_iam_group.handson.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_policy" "instance-connect" {
  name        = "instance-connect"
  description = "for instance connect"
  policy = templatefile(
    "./policy/instant-connect-policy.json",
    {
      account_id = data.aws_caller_identity.current.account_id,
      aws_region = var.aws_region
    }
  )
}
