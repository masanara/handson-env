output "user" {
  value = aws_iam_user.housers.*.name
}

output "password" {
  value = aws_iam_user_login_profile.profiles.*.password
}
