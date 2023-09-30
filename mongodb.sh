log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>> download Mongo Repo <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Install Mongo Repo <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf install mongodb-org -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Update configuration <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Start Mongo services <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
systemctl enable mongod &>>${log}

systemctl restart mongod &>>${log}