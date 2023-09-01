code_dir=$(pwd)
log_file=/tmp/roboshop.log # automatically the location and file will created here
rm -f ${log_file}

print_head() {
  echo -e "\e[35m${1}\e[0m"
}