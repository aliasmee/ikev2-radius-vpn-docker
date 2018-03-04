# A runing IKEv2 VPN's container
## Overview ##
Let the IKEv2 vpn service run in the Docker container, do not need too much configuration, you just take the mirror on the Docker server, then run a container, the container generated certificate copy installed on your client, you can connect vpn The server.Welcome everyone's discussion！:blush:

## Features
* StrongSwan provides ikev2 VPN service
* In addition to Android and Linux, but other devices(Winodws 7+,Mac,iOS) by default comes with IKEv2 dial clients
* When the container is run, the certificate file is dynamically generated based on the environment variable (last version)
* Combined with Freeradius achieve Authentication, authorization, and accounting (AAA) (last version)

## Prerequisites
* The host machines and containers must be opened within ip_forward （net.ipv4.ip_forward）

## Usage examples
1. Clone git
```Bash
# git clone https://github.com/aliasmee/IKEv2-radius-vpn.git
```

2. Using docker build can create an automated build image,Then use the following command to run
```Bash
# cd IKEv2-radius-vpn/
# docker build -t ikev2 .
# docker run -itd --privileged --cap-add=SYS_ADMIN -e "HOSTIP=Your's Public network IP" -p 500:500/udp -p 4500:4500/udp  --user=root --name ikev2-vpn-server ikev2
```
    **HOSTIP :Public network must be your host IP**


3. Use the following command to generate the certificate and view the certificate contents
```Bash
# docker exec -it ikev2-vpn-server sh /usr/bin/vpn
net.ipv4.ip_forward = 1
Below the horizontal line is the content of the certificate
___________________________________________________________
-----BEGIN CERTIFICATE-----
MIIDKjCCAhKgAwIBAgIISmAlxNsR7iEwDQYJKoZIhvcNAQELBQAwMzELMAkGA1UE
BhMCY24xDjAMBgNVBAoTBWlsb3ZlMRQwEgYDVQQDEwtqZGNsb3VkIHZwbjAeFw0x
NzA0MTAxNzE0MDNaFw0yNzA0MDgxNzE0MDNaMDMxCzAJBgNVBAYTAmNuMQ4wDAYD
VQQKEwVpbG92ZTEUMBIGA1UEAxMLamRjbG91ZCB2cG4wggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDIy9XbS2VPuPxMLBM47L9JdpDIexY5bmLAAZwAXgmS
dXzcXDdzUlepHi45V+zWDsbkWeOQVZ505YxRL0RGRvOZB1gHoUopSCeMdq0jnrfZ
6ZqudepAtQFGIW2j5LAdU3f3BD9sxkgN88YsWxjQHEVLeUNnJ+hbA5ehcSJ5KAQA
cD/FaAMP3rMUyUZ9rhSQDzXn/p10l/oYUvFvYnJyqdwMkgYjEeYOG0++IclHfJF4
P8O+1ZZzwKwG3Ua1hx/UZCV/X+js/Mxrwfyc4P5tuCkCOQ95dd0N/Mfx0RO4LDH8
557qOSnm3jGUdj5a0jcnlMZIuRDNJ7xrKK9Mwh55aKmLAgMBAAGjQjBAMA8GA1Ud
EwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBTbZhnawhk9Ghmn
JcmaIohC0pYzmTANBgkqhkiG9w0BAQsFAAOCAQEAZS+0HutM+EHxSQXhFCXdlf6i
992qJeWPiDo4KHoU5GTtMoTjEd3UB+mf65dWGzms7NbDLbzc9qw2B3/IKI/lRdOI
rsv9oI98Tu+kBonscGZfgswChJQ80Y9tQQ69Zcw6spP/0C7MOag90TqkLdhdR6Lv
uABDCLy4jUcAWuM4P1Yt1Tyg5796l6Dlh1xwlF75IwPrlULJ58vp1AdLROolD5a5
gmzR5T2x34Gvycs7qZfFSNn0Kp4A9k+UPMm18Foi0pKTltspWAFC+sEgKO6IRgHA
T0W+bd7/A7VcIclxfXAQ1Vx8hhEVYNFUF6vqOf6BsBN/roU+MfTood//8Xqmiw==
-----END CERTIFICATE-----

```

4. Copy this certificate to the remote client and name it xx.xxx.pem（Note：Windows need to modify the suffix pem for cer can be installed）
example:<br>
![](https://github.com/aliasmee/IKEv2-radius-vpn/blob/master/Mac_install_cert.png)
6. Connect vpn it！

## Plan list
* Dynamically generated based on the environment variable （Completed）
* Combined with Freeradius achieve AAA

## Currently supported client device 
Only test for the following client device system，You can test on the other system versions and feedback ！<br>
`Mac`:	10.11.4<br>
`iOS`:	10.2<br>
`Windows`:	10<br>
`Centos`:	6.8<br>
`Android`：(Download strongSwan APK)

## Authors
Name:	Yifeng Han<br>

## Licensing
This project is licensed under the GNU General Public License - see the [LICENSE.md](https://github.com/aliasmee/IKEv2-radius-vpn/blob/master/LICENSE) file for details

## Acknowledgments
https://www.strongswan.org/

