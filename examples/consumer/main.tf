module "webserver_cluster" {
  source = "../.."

  project_name = "consumer-test"
  team_name    = "devops"
  environment  = "test"
  cluster_name = "consumer-web-test"

  enable_destroy_protection = false
}
