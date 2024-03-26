#!/bin/bash

DIR='/etc/netplan/'
DIR1='/home/otus-db1/02db-static.yaml'
DIR2='/etc/netplan/'

#Копируем конфиг 
cp $DIR1 $DIR2
echo "файл конфига 02db-static.yml скопирован в $DIR"

netplan generate
netplan apply
if [ $? -eq 0 ]; then
          echo "Статический IP включен"
else
          echo "Возникла ошибка"
fi
read -p "Для просмотра сетевых интерфейсов нажмите Enter"
ip -4 a
