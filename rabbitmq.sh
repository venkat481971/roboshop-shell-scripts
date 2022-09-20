COMPONENT=rabbitmq
source common.sh
LOG_FILE=/tmp/${COMPONENT}

echo "setup rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOG_FILE
StatusCheck $?

echo "install Erland & Rabbitmq"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>$LOG_FILE
StatusCheck $?

echo "start RabbitMQ server"
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl restart rabbitmq-server &>>$LOG_FILE
StatusCheck $?

echo "Add Application user in Rabbitmq"
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
StatusCheck $?

echo "Add Application user tags in Rabbitmq"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
StatusCheck $?

echo "Add permission for app user in Rabbitmq"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
StatusCheck $?
