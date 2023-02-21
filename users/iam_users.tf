resource "aws_iam_group" "handson" {
  name = "handson"
}

resource "aws_iam_user" "housers" {
  count = var.instance_number
  name  = "houser${count.index}"
}

/*
resource "time_sleep" "iam_user" {
  create_duration = "20s"
  depends_on = [aws_iam_user.housers["${var.instance_number}"]]
}
*/

resource "aws_iam_user_login_profile" "profiles" {
  count                   = var.instance_number
  user                    = "houser${count.index}"
  password_reset_required = true
  password_length         = 10
}

resource "aws_iam_user_group_membership" "handson" {
  count  = var.instance_number
  user   = "houser${count.index}"
  groups = ["handson"]
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = false
  require_numbers                = false
  require_uppercase_characters   = false
  require_symbols                = false
  allow_users_to_change_password = false
}
