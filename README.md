Koalab
======

A scrum-like board powered by nginx, nodejs, mongodb, backbone and html5.

How to run it in local?
-----------------------

Admin

```
git clone git@github.com:AF83/koalab.git
cd koalab
su -
# echo "127.0.0.1 koalab.lo >> /etc/hosts"
# cp admin/nginx/koalab.lo /etc/nginx/site-enabled/
# /etc/init.d/nginx reload
```

Restful API

```
cd nodeapi
npm install
node app.js
```

Front

```
cd front
npm install grunt -g
npm install grunt-contrib grunt-coffeelint
grunt
```
