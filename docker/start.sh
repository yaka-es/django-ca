#!/bin/sh

DJANGO_CA_UWSGI_INI=${DJANGO_CA_UWSGI_INI:-/usr/src/django-ca/uwsgi/standalone.ini}

if [ ! -e /var/lib/django-ca/secret_key ]; then
    python <<EOF
import random, string

key = ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(32))
with open('/var/lib/django-ca/secret_key', 'w') as stream:
    stream.write(key)
EOF
fi

python ca/manage.py migrate --noinput
uwsgi --ini ${DJANGO_CA_UWSGI_INI}
