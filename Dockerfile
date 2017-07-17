# From centos7:latest image
FROM centos

# MAINTAINER Yifeng,http://www.cnblogs.com/hanyifeng

# Define a dynamic variable for Certificate CN
ENV HOSTIP ''
ENV STRONGSWAN_VERSION 5.5.3


# Install dep packge and strongSwan
RUN yum install pam-devel openssl-devel make gcc iptables-services -y && yum clean all && rm -rf /var/cache/yum/* && curl -SLO "https://download.strongswan.org/strongswan-$STRONGSWAN_VERSION.tar.gz" && \
  tar -xf strongswan-5.5.3.tar.gz && cd /strongswan-5.5.3 && ./configure  --enable-eap-identity --enable-eap-md5 --enable-eap-mschapv2 --enable-eap-tls \
  --enable-eap-ttls --enable-eap-peap --enable-eap-tnc --enable-eap-dynamic --enable-eap-radius --enable-xauth-eap --enable-xauth-pam  --enable-dhcp  \
  --enable-openssl  --enable-addrblock --enable-unity --enable-certexpire --enable-radattr --enable-swanctl --enable-openssl --disable-gmp && make && make install

# (Optional) Change local zonetime(BeiJing)
RUN \cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime 

# Create cert dir & Clear temp file
RUN mkdir -p /data/key_files && rm -rf /strongswan-5.5.3 && rm -f /strongswan-5.5.3.tar.gz

# Use mount volume ! Copy configure file to ipsec\iptables
COPY ./conf/ipsec.conf /usr/local/etc/ipsec.conf 
#COPY ./conf/strongswan.conf /usr/local/etc/strongswan.conf 
#COPY ./conf/ipsec.secrets /usr/local/etc/ipsec.secrets
COPY ./conf/iptables /etc/sysconfig/iptables

# Make cert script and copy cert to ipsec dir
# COPY ./scripts/vpn /usr/bin/vpn

# Let iptables and ipsec start is Boot
COPY ./conf/ipsec.service /usr/lib/systemd/system/ipsec.service
COPY ./conf/ipsec.init /usr/libexec/ipsec/ipsec.init

# Enable iptables and ipsec on Boot
RUN systemctl enable iptables.service && systemctl enable ipsec.service

# Open udp 500\4500 port
EXPOSE 500:500/udp \
  4500:4500/udp

# Privilege mode
CMD ["/sbin/init"]
