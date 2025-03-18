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
dnf install golang -y &>>$logfile

validate $? "installing golang"

useradd roboshop -y &>>$logfile

user=$(id roboshop) &>> $logfile

if [ $? -ne 0 ]
then 
echo " addding user" &>>$logfile
useradd roboshop
else
echo " user already exists "
fi
mkdir /app &>>$logfile

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip  &>>$logfile

validate $? "unzipping dispatch"

cd /app  &>>$logfile

validate $? "changing app directory"

unzip /tmp/dispatch.zip &>>$logfile

validate $? "unzipping dispatch"

go mod init dispatch &>>$logfile

validate $? "installing mod"

go get &>>$logfile

validate $? "installing get"

go build &>>$logfile

validate $? "installing build"

cp /home/ec2-user/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>>$logfile

validate $? "copying dispatch"

systemctl daemon-reload &>>$logfile

validate $? "deamon-reload"

systemctl enable dispatch &>>$logfile 

validate $? "enabling dispatch"

systemctl start dispatch &>>$logfile

validate $? "start dispatch"

