"""
WSGI config for config project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/2.1/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')

# application 변수가 uWSGI로 Django 정보를 전달할 것
# uWSGI 실행 시 --wsgi config.wsgi
application = get_wsgi_application()
