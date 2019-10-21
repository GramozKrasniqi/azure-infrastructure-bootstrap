ipaddress = $("vagrant ssh -c \"ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1'\"")

user = admin
password = $QXdiSTFqVmlibTJZTUxsOEtVczlGeWM2aUM1cmNCWXFuU0d6RzBSOTJtTT0K
cluster_name = $cluster_name
namespace_name = $namespace_name
ip_address = $ip_address

context_name = $namespace_name/$cluster_name/$cluster_username

kubectl config set-credentials $user/$cluster_name --username=$user --password=$password

kubectl config set-cluster $cluster_name --insecure-skip-tls-verify=true --server=https://$ip_address

kubectl config set-context "internal_cluster" --user=$user/$cluster_name --namespace=default --cluster=$cluster_name

kubectl config use-context "internal_cluster"