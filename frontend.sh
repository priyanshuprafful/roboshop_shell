code_dir=$(pwd)
log_file=/tmp/roboshop.log # automatically the location and file will created here
rm -f ${log_file}

print_head() {
  echo -e "\e[35m${1}\e[0m"
}

print_head "Installing Nginx"
yum install nginx -y &>>${log_file}

print_head "Removing Old Content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_head "Extracting Downloaded Content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

print_head "Copying Nginx Configurations for Roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "Enabling Nginx"
systemctl enable nginx &>>${log_file}

print_head "Starting Nginx"
systemctl restart nginx &>>${log_file} # because we might modify the configurations

# Roboshop Configs is not copied # now it is copied # now we have copied and solved our issue
# If any command is a errored or failed , we need to stop the script there itself