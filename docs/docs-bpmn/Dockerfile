FROM node:20-slim

# Установка зависимостей
RUN apt-get update && \
    apt-get install -y \
      inkscape \
      chromium \
      libatk-bridge2.0-0 \
      libxcomposite1 \
      libxdamage1 \
      libxrandr2 \
      libgbm1 \
      libgtk-3-0 \
      libasound2 \
      libnss3 \
      libxshmfence1 \
      libx11-xcb1 \
      fonts-liberation \
      wget \
      ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Создание рабочей директории
WORKDIR /app

# Копируем проект
COPY . .

# Установка node-зависимостей
RUN npm install

# Установка Puppeteer Chromium вручную (для slim образа)
RUN npx puppeteer browsers install

# Команда по умолчанию
CMD ["node", "docs/docs-bpmn/bpmn-to-svg.js"]
