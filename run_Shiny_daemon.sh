sudo docker kill ksd_shiny

sudo docker rm ksd_shiny

sudo docker run --name ksd_shiny -d -p 8282:3838 -v $PWD/Shiny/:/srv/shiny-server/ bioxfu/shiny-server
