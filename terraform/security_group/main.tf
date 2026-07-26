resource "aws_security_group" "this" {
  for_each = var.security_groups

  name   = each.key
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = each.key
    },
    each.value.tags
  )
}

resource "aws_security_group_rule" "rds_from_default_nodes" {
  for_each = var.security_group_ingress_rules

  type                     = each.value.type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  security_group_id        = aws_security_group.this[each.value.sg_id_key].id
  source_security_group_id = aws_security_group.this[each.value.src_sg_key].id
}

resource "aws_security_group_rule" "rds_egress" {
  for_each = var.security_group_egress_rules

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.this[each.value.sg_id_key].id
  cidr_blocks       = each.value.cidr_block
}
