#!/bin/bash
sudo yum update -y
sudo yum install -y nginx

# Added index.html
sudo cat >/usr/share/nginx/html/index.html << "EOF"
<html>
  <head>
    <title>Web service</title>
  </head>
  <body>
    <h1>The Web service on ${private_ip}</h1>
  </body>
</html>
EOF

sudo service nginx start
