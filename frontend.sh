yum install nginx -y
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
cp configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl restart nginx # because we mighnt modify the configurations

# Roboshop Configs is not copied # now it is copied
# If any command is a errored or failed , we need to stop the script there itself