#!/bin/bash
cd $(dirname "$0")
source test-utils.sh vscode

# Run common tests
checkCommon

# Template specific tests
check "php" php --version
check "apache2ctl" which apache2ctl
check "composer" which composer
check "xdebug" [ "$(php --version | grep -i xdebug)" ]

check "joomla-installation" [ -f "/var/www/html/configuration.php" ]
check "joomla" /var/www/html/cli/joomla.php --version

sleep 10 # Sleep to be sure MariaDB is running.
check "mariadb" mariadb -h localhost -P 3306 --protocol=tcp -u root --password=joomla -D joomladb -Bse exit

# Report result
reportResults
