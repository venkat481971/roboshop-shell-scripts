 echo installing Nginx
 yum install nginx -y

 echo Downloading Nginx web conent
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

 cd /usr/share/nginx/html

 echo removing old web content
 rm -rf *

 echo extracting web content
 unzip /tmp/frontend.zip


 mv frontend-main/static/* .
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

 echo starting Nginx service
 systemctl enable nginx
 systemctl restart nginx


