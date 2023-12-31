source common.sh

print_head "Setup MongoDB repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install MongoDB"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_head "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check $?

print_head "Enable MongoDB"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "Start MongoDB Service"
systemctl restart mongod &>>${log_file}
status_check $?
# update /etc/mongod.conf from 127.0.0.1 to 0.0.0.0 , this task is pending , we have completed the same
# using sed editor
