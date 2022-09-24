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

APP_PREREQ() {
    id roboshop &>>${LOG_FILE}
    if [ $? -ne 0 ]; then
     echo 'Add Roboshop Application user'
     useradd roboshop &>>${LOG_FILE}
     StatusCheck $?
  fi

    echo 'download ${COMPONENT} Application code'
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
    StatusCheck $?


    echo "clean old app content"
    rm -rf ${COMPONENT} &>>${LOG_FILE}
    StatusCheck $?

    echo "Extract ${COMPONENT} Application Code"
    unzip /tmp/${COMPONENT}.zip &>>${LOG_FILE}
    StatusCheck $?

    mv ${COMPONENT}-main ${COMPONENT}
}

SYSTEMD_SETUP() {
    echo "update systemD service files"
    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e  's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
    StatusCheck $?

    echo "setup ${COMPONENT} service"
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
    StatusCheck $?


    systemctl daemon-reload &>>${LOG_FILE}
    systemctl enable ${COMPONENT} &>>${LOG_FILE}

    echo "start ${COMPONENT} service"
    systemctl start ${COMPONENT} &>>${LOG_FILE}
    StatusCheck $?
}

NODEJS() {
  echo 'setup nodejs repos'
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
  StatusCheck $?

  echo 'install nodejs'
  yum install nodejs -y &>>${LOG_FILE}
  StatusCheck $?

  APP_PREREQ

  echo "Install NodeJS Dependencies"
  npm install &>>${LOG_FILE}
  StatusCheck $?

  SYSTEMD_SETUP

}

JAVA() {
  echo "install maven"
  yum install maven -y &>>${LOG_FILE}
  StatusCheck $?

  APP_PREREQ

  echo "Download Dependencies & make package"
  mvn clean package &>>${LOG_FILE}
  mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar  &>>${LOG_FILE}
  StatusCheck $?

  SYSTEMD_SETUP
}

PYTHON() {
  echo "install python 3"
  yum install python36 gcc python3-devel -y &>>${LOG_FILE}
  StatusCheck $?

  APP_PREREQ

  cd /home/roboshop/${COMPONENT}

  echo "install python dependencies for App''"
  pip3 install -r requirements.txt &>>${LOG_FILE}
  StatusCheck $?

  APP_UID=$(id -u roboshop)
  APP_GID=$(id -g roboshop)

  echo "update payment configuration file"
  sed -i -e "/uid/ c uid = ${APP_GID}" -e "/gid/ c gid = ${APP_GID}" /home/roboshop/${COMPONENT}/${COMPONENT}.ini &>>${LOG_FILE}
  StatusCheck $?

  SYSTEMD_SETUP

}