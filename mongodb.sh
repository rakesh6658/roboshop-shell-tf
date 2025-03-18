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
cp /home/ec2-user/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$logfile

validate $? "copying mongo.repo"

dnf install mongodb-org -y  &>>$logfile
 
validate $? "installing mongodb"

systemctl enable mongod &>>$logfile

validate $? "enabling mongodb"

systemctl start mongod &>>$logfile

validate $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf  &>>$logfile

validate $?  "updating listen address from 127.0.0.1 to 0.0.0.0"

systemctl restart mongod &>>$logfile

validate $? "restarting mongodb"