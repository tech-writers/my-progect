# # #!/bin/bash

# # # 📦 Пересобрать контейнер
# # echo "🔄 Сборка Docker-контейнера..."
# # docker-compose build

# # # 🚀 Запустить сборку PDF
# # echo "📚 Запуск генерации PDF-документов..."
# # docker-compose run --rm apu-builder

# # # ✅ Готово
# # echo "✅ Все PDF-файлы собраны! Найти их можно в docs/pdf/pages/"

# # !/bin/bash
# #!/bin/bash
# set -e

# echo "🔄 Сборка Docker-контейнера..."
# docker-compose build

# echo "📚 Запуск генерации PDF-документов..."
# docker-compose run --rm apu-builder

# echo "✅ Все PDF-файлы собраны! Найти их можно в docs/pdf/pages/"
#!/bin/bash
set -e

# Абсолютный путь к директории, где находится этот скрипт
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/../..")"

echo "🔄 Сборка Docker-контейнера..."
docker-compose -f "$SCRIPT_DIR/docker-compose.yml" build

echo "📚 Запуск генерации PDF-документов..."
docker-compose -f "$SCRIPT_DIR/docker-compose.yml" run --rm \
  -v "$PROJECT_ROOT:/app" \
  -w /app \
  apu-builder ruby docs/ruby/start.rb

echo "✅ Все PDF-файлы собраны! Найти их можно в docs/pdf/pages/"
