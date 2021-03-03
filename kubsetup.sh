function enabled_user(){
  mkdir -p $HOME/.kube
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  chown $(id -u):$(id -g) $HOME/.kube/config
}
echo "Disabling SELinux"
setenforce 0 
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
echo "######################################"
echo "Making firwall rules"
firewall-cmd --permanent --add-port=6783/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --permanent --add-port=30000-32767/tcp
firewall-cmd  --reload
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
echo "######################################"
echo "Creating kubernetes repo"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
echo "Installing Docker and kuberadm"
yum install kubeadm docker -y && systemctl enable docker && systemctl start docker && systemctl enable kubelet && systemctl start kubelet
echo "###########################"
echo "Disabling swap"
swapoff -a
echo "####################################"
echo "Initializing Kubernetes"
kubeadm init && enabled_user
kubectl get nodes && echo "kubernetes cluster created" || echo "kubernetes cluster failed to create" 
