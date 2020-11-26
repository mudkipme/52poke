resource "cloudflare_record" "klinklang" {
  zone_id = data.cloudflare_zones.wiki_52poke.zones[0].id
  name    = "util"
  value   = var.load_balancer_ip
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "wiki_52poke" {
  zone_id = data.cloudflare_zones.wiki_52poke.zones[0].id
  name    = "52poke.wiki"
  value   = var.load_balancer_ip
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "wiki_52poke_www" {
  zone_id = data.cloudflare_zones.wiki_52poke.zones[0].id
  name    = "www"
  value   = var.load_balancer_ip
  type    = "A"
  ttl     = 1
  proxied = true
}