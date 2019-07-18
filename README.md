
On Master and Worker nodes:

1. Add to /etc/sysconfig/kubelet
KUBELET_EXTRA_ARGS="--cloud-provider=external"

On Master node:

1. Create /etc/kubernetes/cloud-config

[Global]
auth-url="https://engcloud.prv.suse.net:5000/v3"
username="mjura"
password="PASSWORD"
tenant-id="05394ae447d74bc0b3ed2cca262c9b7c"
domain-name="ldap_users"
region="CustomRegion"
ca-file="/etc/ssl/certs/SUSE_Trust_Root.pem"
[LoadBalancer]
lb-version=v2
subnet-id="PROVIDE_UUID"
floating-network-id="890584bc-da17-424b-9147-2dc8f3d69d64"
create-monitor=yes
monitor-delay=1m
monitor-timeout=30s
monitor-max-retries=3
[BlockStorage]
trust-device-path=false
bs-version=v2
ignore-volume-az=true
[Route]
router-id="PROVIDE_UUID"

2. Add "- --cloud-provider=external" to configuration to:
 - /etc/kubernetes/manifests/kube-apiserver.yaml
 - /etc/kubernetes/manifests/kube-controller-manager.yaml

3. Copy manifests folder on Master node:

4. Create cloud-config secret

export CLOUD_CONFIG=/etc/kubernetes/cloud-config
kubectl create secret -n kube-system generic cloud-config --from-literal=cloud.conf="$(cat $CLOUD_CONFIG)" --dry-run -o yaml > manifests/cloud-config-secret.yaml
kubectl apply -f manifests/cloud-config-secret.yaml

3. Create RBAC for cloud-controller-manager

kubectl apply -f manifests/rbac/cloud-controller-manager-roles.yaml
kubectl apply -f manifests/rbac/cloud-controller-manager-role-bindings.yaml

4. Deploy openstack cloud controller manager pod

kubectl apply -f manifests/openstack-cloud-controller-manager-pod.yaml

5. Check logs

kubectl logs -n kube-system cloud-controller-manager

6. Deploy demo examples
