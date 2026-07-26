resource "aws_db_subnet_group" "this" {
  for_each = var.db_subnet_groups

  name       = each.value.name
  subnet_ids = each.value.subnet_ids

  tags = {
    Name = each.value.name
  }
}

resource "aws_rds_cluster" "this" {
  for_each = var.db_clusters

  cluster_identifier = each.value.cluster_identifier

  engine         = each.value.engine
  engine_version = each.value.engine_version

  database_name   = each.value.database_name
  master_username = each.value.master_username

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.this[each.value.db_subnet_group_key].name
  vpc_security_group_ids = each.value.vpc_security_group_ids
  port                   = each.value.port

  backup_retention_period = each.value.backup_retention_period

  skip_final_snapshot = each.value.skip_final_snapshot
}

# 추후에 reader instance 가 필요할 때를 위해 count 로 생성
resource "aws_rds_cluster_instance" "this" {
  for_each = var.db_instances

  identifier         = "${aws_rds_cluster.this[each.value.cluster_key].cluster_identifier}-instance-1"
  cluster_identifier = aws_rds_cluster.this[each.value.cluster_key].id
  engine             = aws_rds_cluster.this[each.value.cluster_key].engine
  engine_version     = aws_rds_cluster.this[each.value.cluster_key].engine_version
  instance_class     = each.value.instance_class
}
