source common.sh

print_head "Installing Nginx"
yum install nginx -y &>>${log_file}
status_check $? # here this $? value will go to the function and status check will use that value

print_head "Removing Old Content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
status_check $?

print_head "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status_check $?

print_head "Extracting Downloaded Content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
status_check $?

print_head "Copying Nginx Configurations for Roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status_check $?

print_head "Enabling Nginx"
systemctl enable nginx &>>${log_file}
status_check $?

print_head "Starting Nginx"
systemctl restart nginx &>>${log_file} # because we might modify the configurations
status_check $?

# Roboshop Configs is not copied # now it is copied # now we have copied and solved our issue
# If any command is a errored or failed , we need to stop the script there itself
#Status of command need to be printed