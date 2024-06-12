#!/bin/bash

USERNAME="vscode"

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

usermod -aG www-data ${USERNAME}

chmod -R g+w /var/www/html

echo -e "Done!"
