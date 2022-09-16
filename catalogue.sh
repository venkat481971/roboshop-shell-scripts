LOG_FILE=/tmp/catalogue

echo 'setup nodejs repos'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit
fi

echo 'install nodejs'
yum install nodejs -y &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit
fi

echo 'Add Roboshop Application user'
useradd roboshop &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit
fi

echo 'download catalogue application code'
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit
fi

$ cd /home/roboshop

echo 'extraction catalogue app code'
unzip /tmp/catalogue.zip &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit
fi

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo 'install nodejs  dependencies'
npm install &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit
fi

echo 'setup catalogue service'
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit
fi


systemctl daemon-reload &>>${LOG_FILE}
systemctl start catalogue &>>${LOG_FILE}

echo 'start catalogue service'
systemctl enable catalogue &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit
fi