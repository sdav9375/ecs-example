project = "ecs-example"

app "ecs-example-app" {

  build {
    use "docker" {}
    
    workspace "production" {
      use "docker" {}
      registry {
        use "docker" {
          image = var.image
          // returns a humanized version of the git hash, taking into account tags and changes
          tag = gitrefpretty()
          // Credentials for authentication to push to docker registry
          auth {
            username = var.username
            password = var.password
          }
        }
      }
    }
  }

  deploy {
    use "docker" {}
    
    workspace "production" {
      # use "kubernetes" {
      #   service_port = 5300
      #   namespace = "default"
      # }
      use "aws-ecs" {
        region = "us-east-1"
        memory = 512
      }
    }
  }

  # release {
  #   workspace "production" {
  #     use "aws-ecs" {

  #     }
  #     use "kubernetes" {
  #       port = 5300
  #     }
  #   }
  # }
}

variable "image" {
  type = string
  default = "sdav9375/hashitalk-deploy"
}
variable "username" {
  type = string
  default = "sdav9375"
}
variable "password" {
  type = string
  env = ["DOCKER_PWD"]
  sensitive = true
}
