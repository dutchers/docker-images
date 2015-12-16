import os

pythonpath = "/srv/active/tmp/project/"
bind = "0.0.0.0:8000"

# Make sure to tune
workers = 4

loglevel = "WARNING"
logfile = "/var/log/gunicorn/django.log"
django_settings = "settings"
