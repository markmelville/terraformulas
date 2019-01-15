# terraformulas
A place for my [terraform](https://www.terraform.io/) modules. Read below if you need help getting started.

## The Modules
 - [ssl_cert_letsencrypt_godaddy](./ssl_cert_letsencrypt_godaddy) - Create a free SSL certificate in seconds.

## Getting Started With Terraform

Terraform makes it easy to create an "infrastructure as code" system. Install it with `brew install terraform`.

It uses `.tf` files to define resources that should exist. When you run `terraform apply` it will create all the resources.

For example, to manage a file resource, put this code into a `hello_file.tf`:

    resource "local_file" "hello_file" {
        filename = "${path.module}/hello.txt"
        content = "Hello, File!"
    }

Run `terraform apply` and the file `hello.txt` will be created. (The first run will prompt you run `terraform init` first.) Run `apply` again, and nothing happens because the file already exists. Modify the contents of `hello.txt`, run `apply` again, and the contents will be changed back to what is specified by the resource definition.

Running `terraform plan` will verify your terraform files and do a dry-run of the actions that `apply` would perform.

There are many, many resource types from various [providers](https://www.terraform.io/docs/providers/index.html).
