# Output the DB endpoint
output "db-endpoint" {
  value = aws_db_instance.royal-wp-db.endpoint
}