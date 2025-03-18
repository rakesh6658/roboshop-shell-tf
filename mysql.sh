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
#dnf module disable mysql -y  &>>$logfile
 
 #validate $? "disabling mysql"

 #cp /home/ec2-user/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$logfile

 #validate $? "copying mysql repo"


dnf install mysql-server -y &>> $logfile

validate $? "installing mysql"

systemctl enable mysqld &>> $logfile

validate $? "enabling mysql"

systemctl start mysqld  &>> $logfile

validate $? "starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1  &>> $logfile

validate $? "changing default password"