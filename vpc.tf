resource "aws_vpc" "homework_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "homework_vpc"
  }
}


resource "aws_subnet" "pvt_subnet" {
    count = length(var.pvt_subnet_cidr_list)
    vpc_id = aws_vpc.homework_vpc.id
    cidr_block = var.pvt_subnet_cidr_list[count.index]
    availability_zone = "eu-west-1a"

    tags = {
      "Name" = "homework_pvt_subnets"
    }
}


resource "aws_subnet" "pub_subnet" {
    count = length(var.pub_subnet_cidr_list)
    vpc_id = aws_vpc.homework_vpc.id
    cidr_block = var.pub_subnet_cidr_list[count.index]
    availability_zone = "eu-west-1b"
     tags = {
      "Name" = "homework_pvt_subnets"
    }
}


resource "aws_internet_gateway" "homework_internet_gateway" {
    vpc_id = aws_vpc.homework_vpc.id

    tags = {
      "Name" = "Homework_igw"
    }
}

resource "aws_route_table" "homework_pub_rt" {
  vpc_id = aws_vpc.homework_vpc.id


    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.homework_internet_gateway.id
    }

    tags = {
      "Name" = "homework public route table"
    }
  
}


resource "aws_eip" "homework_eip" {
  domain = "vpc"
  tags = {
    "Name" = "homework_eip"
  }
}

resource "aws_nat_gateway" "homework_nat_gw" {
  allocation_id = aws_eip.homework_eip.id
  subnet_id = aws_subnet.pub_subnet[0].id

  tags = {
    "Name" = "homework-nat"
  }
}



resource "aws_route_table" "homework_pvt_rt" {
  vpc_id = aws_vpc.homework_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.homework_nat_gw.id
  }

      tags = {
      "Name" = "homework private route table"
    }

}

resource "aws_route_table_association" "pub_rta" {
  count = length(var.pub_subnet_cidr_list)
  subnet_id = aws_subnet.pub_subnet[count.index].id
  route_table_id = aws_route_table.homework_pub_rt.id
}

resource "aws_route_table_association" "pvt_rta" {
    count = length(var.pvt_subnet_cidr_list)
    subnet_id = aws_subnet.pvt_subnet[count.index].id
    route_table_id = aws_route_table.homework_pvt_rt.id
}





