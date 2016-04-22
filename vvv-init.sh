#!/bin/bash

# Init script for example project
# Replace example-project with a new project name

echo "Setting up for example-project project..."

# Make a database, if we don't already have one
echo "Creating database (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS example-project; GRANT ALL PRIVILEGES ON example-project.* TO 'wp'@'localhost' IDENTIFIED BY 'wp';"

# Run Composer
composer install --prefer-dist

# Check for the presence of a `htdocs` folder.
if [ ! -f "htdocs/wp-config.php" ]; then
	echo "Creating wp-config.php and installing WordPress"

	wp core config --dbname="example-project" --dbuser=wp --dbpass=wp --dbhost="localhost" --dbprefix=wp_ --locale=en_US --allow-root --extra-php <<PHP
define('WP_CONTENT_DIR', dirname(__FILE__).'/wp-content/' );
define('WP_SITEURL', 'http://example-project.dev/wp/');
define('WP_DEBUG', true);
define('WP_DEBUG_DISPLAY', false);
define('WP_DEBUG_LOG', true);
define('SCRIPT_DEBUG', true);
define('JETPACK_DEV_DEBUG', true);
PHP

	mv htdocs/wp/wp-config.php htdocs/

	wp core install --url=example-project.dev --title="example-project" --admin_user=root --admin_password=password --admin_email=root@example-project.dev --allow-root

	wp option update permalink_structure "/%postname%/" --allow-root
fi

# The Vagrant site setup script will restart Nginx for us

echo "example-project now installed";
