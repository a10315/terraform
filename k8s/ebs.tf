# ------------------
# create ks8_ebs
# ------------------
resource "aws_ebs_volume" "k8s_ebs" {
  availability_zone = "ap-northeast-1d"
  size              = 3

}