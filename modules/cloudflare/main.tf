provider "cloudflare" {
  api_token = var.cf_token_dns
}

data "cloudflare_zones" "wiki_52poke" {
  filter {
    name = "52poke.wiki"
  }
}