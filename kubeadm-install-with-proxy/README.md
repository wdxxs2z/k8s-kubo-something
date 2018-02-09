# kubeadm-install-with-proxy

## Important Link
* Dashboard 1. [Access control](https://github.com/kubernetes/dashboard/wiki/Access-control)
* Dashboard 2. [Accessing Dashboard 1.7.X and above](https://github.com/kubernetes/dashboard/wiki/Accessing-Dashboard---1.7.X-and-above)
* Dashboard 3. [Installation](https://github.com/kubernetes/dashboard/wiki/Installation)

## Configuration the proxy with shadowsocket and privoxy linux(ubuntu)

1. install shadowsocket and privoxy | setup the proxy
```
apt-get install -y python2.7 python-dev python-pip privoxy
pip install shadowsocks
apt-get install privoxy

sslocal -s server_host -p server_port -l 1080 -k "password" -t 600 -m aes-256-cfb --log-file /home/ubuntu/sslocal.log -d start

edit /etc/privoxy/config
 listen-address  0.0.0.0:8118
 forward-socks5 / localhost:1080 .

cd /etc/privoxy/
sudo privoxy
```

2. modify the docker proxy
```
[Service]
Environment="HTTPS_PROXY=http://your_proxy_ip:8118"
```

3. first init kubeadm,but always failed
```
export https_proxy=http://ip:8118
kubeadm init --pod-network-cidr=10.96.0.0/16
```

4. try the kubeadm init without proxy
```
kubeadm reset
export https_proxy=""
kubeadm init --pod-network-cidr=10.96.0.0/16
```

5. dashboard part, if you want access web without local host,you must config the tls.
```
args:
 # - --auto-generate-certificates
 # Uncomment the following line to manually specify Kubernetes API server Host
 # If not specified, Dashboard will attempt to auto discover the API server and connect
 # to it. Uncomment only if the default does not work.
 # - --apiserver-host=http://my-address:port
 - --default-cert-dir=/certs
 - --tls-cert-file=dashboard.crt
 - --tls-key-file=dashboard.key
```

6. make sure your certs in your $HOME/certs
```
kubectl create secret generic kubernetes-dashboard-certs --from-file=$HOME/certs -n kube-system
```

7. edit your dashboard yaml, and add nodeport part
```
spec:
  type: NodePort
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 30010
  selector:
    k8s-app: kubernetes-dashboard
```