#!/bin/bash

#fip1="$(cat floating_ip1)"
# set -e

# # Step 1
# sudo apt update -y


# Step 3
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
cp -r /opt/prometheus-2.26.0.linux-amd64/prometheus.yml /etc/prometheus

# Step 22
chown -R prometheus:prometheus /etc/prometheus/consoles

# Step 23
chown -R prometheus:prometheus /etc/prometheus/console_libraries

# Step 24
chown -R prometheus:prometheus /etc/prometheus/prometheus.yml

# Step 25
# su -c prometheus /usr/local/bin/prometheus \
#     --config.file /etc/prometheus/prometheus.yml \
#     --storage.tsdb.path /var/lib/prometheus/ \
#     --web.console.templates=/etc/prometheus/consoles \
#     --web.console.libraries=/etc/prometheus/console_libraries
#!/bin/bash

# Your script commands before running multiple commands

# Run the commands without sudo
/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

# Step 26
#nano /etc/systemd/system/prometheus.service

# Step 27
# Copy the contents of the prometheus.service file to /etc/systemd/system/prometheus.service
# echo "[Unit]" >> /etc/systemd/system/prometheus.service
# echo "Description=Prometheus" >> /etc/systemd/system/prometheus.service
# echo "Wants=network-online.target" >> /etc/systemd/system/prometheus.service
# echo "After=network-online.target" >> /etc/systemd/system/prometheus.service

# echo "[Service]" >> /etc/systemd/system/prometheus.service
# echo "User=prometheus" >> /etc/systemd/system/prometheus.service
# echo "Group=prometheus" >> /etc/systemd/system/prometheus.service
# echo "Type=simple" >> /etc/systemd/system/prometheus.service
# echo "ExecStart=/usr/local/bin/prometheus \" >> /etc/systemd/system/prometheus.service
# echo " --config.file /etc/prometheus/prometheus.yml \" >> /etc/systemd/system/prometheus.service
#     echo " --storage.tsdb.path /var/lib/prometheus/ \" >> /etc/systemd/system/prometheus.service
#     echo " --web.console.templates=/etc/prometheus/consoles \" >> /etc/systemd/system/prometheus.service
#     echo " --web.console.libraries=/etc/prometheus/console_libraries \" >> /etc/systemd/system/prometheus.service
# echo " --web.listen-address=188.95.227.215:9090" >> /etc/systemd/system/prometheus.service
# echo " Restart=always" >> /etc/systemd/system/prometheus.service
# echo " RestartSec=10s " >> /etc/systemd/system/prometheus.service
# echo " [Install]" >> /etc/systemd/system/prometheus.service
# echo "WantedBy=multi-user.target" >> /etc/systemd/system/prometheus.service

echo "[Unit]" >> /etc/systemd/system/prometheus.service
echo "Description=Prometheus" >> /etc/systemd/system/prometheus.service
echo "Wants=network-online.target" >> /etc/systemd/system/prometheus.service
echo "After=network-online.target" >> /etc/systemd/system/prometheus.service

echo "[Service]" >> /etc/systemd/system/prometheus.service
echo "User=prometheus" >> /etc/systemd/system/prometheus.service
echo "Group=prometheus" >> /etc/systemd/system/prometheus.service
echo "Type=simple" >> /etc/systemd/system/prometheus.service
echo "ExecStart=/usr/local/bin/prometheus \ "  >> /etc/systemd/system/prometheus.service
    echo "--config.file /etc/prometheus/prometheus.yml \ " >> /etc/systemd/system/prometheus.service
    echo "--storage.tsdb.path /var/lib/prometheus/ \ " >> /etc/systemd/system/prometheus.service
    echo "--web.console.templates=/etc/prometheus/consoles \ " >> /etc/systemd/system/prometheus.service
    echo "--web.console.libraries=/etc/prometheus/console_libraries \ " >> /etc/systemd/system/prometheus.service
    echo "--web.listen-address=0.0.0.0:9090" >> /etc/systemd/system/prometheus.service

echo "Restart=always" >> /etc/systemd/system/prometheus.service
echo "RestartSec=10s" >> /etc/systemd/system/prometheus.service
echo "[Install]" >> /etc/systemd/system/prometheus.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/prometheus.service





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

# Step 33
apt install docker.io

# Step 34
docker pull grafana/grafana

# Step 35
docker run -d -p 3000:3000 --name=grafana grafana/grafana

echo "Script execution completed."
