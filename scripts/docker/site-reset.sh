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

# Determine if we have Dory.
if [[ $(type -P "dory") ]]; then
    echo "Starting dory.."
    dory up
fi

mkdir -p "${FILES[@]}"
find "${FILES[@]}" \! -uid 33  \! -print0 -name .gitkeep | sudo xargs -0 chmod 777

sudo chmod -R 777 web/sites/default

docker-compose exec fpm sh -c  "cp /var/www/docker/docker.settings.php /var/www/web/sites/default/settings.php"

# Make sites/default read-only and executable
time docker-compose exec fpm sh -c  "\
  echo ' * Waiting php container to be ready' \
  && wait-for-it -t 60 localhost:9000 \
  && echo ' * Waiting for the database to be available' \
  && wait-for-it -t 600 db:3306 \
  && echo 'Site reset' \
  && echo ' * Disable modules that conflict with local setup.' \
  && drush dis -y ddb_cp \
  && echo ' * Update database (drush -y updatedb)' \
  && drush -y updatedb \
  && echo ' * Cache clear (drush cc all)' \
  && drush cc all \
  && echo ' * Generate the variable-based CSS. (drush css-generate).' \
  && drush css-generate \
  && echo ' * Enable Connie opensearch tokens (drush en -y connie_openplatform_token).' \
  && drush en -y connie_openplatform_token \
  && echo ' * Cache clear (drush cc all)' \
  && drush cc all
  "

"${SCRIPT_DIR}/done.sh"
