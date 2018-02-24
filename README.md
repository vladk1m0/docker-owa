Open Web Analytics docker image based on Alpine Linux.
==============================================
 Open Web Analytics docker image depends on PHP-FPM 5.x & Nginx and build on [Alpine Linux](http://www.alpinelinux.org/).  
[Open Web Analytics (OWA)](http://www.openwebanalytics.com) is open source web analytics software licensed under GPL and provides website owners and developers with easy ways to add web analytics to their sites using simple Javascript, PHP, or REST based APIs.  

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)[![Build Status](https://travis-ci.org/vladk1m0/alpine-owa.svg?branch=master)](https://travis-ci.org/vladk1m0/alpine-owa)[![Docker Pulls](https://img.shields.io/docker/pulls/vladk1m0/alpine-owa.svg)](https://hub.docker.com/r/vladk1m0/alpine-owa/)

How to use this image
-----
Start the Docker containers:
```
docker run -p 80:80 --name my-owa --link my-mysql:db -d vladk1m0/alpine-owa
```
Once started, you'll arrive at the configuration wizard.   
At the Database Setup step, please enter the following

    Database Server: db
    Database Name: owadb (or you can choose)
    Login: MYSQL_USER
    Password: MYSQL_PASSWORD
   
Then you can continue the installation with the super user. 

Via docker-compose
----
```
docker-compose up
```
Notice, that the .env file contains the default values for MYSQL_ environment vars.

Contribute
----
Pull requests are very welcome!

Special thanks to
-----
Padams for [Open-Web-Analytics](https://github.com/padams)  
Tim de Pater for [docker-php-nginx](https://github.com/TrafeX/docker-php-nginx)
