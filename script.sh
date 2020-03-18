#!/bin/bash
apt-get update
apt-get upgrade -yq
apt-get install -yq git curl wget unzip > /dev/null 2>&1

#Docker Install
apt-get install -yq software-properties-common syslog-summary ccze apt-transport-https ca-certificates gnupg2 > /dev/null 2>&1

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update && apt install -yq docker-ce docker-ce-cli containerd.io > /dev/null 2>&1

curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
curl -L https://raw.githubusercontent.com/docker/compose/1.25.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

groupadd docker
usermod -aG docker $USER

cd /tmp
wget https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip
unzip terraform_0.12.23_linux_amd64.zip
mv terraform /usr/local/bin

cd /tmp
wget https://releases.hashicorp.com/packer/1.5.4/packer_1.5.4_linux_amd64.zip
unzip packer_1.5.4_linux_amd64.zip
sudo mv packer /usr/local/bin

cd /tmp
wget https://releases.hashicorp.com/vault/1.3.1/vault_1.3.1_linux_amd64.zip
unzip vault_*.zip
cp vault /usr/local/bin

vault -autocomplete-install
complete -C /usr/local/bin/vault vault

setcap cap_ipc_lock=+ep /usr/local/bin/vault
mkdir --parents /etc/vault.d
cat <<-EOF > /etc/vault.d/vault
 listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
 }

 storage "file" {
  path = "/home/vault/data"
 }
EOF

cat <<-EOF > /etc/systemd/system/vault.service
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/vault.hcl
StartLimitIntervalSec=60
StartLimitBurst=3

[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitInterval=60
StartLimitIntervalSec=60
StartLimitBurst=3
LimitNOFILE=65536
LimitMEMLOCK=infinity

[Install]
WantedBy=multi-user.target
EOF

useradd --system --home /etc/vault.d --shell /bin/false vault
chown --recursive vault:vault /etc/vault.d
chown 640 /etc/vault.d/vault.hcl
systemctl enable vault
systemctl start vault


