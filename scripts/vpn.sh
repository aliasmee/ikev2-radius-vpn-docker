#!/bin/bash
#Author by Yifeng Han
#Time 2017-04-08 13:00

# Create certificate

cd /data/key_files
ipsec pki --gen --outform pem > ca.pem 
ipsec pki --self --in ca.pem --dn "C=cn, O=ilove, CN=jdcloud vpn" --ca --lifetime 3650 --outform pem >ca.cert.pem 
ipsec pki --gen --outform pem > server.pem 
ipsec pki --pub --in server.pem | ipsec pki --issue --lifetime 1200 --cacert ca.cert.pem --cakey ca.pem --dn "C=cn, O=ilove, CN=202.77.130.178" --san="202.77.130.178" --flag serverAuth --flag ikeIntermediate --outform pem > server.cert.pem 
ipsec pki --gen --outform pem > client.pem 
ipsec pki --pub --in client.pem | ipsec pki --issue --cacert ca.cert.pem --cakey ca.pem --dn "C=cn, O=ilove, CN=jdcloud vpn client" --outform pem > client.cert.pe

# Copy certificate to ipsec dir
\cp ca.cert.pem /usr/local/etc/ipsec.d/cacerts/ 
\cp server.cert.pem /usr/local/etc/ipsec.d/certs/ 
\cp server.pem /usr/local/etc/ipsec.d/private/ 
\cp client.cert.pem /usr/local/etc/ipsec.d/certs/ 
\cp client.pem  /usr/local/etc/ipsec.d/private/

# Enable system forward
sysctl -w net.ipv4.ip_forward=1

# Disable firewalld and Enable iptables
systemctl stop firewalld && systemctl disable firewalld && systemctl start iptables && systemctl enable iptables

# Start ipsec
ipsec start
