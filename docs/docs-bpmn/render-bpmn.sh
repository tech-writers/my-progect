#!/bin/bash

set -e

echo "🔍 Проверка наличия Docker..."
if ! command -v docker &> /dev/null; then
  echo "❌ Docker не установлен. Установите его: https://www.docker.com/"
  exit 1
fi

echo "🔍 Проверка наличия Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
  echo "❌ Docker Compose не установлен."
  echo "👉 Установите через: https://docs.docker.com/compose/install/"
  exit 1
fi

echo "🔧 Сборка Docker-образа..."
docker-compose build

echo "🚀 Запуск генерации BPMN → SVG..."
docker-compose run --rm apu-builder

echo "✅ Готово! SVG-файлы обновлены в modules/bpmn/images/"
