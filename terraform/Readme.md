docker build -t proj-terraform:latest .
docker run -it --rm --mount type=bind,source="C:\personal\Final\terraform\src",target=/apps/terraform --env-file .\src\config.env proj-terraform:latest 

#If you need to open the shell inside the container please use the following

docker run -it --rm --mount type=bind,source="C:\personal\Final\terraform\src",target=/apps/terraform --entrypoint "/bin/sh" proj-terraform:latest

