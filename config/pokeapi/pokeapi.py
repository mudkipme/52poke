# Docker settings
from .settings import *
import os

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql_psycopg2",
        "NAME": "pokeapi",
        "USER": os.getenv('POSTGRES_USER'),
        "PASSWORD": os.getenv('POSTGRES_PASSWORD'),
        "HOST": "postgres",
        "PORT": 5432,
    }
}


CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://redis:6379/1",
        "OPTIONS": {"CLIENT_CLASS": "django_redis.client.DefaultClient",},
    }
}

DEBUG = False
TASTYPIE_FULL_DEBUG = False

ADMINS = (
    ('52POKE', 'no_reply@52poke.net'),
)
BASE_URL = 'https://pokeapi.52poke.com'
ALLOWED_HOSTS = ['.52poke.com', 'localhost', 'pokeapi']
