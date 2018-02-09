# tiller with rbac

## Deploy

1. make sure the kubernetes home director and can connect to k8s
```
more ${HOME}/.kube/config
```

2. if not RBAC mode.
```
helm init
helm init --upgrade -i your_registry/tiller:v2.8.1 --stable-repo-url https://your_charts_server/charts
```

3. if set RBAC mode,write this in your file.
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
```

4. install with RBAC
```
kubectl create -f  rbac-config.yaml
helm init --service-account tiller --upgrade
```

5. if want install with RBAC, but already init with no RBAC.
```
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```