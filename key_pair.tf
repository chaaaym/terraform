# was 키 페어 생성
resource "aws_key_pair" "was-key" {
key_name   = "was-key"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2XGu5Q6jCvpxTkxOLN0a9qmVQPVNdfdNyFPekln4OVBXeMoxibdXRwBky7lDro0+WG1sp2swof3jMGIICU4+zu+jZtm9dlvdUBcZJy8z79qJGacdjdJeXH+fFr9m8b4ACNLKkfOCKeDuU5Vacf9vmrbPkkm97ElVWsN2qaA8cJ7aKh1aTaQDnSVdSYTjYbcRcoEr7/ZbTuZbpPdo3GFeFFY9oIuRV9iMtUdTReM5HmaO3hE4F8MFSARpw30TVcyBjfiq5aHSsJMK/hPHNt+k6ImPXbUagtdIknOFv4Zd3m7SK0Wq0zxmBA0NsMxVynMX7aOVXjSIscafL4bwQSOyF root@project"
}

# web 키 페어 생성
resource "aws_key_pair" "web-key" {
key_name   = "web-key"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYj/YgRxvW077A1GhCEJ3B8sOvtvKn7BTi2JTH0sAw783H2v5HbrSXXkmqWGZSsqF3aBO/yE++kFtqAQyc3iW/OQyAJ88u1Glw+2DGTicgmN//uf+UkWXN5FU+qixX3Jo0NgC/Z05gDXpYR9CoznkspBu+f6vLs5r7Iz5jbX2+MWKpd3GhrJl9wraxMrw8S/AYNHgQVsHZxfFYyzONI//udTgG9OnRo57dxWFFyegP549aOKZOcEhn8lTy/oQxj9AN+ZgRcRIl4fvZ2Qj8w1duwO2cPOnur4XtU2n8zxnZG88jUfbUsBBJvfypcgF+q/iJt1lEQKIC1pDlWJ87rc8h root@project"
}

# db 키 페어 생성
resource "aws_key_pair" "db-key" {
key_name   = "db-key"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUoZ+6YRGKfSsd7XAjdUU2lvB75qGWnZsvlc7Yun4iD4llNAgBBqS9+ZyZLSXyodrhMPzW1dQkNws3go4jJqmmyIbjy1EM2DoYIt3VxHdlT6tzArs+Ao2hWWpRqTm2pgwdFrKaSSBdSZASbxhVGw+dwfxqYFkAjGCOgghXkVQCLyTV4MGFCWl8mVYWysl4U4VwLDM4ffNhhQcON+F6h9OStlbjQzwovEdFdoeBzbYkFGjsZb27k+0JQ2WHuWEtU3Hu/ypnu2dUMsKAjSgeAoABuQbNNFUdifGaV5rrX+ggv0ETfzBoZ2vYpyU4QHhfwQUQO7z7G47dJ+EKc6j3dT3n root@project"
}