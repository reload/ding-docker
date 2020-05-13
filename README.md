# Docker for Ding

Still unpolished and in the works.

## Prerequisites

This project assumes that the following software is installed and working on your machine:

- [Docker and docker-compose](https://www.docker.com/community-edition#/download)
- [Drush 8.x](http://docs.drush.org/en/8.x/install/)

## Preparation

Clone this repository
```sh
% git clone https://github.com/reload/ding-docker.git
% cd ding-docker
```

### Make sure you have a local drush that is BELOW version 9.
This is necessary, as the ding2 project uses .make files, which became unsupported in Drush 9.

Setup the .make files:
```sh
$ make drush-make
```

If you have an existing project, with a drupal core, you can use this:
```sh
$ make drush-remake
```

### Using NFS with Docker for Mac
This project is NFS enabled. You need to copy over the override file for it to work:
```sh
$ cp docker-compose.mac-nfs.yml docker-compose.override.yml
```

### Starting the docker and drupal setup:
"I want everything to be reset, and I dont care about losing any data":
```sh
$ make reset
```

"I want to just bring the containers up again":
```sh
$ make up
```

### Using a custom version of the codebase

To use a custom version of the code base then first complete the steps above. add your fork as a remote to the profile and checkout your branch:

```sh
% cd web/profiles/ding2
% git remote add [remote name] [remote repository url]
% git fetch [remote name]
% git checkout -t [remote name]/[remote branch]
```

In the following example we work with the `master` branch from the Reload fork of Ding2:

```sh
% cd web/profiles/ding2
% git remote add reload git@github.com:reload/ding2.git
% git fetch reload
% git checkout -t reload/master
```


Note that you may have to clear the cache, download new dependencies or even reinstall the site to make the changes take effect.

## Install ding

This setup includes a database containing data from a clean installation of the latest version of Ding. Thus the system is already installed.

If you want to run the install profile yourself you have to drop the contents of the datase first. After that running the install profile can sometimes be tricky.

The sure-fire way (especially on Mac) is to run the install script through the browser:
http://local.docker/install.php (Use the ding2 profile)

Notice: This way can be pretty slow.


A faster, but not-so-sure way is to run the install-script through Drush:

From inside the docker web containers document root (`/var/www/html`) do:
```sh
% drush site-install ding2
```

## Stuff not polished yet

* varnish only one way
* the drush container does not have access to the SOAP connection that the web container has. This makes it fail on site-install sometimes
