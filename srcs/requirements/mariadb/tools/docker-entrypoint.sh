#!/bin/bash

set -e

# Vérifie et initialise la base de données si nécessaire
if [ ! -d "/var/lib/mysql" ]; then
    echo "Le répertoire /var/lib/mysql n'existe pas. Initialisation de la base de données..."
    mysql_install_db
fi

# Vérifie et prépare le répertoire de runtime de MariaDB
if [ ! -d "/run/mysqld" ]; then
    echo "Le répertoire /run/mysqld n'existe pas. Création..."
    mkdir -p /run/mysqld
    chown mysql:mysql /run/mysqld
fi

echo "Démarrage de MariaDB..."
mariadbd --skip_networking &

echo "Attente que MariaDB démarre..."
sleep 10

# Changement du mot de passe root si nécessaire
if ! mysqladmin ping -h localhost --silent; then
    DB_PASSWORD_ROOT=${DB_PASSWORD_ROOT:-password}
    echo "Changement du mot de passe root..."
    mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASSWORD_ROOT}'"
else
    echo "MariaDB est déjà en cours d'exécution, pas de réinitialisation du mot de passe."
fi

# Configuration de la base de données et des utilisateurs
mariadb -u root -p"${DB_PASSWORD_ROOT}" <<EOF
CREATE DATABASE IF NOT EXISTS ${WP_DB};
DROP USER IF EXISTS '${DB_USER}'@'%';
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${WP_DB}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p"${DB_PASSWORD_ROOT}" shutdown

echo "Démarrage de mariadbd en premier plan..."
exec "$@"
