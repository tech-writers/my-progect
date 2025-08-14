FROM node:20-alpine

# Установка необходимых пакетов
RUN apk add --no-cache git

# Установка Antora CLI + Site Generator
RUN npm install -g antora

# Установка lunr-расширения нужной версии
RUN npm install -g @antora/lunr-extension

WORKDIR /antora

ENTRYPOINT ["antora"]
CMD ["antora-playbook.yml"]