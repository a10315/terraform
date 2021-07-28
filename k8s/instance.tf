# ------------------
# time_sleep 180seconds
# ------------------
resource "time_sleep" "wait_180_seconds" {
  create_duration = "180s"
}

#------------------
#create k8sMaster instance
#------------------
resource "aws_instance" "k8sMaster" {
  ami                         = "ami-0b276ad63ba2d6009"
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-0b84c394a32ce80a0"]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "tasylog"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./user_data_master.sh")

  tags = {
    Name                        = "${var.project}-k8s-k8sMaster"
    "kubernetes.io/cluster/k8s" = "k8s-k8sMaster"
  }
}
# ------------------
# create k8s-worker1 instance
# ------------------
resource "aws_instance" "k8s-worker1" {
  ami                         = "ami-0b276ad63ba2d6009"
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-05982324a47d31b22"]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "tasylog"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./user_data_worker.sh")
  tags = {
    Name                        = "${var.project}-k8s-worker1"
    "kubernetes.io/cluster/k8s" = "k8s-worker1"
  }
    depends_on = [time_sleep.wait_180_seconds]
}
#------------------
#create k8s-worker2 instance
#------------------
resource "aws_instance" "k8s-worker2" {
  ami                         = "ami-0b276ad63ba2d6009"
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-0ac4e93938853460e"]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "tasylog"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./user_data_worker.sh")
  tags = {
    Name                        = "${var.project}-k8s-worker2"
    "kubernetes.io/cluster/k8s" = "k8s-worker2"
  }
  depends_on = [time_sleep.wait_180_seconds]
}
