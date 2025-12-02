#!/bin/bash
sudo apt update
sudo apt install -y apache2

sudo snap install aws-cli --classic
  sudo aws s3 cp s3://terraform-project-s3bkt/photos/bitch.png /var/www/html/bitch.png

sudo tee /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Bitch</title>
  </head>
  <body>
    <img src="/bitch.png" alt="sundar bitch" />
  </body>
</html>
EOF

sudo systemctl start apache2
sudo systemctl daemon-reload
sudo systemctl enable apache2
