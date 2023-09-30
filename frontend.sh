source common.sh

log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>> Install Nginx <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf install nginx -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Copy Roboshop configuration <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Remove Old Content <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Download Application Content <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Extract Application content <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cd /usr/share/nginx/html &>>${log}
unzip /tmp/frontend.zip &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>> Start Nginx Service <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
func_exit_status
