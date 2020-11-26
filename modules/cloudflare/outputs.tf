output "cf_zone_id" {
  value = data.cloudflare_zones.wiki_52poke.zones[0].id
}