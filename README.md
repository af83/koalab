Boardz
======

A scrum-like board powered by nginx, nodejs, mongodb and backbone.

How to run it in local?
-----------------------

1. Admin

```
git clone git@github.com:AF83/boardz.git
cd boardz
su -
# echo "127.0.0.1 boardz.lo >> /etc/hosts"
# cp admin/nginx/boardz.lo /etc/nginx/site-enabled/
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
