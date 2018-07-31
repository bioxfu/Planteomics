sudo docker kill plumber_api
sudo docker rm plumber_api
sudo docker run --name plumber_api -d -p 8080:8000 -v $PWD/app:/app bioxfu/plumber
