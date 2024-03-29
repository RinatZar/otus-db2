#!/bin/bach
#Пользователь для реплики
user="repl"
pass="123456"

cre_mysqld_cnf="/etc/mysql/mysql.conf.d/mysqld.cnf"


#Добавляем параметры в mysqld.cnf

if [ -f "$cre_mysqld_cnf" ]; then
  #sed -i "s/^bind-address\s*=\s*127.0.0.1/$bind_address_new/" $cre_mysqld_cnf
  echo "server-id = 2" >> $cre_mysqld_cnf
  echo "read-only = ON" >> $cre_mysqld_cnf
  echo "gtid-mode=ON" >> $cre_mysqld_cnf
  echo "enforce-gtid-consistency" >> $cre_mysqld_cnf
  echo "log-replica-updates" >> $cre_mysqld_cnf
  #echo "binlog_expire_logs_seconds = 86400" >> $cre_mysqld_cnf
else
  echo "файл $cre_mysqld_cnf не найден"
fi
service mysql restart
echo "Конфиг MySQL-repl настроен"

#Запускаем репликацию 
mysql -e "STOP REPLICA;"
mysql -e "CHANGE REPLICATION SOURCE TO SOURCE_HOST='192.168.47.12', SOURCE_USER='repl', SOURCE_PASSWORD='123456', SOURCE_AUTO_POSITION = 1, GET_SOURCE_PUBLIC_KEY = 1;"
mysql -e "START REPLICA;"
echo "Ожидаем соедиения с сервером 5 секунд"
sleep 5
echo "Репликация запущена. Статус состояния:"
mysql -e "show replica status\G"
#--Настройка бэкапа базы данных OTUS"
# Путь к скрипту, который нужно выполнить
SCRIPT_PATH="//home/otus-db2/reserve_copy.sh"

# Команда, которую нужно добавить в cron для выполнения каждые 5 минут
CRON_COMMAND="*/5 * * * * $SCRIPT_PATH"

# Добавляем команду в cron таблицу
(crontab -l ; echo "$CRON_COMMAND") | crontab -

echo "Задание на потабличный бэкап базы данных OTUS успешно добавлено в планировщик"
chmod +x reserve_copy.sh
