source common.sh

log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>> Redis Repo <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Enable Redis  <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf module enable redis:remi-6.2 -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Install Redis <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf install redis -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> updated defaulted IP address <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf & /etc/redis/redis.conf &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> started Redis Services <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
systemctl enable redis &>>${log}
systemctl restart redis  &>>${log}
func_exit_status