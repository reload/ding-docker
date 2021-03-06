#!/bin/sh

# Make sure files folders exists and are owned by www-data.
mkdir -p /var/www/web/sites/default/files/private
chown -R www-data /var/www/web/sites/default/files

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
