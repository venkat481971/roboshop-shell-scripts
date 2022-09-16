LOG_FILE=/tmp/mongodb

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo you should run this script as root user or with sudo previlages.
  exit 1
fi

StatusCheck() {
  if [ $1 -eq 0 ]; then
    echo -e status = "\e[32mSUCCESS\e[0m"
  else
    echo -e status = "\e[31mFAILURE\e[0m"
    exit 1
  fi
}


echo "Setting MongoDB Repo"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
echo status $?

echo "installing mongodb server"
yum install -y mongodb-org &>>$LOG_FILE
echo status $?

echo 'Update mongodb listen address'
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo status = $?


echo "Starting mongodb service"
systemctl enable mongod &>>$LOG_FILE
systemctl restart mongod &>>$LOG_FILE
echo status $?

echo 'downloading mongodb schema'
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
echo status = $?

cd /tmp
echo 'extract schema file'
unzip mongodb.zip &>>$LOG_FILE
echo status = $?

cd mongodb-main

echo 'load catalogue service schema'
mongo < catalogue.js &>>$LOG_FILE
echo status = $?

echo 'load user service schema'
mongo < users.js &>>$LOG_FILE
echo status = $?

