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

NODEJS() {
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

  print_head "Installing NodeJS dependencies"
  npm install &>>${log_file}
  status_check $?

  print_head "Copy SystemD service files"
  cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  status_check $?

  print_head "Reload SystemD"
  systemctl daemon-reload &>>${log_file}
  status_check $?

  print_head "Enable ${component} service"
  systemctl enable ${component} &>>${log_file}
  status_check $?

  print_head "Start ${component} Service"
  systemctl restart ${component} &>>${log_file} # restart so that any change it will get impacted
  status_check $?

  print_head "Copy MongoDB repo files"
  cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
  # cp ${code_dir}/configs mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
  status_check $?

  print_head "Install Mongo Client"
  yum install mongodb-org-shell -y &>>${log_file}
  status_check $?

  print_head "Load Schema"
  mongo --host mongodb.saraldevops.online </app/schema/${component}.js &>>${log_file}
  status_check $?

}