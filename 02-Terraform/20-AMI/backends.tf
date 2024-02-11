terraform {
  backend "remote" {
    organization = "terrancible"

    workspaces {
      name = "terransible"
    }
  }
}