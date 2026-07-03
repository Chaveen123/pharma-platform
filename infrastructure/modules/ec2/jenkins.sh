#!/bin/bash
set -e

echo "Updating system..."
dnf update -y

echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/
echo "kubectl installed successfully"

echo "Installing Jenkins..."
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
dnf install -y java-21-amazon-corretto jenkins
systemctl enable --now jenkins
echo "Jenkins installed and started successfully"

echo "Installing Git..."
dnf install -y git
echo "Git installed successfully"

echo "Installing Docker..."
dnf install -y docker
systemctl enable --now docker
usermod -aG docker jenkins
echo "Docker installed and started successfully"

echo "Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "Helm installed successfully"

echo "Configuring Jenkins user..."
usermod --shell /bin/bash jenkins
echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Jenkins user configured successfully"