# ------------------
# time_sleep 180seconds
# ------------------
resource "time_sleep" "wait_200_seconds" {
  create_duration = "200s"
}
#------------------
#最新のAMI IDを取得
#------------------
data "aws_ami" "recent_amazon_linux2" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "state"
        values = ["available"]
    }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}
#------------------
#create k8sMaster-1 instance
#------------------
resource "aws_instance" "k8sMaster1" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  #aws上の自分のkey_nameを入れる
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./master_sh/k8s_master-1.sh")

  tags = {
    Name                        = "k8s-Master-1"
    "kubernetes.io/cluster/k8s" = "k8s-k8sMaster"
  }
}
# ------------------
# create k8s-worker1-1 instance
# ------------------
resource "aws_instance" "k8s-worker1-1" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
   user_data = file("./worker_sh/k8s_worker-1.sh")
  tags = {
    Name                        = "k8s-worker-1-1"
    "kubernetes.io/cluster/k8s" = "k8s-worker"
  }
  depends_on = [time_sleep.wait_200_seconds]
}
# ------------------
# create k8s-worker1-2 instance
# ------------------
resource "aws_instance" "k8s-worker1-2" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./worker_sh/k8s_worker-1.sh")
  tags = {
    Name                        = "k8s-worker-1-2"
    "kubernetes.io/cluster/k8s" = "k8s-worker"
  }
  depends_on = [time_sleep.wait_200_seconds]
}

#------------------
#create k8sMaster-2 instance
#------------------
resource "aws_instance" "k8sMaster2" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  #aws上の自分のkey_nameを入れる
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./master_sh/k8s_master-2.sh")

  tags = {
    Name                        = "k8s-Master-2"
    "kubernetes.io/cluster/k8s" = "k8s-k8sMaster"
  }
}
# ------------------
# create k8s-worker2-1 instance
# ------------------
resource "aws_instance" "k8s-worker2-1" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
   user_data = file("./worker_sh/k8s_worker-2.sh")
  tags = {
    Name                        = "k8s-worker-2-1"
    "kubernetes.io/cluster/k8s" = "k8s-worker"
  }
  depends_on = [time_sleep.wait_200_seconds]
}
#------------------
#create k8s-worker2-2 instance
#------------------
resource "aws_instance" "k8s-worker2-2" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./worker_sh/k8s_worker-2.sh")
  tags = {
    Name                        = "k8s-worker-2-2"
    "kubernetes.io/cluster/k8s" = "k8s-worker"
  }
  depends_on = [time_sleep.wait_200_seconds]
}

#------------------
#create k8sMaster-3 instance
#------------------
resource "aws_instance" "k8sMaster3" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  #aws上の自分のkey_nameを入れる
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./master_sh/k8s_master-3.sh")

  tags = {
    Name                        = "k8s-Master-3"
    "kubernetes.io/cluster/k8s" = "k8s-k8sMaster"
  }
}
# ------------------
# create k8s-worker3-1 instance
# ------------------
resource "aws_instance" "k8s-worker3-1" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
   user_data = file("./worker_sh/k8s_worker-3.sh")
  tags = {
    Name                        = "k8s-worker-3-1"
    "kubernetes.io/cluster/k8s" = "k8s-worker"
  }
  depends_on = [time_sleep.wait_200_seconds]
}
#------------------
#create k8s-worker3-2 instance
#------------------
resource "aws_instance" "k8s-worker3-2" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./worker_sh/k8s_worker-3.sh")
  tags = {
    Name                        = "k8s-worker-3-2"
    "kubernetes.io/cluster/k8s" = "k8s-worker"
  }
  depends_on = [time_sleep.wait_200_seconds]
}

#------------------
#create k8sMaster-4 instance
#------------------
resource "aws_instance" "k8sMaster4" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  #aws上の自分のkey_nameを入れる
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./master_sh/k8s_master-4.sh")

  tags = {
    Name                        = "k8s-Master-4"
    "kubernetes.io/cluster/k8s" = "k8s-k8sMaster"
  }
}
# ------------------
# create k8s-worker4-1 instance
# ------------------
resource "aws_instance" "k8s-worker4-1" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
   user_data = file("./worker_sh/k8s_worker-4.sh")
  tags = {
    Name                        = "k8s-worker-4-1"
    "kubernetes.io/cluster/k8s" = "k8s-worker"
  }
  depends_on = [time_sleep.wait_200_seconds]
}
#------------------
#create k8s-worker4-2 instance
#------------------
resource "aws_instance" "k8s-worker4-2" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./worker_sh/k8s_worker-4.sh")
  tags = {
    Name                        = "k8s-worker-4-2"
    "kubernetes.io/cluster/k8s" = "k8s-worker"
  }
  depends_on = [time_sleep.wait_200_seconds]
}

#------------------
#create k8sMaster-5 instance
#------------------
resource "aws_instance" "k8sMaster5" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  #aws上の自分のkey_nameを入れる
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./master_sh/k8s_master-5.sh")

  tags = {
    Name                        = "k8s-Master-5"
    "kubernetes.io/cluster/k8s" = "k8s-k8sMaster"
  }
}
# ------------------
# create k8s-worker5-1 instance
# ------------------
resource "aws_instance" "k8s-worker5-1" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
   user_data = file("./worker_sh/k8s_worker-5.sh")
  tags = {
    Name                        = "k8s-worker-5-1"
    "kubernetes.io/cluster/k8s" = "k8s-worker"
  }
  depends_on = [time_sleep.wait_200_seconds]
}
#------------------
#create k8s-worker5-2 instance
#------------------
resource "aws_instance" "k8s-worker5-2" {
  ami                         = data.aws_ami.recent_amazon_linux2.image_id
  instance_type               = "t2.medium"
  subnet_id                   = "subnet-31718a1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  key_name                    = "k8s"
  root_block_device {
    delete_on_termination = true
  }
  user_data = file("./worker_sh/k8s_worker-5.sh")
  tags = {
    Name                        = "k8s-worker-5-2"
    "kubernetes.io/cluster/k8s" = "k8s-worker"
  }
  depends_on = [time_sleep.wait_200_seconds]
}