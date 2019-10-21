user = $user
password = $password
cluster_name = $cluster_name
namespace_name = $namespace_name
ip_address = $ip_address

context_name = $namespace_name/$cluster_name/$cluster_username

kubectl config set-credentials $user/$cluster_name --username=$user --password=$password

kubectl config set-cluster $cluster_name --insecure-skip-tls-verify=true --server=https://$ip_address

kubectl config set-context "internal_cluster" --user=$user/$cluster_name --namespace=default --cluster=$cluster_name

kubectl config use-context "internal_cluster"