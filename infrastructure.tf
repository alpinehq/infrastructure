provider "digitalocean" {
}

resource "digitalocean_droplet" "web" {
    image = "ubuntu-18-04-x64"
    name = "alpinehq-web"
    region = "nyc3"
    size = "s-1vcpu-1gb"
    monitoring = true
    ssh_keys = [
        digitalocean_ssh_key.beast.fingerprint,
    ]
}

resource "digitalocean_floating_ip" "web" {
  droplet_id = digitalocean_droplet.web.id
  region     = digitalocean_droplet.web.region
}

resource "digitalocean_ssh_key" "beast" {
    name = "matt@beast"
    public_key = file("~/.ssh/id_rsa_alpinehq.pub")
}

resource "digitalocean_domain" "alpinehq" {
    name = "alpinehq.dev"
    ip_address = digitalocean_floating_ip.web.ip_address
}

resource "digitalocean_record" "all" {
    domain = digitalocean_domain.alpinehq.name
    type = "CNAME"
    value = "@"
    name = "*"
    ttl = 60
}
