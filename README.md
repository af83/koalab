Koalab
======

[Koalab](https://github.com:AF83/koalab) is a scrum-like board for
brainstorming, [Scrum](http://en.wikipedia.org/wiki/Scrum_(development)) or to
[manage your family chores](http://scrum4kids.blogspot.fr/2010/09/using-scrum-for-saturday-chores.html).

It's powered by nginx, nodejs, mongodb, grunt, backbone and html5. It takes
profit of the most advanced features of html5, thus you should only use it
with a modern browser like Mozilla Firefox or Google Chrome.


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
[MongoDB](http://www.mongodb.org/) and run these commands:

```
git clone git@github.com:AF83/koalab.git
cd koalab
npm install .
npm install grunt -g
grunt
node koalab.js
firefox http://localhost:8080/
```


Credits
-------

Copyright (c) 2012 af83

Released under the MIT license
