provider "aws" {
 region = var.region
}


data "aws_availability_zones" "myazs" {
  state = "available"
}

data "aws_subnet_ids" "tdb-lower" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = local.tdb_subnets
  }
}



data "template_file" "hostscript" {
  template = "${file("${path.module}/webserverhost.sh.tpl")}"
  vars = {
    hostname = var.asg_tag
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content      = data.template_file.hostscript.rendered
  }
}




#Create EC2 Instance for BRM Database(Primary and Secondary)
resource "aws_instance" "brmdbinstance" {
  count                  = var.instancenumber
  ami                    = var.goldami
  instance_type          = var.dbinstance_type
  subnet_id              = element(tolist(data.aws_subnet_ids.tdb-lower.ids), count.index)
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.brbinstance_profile.name
  vpc_security_group_ids = [aws_security_group.BRM-DB-sg.id]
  tags = {
    Name = "BRM-DbInstance${count.index + 1}"
  }
  # user_data=file("dbhost.sh")    # This is the user-data
  root_block_device {
    volume_type = var.volume_type
    volume_size = var.brmvolumesize
    encrypted   = var.rootvolumeencrypt
    delete_on_termination = true
  } 
}


# Create EBS Volumes for Primary DB-Instance
resource "aws_ebs_volume" "ebsvolumes" {
  count             = var.numberofebsvolume
  availability_zone = data.aws_availability_zones.myazs.names[2]
  size              = var.extravolumesize
  encrypted         = var.rootvolumeencrypt
  tags = {
    Name = "Pri-Vol${count.index + 1}"
  }
}

# Create EBS Volumes for Secondary DB-Instance
resource "aws_ebs_volume" "ebsvolumesbackup" {
  count             = var.numberofebsvolume
  availability_zone = data.aws_availability_zones.myazs.names[3]
  size              = var.extravolumesize
  encrypted         = var.extravolumeencrypt
  tags = {
    Name = "Sec-Vol${count.index + 1}"
  }
}


resource "aws_ebs_encryption_by_default" "brm_ebs_encryption" {
  enabled = var.extravolumeencrypt
}


#Attach the volume created to BRM Database Instance
resource "aws_volume_attachment" "volumeattachment" {
  count       = var.numberofebsvolume
  device_name = "/dev/xvd${var.letters[count.index]}"
  volume_id   = aws_ebs_volume.ebsvolumes[count.index].id
  force_detach      = var.detachextravolume
  instance_id = aws_instance.brmdbinstance[0].id
}

resource "aws_volume_attachment" "volumeattachbackup" {
  count       = var.numberofebsvolume
  device_name = "/dev/xvd${var.letters[count.index]}"
  volume_id   = aws_ebs_volume.ebsvolumesbackup[count.index].id
  force_detach      = var.detachextravolume
  instance_id = aws_instance.brmdbinstance[1].id
}




