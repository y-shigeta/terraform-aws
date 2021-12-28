
variable "availability_zone_0" {
    default = "us-west-1b"
}
variable "availability_zone_1" {
    default = "us-west-1c"
}
variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}
variable "public_subnet_0_cidr_block" {
    default  = "10.0.10.0/24"
}
variable "public_subnet_1_cidr_block" {
    default = "10.0.11.0/24"
}
variable "private_subnet_0_cidr_block" {
    default = "10.0.30.0/24"
} 
variable "private_subnet_1_cidr_block" {
    default = "10.0.31.0/24"
}