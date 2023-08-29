curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app
rm -rf /app/* # because re run of code should not fail , hence deleting the files
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
npm install
cp configs/catalogue.service /etc/systemd/system/catalogue.service

systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

cp configs mongodb.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y

mongo --host mongodb.saraldevops.online </app/schema/catalogue.js