source common.sh
mysql_root_password=$1
if [ -z "${my_sql_password}" ]; then
  echo "\e[31mMissing Mysql root password argument\e[0m"
  exit 1
fi


print_head "Disabling MySql 8 version"
yum module disable mysql -y
status_check $?

cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo

print_head "Installing MySql server"
yum install mysql-community-server -y
status_check $?

print_head "Enable Mysql service"
systemctl enable mysqld
status_check $?

print_head "Start Mysql Service"
systemctl start mysqld
status_check $?

print_head "Set Password"
mysql_secure_installation --set-root-pass ${mysql_root_password}
