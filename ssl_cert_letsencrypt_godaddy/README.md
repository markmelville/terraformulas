# ssl_cert_letsencrypt_godaddy

## Create an SSL cert

The Certificate Authority, [Let's Encrypt](https://letsencrypt.org/), pioneered a way to create free SSL certificates. Then, they developed a protocol called ACME which can automate the verification of domain ownership. Now, just add terraform, and you have a dead simple way to create a free SSL certificate.

Use this module if GoDaddy manages your DNS. You'll need to [create an API credential over there](https://developer.godaddy.com/keys), and use it here.

    module "ssl_cert" {
        source = "github.com/markmelville/terraformulas//ssl_cert_letsencrypt_godaddy"

        # the email address to use on the Let's Encrypt account
        account_email    = "me@example.com"

        # a file that holds the account key for the Let's Encrypt account. it must exist.
        # however it can be empty, in which case a new account will be created and the key will be saved into this file.
        account_key_file = "${path.module}/account.key"   

        # the domain name to issue the cert for
        domain           = "secure.mysite.com"

        # credentials from GoDaddy API
        godaddy_key      = "..."
        godaddy_secret   = "..."

        # directory where the (.pem) and private key (.key) files will be created, and the prefix to use in the filename
        cert_dir         = "/etc/ssl"
        cert_prefix      = "secure_mysite_com"
    }

This resulting certificate can be added easily added to an nginx.conf.
Just add something like this to a `server` block:

    listen              8443 ssl;
    ssl_certificate     /etc/ssl/secure_mysite_com.crt;
    ssl_certificate_key /etc/ssl/secure_mysite_com.key;

### Enable Production When Ready

You'll notice, when you first browse your site over SSL, that the certificate is not trusted. That is because this module uses a staging server by default. When you have tested the staging cert and are ready to get a "real" certificate, empty your `account_key_file` add this variable to the module:

    production = "true"

### Wildcard Cert

Since ACME v2 is used, wildcard certs can be created as well:

    module "wildcard_cert" {
        source = "github.com/markmelville/terraformulas//ssl_cert_letsencrypt_godaddy"
        account_email    = "me@example.com"
        account_key_file = "${path.module}/account.key"
        domain           = "*.mysite.com"
        godaddy_key      = "..."
        godaddy_secret   = "..."
        cert_dir         = "/etc/ssl"
        cert_prefix      = "wildcard_mysite_com"
    }

