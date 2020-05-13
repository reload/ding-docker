# Docker for Ding

Still unpolished and in the works.

## Prerequisites

This project assumes that the following software is installed and working on your machine:

- [Docker and docker-compose](https://www.docker.com/community-edition#/download)
- [Drush 8.x](http://docs.drush.org/en/8.x/install/)

## Preparation

Clone this repository
```sh
$ git clone https://github.com/reload/ding-docker.git
$ cd ding-docker
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
This project is Mac NFS enabled. You need to copy over the override file for it to work:
[Reloaders can find a guide on how to set up NFS here](https://reload.atlassian.net/wiki/spaces/RW/pages/153288705/Docker+for+Mac#DockerforMac-5.NFS)

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

### You should now have a local site available
Assuming you're using [dory](https://github.com/FreedomBen/dory), you can visit it at https://ding2.docker

Otherwise, you need to visit it using localhost:XXXX. 
You can find the port using `$ docker-compose ps` and seeing what `web` is set to.

### Using a custom version of the codebase

To use a custom version of the code base then first complete the steps above.
To use this fork as your origin with the ding2/ding2 as your upstream, do this:

```sh
$ cd web/profiles/ding2
$ git remote add origin git@github.com:reload/ding2.git
$ git remote add upstream git@github.com:ding2/ding2.git
$ git fetch origin
$ git fetch upstream
$ git checkout master
```

and then, if you want to make sure that the origin (reload/ding2) is up to date with upstream (ding2/ding2):
```sh
$ git rebase upstream/master
$ git push origin master
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
$ drush site-install ding2
```

## Stuff not polished yet

* varnish only one way
