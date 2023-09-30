source common.sh

log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>> Install Nginx <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
dnf install nginx -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>> Copy Roboshop configuration <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>>>>> Remove Old Content <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>>>>> Download Application Content <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m>>>>>>>>>>>> Extract Application content <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>>>>> Start Nginx Service <<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
systemctl enable nginx
systemctl restart nginx

