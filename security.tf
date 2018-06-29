resource "aws_security_group" "base_linux_jenkins_test" {
  name        = "base_linux_${random_id.instance_id.hex}"
  description = "base security rules for all linux nodes"
  vpc_id      = "${var.jenkins_vpc_id}"

  tags {
    Name          = "${var.jenkins_tag_customer}-${var.jenkins_tag_project}_${random_id.instance_id.hex}_${var.tag_application}_security_group"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.jenkins_tag_customer}"
    X-Project     = "${var.jenkins_tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "aws_security_group" "habitat_supervisor_jenkins" {
  name        = "habitat_supervisor_${random_id.instance_id.hex}"
  description = "Security rules for the Habitat supervisor"
  vpc_id      = "${var.jenkins_vpc_id}"

  tags {
    Name          = "${var.jenkins_tag_customer}-${var.jenkins_tag_project}_${random_id.instance_id.hex}_${var.tag_application}_security_group"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.jenkins_tag_customer}"
    X-Project     = "${var.jenkins_tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "aws_security_group" "jenkins_test" {
  name        = "jenkins_${random_id.instance_id.hex}"
  description = "Security rules for Jenkins"
  vpc_id      = "${var.jenkins_vpc_id}"

  tags {
    Name          = "${var.jenkins_tag_customer}-${var.jenkins_tag_project}_${random_id.instance_id.hex}_${var.tag_application}_security_group"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.jenkins_tag_customer}"
    X-Project     = "${var.jenkins_tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

//////////////////////////
// Base Jenkins Rules
resource "aws_security_group_rule" "ingress_allow_80_tcp_all" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.jenkins_test.id}"
}

resource "aws_security_group_rule" "ingress_allow_8080_tcp_all" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.jenkins_test.id}"
}

//////////////////////////
// Base Linux Rules
resource "aws_security_group_rule" "ingress_allow_22_tcp_all" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.base_linux_jenkins_test.id}"
}

/////////////////////////
// Habitat Supervisor Rules
# Allow Habitat Supervisor http communication tcp
resource "aws_security_group_rule" "ingress_allow_9631_tcp" {
  type                     = "ingress"
  from_port                = 9631
  to_port                  = 9631
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.habitat_supervisor_jenkins.id}"
  source_security_group_id = "${aws_security_group.habitat_supervisor_jenkins.id}"
}

# Allow Habitat Supervisor http communication udp
resource "aws_security_group_rule" "ingress_allow_9631_udp" {
  type                     = "ingress"
  from_port                = 9631
  to_port                  = 9631
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.habitat_supervisor_jenkins.id}"
  source_security_group_id = "${aws_security_group.habitat_supervisor_jenkins.id}"
}

# Allow Habitat Supervisor ZeroMQ communication tcp
resource "aws_security_group_rule" "ingress_9638_tcp" {
  type                     = "ingress"
  from_port                = 9638
  to_port                  = 9638
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.habitat_supervisor_jenkins.id}"
  source_security_group_id = "${aws_security_group.habitat_supervisor_jenkins.id}"
}

# Allow Habitat Supervisor ZeroMQ communication udp
resource "aws_security_group_rule" "ingress_allow_9638_udp" {
  type                     = "ingress"
  from_port                = 9638
  to_port                  = 9638
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.habitat_supervisor_jenkins.id}"
  source_security_group_id = "${aws_security_group.habitat_supervisor_jenkins.id}"
}

# Egress: ALL
resource "aws_security_group_rule" "linux_egress_allow_0-65535_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.base_linux_jenkins_test.id}"
}
