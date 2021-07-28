# --------------------------
# update ebs id
# --------------------------
resource "aws_ssm_parameter" "ebs_id" {
  name  = "ebs_id"
  type  = "String"
  value = aws_ebs_volume.k8s_ebs.id
}