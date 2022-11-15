resource "aws_codebuild_source_credential" "github_source_credential" {
  auth_type   = var.codestar-connection.auth-type
  server_type = var.codestar-connection.server-type
  token       = var.codestar-connection.token

}

resource "aws_codestarconnections_connection" "pipeline" {
  name          = "${local.name_codestar}-github-conn"
  provider_type = "GitHub"
}
