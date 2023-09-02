source common.sh

print_head " Configure NodeJS repository"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install NodeJS"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Create Roboshop User"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head "Create Application Directory"
if [ ! d/app ]; then # here ! will inverse the logic also mkdir has options for all this well
  mkdir /app &>>${log_file}
fi
status_check $?

print_head "Delete Old Content"
rm -rf /app/* &>>${log_file} # because re run of code should not fail , hence deleting the files
status_check $?

print_head "Downloading App Content"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
status_check $?

cd /app

print_head "Extracting App Content"
unzip /tmp/user.zip &>>${log_file}
status_check $?

print_head "Installing NodeJS dependencies"
npm install &>>${log_file}
status_check $?

print_head "Copy SystemD service files"
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable User service"
systemctl enable user &>>${log_file}
status_check $?

print_head "Start User Service"
systemctl restart user &>>${log_file} # restart so that any change it will get impacted
status_check $?

print_head "Copy MongoDB repo files"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
# cp ${code_dir}/configs mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status_check $?

print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load Schema"
mongo --host mongodb.saraldevops.online </app/schema/catalogue.js &>>${log_file}
status_check $?

