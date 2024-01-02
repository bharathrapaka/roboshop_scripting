#!/bin/bash

TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$TIMESTAMP.$0.log




ID=$(id -u)

VALIDATE ()
{
    if [ $1 -ne 0 ]
    then
    echo "$2 FAILED"
    else
    echo "$2 SUCCESSFUL"
    fi
}

if [ $ID -ne 0 ]
then 
echo "please run the script with root previlages"
exit 1
else 
echo "you are root user"
fi
cp -p /tmp/roboshop_scripting/mongodb_service /etc/yum.repos.d/mongo.repo 

VALIDATE $? "copied repo"  

dnf install mongodb-org -y &>>$LOG_FILE 

VALIDATE $? "installation is" 

systemctl enable mongod &>>$LOG_FILE 

systemctl start mongod &>>$LOG_FILE 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 

cat /etc/mongod.conf &>>$LOG_FILE 

systemctl restart mongod &>>$LOG_FILE 
