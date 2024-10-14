variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}


variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = "true"
        Environment = "dev"
    }
}

variable "mysql_sg_tags" {     #sg module
    default = {
        Component = "mysql"
    }
}

variable "backend_sg_tags" {     #backend module
    default = {
        Component = "backend"
    }
}

variable "frontend_sg_tags" {     #frontend module
    default = {
        Component = "frontend"
    }
}

variable "bastion_sg_tags" {     #bastion module
    default = {
        Component = "bastion"
    }
}


variable "ansible_sg_tags" {     #ansible module
    default = {
        Component = "ansible"
    }
}