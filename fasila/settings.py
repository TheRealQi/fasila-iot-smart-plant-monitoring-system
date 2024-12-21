import os
from pathlib import Path
from dotenv import load_dotenv
import dj_database_url
import firebase_admin
from firebase_admin import credentials
import django_heroku
from datetime import timedelta

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = os.getenv('SECRET_KEY')
DEBUG = os.getenv('DEBUG', 'True')

cred = credentials.Certificate(os.path.join(BASE_DIR, 'fasila/service-account.json'))
firebase_admin.initialize_app(cred)

ALLOWED_HOSTS = ['.herokuapp.com', 'localhost', '192.168.1.13']

INSTALLED_APPS = [
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'corsheaders',
    'channels',
    'django_extensions',
    'rest_framework',
    'devices',
    'users',
    'communications',
    'notifications',
    'guide',
    'api'
]

AUTH_USER_MODEL = 'users.CustomUser'

DATABASES = {
    'default': dj_database_url.config(default=os.getenv('DATABASE_URL'))
}

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
]

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.IsAuthenticated',
    ]
}

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=365*100),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=1),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
    'AUTH_HEADER_TYPES': ('Bearer',),
}

ROOT_URLCONF = 'fasila.urls'

ASGI_APPLICATION = 'fasila.asgi.application'

REDIS_URL = os.getenv('REDIS_URL', 'redis://localhost:6379/1')

CHANNEL_LAYERS = {
    'default': {
        'BACKEND': 'channels_redis.core.RedisChannelLayer',
        'CONFIG': {
            'hosts': [{
                'address': REDIS_URL,
                'ssl_cert_reqs': None,
            }],
        },
    },
}

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')
AWS_STORAGE_BUCKET_NAME = os.getenv('AWS_STORAGE_BUCKET_NAME')
AWS_S3_REGION_NAME = os.getenv('AWS_S3_REGION_NAME', 'us-east-1')
AWS_S3_CUSTOM_DOMAIN = f'{AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com'

DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
STATICFILES_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'

AWS_LOCATION = 'media'
MEDIA_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/{AWS_LOCATION}/'

AWS_S3_OBJECT_PARAMETERS = {
    'CacheControl': 'max-age=86400',
}
AWS_PRELOAD_METADATA = True
AWS_QUERYSTRING_AUTH = False

LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'Africa/Cairo'
USE_I18N = False
USE_L10N = False
USE_TZ = False
CORS_ALLOW_ALL_ORIGINS = True

import django_heroku
django_heroku.settings(locals())