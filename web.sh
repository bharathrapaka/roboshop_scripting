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


dnf install nginx -y
VALIDATE $? "installation of nginx"

systemctl enable nginx
VALIDATE $? "enabling nginx"

systemctl start nginx
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/*

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
VALIDATE $? "downloading webzip"

cd /usr/share/nginx/html
unzip /tmp/web.zip
VALIDATE $? "unzip is"
cp -pr robo2.conf  /etc/nginx/default.d/roboshop.conf
VALIDATE $? "copying is"
systemctl restart nginx 
VALIDATE $? "restarting ngnix is"
