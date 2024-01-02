#!/bin/bash

TIMESTAMP=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$TIMESTAMP.$0.log


cp -p /tmp/roboshop_scripting/mongodb_service /etc/yum.repos.d/mongo.repo 

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

dnf install mongodb-org -y &>>$LOG_FILE

VALIDATE $? "installation is" 