terraform {
  cloud {
    organization = "homeworknetology"

    workspaces {
      project = "Netology"
      tags = [ "stage", "prod" ]
    }
  }
}