# Create DB subnet group
resource "aws_db_subnet_group" "wp-db-subnet-group" {
  name       = "wp-db-subnet-group"
  subnet_ids = [aws_subnet.private-1.id, aws_subnet.private-2.id]
}

#Create RDS MariaDB Database
resource "aws_db_instance" "royal-wp-db" {
  identifier             = "royal-wp-db"
  allocated_storage      = 20
  engine                 = "mariadb"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.wp-db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.allow-mysql.id]
  username               = "royalvikingr"
  password               = "r0y4LV1k!nGr"
  publicly_accessible    = false
  deletion_protection    = false
  skip_final_snapshot    = true
  tags = {
    Name = "royal-wp-db"
  }
}
