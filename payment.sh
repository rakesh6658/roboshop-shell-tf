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
dnf install python3.11 gcc python3-devel -y &>>$logfile

validate $? "installing python"

user=$(id roboshop) &>> $logfile

if [ $? -ne 0 ]
then 
echo " addding user"
useradd roboshop
else
echo " user already exists "
fi
mkdir /app &>>$logfile

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip  &>>$logfile

validate $? "downloading payment.zip"

cd /app  &>>$logfile

validate $? "changing app directory"

unzip /tmp/payment.zip &>>$logfile

validate $? "unzipping payment"

pip3.11 install -r requirements.txt &>>$logfile

validate $? "installing pip3"

cp /home/ec2-user/roboshop-shell/payment.service  /etc/systemd/system/payment.service &>>$logfile

validate $? "copying payment.service"

systemctl daemon-reload &>>$logfile

validate $? "deamon-reload"

systemctl enable payment &>>$logfile

validate $? "enable payment"

systemctl start payment &>>$logfile

validate $? "start payment"