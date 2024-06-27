#!/bin/sh

set -e

echo "Test de la configuration Nginx..."
nginx -t

echo "Démarrage de Nginx..."
exec nginx -g "daemon off;"
