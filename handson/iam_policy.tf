resource "aws_iam_policy" "albcontroller_policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  description = "AWS Load Balancer Controller"
  policy = file("./policy/iam_policy.json")
}

resource "aws_iam_policy" "albcontroller_additional_policy" {
  name = "AWSLoadBalancerControllerAdditionalIAMPolicy"
  description = "AWS Load Balancer Controller Additional"
  policy = file("./policy/iam_policy_v1_to_v2_additional.json")
}

resource "aws_iam_role_policy_attachment" "csi-attach" {
  role = module.eks.eks_managed_node_groups["one"].iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

/*
resource "aws_iam_role_policy_attachment" "alb-attach1" {
  role = module.eks.eks_managed_node_groups["one"].iam_role_name
  policy_arn = aws_iam_policy.albcontroller_policy.arn
}

resource "aws_iam_role_policy_attachment" "alb-attach2" {
  role = module.eks.eks_managed_node_groups["one"].iam_role_name
  policy_arn = aws_iam_policy.albcontroller_additional_policy.arn
}
*/
