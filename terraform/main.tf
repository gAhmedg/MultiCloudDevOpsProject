provider "aws" {
          region = var.region
          profile = "default"
#           access_key = "my-access-key"
#   secret_key = "my-secret-key"
}
terraform {
    backend "s3" {
        bucket         = "ivolve-remote-statefile"
        key            = "terraform.tfstate"
        region         = "us-east-1"
        dynamodb_table = "ivolve-locks"
        encrypt        = true
    }
}


module "ec2" {

    source                 =   "./modules/instance"
    vpcid                  =   module.vpc.vpc_id
    subnetpublicid         =   module.vpc.subnet_public_id
    ami                    =   var.ami
    instance_type          =   var.instance_type
# output puplic ip module.ec2.public_ip
}

module "vpc" {

    source                  =   "./modules/vpc"
    vpc_cidr                =   var.vpc_cidr
    public_subnet_cidr      =  var.public_cidr 
    private_subnet_cidr     = var.private_cidr 
    
  
}



# Create CloudWatch metric alarm for CPU utilization
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "terraform-Ec2-70%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when CPU exceeds 70%"
  alarm_actions       = [aws_sns_topic.my_topic.arn]

  dimensions = {
    InstanceId = module.ec2.instaceid
  }
}

# Create SNS topic
resource "aws_sns_topic" "my_topic" {
  name = "cpu-utilization-topic"
}

# Subscribe Gmail address to the SNS topic
resource "aws_sns_topic_subscription" "gmail_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "email"
  endpoint  = "gomaaa447@gmail.com"
}