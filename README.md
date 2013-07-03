Koalab
======

[Koalab](https://github.com/AF83/koalab) is a board for brainstorming,
[Scrum](http://en.wikipedia.org/wiki/Scrum_\(development\)) or managing your
[family chores](http://scrum4kids.blogspot.fr/2010/09/using-scrum-for-saturday-chores.html).

It's powered by nginx, nodejs, mongodb, grunt, backbone and html5. It takes
profit of the most advanced features of html5, thus you should only use it
with a modern browser like Mozilla Firefox or Google Chrome.


Screenshot
----------

You can try Koalab on [koalab.af83.com](http://koalab.af83.com).

![Our board](https://raw.github.com/AF83/koalab/master/public/screenshots/board.png)


Features
--------

On koalab, you can:

* Login with [Mozilla Persona](http://www.mozilla.org/persona/) (was BrowserID)
* Create a board
* Show a board
* Add post-its on it: blue, green, rose or yellow, it's your choice
* Edit in place the title of a post-it
* Move post-its with drag'n'drop
* Resize post-its
* Add some lines to cluster post-its

And our killer features are:

* A very cute logo <3 <3 <3
* When a post-it is moved or edited, it's brought on top of the other post-its.
* The font size of post-its is automatically adjusted to avoid its text to overflow.
* And it's real-time! When a user does something, it's reflected almost instantaneously
  on the browsers of the participants of this board!


How to run it in local?
-----------------------

Install [Git](http://git-scm.com/), [NodeJS](http://www.nodejs.org/),
[MongoDB](http://www.mongodb.org/), [Grunt](http://gruntjs.com/getting-started)
and run these commands:

```
git clone git@github.com:AF83/koalab.git
cd koalab
cp config/server.json.example config/server.json
$EDITOR config/server.json
npm install -g grunt-cli
npm install .
./node_modules/bower/bin/bower install
grunt
node koalab.js
firefox http://localhost:8080/
```


And for production?
-------------------

In production, we are using:

- nginx (you can find an example of the vhost config in the config/nginx directory)
- [forever](https://github.com/nodejitsu/forever) (`npm install forever -g` on the server)
- and [mina](http://nadarei.co/mina/) for deployments.


Configuration
-------------

The `config/server.json` file contains some configuration entries:

- `authorized` is an array with the list of email addresses than can access
  this koalab instance. `*` can be used as a joker to match one or more
  characters: `*@example.com` will authorized everybody whose email address
  has `example.com` as domain.
- `port` is the TCP port the node will listen to.
- `persona.audience` is the public hostname and port of the website.
- `mongodb` is the database informations.


JavaScript Code Analysis
------------------------

[Plato](http://github.com/jsoverson/plato) can be used to generate two reports
on the JavaScript Code Analysis (back and front):

```
grunt plato
$BROWER reports/back/index.html
$BROWER reports/front/index.html
```


Credits
-------

The logo is the copyright of [Charlotte Schimdt](http://pattedemouche.free.fr/)
and can be distributed and used for personal purpose.

Copyright (c) 2012 af83

Released under the MIT license
