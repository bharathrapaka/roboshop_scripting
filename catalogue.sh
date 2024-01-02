#!/bin/bash

ID=$(id -u)
pwd1=$(pwd)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$TIMESTAMP.$0.log
mongohostIP=mangodb.bpix.online
echo "script start execting at $TIMESTAMP" &>> $LOG_FILE

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
echo "please run with root previlages"
exit 1  
else 
echo "you are root user"
fi

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "disabling current nodejs"

dnf module enable nodejs:18 -y &>>$LOG_FILE
VALIDATE $? "enabling new nodejs"

dnf install nodejs -y &>>$LOG_FILE

VALIDATE $? "installation is"

useradd roboshop &>>$LOG_FILE
VALIDATE $? "created roboshop"

mkdir /app &>>$LOG_FILE
VALIDATE $? "created /app"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOG_FILE
unzip -o /tmp/catalogue.zip 

VALIDATE $? "unzip is"

cd /app &>>$LOG_FILE
VALIDATE $? "in /app directory" 

npm install  &>>$LOG_FILE
VALIDATE $? "dependencies installation"

cp -pr catalogue_service /etc/systemd/system/catalogue.service &>>$LOG_FILE
VALIDATE $? "copied successful"

systemctl daemon-reload
VALIDATE $? "daemon-reload"
systemctl enable catalogue
VALIDATE $? "enabling catalogue is"
systemctl start catalogue
VALIDATE $? "starting catalogue is"

cp -pr /tmp/roboshop_scripting/mongodb_service  /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
VALIDATE $? "copied successful"

dnf install mongodb-org-shell -y &>>$LOG_FILE
VALIDATE $? "installation is"

mongo --host $mongohostIP </app/schema/catalogue.js



