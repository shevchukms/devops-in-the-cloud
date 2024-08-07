data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "random_id" "mtc_node_id" {
  byte_length = 2
  count       = var.main_instance_count
}


resource "aws_instance" "mtc_main" {
  count         = var.main_instance_count
  instance_type = var.main_instance_type
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "mtc-main-${random_id.mtc_node_id[count.index].dec}"
  }

  key_name               = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet[count.index].id
#  user_data = templatefile("./userdata.tpl", {new_hostname = "mtc-main-${random_id.mtc_node_id[count.index].dec}"})

  root_block_device {
    volume_size = var.main_vol_size
  }
}

resource "aws_key_pair" "mtc_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}