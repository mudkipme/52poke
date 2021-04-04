52Poké
======

52Poké (神奇宝贝部落格/神奇寶貝部落格) is a nonprofit Chinese-language Pokémon fan community. It hosts [52Poké Wiki](https://wiki.52poke.com/), as well as other sub-websites such as a [Pokémon news blog](https://52poke.com/) and a [fan forum](https://52poke.net/). 52Poké Wiki (神奇宝贝百科/神奇寶貝百科) is the largest Chinese-language Pokémon encyclopedia, and a member of [Encyclopædiæ Pokémonis](http://www.encyclopaediae-pokemonis.org/).

This is a repository to track the infrastructure, deployment, tech documentation and issues in general of 52Poké.

We believe in the openness, inclusiveness and independence of individual fan communities, and 52Poké is managed by a set of open source projects including this one. Most of the projects will be licensed under BSD-3-Clause, MIT or GPLv2. To be compatible with [the content license of 52Poké Wiki](https://creativecommons.org/licenses/by-nc-sa/3.0/deed.zh), some projects may choose restrictive licenses which forbid commercial use.

While these projects are developed for 52Poké, most of them could be useful for similar websites or services, such as [MediaWiki](https://www.mediawiki.org/) wikis, [NodeBB](https://nodebb.org/) forums, [WordPress](https://wordpress.org/) blogs, or fan works related to Pokémon.

Please use [issues](https://github.com/mudkipme/52poke/issues) and [wiki](https://github.com/mudkipme/52poke/wiki) in this repository or the following sub-projects track the progress.

## Sub-projects

- [timburr](https://github.com/mudkipme/timburr): A MediaWiki event handler.
- [malasada](https://github.com/mudkipme/malasada): A serverless function to resize and convert images.
- [meltan](https://github.com/mudkipme/meltan): Dockerfiles to build containers for services and jobs on 52Poké.
- [mediawiki](https://github.com/mudkipme/mediawiki): Core MediaWiki repository of 52Poké Wiki.
- [mediawiki-lazyload](https://github.com/mudkipme/mediawiki-lazyload): An extension to lazy-loading images on MediaWiki pages.
- [klinklang](https://github.com/mudkipme/klinklang): A collection of utilities for 52Poké Wiki.
- [pokeapi-v2-typescript](https://github.com/mudkipme/pokeapi-v2-typescript): TypeScript definitions for pokedex-promise-v2 and PokeAPI endpoints.
- [nodebb-plugin-checkin](https://github.com/mudkipme/nodebb-plugin-checkin): A checking-in and award plugin for NodeBB.
- [nodebb-plugin-wikilink](https://github.com/mudkipme/nodebb-plugin-wikilink): A NodeBB plugin to link `[[text]]` with the the appropriate wiki-system.
- [nodebb-plugin-opencc](https://github.com/mudkipme/nodebb-plugin-opencc): A NodeBB plugin to translate between Traditional and Simplified Chinese.
- [nodebb-plugin-sso-mediawiki](https://github.com/mudkipme/nodebb-plugin-sso-mediawiki): NodeBB Plugin that allows users to login/register via MediaWiki.
- [ivcalc](https://github.com/mudkipme/ivcalc): Pokémon Individual Value & Stat Calculator in Chinese.
- [makeawish](https://github.com/mudkipme/makeawish): Petition for In-game Chinese Support in Pokémon Video Games.

## Deployment

As of December 2020, 52Poké runs on multiple cloud providers including Linode, AWS and Cloudflare, and most resources and applications are running in a Linode Kubernetes Engine cluster.

This repository uses Terraform to manage the infrastructure of 52Poké.

## License

The source code of this projects is under [BSD-3-Clause](LICENSE).

Neither the name of 52Poké nor the names of the contributors may be used to endorse any usage of codes under this project.

Pokémon ©2020 Pokémon. ©1995-2020 Nintendo/Creatures Inc./GAME FREAK inc. 52Poké and this project is not affiliated with any Pokémon-related companies.