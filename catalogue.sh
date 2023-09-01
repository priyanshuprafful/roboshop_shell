source common.sh

print_head " Configure NodeJS repository"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Install NodeJS"
yum install nodejs -y &>>${log_file}

print_head "Create Roboshop User"
useradd roboshop &>>${log_file}

print_head "Create Application Directory"
mkdir /app &>>${log_file}

print_head "Delete Old Content"
rm -rf /app/* &>>${log_file} # because re run of code should not fail , hence deleting the files

print_head "Downloading App Content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}

cd /app

print_head "Extracting App Content"
unzip /tmp/catalogue.zip &>>${log_file}

print_head "Installing NodeJS dependencies"
npm install &>>${log_file}

print_head "Copy SystemD service files"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "Reload SystemD"
systemctl daemon-reload &>>${log_file}

print_head "Enable Catalogue service"
systemctl enable catalogue &>>${log_file}

print_head "Start Catalogue Service"
systemctl restart catalogue &>>${log_file} # restart so that any change it will get impacted

print_head "Copy MongoDB repo files"
cp configs mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}

print_head "Load Schema"
mongo --host mongodb.saraldevops.online </app/schema/catalogue.js &>>${log_file}