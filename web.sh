#!/bin/bash

ID=$(id -u)
pwd1=$(pwd)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$TIMESTAMP.$0.log
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


dnf install nginx -y &>> $LOG_FILE
VALIDATE $? "installation of nginx"

systemctl enable nginx &>> $LOG_FILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>> $LOG_FILE
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/*

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip 
VALIDATE $? "downloading webzip"

cd /usr/share/nginx/html
unzip /tmp/web.zip
VALIDATE $? "unzip is"
cp /c/Users/brapaka/roboshop_scripting/robo2_repo /etc/nginx/default.d/roboshop.conf  &>> $LOG_FILE
VALIDATE $? "copying is"
systemctl restart nginx &>> $LOG_FILE
VALIDATE $? "restarting ngnix is"
C:\Users\brapaka\roboshop_scripting\robo2_repo