## kubernetes通用登录设置

1.设置一个cluster
```
kubectl config set-cluster default --server=https://kubernetes.xxx.com:8443 --certificate-authority=C:\Users\zxxx\.kube\ca.pem
```
2.设置登录认证方式 我们默认是token方式
```
kubectl config set-credentials admin --token="xxx"
```
3.设置一个对应的访问上下文
```
kubectl config set-context default --cluster=default --user=admin
```
4.应用上下文,或者称为切换上下文
```
kubectl config use-context default
```
5.便捷登录方式
```
kubectl get pod -n default --token="xxx" --server="https://kubernetes.xxx.com:8443" --insecure-skip-tls-verify=true
```
## UAA With Kubernetes
1. 获取token
```
uaa-k8s-oidc-helper -uaa.skip_ssl_verify=true -uaa.client_id=cf -uaa.client_secret="" -uaa.password="xxx" -uaa.url=https://uaa.xxx.com -uaa.username=xxxx
```

2. 设置认证
```
kubectl config set-credentials xxx --auth-provider="oidc" --auth-provider-arg=idp-certificate-authority=C:\Users\xxx\.kube\ca.pem --auth-provider-arg=idp-issuer-url=https://uaa.xxx.com/oauth/token --auth-provider-arg=client-id=cf --auth-provider-arg=client-secret="" --auth-provider-arg=id-token=%token_id% --auth-provider-arg=refresh-token=%refresh_token%
```
3. 设置上下文
```
kubectl config set-context xxx --cluster=default --user=xxx
```
4. 应用上下文
```
kubectl config use-context xxx

uaac client add kubernetes_client --scope="openid,oauth.approvals" --authorized_grant_types="client_credentials,password,refresh_token" --access_token_validity=1209600 --refresh_token_validity=1209600 --authorities="uaa.resource,cloud_controller.admin_read_only"
```
### windows 方式
```
set token_id=""
```
```
set refresh_token=""
```
```
kubectl config set-credentials xxx --auth-provider="oidc" --auth-provider-arg=idp-certificate-authority=C:\Users\xxx\.kube\ca.pem --auth-provider-arg=idp-issuer-url=https://uaa.xxx.com/oauth/token --auth-provider-arg=client-id=cf --auth-provider-arg=client-secret="" --auth-provider-arg=id-token=%token_id% --auth-provider-arg=refresh-token=%refresh_token%
```
