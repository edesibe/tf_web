#!/bin/bash
sudo yum update -y
sudo yum install -y nginx

# Added index.html
sudo cat >/usr/share/nginx/html/index.html << "EOF"
<html>
  <head>
    <title>Web service on ${hostname}</title>
  </head>
  <body>
    <h1>The Web service running on ${hostname}</h1>
  </body>
</html>
EOF

sudo service nginx start
