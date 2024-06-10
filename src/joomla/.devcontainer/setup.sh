#!/bin/bash

set -e

cd /var/www/html

if [ -z "${JOOMLA_DB_HOST}" ] || [ -z "${JOOMLA_DB_USER}" ] ||
    [ -z "${JOOMLA_DB_NAME}" ] || [ -z "$JOOMLA_DB_PASSWORD" ] ||
    [ -z "${JOOMLA_SITE_NAME}" ] || [ -z "${JOOMLA_ADMIN_USER}" ] ||
    [ -z "${JOOMLA_ADMIN_USERNAME}" ] || [ -z "${JOOMLA_ADMIN_PASSWORD}" ] ||
    [ -z "${JOOMLA_ADMIN_EMAIL}" ]; then

    echo >&2 "error: missing JOOMLA_DB_HOST, JOOMLA_DB_USER, JOOMLA_DB_NAME, JOOMLA_DB_PASSWORD,"
    echo >&2 "JOOMLA_SITE_NAME, JOOMLA_ADMIN_USER, JOOMLA_ADMIN_USERNAME, JOOMLA_ADMIN_PASSWORD, "
    echo >&2 "or JOOMLA_ADMIN_EMAIL environment variables."

    exit 1
fi

# Sleep to be sure MariaDB is running.
sleep 10

if [ -d installation ] && [ -e installation/joomla.php ]; then
    installJoomlaArgs=(
        --site-name="${JOOMLA_SITE_NAME}"
        --admin-email="${JOOMLA_ADMIN_EMAIL}"
        --admin-username="${JOOMLA_ADMIN_USERNAME}"
        --admin-user="${JOOMLA_ADMIN_USER}"
        --admin-password="${JOOMLA_ADMIN_PASSWORD}"
        --db-type="${JOOMLA_DB_TYPE:-mysqli}"
        --db-host="${JOOMLA_DB_HOST}"
        --db-name="${JOOMLA_DB_NAME}"
        --db-pass="${JOOMLA_DB_PASSWORD}"
        --db-user="${JOOMLA_DB_USER}"
        --db-prefix="${JOOMLA_DB_PREFIX:-joom_}"
        --db-encryption=0
        --public-folder=""
    )

    # Run the auto deploy (install)
    if php installation/joomla.php install "${installJoomlaArgs[@]}"; then
        # The PHP command succeeded (so we remove the installation folder)
        rm -rf installation

        echo >&2 "========================================================================"
        echo >&2
        echo >&2 "This server is now configured to run Joomla!"

        # fix the configuration.php ownership
        if ! chown www-data:www-data configuration.php; then
            echo >&2
            echo >&2 "Error: Ownership of configuration.php failed to be corrected."
        fi

        # Set configuration to correct permissions
        if ! chmod 444 configuration.php; then
            echo >&2
            echo >&2 "Error: Permissions of configuration.php failed to be corrected."
        fi

        echo >&2
        echo >&2 "========================================================================"
    fi
fi

exec "$@"
