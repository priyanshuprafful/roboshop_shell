source common.sh
mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing Mysql root password argument\e[0m"
  exit 1
fi


print_head "Disabling MySql 8 version"
yum module disable mysql -y &>>${log_file}
status_check $?

print_head "Copy Mysql repo Files"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "Installing MySql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable Mysql service"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Start Mysql Service"
systemctl  start mysqld &>>${log_file}
status_check $?

print_head "Set Root Password"
echo show databases | mysql-uroot -p${mysql_root_password} &>>${log_file}
if [ $? -ne 0 ]; then
  mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
fi
status_check $?
