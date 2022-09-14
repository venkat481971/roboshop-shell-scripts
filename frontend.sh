 echo installing Nginx
 yum install nginx -y &>>/tmp/frontend

 echo Downloading Nginx web conent
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend

 cd /usr/share/nginx/html

 echo removing old web content
 rm -rf * &>>/tmp/frontend

 echo extracting web content
 unzip /tmp/frontend.zip &>>/tmp/frontend


 mv frontend-main/static/* . &>>/tmp/frontend
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/frontend

 echo starting Nginx service
 systemctl enable nginx &>>/tmp/frontend
 systemctl restart nginx &>>/tmp/frontend


