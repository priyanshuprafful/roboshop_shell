yum install nginx -y
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
systemctl enable nginx
systemctl start nginx

# Roboshop Configs is not copied
# If any command is a errored or failed , we need to stop the script there itself