resource "aws_vpc_peering_connection" "requester_connection" {
  provider      = aws.root
  vpc_id        = data.terraform_remote_state.root.outputs.vpc_id
  peer_vpc_id   = module.vpc.vpc_id
  peer_owner_id = var.dev_account
  peer_region   = var.region
  auto_accept   = false
  tags = {
    Side = "Requester"
  }
}


resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = aws.root
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_connection.id

  requester {
    allow_remote_vpc_dns_resolution = var.this_dns_resolution
  }

  depends_on = [
   aws_vpc_peering_connection_accepter.accepter_connection,
   aws_vpc_peering_connection_options.accepter
  ]
}

#routes

resource "aws_route" "pub_route_tables" {
  provider                  = aws.root
  count                     = length(data.terraform_remote_state.root.outputs.vpc_root_public_route_table_id)
  route_table_id            = tolist(data.terraform_remote_state.root.outputs.vpc_root_public_route_table_id)[count.index]
  destination_cidr_block    = module.vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_connection.id
  depends_on                = [aws_vpc_peering_connection.requester_connection]
}

resource "aws_route" "pri_route_tables" {
  provider                  = aws.root
  count                     = length(data.terraform_remote_state.root.outputs.vpc_root_private_route_table_id)
  route_table_id            = tolist(data.terraform_remote_state.root.outputs.vpc_root_private_route_table_id)[count.index]
  destination_cidr_block    = module.vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_connection.id
  depends_on                = [aws_vpc_peering_connection.requester_connection]
}
