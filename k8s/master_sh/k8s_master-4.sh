#!/bin/bash
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/10-k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

curl -OL https://github.com/containerd/containerd/releases/download/v1.4.4/cri-containerd-cni-1.4.4-linux-amd64.tar.gz
sudo tar -zxvf cri-containerd-cni-1.4.4-linux-amd64.tar.gz --no-overwrite-dir -C / --exclude=opt --exclude=etc/cni --transform="s#etc/systemd#usr/local/lib/systemd#"

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

sudo systemctl daemon-reload
sudo systemctl start containerd
sudo systemctl enable containerd

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

sudo yum install -y kubelet-1.20.1-0.x86_64 kubeadm-1.20.1-0.x86_64 kubectl-1.20.1-0.x86_64 --disableexcludes=kubernetes
sudo systemctl enable kubelet && sudo systemctl start kubelet

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version=1.20.1 2>&1 | tee k8s-cluster-install.log

export KUBECONFIG=/home/ec2-user/.kube/config #環境変数にkubeconfigファイルのディレクトリを格納
mkdir -p /home/ec2-user/.kube
sudo cp -i /etc/kubernetes/admin.conf KUBECONFIG
sudo chown ec2-user:ec2-user KUBECONFIG
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml 
--kubeconfig=KUBECONFIG

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

export MASTER_TOKEN_4=$(kubeadm token create --print-join-command)
aws ssm put-parameter --region ap-northeast-1 --name "MASTER_TOKEN_4" --value "$MASTER_TOKEN_4" --type String --overwrite






