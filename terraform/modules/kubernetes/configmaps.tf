resource "kubernetes_config_map" "timburr" {
  metadata {
    name = "timburr"
  }

  data = {
    "config.yml" = templatefile("${path.root}/../config/timburr/config.yml", {
      cf_zone_id      = var.cf_zone_id
      malasada_api_id = var.malasada_api_id
    })
  }
}

resource "kubernetes_config_map" "wiki-52poke" {
  metadata {
    name = "52poke-wiki"
  }

  data = {
    "LocalSettings.php" = file("${path.root}/../config/52poke-wiki/LocalSettings.php")
  }
}

resource "kubernetes_config_map" "logstash" {
  metadata {
    name = "logstash"
  }

  data = {
    "pipelines.yml"           = file("${path.root}/../config/logstash/pipelines.yml")
    "pipeline_mediawiki.conf" = file("${path.root}/../config/logstash/pipeline_mediawiki.conf")
  }
}

resource "kubernetes_config_map" "nginx-52w" {
  metadata {
    name = "nginx-52w"
  }

  data = {
    "nginx.conf" = templatefile("${path.root}/../config/nginx-52w/nginx.conf", {
      wiki_ban_user_agents = var.wiki_ban_user_agents
      wiki_ban_uri         = var.wiki_ban_uri
    })
  }
}

resource "kubernetes_config_map" "nginx-media" {
  metadata {
    name = "nginx-media"
  }

  data = {
    "nginx.conf" = templatefile("${path.root}/../config/nginx-media/nginx.conf", {
      media_ban_user_agent      = var.media_ban_user_agent
      media_ban_empty_refer_uri = var.media_ban_empty_refer_uri
      malasada_api_id           = var.malasada_api_id
    })
  }
}