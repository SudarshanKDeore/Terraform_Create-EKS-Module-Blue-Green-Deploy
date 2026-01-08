bucket         = "terraform-state-prod-1234"
key            = "eks/production/blue/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-locks"
encrypt        = true
