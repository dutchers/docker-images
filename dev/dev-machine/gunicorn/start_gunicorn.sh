# Customize this script if need to launch a configurable conf file. EI: -c `hostname`.py


COMMAND="/usr/local/bin/gunicorn  -c /srv/configs/gunicorn/gunicorn.py wsgi"

# New Relic enviroment variables - do NOT rename!
NEW_RELIC_ENVIRONMENT="dev-server"
NEW_RELIC_CONFIG_FILE="/srv/active/deploy/newrelic/newrelic.ini"

# New Relic startup script
NEW_RELIC_ADMIN="/srv/env/bin/newrelic-admin"

if [ -f $NEW_RELIC_CONFIG_FILE ] && [ -f $NEW_RELIC_ADMIN ]
then
    export NEW_RELIC_ENVIRONMENT
    export NEW_RELIC_CONFIG_FILE
    exec $NEW_RELIC_ADMIN run-program $COMMAND
else
    exec $COMMAND
fi
