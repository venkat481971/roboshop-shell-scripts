LOG_FILE=/tmp/user

source common.sh

echo 'setup nodejs repos'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
StatusCheck $?


echo 'install nodejs'
yum install nodejs -y &>>${LOG_FILE}
StatusCheck $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
 echo 'Add Roboshop Application user'
 useradd roboshop &>>${LOG_FILE}
 StatusCheck $?
fi

echo 'download user application code'
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /home/roboshop

echo "clean old app content"
rm -rf user &>>${LOG_FILE}
StatusCheck $?

echo "Extract user Application Code"
unzip /tmp/user.zip &>>${LOG_FILE}
StatusCheck $?

mv user-main user
cd /home/roboshop/user

echo "Install NodeJS Dependencies"
npm install &>>${LOG_FILE}
StatusCheck $?

echo "update systemD service files"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO ENDPOINT/mongodb.roboshop.internal/'/home/roboshop/user/systemd.service
StatusCheck $?

echo 'setup user service'
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>${LOG_FILE}
StatusCheck $?


systemctl daemon-reload &>>${LOG_FILE}
systemctl start user &>>${LOG_FILE}

echo 'start user service'
systemctl enable user &>>${LOG_FILE}
StatusCheck $?