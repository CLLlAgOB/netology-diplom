#data.tf 
data "template_file" "instance_userdata" {
  template = file("linux.tpl")
  vars = {
    env        = "perf"
    username   = var.username
    ssh_public = var.public_key #file(var.public_key)
  }
}
