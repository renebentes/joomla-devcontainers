#!/bin/bash

USERNAME="vscode"

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

usermod -aG www-data ${USERNAME}

WEBDIR=/var/www/html
cp -r /usr/src/joomla/* ${WEBDIR}

# NOTE: The "Indexes" option is disabled in the php:apache base image so remove it as we enable .htaccess
sed -r 's/^(Options -Indexes.*)$/#\1/' ${WEBDIR}/htaccess.txt >${WEBDIR}/.htaccess

chown -R www-data:www-data ${WEBDIR}
chmod -R g+w ${WEBDIR}

echo -e "Done!"
