# A runing IKEv2 VPN's container
## Overview ##
Let the IKEv2 vpn service run in the Docker container, do not need too much configuration, you just take the mirror on the Docker server, then run a container, the container generated certificate copy installed on your client, you can connect vpn The server.Welcome everyone's discussion！:blush:


## Features
* StrongSwan provides ikev2 VPN service
* When the container is run, the certificate file is dynamically generated based on the environment variable (last version)
* Combined with Freeradius achieve Authentication, authorization, and accounting (AAA) (last version)

## Prerequisites
* The host machines and containers must be opened within ip_forward （net.ipv4.ip_forward）

## Usage examples
1. Clone git
```Bash
# git clone https://github.com/aliasmee/IKEv2-radius-vpn.git
```

2. Modify the configuration file
```Bash
# cd IKEv2-radius-vpn/
# sed -i 's/leftid=202.77.130.178/leftid=Your‘s public IP/g' conf/ipsec.conf
# sed -i "s/testOnePass/Your's VPN login password/g" conf/ipsec.secrets ［options］
# sed -i "s/202.77.130.178/Your's public IP/g" scripts/vpn
```

3. Using docker build can create an automated build image,Then use the following command to run
```Bash
# docker build -t ikev2 .
# docker run -itd --privileged --cap-add=SYS_ADMIN -p 500:500/udp -p 4500:4500/udp  --user=root --name ikev2-vpn-server ikev2
```

4. View the certificate contents
```Bash
# docker exec -it ikev2-vpn-server cat /data/key_files/ca.cert.pem
-----BEGIN CERTIFICATE-----
MIIDKjCCAhKgAwIBAgIIZeB95hPt1/AwDQYJKoZIhvcNAQELBQAwMzELMAkGA1UE
BhMCY24xDjAMBgNVBAoTBWlsb3ZlMRQwEgYDVQQDEwtqZGNsb3VkIHZwbjAeFw0x
NzA0MDgxNjU2MzdaFw0yNzA0MDYxNjU2MzdaMDMxCzAJBgNVBAYTAmNuMQ4wDAYD
VQQKEwVpbG92ZTEUMBIGA1UEAxMLamRjbG91ZCB2cG4wggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQCZoK1Cr2VJWJTVwDykXxaqpG2nGMfCVQJsx+eB68aa
Cza+n5JzlcW1oh7lmnIhj7iyji3RkE9C4GTCCw/k+0rSgTPLU4OyWfySQhHTE9gZ
tJ1dP4KY32ZYgjrgTb7d+lUF/gnKvIEbUbn/zyDDgEqTdhEXrBn+5/+rqWmff1lA
BsJCRbctFgJIDsa5Wgon7HJpF4scfTsmbMZitOHIqi8pOqfvz3gJ89K+jyFDW4YD
TWB+R0pRZ/qxRd9w6EAfWnnOtqX7P6BkPqtSpArs5/PjiHfqXKJ0hhDgTn+RddDI
cQAh8sRi11ZiUULrCzqWr5+YC6sYhO+ZDvc3x6/xgdbTAgMBAAGjQjBAMA8GA1Ud
EwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBROqVY17FC87m+H
NWZsTu6gnbvbKjANBgkqhkiG9w0BAQsFAAOCAQEAPbOatzkYfzebIn6T2ZS0yWs+
XXAdlv1hILSAj4De/lj54dmuwPL/4iAe0GzuzKlqi4h1nFSWS/5TLK8+R7lQZzHi
tgfkQN2rN2WTR2xV5p6rzC5DLvHFaKwPFBDjb8zBn+dSB6UWIMm/U2dOxYoPJGbj
X4sPf3ItkS7dnGD31ws+r/fwZ0E/GVM7JPcmpuLi7Q5z6xPCr+R1tPio+8RHLjPR
+sGca5O5NRQVL8aH+VBHjVHFQJf9hsMxEXKKLfkZ60xnnor5BXWqzEoxVv9iei3h
JWT/0bfN/sOtDWXe8d1SitU7YqTKCWwI2PAxhBdx4fhptE8DKY7O4yd8sc6HyA==
-----END CERTIFICATE-----
```

5. Copy this certificate to the remote client and name it xx.xxx.pem（Note：Windows need to modify the suffix pem for cer can be installed）
example:<br>
![](https://github.com/aliasmee/IKEv2-radius-vpn/blob/master/Mac_install_cert.png)
6. Connect vpn it！

## Plan list
* Dynamically generated based on the environment variable
* Combined with Freeradius achieve AAA


## Authors
Name:	Yifeng Han<br>
e-mail:	 xhanyifeng@gmail.com

## Licensing
This project is licensed under the GNU General Public License - see the [LICENSE.md](https://github.com/aliasmee/IKEv2-radius-vpn/blob/master/LICENSE) file for details

## Acknowledgments
https://www.strongswan.org/

