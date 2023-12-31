mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo Input Password Missing
  exit 1
 fi

source common.sh

log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>> download MySql Repo <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>  Disable Old MySql  <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf module disable mysql -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Install Mysql <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf install mysql-community-server -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Start Mysql Services <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
systemctl enable mysqld &>>${log}
systemctl restart mysqld &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Update default password <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log}
func_exit_status