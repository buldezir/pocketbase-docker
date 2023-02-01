#!/bin/sh

if [ "$1" = '/pb/pocketbase' ]; then
    if [ "$ADMIN_EMAIL" != '' ] && [ "$ADMIN_PASSWORD" != '' ]; then
        cp /pb/1675281304_create_admin.js /pb/pb_migrations/1675281304_create_admin.js || true
        sed -i "s/ADMIN_EMAIL/$ADMIN_EMAIL/g" /pb/pb_migrations/1675281304_create_admin.js
        sed -i "s/ADMIN_PASSWORD/$ADMIN_PASSWORD/g" /pb/pb_migrations/1675281304_create_admin.js
    else
        rm /pb/pb_migrations/1675281304_create_admin.js || true
    fi
    
fi

# curl -X POST -H 'Content-Type: application/json' -d '{"email":"test@example.com","password":"1234567890","passwordConfirm":"1234567890"}' http://0.0.0.0:8080/api/admins || true

exec "$@"