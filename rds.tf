# Create DB subnet group
resource "aws_db_subnet_group" "wp-db-subnet-group" {
  name       = "wp-db-subnet-group"
  subnet_ids = [aws_subnet.private-1.id, aws_subnet.private-2.id]
}

# Create RDS MariaDB Database Instance
resource "aws_db_instance" "royal-wp-db" {
  identifier             = "royal-wp-db"
  allocated_storage      = 20
  engine                 = "mariadb"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.wp-db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.allow-mysql.id]
  username               = var.db-username
  password               = var.db-password
  publicly_accessible    = false
  deletion_protection    = false
  skip_final_snapshot    = true
  tags = {
    Name = "royal-wp-db"
  }
  # Use a provisioner to create a database; CANNOT WORK, NOT REACHABLE FROM INTERNET
  /* provisioner "local-exec" {
    command = "echo 'CREATE DATABASE $(var.db-name);' >> /tmp/db.setup && mysql -h ${self.address} -P ${self.port} -u ${self.username} -p${self.password} < /tmp/db.setup && sudo rm /tmp/db.setup"
  } */
}