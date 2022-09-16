 LOG_FILE=/tmp/frontend

 source common.sh

 echo installing Nginx
 yum install nginx -y &>>$LOG_FILE
 StatusCheck $?

 echo Downloading Nginx web conent
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE

 cd /usr/share/nginx/html

 echo removing old web content
 rm -rf * &>>/tmp/frontend
 StatusCheck $?

 echo extracting web content
 unzip /tmp/frontend.zip &>>$LOG_FILE
 StatusCheck $?


 mv frontend-main/static/* . &>>$LOG_FILE
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE

 echo starting Nginx service
 systemctl enable nginx &>>$LOG_FILE
 systemctl restart nginx &>>$LOG_FILE
 StatusCheck $?


