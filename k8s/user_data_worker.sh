#!/bin/bash
sudo su
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker.service

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
 yum  -y  install kubelet-1.20.1 kubeadm-1.20.1 kubectl-1.20.1 --disableexcludes=kubernetes
systemctl enable kubelet && systemctl restart kubelet
#パラメーターストアからtoken情報取得
k8s_master_token=$(aws ssm get-parameters --region ap-northeast-1 --names k8s_master_token --query "Parameters[*].{Value: Value}"  --output text)
eval ${k8s_master_token}







