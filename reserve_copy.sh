#!/bin/bash

# Параметры подключения к базе данных MySQL
DB_HOST="localhost"
DB_USER="root"
DB_PASS="123456"
DB_NAME="otus"

# Директория для сохранения резервных копий
BACKUP_DIR="/backup_mySQL/"

# Имя файла резервной копии
BACKUP_FILE="backup_$(date +%Y-%m-%d_%H-%M-%S).sql"

# Создание директории для резервных копий, если она не существует
mkdir -p $BACKUP_DIR

# Получение списка таблиц в базе данных
TABLES=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "SHOW TABLES;" | awk '{print $1}' | grep -v '^Tables')

# Цикл по таблицам для создания резервных копий
for TABLE in $TABLES; do
  # Имя файла резервной копии для текущей таблицы
  BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y-%m-%d_%H-%M-%S)_${TABLE}.sql"

  # Выполнение команды mysqldump для создания резервной копии текущей таблицы
  mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME $TABLE --events --routines --dump-slave > $BACKUP_FILE

  # Проверка успешности выполнения команды mysqldump
  if [ $? -eq 0 ]; then
    echo "Резервная копия таблицы $TABLE успешно создана: $BACKUP_FILE"
  else
    echo "Ошибка при создании резервной копии таблицы $TABLE"
  fi
done

# Удаление старых резервных копий (более 2 дней)
find $BACKUP_DIR -type f -name "backup_*" -mtime +2 -exec rm {} \;
