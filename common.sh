code_dir=$(pwd)
log_file=/tmp/roboshop.log # automatically the location and file will created here
rm -f ${log_file}

print_head() {
  echo -e "\e[35m${1}\e[0m"
}

status_check() {
  if [ $1 -eq 0 ] ; then # $1 is the first argument whoich will hold exit status $? value we give whie we use the function
    echo "Success"
  else
    echo "Failure"
    echo "Read the log file ${log_file} for more information"
    exit 1
  fi
}

systemd_setup() {
    print_head "Copy SystemD service files"
    cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?

    sed -i -e "s/GIVE_ROBOSHOP_USER_PASSWORD/${roboshop_app_password}/" /etc/systemd/system/${component}.service &>>${log_file}
    # the above was just for payment service and not for other services
    # and we are using double quotes so that we can access the variable ,
    print_head "Reload SystemD"
    systemctl daemon-reload &>>${log_file}
    status_check $?

    print_head "Enable ${component} service"
    systemctl enable ${component} &>>${log_file}
    status_check $?

    print_head "Start ${component} Service"
    systemctl restart ${component} &>>${log_file} # restart so that any change it will get impacted
    status_check $?
}

schema_setup() {

  if [ "${schema_type}" == "mongo" ]; then

    print_head "Copy MongoDB repo files"
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
    status_check $?

    print_head "Install Mongo Client"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mongo --host mongodb.saraldevops.online </app/schema/${component}.js &>>${log_file}
    status_check $?

  elif [ "${schema_type}" == "mysql" ]; then
    print_head "Install Mysql Client"
    yum install mysql -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mysql -h mysql.saraldevops.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>${log_file}
    status_check $?
  fi
}

app_prereq_setup() {
  print_head "Create Roboshop User"
    id roboshop &>>${log_file}
    if [ $? -ne 0 ]; then
      useradd roboshop &>>${log_file}
    fi
    status_check $?

    print_head "Create Application Directory"
    if [ ! -d /app ]; then # here ! will inverse the logic also mkdir has options for all this well
      mkdir /app &>>${log_file}
    fi
    status_check $?

    print_head "Delete Old Content"
    rm -rf /app/* &>>${log_file} # because re run of code should not fail , hence deleting the files
    status_check $?

    print_head "Downloading App Content"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    status_check $?

    cd /app

    print_head "Extracting App Content"
    unzip /tmp/${component}.zip &>>${log_file}
    status_check $?

}

nodejs() {
  print_head " Configure NodeJS repository"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?



  print_head "Install NodeJS"
  yum install nodejs -y &>>${log_file}
  status_check $?

  app_prereq_setup


  print_head "Installing NodeJS dependencies"
  npm install &>>${log_file}
  status_check $?

  schema_setup

  systemd_setup

}

java() {
  print_head "Install Maven"
  yum install maven -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Downloading Dependencies and Package"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
  status_check $?

  #Schema Setup Function
  schema_setup

  # SystemD Function
  systemd_setup


}

python() {
  print_head "Install Python"
  yum install python36 gcc python3-devel -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Download Dependencies"
  pip3.6 install -r requirements.txt &>>${log_file}
  status_check $?


  systemd_setup




}