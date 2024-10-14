module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  
  ami = local.ami_id
  name = local.resource_name

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.bastion_tags,
    {
        Name = local.resource_name
    }
  )
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
