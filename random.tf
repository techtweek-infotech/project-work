resource "random_password" "admin" {
  length  = 20
  special = true
}
