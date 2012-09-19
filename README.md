Koalab
======

A scrum-like board powered by nginx, nodejs, mongodb, backbone and html5.

How to run it in local?
-----------------------

```
git clone git@github.com:AF83/koalab.git
cd koalab
su -
# echo "127.0.0.1 koalab.lo >> /etc/hosts"
# cp admin/nginx/koalab.lo /etc/nginx/site-enabled/
# /etc/init.d/nginx reload
# exit
npm install .
npm install grunt -g
grunt
node app.js
```
