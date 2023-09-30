rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo Input Password Missing
  exit 1
 fi

source common.sh

log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>> Configure YUM Repos from the script provided by vendor <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Configure YUM Repos for RabbitMQ <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Install RabbitMQ <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf install rabbitmq-server -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Start RabbitMQ Service <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
systemctl enable rabbitmq-server &>>${log}
systemctl restart rabbitmq-server &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> update RabbitMQ default password and permissions <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
rabbitmqctl add_user roboshop ${rabbitmq_app_password} &>>${log}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log}
func_exit_status