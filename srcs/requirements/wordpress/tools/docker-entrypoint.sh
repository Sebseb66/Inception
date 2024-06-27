#!/bin/bash

sleep 10

if [ ! -e /var/www/wordpress/wp-config.php ]; then
    echo "CREATION WP-CONFIG.PHP on sfroidev.42.fr"

    wp config create \
        --dbname=$WP_DB \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=$DB_HOST \
        --allow-root --path='/var/www/wordpress'
fi

if [ $? -ne 0 ]; then
    echo "Echec de la creation du fichier wp-config.php"
    exit 1
fi

if [ ! `wp option get siteurl --path='/var/www/wordpress' > /dev/null 2>&1` ]; then

    wp core install \
        --url=sfroidev.42.fr \
        --title="$SITE_TITLE" \
        --admin_user=$WP_ADMIN_LOGIN \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root --path='/var/www/wordpress'
fi

if [ ! `wp user get $WP_USER --path='/var/www/wordpress' > /dev/null 2>&1` ]; then
    wp user create --allow-root --role=author $WP_USER $WP_EMAIL \
        --user_pass=$WP_PASSWORD --path='/var/www/wordpress' >> /log.txt
fi

exec "$@"

