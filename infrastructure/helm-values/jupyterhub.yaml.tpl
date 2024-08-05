proxy:
  service:
    type: ClusterIP
singleuser:
  networkPolicy:
    enabled: false
  image:
    name: cloudacode/k8s-singleuser-sample
    tag: "3.3.7"
ingress:
  enabled: true
  ingressClassName: nginx
  hosts:
    - jupyter.${domain_name}
