sudo docker kill ksd_shiny

sudo docker rm ksd_shiny

sudo docker run --name ksd_shiny -d -p 8282:5050 -v $PWD/Shiny/:/srv/shiny-server/ bioxfu/shiny-server

sudo docker exec -ti ksd_shiny /bin/bash

# in docker container
# cd /srv/shiny-server/
# R
# > library(shiny)
# > runApp(host='0.0.0.0', port=5050)
