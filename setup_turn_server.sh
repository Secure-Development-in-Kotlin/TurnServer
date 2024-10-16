#!/bin/bash

# Define green color
GREEN='\033[0;32m'
NC='\033[0m' # No color (to reset color)

# Update the system
echo -e "${GREEN}Updating the system...${NC}"
sudo apt update && sudo apt upgrade -y

# Install coturn
echo -e "${GREEN}Installing coturn...${NC}"
sudo apt install coturn -y

# Prompt for the realm IP or domain
echo -e "${GREEN}Enter the IP or domain for the realm (default: your private IP):${NC}"
read -p "" REALM
if [ -z "$REALM" ]; then
  REALM=$(hostname -I) # Use private IP if nothing is entered
fi
echo -e "${GREEN}Using '$REALM' as realm.${NC}"

# Default user and password configuration
DEFAULT_USERNAME="burnerchat"
DEFAULT_PASSWORD="burnerchat"

# Create coturn configuration file
CONFIG_FILE="/etc/turnserver.conf"
echo -e "${GREEN}Configuring coturn...${NC}"

sudo bash -c "cat > $CONFIG_FILE" <<EOL
# Basic TURN configuration
realm=$REALM
listening-port=3478
tls-listening-port=5349
listening-ip=$REALM
relay-ip=$REALM
external-ip=$REALM

# Force use of TCP
no-udp
tcp-relay

# Authentication
lt-cred-mech
user=$DEFAULT_USERNAME:$DEFAULT_PASSWORD

# Enable detailed logs
log-file=/var/log/turn.log
simple-log

# Other useful settings
fingerprint
no-multicast-peers
no-loopback-peers
EOL

# Enable coturn as a service
echo -e "${GREEN}Enabling coturn as a service...${NC}"
sudo sed -i "s/#TURNSERVER_ENABLED=1/TURNSERVER_ENABLED=1/g" /etc/default/coturn

# Restart coturn
echo -e "${GREEN}Restarting coturn...${NC}"
sudo systemctl restart coturn

# Enable coturn at startup
echo -e "${GREEN}Enabling coturn to start on boot...${NC}"
sudo systemctl enable coturn

# Configure firewall (ufw)
echo -e "${GREEN}Configuring firewall to allow ports 3478 and 5349...${NC}"
sudo ufw allow 3478/tcp
sudo ufw allow 5349/tcp

echo -e "${GREEN}Configuration complete.${NC}"
