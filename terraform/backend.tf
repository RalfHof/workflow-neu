terraform {
    backend "s3" {
      bucket = "ralf-state-bucket"
      key = "github-actions.tfstate"
      region = "eu-central-1"
    }
}