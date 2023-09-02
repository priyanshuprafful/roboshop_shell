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
mkdir /app &>>${log_file}
status_check $?

print_head "Delete Old Content"
rm -rf /app/* &>>${log_file} # because re run of code should not fail , hence deleting the files
status_check $?

print_head "Downloading App Content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?

cd /app

print_head "Extracting App Content"
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head "Installing NodeJS dependencies"
npm install &>>${log_file}
status_check $?

print_head "Copy SystemD service files"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable Catalogue service"
systemctl enable catalogue &>>${log_file}
status_check $?

print_head "Start Catalogue Service"
systemctl restart catalogue &>>${log_file} # restart so that any change it will get impacted
status_check $?

print_head "Copy MongoDB repo files"
cp ${code_dir}/configs mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load Schema"
mongo --host mongodb.saraldevops.online </app/schema/catalogue.js &>>${log_file}
status_check $?

