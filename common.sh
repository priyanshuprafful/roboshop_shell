code_dir=$(pwd)
log_file=/tmp/roboshop.log # automatically the location and file will created here
rm -f ${log_file}

print_head() {
  echo -e "\e[35m${1}\e[0m"
}

status_check() {
  if [ echo $? == 0 ] ; then
    echo "Success"
  else
    echo "Failure"
}