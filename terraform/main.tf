terraform {
 required_version = ">= 1.0"

 required_providers {
   local = {
     source = "hashicorp/local"
     version = "~> 2.5"
   }
 }
}
 

resource "local_file" "hello" {
  filename = "hello.txt"
  content = "This is an example message text"
 }

