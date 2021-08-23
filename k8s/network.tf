#------------------
#k8s sg
#------------------
resource "aws_security_group" "k8s_sg" {
  name        = "k8s_sg"
  description = "web front securit group"
}

resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.k8s_sg.id
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.k8s_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}