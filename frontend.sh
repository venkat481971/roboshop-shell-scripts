LOG_FILE=/tmp/frontend

source common.sh

echo installing Nginx
yum install nginx -y &>>$LOG_FILE
StatusCheck $?

echo Downloading Nginx web conent
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
StatusCheck $?

cd /usr/share/nginx/html

echo removing old web content
rm -rf * &>>/tmp/frontend
StatusCheck $?

echo extracting web content
unzip /tmp/frontend.zip &>>$LOG_FILE
StatusCheck $?


mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE

echo "update Roboshop config file"
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
StatusCheck $?

echo starting Nginx service
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
StatusCheck $?