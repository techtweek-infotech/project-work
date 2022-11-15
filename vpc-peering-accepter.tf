
resource "aws_vpc_peering_connection_accepter" "accepter_connection" {
  
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_connection.id
  auto_accept               = true
  tags = {
    Side = "Accepter"
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter_connection.id

  accepter {
    allow_remote_vpc_dns_resolution = var.peer_dns_resolution
  }
}

#routes

resource "aws_route" "accepter-route-pub" {
  
  count                     = length(module.vpc.public_route_table_ids)
  route_table_id            = tolist(module.vpc.public_route_table_ids)[count.index]
  destination_cidr_block    = data.terraform_remote_state.root.outputs.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_connection.id
  depends_on                = [aws_vpc_peering_connection.requester_connection]
}

resource "aws_route" "accepter-route-db" {
  
  count                     = length(module.vpc.database_route_table_ids)
  route_table_id            = tolist(module.vpc.database_route_table_ids)[count.index]
  #route_table_id            = module.vpc.database_route_table_ids
  destination_cidr_block    = data.terraform_remote_state.root.outputs.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_connection.id
  depends_on                = [aws_vpc_peering_connection.requester_connection]
}

resource "aws_route" "accepter-route-pri" {
  
  count                     = length(module.vpc.private_route_table_ids)
  route_table_id            = tolist(module.vpc.private_route_table_ids)[count.index]
  destination_cidr_block    = data.terraform_remote_state.root.outputs.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_connection.id
  depends_on                = [aws_vpc_peering_connection.requester_connection]
}


