#!/bin/bash

cp -p /tmp/roboshop_scripting/mangodb_service /etc/yum.repos.d/mongo.repo 

ID=$(id -u)

VALIDATE ()
{
    if [ $1 -ne 0 ]
    then
    echo "$2 FAILED"
    else
    echo "$2 SUCCESSFUL"
}

if [ $ID -ne 0 ]
then 
echo "please run the script with root previlages"
exit 1
else 
echo "you are root user"
fi

dnf install mongodb-org -y

VALIDATE $? "installation is"

