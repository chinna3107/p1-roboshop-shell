log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>> Create Catalogue Service <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cp catalogue.service  /etc/systemd/system/catalogue.service &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Create Mongodb Repo <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Install Nodejs Repo<<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Install NodeJS <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf install nodejs -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Create Application User <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
useradd roboshop &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Create Application Directory <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
rm -rf /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Create Application Directory <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
mkdir /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Download Application Content <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Extract Application Content  <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cd /app &>>${log}
unzip /tmp/catalogue.zip &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Download NodeJS Dependencies <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
npm install &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Install Mongo Client <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Load Catalogue schema <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
mongo --host mongodb.devops-tools.online </app/schema/catalogue.js &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Start catalogue Services <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
systemctl daemon-reload &>>${log}
systemctl enable catalogue &>>${log}
systemctl restart catalogue &>>${log}