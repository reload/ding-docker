#!/bin/sh

# Install git and patch commands, since we need them for Drush Make operations.
DPKG_STATUS=$(dpkg-query -s git 2>/dev/null)
if [ $? -eq 1 ]; then
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install git patch
fi

# Make sure files folders exists and are owned by www-data.
mkdir -p /var/www/html/sites/default/files/private
chown -R www-data /var/www/html/sites/default/files

# Put cron file into function.
if [ -r /etc/cron.d/drupal-cron.conf ]; then
    # We do a cp to make sure the file is owned by root (the .conf
    # file is mounted into the volume and is owned by the outside user
    # -- besides that the . in the name makes it ignore by crond).
    cp /etc/cron.d/drupal-cron.conf /etc/cron.d/drupal-cron
    chown root:root /etc/cron.d/drupal-cron
fi

# Enable ding PHP configuration.
phpenmod ding

mkdir -p /root/.ssh && touch /root/.ssh/known_hosts && ssh-keyscan -H github.com >> /root/.ssh/known_hosts && chmod 600 /root/.ssh/known_hosts
