Two flows:
Use terraform for provisioning cloud
 - Use terraform workspaces for managing different environments on the cloud
 - e.g. dev, integration, qa, prod
 - Using terraform it will always try to push the backend state to the cloud
Use Vagrant for provisioning locally or on premise
 - It comes with micro8ks a single node kubernetes cluster