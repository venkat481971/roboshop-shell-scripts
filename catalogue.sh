LOG_FILE=/tmp/catalogue

echo 'setup nodejs repos'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
echo status = $?

echo 'install nodejs'
yum install nodejs -y &>>${LOG_FILE}
echo status = $?

echo 'add roboshop user'
useradd roboshop &>>${LOG_FILE}
echo status = $?

echo 'download catalogue application code'
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
echo status = $?

$ cd /home/roboshop

echo 'extraction catalogue app code'
$ unzip /tmp/catalogue.zip &>>${LOG_FILE}
echo status = $?

$ mv catalogue-main catalogue
$ cd /home/roboshop/catalogue

echo 'install nodejs  dependencies'
$ npm install
echo status = $?

echo 'setup catalogue service'
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
echo status = $?


systemctl daemon-reload &>>${LOG_FILE}
systemctl start catalogue &>>${LOG_FILE}

echo 'start catalogue service'
systemctl enable catalogue
echo status = $?