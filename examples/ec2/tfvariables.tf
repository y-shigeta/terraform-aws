
variable "ami" {
    default = "ami-08d2d8b00f270d03b" # CentOS 7 for us-west-1
}
variable "instance_type" {
    default = "t3.micro"
}
variable "src_globalip" {
    default = "60.112.175.56/32"
}