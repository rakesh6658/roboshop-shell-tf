user=$(id -u)
if [ $user -ne 0 ]
then
echo "user is not root user"
exit 1
fi
LOGDIR=/tmp
name=$0
date=$(date +%F-%H-%M-%S)
logfile=$LOGDIR/$name-$date
r="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"
validate(){
if [ $1 == 0 ]
then
echo -e " $g $2 .... success $n"
else
echo  -e " $r $2 ... failure $n"
fi  
}
dnf module disable nodejs -y &>>$logfile

validate $? "disabling nodejs" 

dnf module enable nodejs:20 -y &>>$logfile

validate $? "enabling nodejs" 

dnf install nodejs -y &>>$logfile

validate $? "installing nodejs"

useradd roboshop -y &>>$logfile

user=$(id roboshop) &>> $logfile

if [ $? -ne 0 ]
then 
echo " addding user"
useradd roboshop
else
echo " user already exists "
fi
mkdir /app &>>$logfile

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip  &>>$logfile

validate $? "downloading catalogue.zip"

cd /app  &>>$logfile

validate $? "changing to app directory"

unzip /tmp/catalogue.zip &>>$logfile

validate $? "unzipping catalogue.zip"


npm install &>>$logfile

validate $? "installing dependencies"

cp /home/ec2-user/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$logfile

validate $? "copying catalogue.service"

systemctl daemon-reload &>>$logfile

validate $? "deamon-reload"

systemctl enable catalogue &>>$logfile 

validate $? "enabling catalogue"

systemctl start catalogue &>>$logfile

validate $? "start catalogue"

cp /home/ec2-user/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$logfile

validate $? "copying mongo.repo"

dnf install mongodb-mongosh -y &>>$logfile

validate $? "installing mongodb-mongosh"

mongosh --host mongodb.joindevops.store </app/db/master-data.js &>>$logfile

validate $? "loading data"





