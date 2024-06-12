#!/bin/bash
cd "$(dirname "$0")" || exit 1

source test-utils.sh vscode

# Run common tests
checkCommon

# Template specific tests
check "php" php --version
check "apache2ctl" which apache2ctl
check "composer" which composer
check "xdebug" [ "$(php --version | grep -i xdebug)" ]

check "joomla-installation" [ -d "/var/www/html/installation" ]

# Report result
reportResults
