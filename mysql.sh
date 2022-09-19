LOG_FILE=/tmp/mysql
source common.sh

echo "setting up mysql repo"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
StatusCheck $?

echo "Disable mySQL default module to Enable 5.7 my sql"
dnf module disable mysql -y &>>$LOG_FILE
StatusCheck $?

echo "install mysql"
yum install mysql-community-server -y &>>$LOG_FILE
StatusCheck $?

echo "start mysql service"
systemctl enable mysqld &>>$LOG_FILE
systemctl restart mysqld &>>$LOG_FILE
StatusCheck $?

DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('mypass');
FLUSH PRIVILEGES;" >/tmp/root-pass.sql






 # grep temp /var/log/mysqld.log
 # mysql_secure_installation