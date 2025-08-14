#!/usr/bin/env bash
set -euo pipefail

# ─── Проверка аргументов ──────────────────────────────────────────────────────
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <directory> <search_text> <replace_text>"
  echo "e.g.   $0 docs/components 'ПЗ к ТП' 'ПЗТП'"
  exit 1
fi

DIR="$1"         # каталог, в котором ищем (например docs/components)
SEARCH="$2"      # что ищем
REPLACE="$3"     # на что заменяем

# ─── Обход .adoc‑файлов и замена ──────────────────────────────────────────────
# find ... -name '*.adoc'  — ищем только .adoc
# -print0 / read -d ''     — безопасно обрабатываем пробелы в именах
# sed -i ''  (BSD) / sed -i  (GNU) — различия macOS vs Linux

find "$DIR" -type f -name '*.adoc' -print0 |
while IFS= read -r -d '' file; do
  if grep -q "$SEARCH" "$file"; then
    echo "Updating $file"
    if sed --version >/dev/null 2>&1; then            # GNU sed (Linux)
      sed -i "s/${SEARCH//\//\\/}/${REPLACE//\//\\/}/g" "$file"
    else                                              # BSD sed (macOS)
      sed -i '' "s/${SEARCH//\//\\/}/${REPLACE//\//\\/}/g" "$file"
    fi
  fi
done

echo "Done."