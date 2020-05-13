#!/usr/bin/env bash

##
# Prepares a site for development.
#
# The assumption is that we're bootstrapping with a database-dump from
# another environment, and need to import configuration and run updb.

set -euo pipefail

IFS=$'\n\t'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILES=("web/sites/default/files" "private")

# Chmod to 777 if the file is not owned by www-data
cd "${SCRIPT_DIR}/../../"

if [ ! -d "web" ]
then
    echo "Directory web does not exist."
    echo "Did you remember to run 'make drush-make' ?"
    exit 9999 # die with error code 9999
fi

mkdir -p "${FILES[@]}"
find "${FILES[@]}" \! -uid 33  \! -print0 -name .gitkeep | sudo xargs -0 chmod 777

sudo chmod -R 777 web/sites

docker-compose exec fpm sh -c  "cp /var/www/docker/docker.settings.php /var/www/web/sites/default/settings.php"

# Make sites/default read-only and executable
time docker-compose exec fpm sh -c  "\
  echo ' * Waiting php container to be ready' \
  && wait-for-it -t 60 localhost:9000 \
  && echo ' * Waiting for the database to be available' \
  && wait-for-it -t 60 db:3306 \
  && echo 'Site reset' \
  && echo ' * Update database' \
  && drush -y updatedb \
  && echo ' * Cache clear' \
  && drush cc all \
  && echo ' * drush css-generate.' \
  && drush css-generate \
  && echo ' * Cache clear' \
  && drush cc all
  "
