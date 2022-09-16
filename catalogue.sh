LOG_FILE=/tmp/catalogue

ID=$(id -u)
if [$ID -ne 0 ]; then
  echo you should run this script as root user or with sudo previlages.
  exit 1
fi

echo 'setup nodejs repos'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo -e status = "\e[32mSUCCESS\e[0M"
else
  echo -e status = "\e[31mFAILURE\e[0m"
  exit 1
fi

echo 'install nodejs'
yum install nodejs -y &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit 1
fi

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
 echo 'Add Roboshop Application user'
 useradd roboshop &>>${LOG_FILE}
 if [ $? -eq 0 ]; then
  echo status = SUCCES
 else
  echo status = FAILURE
  exit 1
 fi
fi
echo 'download catalogue application code'
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit 1
fi

$ cd /home/roboshop

echo "clean old app content"
rm -rf catalogue &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit 1
fi

echo "Extract Catalogue Application Code"
unzip /tmp/catalogue.zip &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit 1
fi

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install NodeJS Dependencies"
npm install &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCESS
else
  echo status = FAILURE
  exit 1
fi

echo 'setup catalogue service'
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit 1
fi


systemctl daemon-reload &>>${LOG_FILE}
systemctl start catalogue &>>${LOG_FILE}

echo 'start catalogue service'
systemctl enable catalogue &>>${LOG_FILE}
if [ $? -eq 0 ]; then
  echo status = SUCCES
else
  echo status = FAILURE
  exit 1
fi