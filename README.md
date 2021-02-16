# 

You can use this container to get the list of IP CDRS from a public host to use in security groups...

# Example

* Gitlab is deployed in Google Cloud. In order to allow their CI/CD workers to call your AWS EC2 resources, you can grab all of the IPS to be used.

```console
$ docker run -ti marcellodesales/spf2ip --domain  _cloud-netblocks.googleusercontent.com --ip-version 4
INFO: Getting the ip address with SPF2IP
8.34.208.0/20
8.35.192.0/21
8.35.200.0/23
23.236.48.0/20
23.251.128.0/19
34.64.0.0/11
34.96.0.0/14
34.100.0.0/16
34.102.0.0/15
34.104.0.0/14
34.124.0.0/18
34.124.64.0/20
34.124.80.0/23
34.124.84.0/22
34.124.88.0/23
34.124.92.0/22
34.125.0.0/16
35.184.0.0/14
35.188.0.0/15
35.190.0.0/17
35.190.128.0/18
35.190.192.0/19
35.190.224.0/20
35.190.240.0/22
35.192.0.0/14
35.196.0.0/15
35.198.0.0/16
35.199.0.0/17
35.199.128.0/18
35.200.0.0/13
35.208.0.0/13
35.216.0.0/15
35.219.192.0/24
35.220.0.0/14
35.224.0.0/13
35.232.0.0/15
35.234.0.0/16
35.235.0.0/17
35.235.192.0/20
35.235.216.0/21
35.235.224.0/20
35.236.0.0/14
35.240.0.0/13
104.154.0.0/15
104.196.0.0/14
107.167.160.0/19
107.178.192.0/18
108.59.80.0/20
108.170.192.0/20
108.170.208.0/21
108.170.216.0/22
108.170.220.0/23
108.170.222.0/24
130.211.4.0/22
130.211.8.0/21
130.211.16.0/20
130.211.32.0/19
130.211.64.0/18
130.211.128.0/17
146.148.2.0/23
146.148.4.0/22
146.148.8.0/21
146.148.16.0/20
146.148.32.0/19
146.148.64.0/18
162.216.148.0/22
162.222.176.0/21
173.255.112.0/20
192.158.28.0/22
199.192.112.0/22
199.223.232.0/22
199.223.236.0/23
208.68.108.0/23
```

* Now just update the security group

```console
$ SSH_SG=$(aws ec2 describe-security-groups --group-name "Supercash SSH" | jq -r '.SecurityGroups[0].GroupId’)

$ docker run -ti marcellodesales/spf2ip --domain  _cloud-netblocks.googleusercontent.com --ip-version 4  | \
       xargs -t -I {}  aws ec2 authorize-security-group-ingress --group-id ${SSH_SG} \
       --ip-permissions IpProtocol=tcp,FromPort=23456,ToPort=23456,IpRanges='[{CidrIp={},Description="Gitlab CI/CD Wokers”}]
```

# Development

* Build

```console
$ docker-compose build
Building spf2ip
Step 1/7 : FROM python:alpine
 ---> 53261e7e236b
Step 2/7 : LABEL maintainer="marcello.desales@gmail.com"
 ---> Using cache
 ---> 5f0d69471f50
Step 3/7 : LABEL origin="https://github.com/marcellodesales/docker-pycobertura"
 ---> Using cache
 ---> 912f43456e0e
Step 4/7 : RUN pip install --no-cache-dir pip install SPF2IP
 ---> Using cache
 ---> 71019439c630
Step 5/7 : RUN SPF2IP --help
 ---> Using cache
 ---> d44e95e24ec9
Step 6/7 : COPY entrypoint.sh /entrypoint.sh
 ---> 7e35a9802d79
Step 7/7 : ENTRYPOINT ["/entrypoint.sh"]
 ---> Running in b725d1ff4540
Removing intermediate container b725d1ff4540
 ---> 4083f4250880

Successfully built 4083f4250880
Successfully tagged marcellodesales/spf2ip:latest
```

* Releases

````console
$ docker-compose push
Pushing spf2ip (marcellodesales/spf2ip:latest)...
The push refers to repository [docker.io/marcellodesales/spf2ip]
1ca4c36fc671: Pushing [==================================================>]  2.048kB
519e77a2d4bf: Pushing [==================================================>]  4.608kB
1ca4c36fc671: Pushed
519e77a2d4bf: Pushed
05dbf3c3e393: Pushed
bcacc7286077: Mounted from marcellodesales/cover2cover
c4cd3bcee4dc: Waiting
412ecdf509e8: Mounted from library/python
c4cd3bcee4dc: Mounted from marcellodesales/cover2cover
777b2c648970: Mounted from marcellodesales/cover2cover

latest: digest: sha256:a0cea8457cf82741bd10d00b351a4634b5384bec67f6a9719ef26cb23e6abd5b size: 1993
```
