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
cp /home/ec2-user/roboshop-shell/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$logfile

validate $? "copying rabbitmq.repo"

dnf install rabbitmq-server -y &>>$logfile

validate $? "installing rabbitmq"

systemctl enable rabbitmq-server &>>$logfile

validate $? "enabling rabbitmq"

systemctl start rabbitmq-server &>>$logfile

validate $? "starting rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$logfile

validate $? "adding username and password "

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$logfile

validate $? "setting permissions"