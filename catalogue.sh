#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$TIMESTAMP.$0.log

VALIDATE ()
{
    if [ $1 -ne 0 ]
    then 
    echo "$2 ...FAILED"
    else 
    echo "$2 ...SUCCESS"
    fi
}

if [ $ID -ne 0 ]
then 
echo "please run with root previlages "
else 
echo "you are root user"
fi

dnf module disable nodejs -y 
dnf module enable nodejs:18 -y &>>$LOG_FILE

dnf install nodejs -y &>>$LOG_FILE

VALIDATE $? "installation is"

useradd roboshop &>>$LOG_FILE
mkdir /app &>>$LOG_FILE
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOG_FILE
unzip /tmp/catalogue.zip &>>$LOG_FILE
cd /app &>>$LOG_FILE
npm install  &>>$LOG_FILE
cp -pr /tmp/roboshop_scripting/catalogue_service /etc/systemd/system/catalogue.service &>>$LOG_FILE
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
cp -pr /tmp/roboshop_scripting/mongodb_service  /etc/yum.repos.d/mongo.repo &>>$LOG_FILE

dnf install mongodb-org-shell -y &>>$LOG_FILE

VALIDATE $? "installation is"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js &>>$LOG_FILE



