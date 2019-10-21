docker build -t proj-helm:latest .
docker run -it --rm --mount type=bind,source="C:\personal\Final\helm\src",target=/apps/helm --env-file .\src\config.env proj-helm:latest 

#If you need to open the shell inside the container please use the following

docker run -it --rm --mount type=bind,source="C:\personal\Final\helm\src",target=/apps/helm --entrypoint "/bin/sh" proj-helm:latest

