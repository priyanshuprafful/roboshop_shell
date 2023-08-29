echo -e "\e[35mInstalling Nginx\e[0m"
yum install nginx -y

echo -e "\e[35mRemoving Old Content\e[0m"
rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[35mExtracting Downloaded Content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[35mCopying Nginx Configurations for Roboshop\e[0m"
cp configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[35mEnabling Nginx\e[0m"
systemctl enable nginx

echo -e "\e[35mStarting Nginx\e[0m"
systemctl restart nginx # because we mighnt modify the configurations

# Roboshop Configs is not copied # now it is copied
# If any command is a errored or failed , we need to stop the script there itself