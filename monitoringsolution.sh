#!/bin/bash

#fip1="$(cat floating_ip1)"
# set -e

# # Step 1
# sudo apt update -y


# Step 3
apt update -y
export RELEASE="2.2.1"

# Step 4
useradd --no-create-home --shell /bin/false prometheus

# Step 5
useradd --no-create-home --shell /bin/false node_exporter

# Step 6
mkdir /etc/prometheus

# Step 7
mkdir /var/lib/prometheus

# Step 8
chown prometheus:prometheus /etc/prometheus

# Step 9
chown prometheus:prometheus /var/lib/prometheus

# Step 10
cd /opt/

# Step 11
wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz

# Step 12
sha256sum prometheus-2.26.0.linux-amd64.tar.gz

# Step 13
tar -xvf prometheus-2.26.0.linux-amd64.tar.gz
cd prometheus-2.26.0.linux-amd64 
echo "unzipped prometheus-2.26.0.linux-amd64.tar.gz"
# Step 14
#cd prometheus-2.26.0.linux-amd64

# Step 15
cp /opt/prometheus-2.26.0.linux-amd64/prometheus /usr/local/bin/

# Step 16
cp /opt/prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/

# Step 17
chown prometheus:prometheus /usr/local/bin/prometheus

# Step 18
chown prometheus:prometheus /usr/local/bin/promtool

# Step 19
cp -r /opt/prometheus-2.26.0.linux-amd64/consoles /etc/prometheus

# Step 20
cp -r /opt/prometheus-2.26.0.linux-amd64/console_libraries /etc/prometheus

# Step 21
# cp -r /opt/prometheus-2.26.0.linux-amd64/prometheus.yml /etc/prometheus

# Step 22
chown -R prometheus:prometheus /etc/prometheus/consoles

# Step 23
chown -R prometheus:prometheus /etc/prometheus/console_libraries

# Step 24
chown -R prometheus:prometheus /etc/prometheus/prometheus.yml
echo "changing the permissions"

chown -R prometheus:prometheus /var/lib/prometheus
chmod -R 755 /var/lib/prometheus

# sudo -u prometheus /usr/local/bin/prometheus \
#         --config.file /etc/prometheus/prometheus.yml \
#         --storage.tsdb.path /var/lib/prometheus/ \
#         --web.console.templates=/etc/prometheus/consoles \
#         --web.console.libraries=/etc/prometheus/console_libraries &

sudo -u prometheus /usr/local/bin/prometheus \
        --config.file /etc/prometheus/prometheus.yml \
        --storage.tsdb.path /var/lib/prometheus/ \
        --web.console.templates=/etc/prometheus/consoles \
        --web.console.libraries=/etc/prometheus/console_libraries > /dev/null &


echo "setting up prometheus.service file"

cat >/etc/systemd/system/prometheus.service <<EOL
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
        --config.file /etc/prometheus/prometheus.yml \
        --storage.tsdb.path /var/lib/prometheus/ \
        --web.console.templates=/etc/prometheus/consoles \
        --web.console.libraries=/etc/prometheus/console_libraries 
        --web.listen-address=0.0.0.0:9090
Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOL

echo "" >> /etc/systemd/system/prometheus.service


echo "restarting prometheus"


# Step 28
systemctl daemon-reload

# Step 29
systemctl start prometheus

# Step 30
systemctl enable prometheus

# Step 31
#systemctl status prometheus

# Step 32
ufw allow 9090/tcp

# install node exporter
echo "Installing node Exporter"

wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvf node_exporter-1.3.1.linux-amd64.tar.gz
cd node_exporter-1.3.1.linux-amd64
cp node_exporter /usr/local/bin
cd ..
rm -rf ./node_exporter-1.3.1.linux-amd64
useradd --no-create-home --shell /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter

echo "setting up node_exporter.service file"
cat > /etc/systemd/system/node_exporter.service <<EOL
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOL

echo "" >> /etc/systemd/system/node_exporter.service
echo "restarting node exporter"

systemctl daemon-reload
systemctl start node_exporter

yes | apt update -y
# Step 33
echo "installing grafana"
apt install docker.io -y

# Step 34
docker pull grafana/grafana

# Step 35
docker run -d -p 3000:3000 --name=grafana grafana/grafana

echo "Script execution completed."