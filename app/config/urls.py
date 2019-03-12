"""config URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path
# django.conf.settings로 해야만 env에 설정한 DJANGO_SETTINGS_MODULE 연결
from django.conf import settings
from . import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.index, name='index'),
]


# MEDIA_URL로 시작하는 URL은 static()내의 serve() 함수를 통해 처리
# MEDIA_ROOT기준으로 파일을 검색함
# DEBUG = True 옵션을 통해 정적파일 처리 시 미디어 파일 처리 설정에 필요
# 단 production 환경에서는 사용하지 않는 것을 권장하므로, 조건 처리
# 이를 미리 static() 내부에서 설정해놓았기 때문에, 따로 if DEBUG = True 옵션을 줄 필요는 없다
urlpatterns += static(
    prefix=settings.MEDIA_URL,
    document_root=settings.MEDIA_ROOT,
)