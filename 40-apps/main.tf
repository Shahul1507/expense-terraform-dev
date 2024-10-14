module "mysql" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  
  ami = local.ami_id
  name = "${local.resource_name}-mysql"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id              = local.database_subnet_id

  tags = merge(
    var.common_tags,
    var.mysql_tags,
    {
        Name = "${local.resource_name}-mysql"
    }
  )
}

module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  
  ami = local.ami_id
  name = "${local.resource_name}-backend"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.backend_tags,
    {
       Name= "${local.resource_name}-backend"
    }
  )
}

module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  
  ami = local.ami_id
  name = "${local.resource_name}-frontend"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.frontend_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.frontend_tags,
    {
      Name =  "${local.resource_name}-frontend"
    }
  )
}

module "ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  
  ami = local.ami_id
  name = "${local.resource_name}-ansible"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.ansible_sg_id]
  subnet_id              = local.public_subnet_id
  user_data = file("expense.sh")
  tags = merge(
    var.common_tags,
    var.ansible_tags,
    {
      Name =  "${local.resource_name}-ansible"
    }
  )
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        module.mysql.private_ip
      ]
    },
    {
      name    = "backend"
      type    = "A"
      ttl     = 1
      records = [
        module.backend.private_ip
      ]
    },
    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.private_ip
      ]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.public_ip
      ]
    }
  ]
}

#  module "ec2_instance" {
#    source  = "terraform-aws-modules/ec2-instance/aws" # no need to have 
#    #git link as terraform-aws-modules/ec2-instance/aws will download the 
#    # open-source module.

#    name = "single-instance" # local.resourcename

#    instance_type          = "t2.micro"
#    key_name               = "user1" # remove
#    monitoring             = true #remove
#    vpc_security_group_ids = ["sg-12345678"] 
#    # we need bastion sg id 
#    # we will get the bastion_sg_id from SSM parameter from SG group folder . 

#    subnet_id              = "subnet-eddcdzz4" 
#    # bastion will be in public network 
#    # we will get public subnet id from SSM paramter from vpc group folder
#    # as we have two public subnet ensure that you pick the first subnet
#    tags = {
#      Terraform   = "true"
#      Environment = "dev"
#    }
#  }
