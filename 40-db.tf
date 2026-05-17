resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.id
  engine                 = "postgres"
  engine_version         = "13.23"
  instance_class         = "db.t3.micro"
  multi_az               = var.rds_multi_az
  db_name                = "${var.environment}mydb"
  username               = var.db_username
  password               = var.db_password
#alex  username               = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["username"]
#alex  password               = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)["password"]
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database_sgrp.id]
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.environment}-main"
  subnet_ids = [aws_subnet.database_1.id, aws_subnet.database_2.id]

}
