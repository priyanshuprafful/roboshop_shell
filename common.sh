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
    exit 1
  fi
}