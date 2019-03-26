from .base import *

DEBUG = False

WSGI_APPLICATION = 'config.wsgi.application'

secrets = json.load(open(os.path.join(SECRETS_DIR, 'production.json')))

# .secrets의 production.json을 사용
# SECRET_KEY는 이미 base.py에서 base.json으로 import 했으므로,
# production.json에는 DATABASE : ec2_deploy 설정만 기록
DATABASES = secrets['DATABASES']