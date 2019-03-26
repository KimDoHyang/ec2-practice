from .base import *

DEBUG = True

WSGI_APPLICATION = 'config.wsgi.application'

secrets = json.load(open(os.path.join(SECRETS_DIR, 'development.json')))

# .secrets의  development.json을 사용
# SECRET_KEY는 이미 base.py에서 base.json으로 import 했으므로,
# development.json에는 DATABASE 설정만 기록
DATABASES = secrets['DATABASES']