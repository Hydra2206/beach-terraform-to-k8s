#!/bin/bash
sudo apt update
sudo apt install -y apache2

sudo snap install aws-cli --classic
sudo curl -s -o /var/www/html/bitch.png https://raw.githubusercontent.com/Hydra2206/beach-terraform-to-k8s/main/terraform/bitch.png

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
