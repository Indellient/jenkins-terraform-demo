provider "aws" {
  region                  = "${var.aws_region}"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "~/.aws/credentials"
}

resource "random_id" "instance_id" {
  byte_length = 4
}

////////////////////////////////
// Instance Data

data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["indellient-bluepipeline-habitat-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["454860694652"]
}

data "template_file" "jenkins_toml" {
  template = "${file("${path.module}/templates/jenkins_toml.tpl")}"

  vars {
    username = "${var.jenkins_admin_username}"
    password = "${var.jenkins_admin_password}"
  }
}

data "template_file" "hab_sup_service" {
  template = "${file("${path.module}/templates/hab-sup.service.tpl")}"

  vars {
    habopts = "--strategy at-once"
  }
}


resource "aws_instance" "jenkins_master" {
  count = 1

  connection {
    user        = "${var.aws_centos_image_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  ami                         = "${var.jenkins_master_ami}"
  instance_type               = "${var.jenkins_master_instance_type}"
  key_name                    = "${var.jenkins_key_name}"
  subnet_id                   = "${var.jenkins_master_subnet_id}"
  vpc_security_group_ids      = ["${aws_security_group.base_linux_jenkins_test.id}", "${aws_security_group.habitat_supervisor_jenkins.id}", "${aws_security_group.jenkins_test.id}"]

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags {
    Name          = "${format("${var.tag_name}_master_%02_${random_id.instance_id.hex}", count.index + 1)}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.jenkins_tag_customer}"
    X-Project     = "${var.jenkins_tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  provisioner "habitat" {
    use_sudo = true
    service_type = "systemd"
    url = "https://bldr.habitat.sh"
    channel = "${var.channel}"
    peer = "${self.private_ip}"

    service {
      name = "${var.origin}/jenkins"
      user_toml = "${data.template_file.jenkins_toml.rendered}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/${var.aws_centos_image_user}/keys"
    ]
  }

  provisioner "file" {
    source      = "keys/"
    destination = "/home/${var.aws_centos_image_user}/keys"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /hab/cache/keys",
      "sudo mv /home/${var.aws_centos_image_user}/keys/* /hab/cache/keys"
    ]
  }
}
