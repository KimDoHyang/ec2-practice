# sudo docker build -t ec2-deploy -f Dockerfile .

# Docker 이미지 생성
# ubuntu:18.04 version으로 생성
FROM        ubuntu:18.04
MAINTAINER  hanoul1124@gmail.com

# pipenv shell 실행 위한 기본 설정
# zshrc(bashrc or bash_profile)에 환경변수 설정과 같음
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Docker 컨테이너 생성 및 실행 후 진행 할 터미널 명령어를 RUN
# docker run -it /bin/bash에서 명령어 실행하는 것과 같은 원리
# 패키지 업그레이드 실행
# -y 옵션은 따로 터미널에서 Yes를 선택하지 않아도 자동으로 설치 진행하도록 설정
RUN         apt -y update
RUN         apt -y dist-upgrade

# python3 & pip install
RUN         apt -y install python3-pip

# install pipenv
RUN         pip3 install pipenv

# install Nginx, uWSGI(WebServer, WSGI(AppServer))
RUN         apt -y install nginx
RUN         pip3 install uwsgi

# 현재 실행 중인 호스트 폴더(ec2-deploy)의 내부에 있는 모든 파일을 복사
# 생성될 이미지의 /srv/project/에 붙여넣는다.
# 소스코드를 옮겨 Docker로 서버를 실행하기 위함이다.
COPY        ./  /srv/project/

# Working Directory 설정
WORKDIR     /srv/project

# virtualenv를 사용하지 않아야 한다.
#RUN         pipenv shell
# You need to use --system flag, so it will install all packages into the system python, and not into the virtualenv. Since docker containers do not need to have virtualenvs
# You need to use --deploy flag, so your build will fail if your Pipfile.lock is out of date
# You need to use --ignore-pipfile, so it won't mess with our setup
RUN         pipenv install --system --deploy --ignore-pipfile

# 분리한 settings 중 production 사용 설정(DEBUG=False)
ENV         DJANGO_SETTINGS_MODULE  config.settings.production

# 프로세스를 실행할 명령
# runserver를 실행하기 위한 Directory 이동
WORKDIR     /srv/project/app

# collectstatic으로 정적파일 루트 정리
# --noinput 은 -y 옵션과 유사한 기능을 하는 것
RUN         python3 manage.py collectstatic --noinput

# Nginx 설정
# 기존에 존재하던 Nginx 설정파일(default) 삭제
RUN         rm -rf  /etc/nginx/sites-available/*
RUN         rm -rf  /etc/nginx/sites-enabled/*

# 프로젝트 Nginx 설정파일 복사 및 enabled로 링크 설정
# cp -f 옵션은 강제로 복붙한다는 것(덮어씌우기)
# ln 은 링크 생성(바로가기)
RUN         cp -f   /srv/project/.config/app.nginx \
                    /etc/nginx/sites-available/
RUN         ln -sf /etc/nginx/sites-available/app.nginx \
                    /etc/nginx/sites-enabled/app.nginx

# CMD는 마지막 순서로 1번만 실행될 수 있으며, 이후 Dockerfile로 다른 코드를 실행할 수 없다.
#CMD         python3 manage.py runserver 0:8000

# uWSGI 실행
CMD         uwsgi --http :8000 --chdir /srv/project/app --wsgi config.wsgi