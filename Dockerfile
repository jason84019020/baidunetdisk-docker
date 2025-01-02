FROM jlesage/baseimage-gui:debian-12-v4

ENV APP_NAME=baidunetdisk
ENV LANG=zh_TW.UTF-8
ENV TZ=Asia/Taipei
ENV HOME=/config

RUN apt update \
    && apt install -y curl \
    jq wget locales locales-all pcmanfm tint2 \
    libgbm1 libasound2 \
    && locale-gen ${LANG} \
    && update-locale LANG=${LANG} \
    && export BROWSER_URL=$(curl -s https://pan.baidu.com/disk/cmsdata?do=client | jq -r '.linux.url_1') \
    && export BROWSER_PACKAGE_NAME=$(basename ${BROWSER_URL}) \
    && wget -q -c ${BROWSER_URL} \
    && apt install -y ./${BROWSER_PACKAGE_NAME} \
    && install_app_icon.sh https://nd-static.bdstatic.com/m-static/v20-main/home/img/icon-home-new.b4083345.png \
    && mkdir -p /config/Desktop \
    && mkdir -p /config/Downloads \
    && mkdir -p /config/BrowserUserData \
    && chmod 777 -R /config \
    && chmod 777 -R /config/Desktop \
    && chmod 777 -R /config/Downloads \
    && chmod 777 -R /config/BrowserUserData \
    && sed -i 's/<decor>no<\/decor>/<decor>yes<\/decor>/g' /opt/base/etc/openbox/rc.xml.template \
    && sed -i 's/<maximized>true<\/maximized>/<maximized>false<\/maximized>/g' /opt/base/etc/openbox/rc.xml.template \
    && rm ./${BROWSER_PACKAGE_NAME} \
    && rm -rf /var/lib/apt/lists/*

COPY startapp.sh /startapp.sh
COPY baidunetdisk.desktop /config/Desktop/baidunetdisk.desktop
COPY baidunetdisk.sh /opt/baidunetdisk/baidunetdisk.sh
