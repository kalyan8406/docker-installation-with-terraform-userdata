resource "aws_instance" "my_ec2" {
  ami           = "ami-0f58b397bc5c1f2e8" 
  instance_type = "t3.small"

  key_name = "ec2key"

  tags = {
    Name = "Docker-Instance"
  }
 user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y wget unzip curl

              
              curl -fsSL https://get.docker.com -o install-docker.sh
              sh install-docker.sh

              systemctl start docker
              systemctl enable docker

              sleep 15

              usermod -aG docker ubuntu

              cd /home/ubuntu

              cat <<'EOT' > Dockerfile
              FROM nginx:latest
              COPY . /usr/share/nginx/html
              EOT
              wget https://templatemo.com/tm-zip-files-2020/templatemo_568_digimedia.zip
              unzip templatemo_568_digimedia.zip
              cp -r templatemo_568_digimedia/* .

              docker build -t html-app .
              docker run -d -p 80:80 --name html-container html-app
              EOF

}  

