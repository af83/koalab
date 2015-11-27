FROM node:5.1
# RUN git clone https://github.com/AF83/koalab.git /app
ADD . /app
WORKDIR /app
RUN cp config/server.json.example config/server.json
#?? $EDITOR config/server.json" 
RUN npm install -g grunt-cli 
RUN npm install .
RUN npm install -g bower
RUN bower install --allow-root
RUN grunt
EXPOSE 8080
RUN apt-get update && apt-get install -y mongodb
RUN echo '{"authorized": [ "*@dspeed.eu" ], "port": 80, "persona": { "audience": "http://localhost:80" }, "mongodb": { "host": "localhost", "database": "koalab" }}' > config/server.json
RUN echo '#!/bin/bash' > /init \
 &&  echo 'service mongodb start' >> /init \
 &&  echo 'sleep 15' >> /init \
 &&  echo 'node koalab.js' >> /init 
RUN chmod +x /init
CMD /init

