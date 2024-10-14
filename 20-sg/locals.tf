locals {
  # sg_final_name = "${var.project_name}-${var.environment}-${var.sg_name}"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}
