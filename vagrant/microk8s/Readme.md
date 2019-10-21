# Single node K8s cluster using Microk8s and Vagrant
Setup a local cluster of k8s using Microk8s.
Currently we use Hyper-V if you need to change to another hypervisor please change the Vagrant file.

## Why Microk8s

https://microk8s.io/

Small single node k8s cluster usefuel for local development or when using for IoT edge devices.
A a single package for 42 flavours of linux.
Installs a barebones upstream k8s. 

By default it includes:
- api-server
- controller-manger
- scheduler
- kubelet
- cni
- kube-proxy

You can enable additionial services like:
- kube-dns
- dashboard
- see documentation for other additional services

## Getting Started
`git clone RepoName`

## Prerequisites
- Vagrant https://www.vagrantup.com/downloads.html
- Hyper-V (by default installed on Windows 8+) or
- any other Hypervisor like VirtualBox or VMWare hypervisor

## What you will get
At the end you will get a new VM with the following components installed:
- k8s cluster using Microk8s
    - helm enabled
    - dns service enabled
    - storage enabled
    - ingress enabled
- Docker
- kubectl

## Starting the VM

After you installed Vagrant and cloned the repository reach the `./vagrant/microk8s`, start cmd with admin priviledges and enter `vagrant up`.
This will create the machine and ask you in which vSwitch should it connect (to select the right vSwitch see Known issues below).

## Using k8s

After you start the VM run the command `vagrant ssh` to ssh into the VM.

## Destroy & Clenaup

`vagrant destroy`

## Known issues

#### Virtual Box on hosts with Hyper-V enabled

https://www.vagrantup.com/docs/installation/#windows-virtualbox-and-hyper-v

#### Hyper-V virtual networking

https://www.vagrantup.com/docs/hyperv/limitations.html#limited-networking

#### SMB mounting requires admin priviledges
When mounting SMB shares between Host and VM (in our case we want the .kubeconfig file) it needs administrative priviedges.
Please use the username and password of an admin when provisioning the VM.

#### Accessing k8s cluster from Docker running in Host Machine

If you have set up the k8s cluster and now from your Windows host want to access the k8s cluster from a docker container running with Docker Desktop it wont work.
Both docker container and our k8s cluster run on two different virutal machines that are configured to use different virtual switches from Hyper-V.

Docker Desktop uses DockerNAT switch which is Internal and our k8s cluster is running on a vm that uses another virtual switch be it Internal or External.
If you try to connect your k8s cluster vm in the same vSwitch that Docker Desktop uses it will fail, a known issue.
If you try to change the DockerNAT vSwitch to other then Internal Docker Desktop will fail to start.

#### K8s 1.16.0 & Helm 2.14.3 Bug

https://github.com/helm/helm/issues/6374