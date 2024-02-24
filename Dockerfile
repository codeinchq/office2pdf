####################################################################################################
# OFFICE2PDF
####################################################################################################
FROM --platform=$TARGETPLATFORM node:lts-alpine AS office2pdf

ENV PORT=3000
ENV NODE_ENV=production
WORKDIR /app

# https://github.com/woahbase/alpine-libreoffice/blob/master/Dockerfile_x86_64
RUN apk add --no-cache --purge -uU \
        curl icu-libs unzip zlib-dev musl \
        mesa-gl mesa-vulkan-swrast \
        libreoffice libreoffice-base libreoffice-lang-fr \
        ttf-freefont ttf-opensans ttf-inconsolata \
        ttf-liberation ttf-dejavu \
        libstdc++ dbus-x11 \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache -U ttf-font-awesome ttf-mononoki ttf-hack \
    && rm -rf /var/cache/apk/* /tmp/*


####################################################################################################
# OFFICE2PDF prod
####################################################################################################
FROM office2pdf AS office2pdf-prod

COPY main.mjs /app/
COPY package.json /app/
COPY package-lock.json /app/
RUN mkdir -p /app/temp
RUN npm install --production

EXPOSE $PORT
ENTRYPOINT ["node", "main.mjs"]


####################################################################################################
# OFFICE2PDF dev
####################################################################################################
FROM office2pdf AS office2pdf-dev

ENV NODE_ENV=development
RUN npm install --global nodemon

EXPOSE $PORT
ENTRYPOINT ["nodemon", "main.mjs"]
