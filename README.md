# Docker for Ding

Still unpolished and in the works.

## Københavns biblioteker (KKB)
See the bottom of this README for info on how to get ding-docker/ding2 working with KKB

## Prerequisites

This project assumes that the following software is installed and working on your machine:

- [Docker and docker-compose](https://www.docker.com/community-edition#/download)
- [Drush 8.x](http://docs.drush.org/en/8.x/install/)

## Preparation

### Clone this repository
```sh
$ git clone https://github.com/reload/ding-docker.git
$ cd ding-docker
$ composer install
```

### Get the latest .make files:
```sh
$ make drush-make-download
```

You can also define what version of ding2 you want to setup:

**Remember to also be on the right git branch in your web/profiles/ding2 git repo!**
```sh
$ make drush-make-download ding_version=7.x-6.2.1
```

### Setup the .make files
This will also install core, and **will delete your `web` folder!**

If your `web` folder is deleted, **you lose all the progress** you've made further on in these instructions!

```sh
$ make drush-make
```

### If you have an existing project, with a drupal core, you can use this:

This will *NOT delete your `web` folder.

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
**"I want everything to be reset, and I dont care about losing any data":**
```sh
$ make reset
```

**"I want to just bring the containers up again! I'll reset what I need to reset myself":**
```sh
$ make up
```

### You should now have a local site available
Assuming you're using [dory](https://github.com/FreedomBen/dory), you can visit it at https://ding2.docker

Otherwise, you need to visit it using localhost:XXXX. 

You can find the port using `$ docker-compose ps` and seeing what `web` is set to.

### Using a custom version of the codebase (Recommended)

To use a custom version of the code base then first complete the steps above.

To use this fork as your origin with the ding2/ding2 as your upstream, do this:

```sh
$ make setup-git-remotes
```

and then, if you want to make sure that the origin (reload/ding2) is up to date with upstream (ding2/ding2):

(Substitute `master` with an alternative tag/version if you've used another `ding_version` version above/below)
```sh
$ cd web/profiles/ding2
$ git checkout master
$ git rebase upstream/master
$ git push origin master
```

Note that you may have to clear the cache, download new dependencies or even reinstall the site to make the changes take effect.

## Install ding yourself, without a database dump (not recommended)

This setup includes a database containing data from a clean installation of the latest version of Ding. Thus the system is already installed.

If you want to run the install profile yourself you have to drop the contents of the datase first. After that running the install profile can sometimes be tricky.

The sure-fire way (especially on Mac) is to run the install script through the browser:

http://local.docker/install.php (Use the ding2 profile)

**Notice: This way can be pretty slow.**


A faster, but not-so-sure way is to run the install-script through Drush:

From inside the docker web containers document root (`/var/www/html`) do:
```sh
$ drush site-install ding2
```

## Stuff not polished yet

* varnish only one way (whatever that means)

# "I need to work with Københavns Biblioteker (KKB)"

First of all: **Lucky you!**
All you need to do is follow the patented 6 step programme™️! 

(..after following the million step programme above..)

1) **Talk with Nino to get a DDB dump**
2) **Update/create a docker-compose.override.yml with the following**
  ```
  version: '3'
  
  services:
    db:
      volumes:
        - "./docker/db:/docker-entrypoint-initdb.d"
        
    # Dont delete any other stuff you have in the file, such as 'volumes'
  ```
3) **Put the .sql dump in `/docker/db`:**
  ```
  ╰─$ ll -la  ~/code/ding-docker/docker/db                                                                                                                                                                                130 ↵
  total 3855224
  drwxr-xr-x   4 rasben  staff   128B Mar 25 11:41 .
  drwxr-xr-x  10 rasben  staff   320B Mar 25 11:40 ..
  -rw-r--r--@  1 rasben  staff   1.8G Oct 21 14:53 koebenhavnddbc_0.sql  
  ```
4) **The codebase (Drupal modules) for KKB is available at https://github.com/kdb/kkb-ddb-modules**
  - `git clone git@github.com:kdb/kkb-ddb-modules.git web/sites/all/modules/kkb-ddb-modules`
  - Just like the ding2 codebase is now available - as a git repo - in `web/profiles/ding2/` (see more about that above), the KKB codebase is now available in `web/sites/all/modules/kkb-ddb-modules`
  - It's a git sub-repo, so you also need to do your `git` commands inside the subfolders.

5) `make reset` in the `ding-docker` root
  - Buckle up, buckaroo! This is gonna take a while, because of the big DB dump!

6) After the initial setup, it's a good idea to use **`make up`** instead of **`make reset`** to speed up the process

### Troubleshooting:

```
wait-for-it: timeout occurred after waiting XXX seconds for db:3306
make: *** [_reset-container-state] Error 124
```

The DB-dump from KK is huge. We've set it to wait for 600 seconds, but sometimes that isnt enough.
You can bump the number up even more in `scripts/docker/site-reset.sh` - however if 10 minutes wasnt enough for you, there might be a bigger issue at hand.
