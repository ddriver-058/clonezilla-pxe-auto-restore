dhclient # Register with DHCP for network access
curl -X POST -d "$(ifconfig enp2s0)" http://<HTTP SERVER IP>:8080/getImagePartBootParam > /root/ocs-sr.sh # Get the OCS-SR command from HTTP server
chmod +x /root/ocs-sr.sh 
/root/ocs-sr.sh # Run it
