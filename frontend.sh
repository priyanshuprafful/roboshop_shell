code_dir=$(pwd)
log_file=/tmp/roboshop.log # automatically the location and file will created here
rm -f ${log_file}

echo -e "\e[35mInstalling Nginx\e[0m"
yum install nginx -y &>>${log_file}

echo -e "\e[35mRemoving Old Content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log_file}

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

echo -e "\e[35mExtracting Downloaded Content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

echo -e "\e[35mCopying Nginx Configurations for Roboshop\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[35mEnabling Nginx\e[0m"
systemctl enable nginx &>>${log_file}

echo -e "\e[35mStarting Nginx\e[0m"
systemctl restart nginx &>>${log_file} # because we might modify the configurations

# Roboshop Configs is not copied # now it is copied # now we have copied and solved our issue
# If any command is a errored or failed , we need to stop the script there itself