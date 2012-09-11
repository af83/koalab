Koalab
======

A scrum-like board powered by nginx, nodejs, mongodb, backbone and html5.

How to run it in local?
-----------------------

1. Admin

```
git clone git@github.com:AF83/koalab.git
cd koalab
su -
# echo "127.0.0.1 koalab.lo >> /etc/hosts"
# cp admin/nginx/koalab.lo /etc/nginx/site-enabled/
# /etc/init.d/nginx reload
```

2. Restful API

```
cd nodeapi
npm install
node app.js
```

3. Front

```
cd front
npm install grunt -g
npm install grunt-contrib
npm install grunt-coffeelint
grunt
```
