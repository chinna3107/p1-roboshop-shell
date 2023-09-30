func_preq() {

  echo -e "\e[36m>>>>>>>>>>>> Create ${component} service <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
    cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  echo -e "\e[36m>>>>>>>>>>>> Create Application User <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
    useradd roboshop &>>${log}

    echo -e "\e[36m>>>>>>>>>>>> Cleanup old Application content <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
    rm -rf /app &>>${log}

    echo -e "\e[36m>>>>>>>>>>>> create new directory  <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
    mkdir /app &>>${log}

    echo -e "\e[36m>>>>>>>>>>>> Download application content  <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
    cd /app &>>${log}

    echo -e "\e[36m>>>>>>>>>>>> Extract Application Content <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
    unzip /tmp/${component}.zip &>>${log}

}

func_schema_setup() {

 log=/tmp/roboshop.log

if [ "${schema_type}" == "mongodb" ]; then

echo -e "\e[36m>>>>>>>>>>>> Install Mongo Client <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Load ${component} schema <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
mongo --host mongodb.devops-tools.online </app/schema/${component}.js &>>${log}

fi

if [ "${schema_type}" == "mysql" ]; then
echo -e "\e[36m>>>>>>>>>>>> Install mysql client  <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
  dnf install mysql -y &>>${log}

  echo -e "\e[36m>>>>>>>>>>>> Load Schema <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
  mysql -h mysql.devops-tools.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
fi

}

func_systemd() {

echo -e "\e[36m>>>>>>>>>>>> Start ${component} Services <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
systemctl daemon-reload &>>${log}
systemctl enable ${component} &>>${log}
systemctl restart ${component} &>>${log}

}

func_nodejs() {
log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>> Create Mongodb Repo <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Install Nodejs Repo<<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Install NodeJS <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
yum install nodejs -y &>>${log}

 func_preq

 func_schema_setup

echo -e "\e[36m>>>>>>>>>>>> Download NodeJS Dependencies <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
npm install &>>${log}


func_systemd

}


func_java() {

  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>>> Install Maven  <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
  dnf install maven -y &>>${log}

  func_preq

  echo -e "\e[36m>>>>>>>>>>>> Build ${component} service  <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
  cd /app &>>${log}
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}

  func_schema_setup

 func_systemd
}

func_python() {
   log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>>> Install python <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
  dnf install python36 gcc python3-devel -y &>>${log}

 func_preq

  echo -e "\e[36m>>>>>>>>>>>> Build ${component} service  <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
  pip3.6 install -r requirements.txt &>>${log}

  func_systemd

}
