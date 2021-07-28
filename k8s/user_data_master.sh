#!/bin/bash
sudo su
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker.service

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


cat <<EOF > kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
apiServer:
  extraArgs:
    cloud-provider: aws 
clusterName: k8s 
controllerManager:
  extraArgs:
    cloud-provider: aws 
kubernetesVersion: 1.20.8
networking:
  podSubnet: 10.244.0.0/16
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
nodeRegistration:
  kubeletExtraArgs:
    cloud-provider: aws 
EOF

kubeadm init --config kubeadm-config.yaml 2>&1 | tee  k8s-cluster-install.log
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
mv kubeadm-config.yaml ./home/ec2-user/
cd /home/ec2-user

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#パラメーターストアにtoken情報をアップロードとEBSidを取得
export TOKEN=$(kubeadm token create --print-join-command)
aws ssm put-parameter --region ap-northeast-1 --name "k8s_master_token" --value "$TOKEN" --type String --overwrite
ebs_id=$(aws ssm get-parameters --region ap-northeast-1 --names ebs_id --query "Parameters[*].{Value: Value}"  --output text)

cat <<EOF > ebs-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: ebs-pv
spec:
  capacity:
    storage: 3Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  awsElasticBlockStore:
    volumeID: "${ebs_id}"
EOF

cat <<EOF > ebs-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-pvc
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 2Gi
EOF

cat <<EOF > ebs-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: ebs-pod
spec:
  initContainers:
  - name: deploy-app
    image: registry.gitlab.com/ss-cloudnative/kubernetes-trainingresearch/jsp-counter
    command: ['sh', '-c', "cp /jsp-counter.war /webapps"]
    volumeMounts:
    - mountPath: "/webapps"
      name: webapps-dir
  containers:
    - name: tomcat
      image: tomcat:9
      volumeMounts:
      - mountPath: "/usr/local/tomcat/webapps"
        name: webapps-dir
  volumes:
    - name: webapps-dir
      persistentVolumeClaim:
        claimName: ebs-pvc
EOF

cat <<EOF > ebs-pod2.yaml
apiVersion: v1
kind: Pod
metadata:
  name: ebs-pod2
spec:
  containers:
    - name: tomcat
      image: tomcat:9
      volumeMounts:
      - mountPath: "/usr/local/tomcat/webapps"
        name: webapps-dir
  volumes:
    - name: webapps-dir
      persistentVolumeClaim:
        claimName: ebs-pvc
EOF

cat <<EOF > ebs-sc.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
reclaimPolicy: Delete
volumeBindingMode: Immediate
EOF

cat <<EOF > ebs-pvc3.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-pvc3
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  storageClassName: ebs-sc
  resources:
    requests:
      storage: 2Gi
EOF

cat <<EOF > ebs-pvc3.yaml
apiVersion: v1
kind: Pod
metadata:
  name: ebs-pod3
spec:
  initContainers:
  - name: deploy-app
    image: registry.gitlab.com/ss-cloudnative/kubernetes-trainingresearch/jsp-counter
    command: ['sh', '-c', "cp /jsp-counter.war /webapps"]
    volumeMounts:
    - mountPath: "/webapps"
      name: webapps-dir
  containers:
    - name: tomcat
      image: tomcat:9
      volumeMounts:
      - mountPath: "/usr/local/tomcat/webapps"
        name: webapps-dir
  volumes:
    - name: webapps-dir
      persistentVolumeClaim:
        claimName: ebs-pvc2
EOF

cat <<EOF > ebs-pod3.yaml
apiVersion: v1
kind: Pod
metadata:
  name: ebs-pod3
spec:
  initContainers:
  - name: deploy-app
    image: registry.gitlab.com/ss-cloudnative/kubernetes-trainingresearch/jsp-counter
    command: ['sh', '-c', "cp /jsp-counter.war /webapps"]
    volumeMounts:
    - mountPath: "/webapps"
      name: webapps-dir
  containers:
    - name: tomcat
      image: tomcat:9
      volumeMounts:
      - mountPath: "/usr/local/tomcat/webapps"
        name: webapps-dir
  volumes:
    - name: webapps-dir
      persistentVolumeClaim:
        claimName: ebs-pvc2
EOF

 




