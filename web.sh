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
dnf install nginx -y &>>$logfile

validate $? "installing nginx"

systemctl enable nginx &>>$logfile

validate $? "enabling nginx"

systemctl start nginx &>>$logfile

validate $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$logfile

validate $? "removing files html"


curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$logfile

validate $? "downloading web.zip"

cd /usr/share/nginx/html &>>$logfile

validate $? "changing directory"

unzip /tmp/web.zip &>>$logfile

validate $? "unzipping web.zip"

cp /home/ec2-user/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$logfile

validate $? "copying roboshop.conf"

systemctl restart nginx &>>$logfiles

validate $? "restarting nginx"

