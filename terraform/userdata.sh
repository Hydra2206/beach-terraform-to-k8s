#!/bin/bash
sudo apt update
sudo apt install -y apache2

sudo snap install aws-cli --classic
sudo curl -s -o /var/www/html/beach.png https://raw.githubusercontent.com/Hydra2206/beach-terraform-to-k8s/main/terraform/beach.png

sudo tee /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Beach</title>
  </head>
  <body>
    <img src="/beach.png" alt="sundar beach" />
  </body>
</html>
EOF

sudo systemctl start apache2
sudo systemctl daemon-reload
sudo systemctl enable apache2
