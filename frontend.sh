 LOG_FILE=/tmp/frontend
 echo installing Nginx
 yum install nginx -y &>>$LOG_FILE
 echo status $?

 echo Downloading Nginx web conent
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE

 cd /usr/share/nginx/html

 echo removing old web content
 rm -rf * &>>/tmp/frontend
 echo status $?

 echo extracting web content
 unzip /tmp/frontend.zip &>>$LOG_FILE
 echo status $?


 mv frontend-main/static/* . &>>$LOG_FILE
 echo status $?
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
 echo status $?

 echo starting Nginx service
 systemctl enable nginx &>>$LOG_FILE
 echo status $?
 systemctl restart nginx &>>$LOG_FILE
 echo status $?


