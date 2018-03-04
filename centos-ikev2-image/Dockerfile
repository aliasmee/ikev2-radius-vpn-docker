# From centos7:latest image
FROM centos

MAINTAINER @aliasmee

USER root

# Define a dynamic variable for Certificate CN
ENV HOSTIP ''


# Install dep packge
RUN yum install pam-devel openssl-devel make gcc wget iptables-services -y && yum clean all && rm -rf /var/cache/yum/* 
#RUN systemctl stop firewalld && systemctl disable firewalld && systemctl start iptables && systemctl enable iptables

# Download strongSwan soft
RUN wget -c https://download.strongswan.org/strongswan-5.5.2.tar.gz
RUN tar -xf strongswan-5.5.2.tar.gz 

# Configure,make and install strongSwan
RUN cd /strongswan-5.5.2 && ./configure  --enable-eap-identity --enable-eap-md5 --enable-eap-mschapv2 --enable-eap-tls --enable-eap-ttls --enable-eap-peap --enable-eap-tnc --enable-eap-dynamic --enable-eap-radius --enable-xauth-eap --enable-xauth-pam  --enable-dhcp  --enable-openssl  --enable-addrblock --enable-unity --enable-certexpire --enable-radattr --enable-swanctl --enable-openssl --disable-gmp && make && make install

# Change local zonetime(BeiJing)
RUN \cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

# Create cert dir
RUN mkdir -p /data/key_files

# Clear temp file
RUN rm -rf /strongswan-5.5.2 && rm -f /strongswan-5.5.2.tar.gz

# Copy configure file to ipsec\iptables
COPY ./conf/ipsec.conf /usr/local/etc/ipsec.conf 
COPY ./conf/strongswan.conf /usr/local/etc/strongswan.conf 
COPY ./conf/ipsec.secrets /usr/local/etc/ipsec.secrets
COPY ./conf/iptables /etc/sysconfig/iptables

# Make cert script and copy cert to ipsec dir
COPY ./scripts/vpn /usr/bin/vpn

# Let iptables and ipsec start is Boot
COPY ./conf/ipsec.service /usr/lib/systemd/system/ipsec.service
COPY ./conf/ipsec.init /usr/libexec/ipsec/ipsec.init

# Enable iptables and ipsec on Boot
RUN systemctl enable iptables.service
RUN systemctl enable ipsec.service

# Open udp 500\4500 port
EXPOSE 500:500/udp
EXPOSE 4500:4500/udp

# Privilege mode
CMD ["/sbin/init"]
