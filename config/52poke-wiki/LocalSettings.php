<?php

# This file was automatically generated by the MediaWiki installer.
# If you make manual changes, please keep track in case you need to
# recreate them later.
#
# See includes/DefaultSettings.php for all configurable settings
# and their default values, but don't forget to make changes in _this_
# file, not there.
#
# Further documentation for configuration settings may be found at:
# http://www.mediawiki.org/wiki/Manual:Configuration_settings

# If you customize your file layout, set $IP to the directory that contains
# the other MediaWiki files. It will be used as a base to locate files.
if( defined( 'MW_INSTALL_PATH' ) ) {
    $IP = MW_INSTALL_PATH;
} else {
    $IP = dirname( __FILE__ );
}

$path = array( $IP, "$IP/includes", "$IP/languages" );
set_include_path( implode( PATH_SEPARATOR, $path ) . PATH_SEPARATOR . get_include_path() );

require_once( "$IP/includes/DefaultSettings.php" );

if ( $wgCommandLineMode ) {
    if ( isset( $_SERVER ) && array_key_exists( 'REQUEST_METHOD', $_SERVER ) ) {
        die( "This script must be run from the command line\n" );
    }
}
## Uncomment this to disable output compression
# $wgDisableOutputCompression = true;

$wgSitename = "神奇宝贝百科";
$wgServer = '//wiki.52poke.com';
$wgCanonicalServer = 'https://wiki.52poke.com';
$wgEnableCanonicalServerLink = true;

## The URL base path to the directory containing the wiki;
## defaults for all runtime URL paths are based off of this.
## For more information on customizing the URLs please see:
## http://www.mediawiki.org/wiki/Manual:Short_URL
$wgScriptPath = "";
$wgArticlePath = "/wiki/$1";
$wgUsePathInfo = true;
$wgScriptExtension = ".php";

## The relative URL path to the skins directory
$wgStylePath = "$wgScriptPath/skins";

## The relative URL path to the logo.  Make sure you change this from the default,
## or else you'll overwrite your logo when you upgrade!
$wgLogo = "https://s0.52poke.wiki/assets/wikilogo.png";

## UPO means: this is also a user preference option

$wgEnableEmail = true;
$wgEnableUserEmail = true; # UPO

$wgEmergencyContact = "no-reply@52poke.net";
$wgPasswordSender = "no-reply@52poke.net";

$wgEnotifUserTalk = true; # UPO
$wgEnotifWatchlist = true; # UPO
$wgEmailAuthentication = true;
$wgSMTP = array(
    'host' => 'tls://email-smtp.us-west-2.amazonaws.com',
    'IDHost' => 'email-smtp.us-west-2.amazonaws.com',
    'port' => 465,
    'username' => file_get_contents("/run/secrets/aws-smtp-ak"),
    'password' => file_get_contents("/run/secrets/aws-smtp-sk"),
    'auth' => true
);

## Database settings
$wgDBtype = "mysql";
$wgDBserver = "mysql";
$wgDBname = file_get_contents("/run/secrets/52w-db-name");
$wgDBuser = file_get_contents("/run/secrets/52w-db-user");
$wgDBpassword = file_get_contents("/run/secrets/52w-db-password");

# MySQL specific settings
$wgDBprefix = "";

# MySQL table options to use during installation or update
$wgDBTableOptions = "ENGINE=InnoDB, DEFAULT CHARSET=utf8";

## Shared memory settings
$wgMainCacheType = CACHE_MEMCACHED;
$wgMemCachedServers = array( 'memcached:11211' );

$wgObjectCaches['mysql-pc'] = [
    'class' => 'SqlBagOStuff',
    'server' => [
        'host' => 'mysql-pc',
        'dbname' => $wgDBname,
        'user' => $wgDBuser,
        'password' => $wgDBpassword,
    ],
];
$wgParserCacheType = 'mysql-pc';

## To enable image uploads, make sure the 'images' directory
## is writable, then set this to true:
$wgEnableUploads = true;
$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";

## If you use ImageMagick (or any other shell command) on a
## Linux server, this will need to be set to the name of an
## available UTF-8 locale
$wgShellLocale = "en_US.utf8";

## If you want to use image uploads under safe mode,
## create the directories images/archive, images/thumb and
## images/temp, and make them all writable. Then uncomment
## this, if it's not already uncommented:
# $wgHashedUploadDirectory = false;

## If you have the appropriate support software installed
## you can enable inline LaTeX equations:
$wgUseTeX = false;

## Set $wgCacheDirectory to a writable directory on the web server
## to make your wiki go slightly faster. The directory should not
## be publically accessible from the web.
$wgCacheDirectory = "$IP/cache";
//$wgUseFileCache = true;
//$wgFileCacheDirectory = "$IP/cache";
//$wgUseGzip = true;
$wgDisableCounters = true;

$wgLocalInterwiki = strtolower( $wgSitename );

$wgLanguageCode = "zh";

$wgSecretKey = file_get_contents("/run/secrets/52w-secret-key");

## Default skin: you can change the default skin. Use the internal symbolic
## names, ie 'vector', 'monobook':
$wgDefaultSkin = 'vector';

## For attaching licensing metadata to pages, and displaying an
## appropriate copyright notice / icon. GNU Free Documentation
## License and Creative Commons licenses are supported so far.
$wgEnableCreativeCommonsRdf = true;
$wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
$wgRightsUrl = "//creativecommons.org/licenses/by-nc-sa/3.0/deed.zh";
$wgRightsText = "署名-非商业性使用-相同方式共享 3.0";
$wgRightsIcon = "//licensebuttons.net/l/by-nc-sa/3.0/88x31.png";

$wgDiff3 = "/usr/bin/diff3";

$wgInvalidateCacheOnLocalSettingsChange = false;
$wgHtml5 = true;
$wgSecureLogin = true;
$wgAllowUserJs = true;
$wgAllowUserCss = true;
$wgShowIPinHeader = false;

# Namespaces
$wgExtraNamespaces[100] = "附录";
$wgExtraNamespaces[101] = "附录_talk";
$wgExtraNamespaces[102] = "Pre";
$wgExtraNamespaces[103] = "Pre_talk";
$wgNamespaceAliases['52W'] = NS_PROJECT;
$wgNamespaceAliases['神奇寶貝百科'] = NS_PROJECT;
$wgNonincludableNamespaces[] = 102;
$wgNonincludableNamespaces[] = 103;

# Permissions
$wgGroupPermissions['*']['edit'] = false;
$wgGroupPermissions['*']['writeapi'] = false;
$wgGroupPermissions['*']['createtalk'] = false;
$wgGroupPermissions['*']['createpage'] = false;
$wgGroupPermissions['sysop']['renameuser'] = true;
$wgGroupPermissions['sysop']['deleterevision'] = true;
$wgGroupPermissions['sysop']['upload_by_url'] = true;
$wgGroupPermissions['sysop']['move'] = true;
$wgGroupPermissions['sysop']['createpage'] = true;
$wgGroupPermissions['sysop']['editsitecss'] = true;
$wgGroupPermissions['sysop']['editsitejs'] = true;
$wgGroupPermissions['sysop']['editsitejson'] = true;
$wgGroupPermissions['user']['upload'] = false;
$wgGroupPermissions['user']['move'] = false;
$wgGroupPermissions['user']['edit'] = true;
$wgGroupPermissions['user']['createpage'] = false;
$wgGroupPermissions['autoconfirmed']['upload'] = true;
$wgGroupPermissions['autoconfirmed']['createpage'] = true;
$wgGroupPermissions['autoconfirmed']['skipcaptcha'] = true;
$wgGroupPermissions['autoconfirmed']['createpage'] = true;
$wgGroupPermissions['autoconfirmed']['move'] = true;
$wgGroupPermissions['confirmed']['upload'] = true;
$wgGroupPermissions['confirmed']['createpage'] = true;
$wgGroupPermissions['confirmed']['skipcaptcha'] = true;
$wgGroupPermissions['confirmed']['edit'] = true;
$wgGroupPermissions['confirmed']['move'] = true;
$wgGroupPermissions['inspector']['patrol'] = true;
$wgGroupPermissions['inspector']['rollback'] = true;
$wgGroupPermissions['inspector']['block'] = true;
$wgGroupPermissions['inspector']['editprotected'] = true;
$wgGroupPermissions['inspector']['skipcaptcha'] = true;
$wgGroupPermissions['inspector']['move'] = true;
$wgGroupPermissions['archivist']['upload'] = true;
$wgGroupPermissions['archivist']['reupload'] = true;
$wgGroupPermissions['archivist']['upload_by_url'] = true;
$wgGroupPermissions['archivist']['movefile'] = true;
$wgGroupPermissions['archivist']['suppressredirect'] = true;
$wgGroupPermissions['archivist']['delete'] = true;
$wgGroupPermissions['archivist']['move'] = true;
$wgGroupPermissions['bot']['move'] = true;
$wgGroupPermissions['bot']['createpage'] = true;
$wgGroupPermissions['bot']['upload'] = true;
$wgGroupPermissions['bot']['reupload'] = true;
$wgGroupPermissions['bot']['upload_by_url'] = true;
$wgGroupPermissions['bot']['movefile'] = true;
$wgGroupPermissions['bot']['createpage'] = true;
$wgGroupPermissions['bot']['noratelimit'] = true;

$wgLockManagers[] = [
    'name'         => 'redisLockManager',
    'class'        => 'RedisLockManager',
    'lockServers'  => [ 'redis' => 'redis' ],
    'srvsByBucket' => [
        0 => [ 'redis' ]
    ],
    'lockTTL' =>  60,
    'redisConfig'  => [
        'connectTimeout' => 2,
        'readTimeout'    => 2
    ]
];

$wgVariantArticlePath = "/$2/$1";
$wgNoFollowLinks = false;
$wgAllowExternalImagesFrom = [
    'http://wiki.52poke.com/',
    'https://wiki.52poke.com/',
    'http://media.52poke.com/',
    'https://media.52poke.com/'
];

$wgDisabledVariants = array( 'zh-cn', 'zh-hk', 'zh-tw', 'zh-sg', 'zh-mo', 'zh-my' );
$wgUpgradeKey = file_get_contents("/run/secrets/52w-upgrade-key");
$wgAutoConfirmAge = 7*86400;
$wgAutoConfirmCount = 50;

wfLoadSkin( "MonoBook" );
wfLoadSkin( "Vector" );
wfLoadSkin( 'MinervaNeue' );

# googleAnalytics Extension
require_once "$IP/extensions/googleAnalytics/googleAnalytics.php";
$wgGoogleAnalyticsAccount = "UA-4004655-3";

# ParserFunctions Extension
wfLoadExtension( "ParserFunctions" );
$wgPFEnableStringFunctions = true;

# ConfirmEdit Extension
wfLoadExtensions([ 'ConfirmEdit', 'ConfirmEdit/ReCaptchaNoCaptcha' ]);
$wgCaptchaClass = 'ReCaptchaNoCaptcha';
$wgReCaptchaSiteKey = file_get_contents("/run/secrets/recaptcha-site-key");
$wgReCaptchaSecretKey = file_get_contents("/run/secrets/recaptcha-secret-key");

# Cite Extension
wfLoadExtension( "Cite" );

# Poem Extension
wfLoadExtension( 'Poem' );

# ReplaceText Extension
wfLoadExtension( "ReplaceText" );
$wgGroupPermissions['sysop']['replacetext'] = true;
$wgGroupPermissions['bot']['replacetext'] = true;

# MobileFrontend Extension
wfLoadExtension( "MobileFrontend" );
$wgMFDefaultSkinClass = 'SkinMinerva';
$wgMFAutodetectMobileView = false;

# Renameuser Extension
wfLoadExtension( "Renameuser" );

# WikiEditor Extension
wfLoadExtension( "WikiEditor" );
$wgVectorUseSimpleSearch = true;
$wgDefaultUserOptions['usebetatoolbar'] = 1;
$wgDefaultUserOptions['usebetatoolbar-cgd'] = 1;
$wgDefaultUserOptions['wikieditor-preview'] = 1;
$wgDefaultUserOptions['useeditwarning'] = 1;

# Editcount Extension
wfLoadExtension( "Editcount" );

wfLoadExtension( "Interwiki" );
// To grant sysops permissions to edit interwiki data
$wgGroupPermissions['sysop']['interwiki'] = true;

# RSS Extension
wfLoadExtension( "RSS" );
$wgRSSUrlWhitelist = array('https://52poke.com/feed/');

# Gadgets Extension
wfLoadExtension( "Gadgets" );

# UserMerge Extension
wfLoadExtension( "UserMerge" );
$wgGroupPermissions['bureaucrat']['usermerge'] = true;

# Lazyload Extension
wfLoadExtension( "Lazyload" );

# Echo Extension
wfLoadExtension( "Echo" );

# OAuth Extension
wfLoadExtension( 'OAuth' );
$wgGroupPermissions['sysop']['mwoauthproposeconsumer'] = true;
$wgGroupPermissions['sysop']['mwoauthupdateownconsumer'] = true;
$wgGroupPermissions['sysop']['mwoauthmanageconsumer'] = true;
$wgGroupPermissions['sysop']['mwoauthsuppress'] = true;
$wgGroupPermissions['sysop']['mwoauthviewsuppressed'] = true;
$wgGroupPermissions['sysop']['mwoauthviewprivate'] = true;

# Elasticsearch Extension
wfLoadExtension( 'Elastica' );
require_once "$IP/extensions/CirrusSearch/CirrusSearch.php";

$wgCirrusSearchServers = [
    'default' => 'es-mediawiki',
];

$wgSearchType = 'CirrusSearch';

# PoolCounter
$wgPoolCounterConf = [
    'ArticleView' => [
        'class' => 'PoolCounterRedis',
        'timeout' => 15,
        'workers' => 2,
        'maxqueue' => 100,
        'servers' => ['redis']
    ],
    'CirrusSearch-Search' => [
        'class' => 'PoolCounterRedis',
        'timeout' => 15,
        'workers' => 50,
        'maxqueue' => 150,
        'servers' => ['redis']
    ],
    'CirrusSearch-Prefix' => [
        'class' => 'PoolCounterRedis',
        'timeout' => 15,
        'workers' => 8,
        'maxqueue' => 15,
        'servers' => ['redis']
    ],
    'CirrusSearch-Completion' => [
        'class' => 'PoolCounterRedis',
        'timeout' => 15,
        'workers' => 108,
        'maxqueue' => 150,
        'servers' => ['redis']
    ],
    'CirrusSearch-Regex' => [
        'class' => 'PoolCounterRedis',
        'timeout' => 60,
        'workers' => 2,
        'maxqueue' => 5,
        'servers' => ['redis']
    ],
    'CirrusSearch-NamespaceLookup' => [
        'class' => 'PoolCounterRedis',
        'timeout' => 5,
        'workers' => 12,
        'maxqueue' => 50,
        'servers' => ['redis']
    ],
    'CirrusSearch-MoreLike' => [
        'class' => 'PoolCounterRedis',
        'timeout' => 5,
        'workers' => 12,
        'maxqueue' => 50,
        'servers' => ['redis']
    ]
];

# Thanks Extension
wfLoadExtension( 'Thanks' );

# AWS Extension
$wgFileBackends['s3'] = [ // backend config for wiki's local repo
    'class'              => 'AmazonS3FileBackend',
    'name'               => 'AmazonS3',
    'wikiId'             => 'wiki',
    'lockManager'        => 'redisLockManager',
    'containerPaths'     => [
        'wiki-local-public'  => 'media.52poke.com/wiki',
        'wiki-local-thumb'   => 'media.52poke.com/wiki/thumb',
        'wiki-local-temp'    => 'media.52poke.com/wiki/temp',
        'wiki-local-deleted' => 'media.52poke.com/wiki/deleted',
    ]
];

$wgLocalFileRepo = [
    'class'              => 'LocalRepo',
    'name'               => 'local',
    'backend'            => 'AmazonS3',
    'scriptDirUrl'       => $wgScriptPath,
    'url'                => wfScript( 'img_auth' ),
    'hashLevels'         => 2,
    'deletedHashLevels'  => 3,
    'zones'             =>  [
        'public'  => [ 'url' => '//media.52poke.com/wiki' ],
        'thumb'   => [ 'url' => '//media.52poke.com/wiki/thumb' ],
        'temp'    => [ 'url' => false ],
        'deleted' => [ 'url' => false ]
    ],
    'transformVia404' => true
];

$wgGenerateThumbnailOnParse = false;
$wgUploadPath = "//media.52poke.com/wiki";
$wgAllowCopyUploads = true;
$wgCopyUploadsFromSpecialUpload = true;
$wgCopyUploadsDomains = array();

wfLoadExtension( 'AWS' );
$wgAWSCredentials = [
	'key'    => file_get_contents("/run/secrets/aws-s3-ak"),
	'secret' => file_get_contents("/run/secrets/aws-s3-sk"),
	'token'  => false
];
$wgAWSRegion = 'ap-northeast-1';

# EventBus Extension
wfLoadExtension( 'EventBus' );
$wgEnableEventBus = 'TYPE_ALL';
$wgEventServices = [
    'eventbus' => [ 'url' => 'http://logstash:5001', 'timeout' => 10 ],
];
$wgEventRelayerConfig = [
    'default' => [
        'class' => EventRelayerKafka::class,
        'KafkaEventHost' => 'kafka:9092'
    ]
];
$wgUpdateRowsPerJob = 5;
$wgMaxSquidPurgeTitles = 5;
$wgJobRunRate = 0;
$wgJobTypeConf['default'] = [ 'class' => 'JobQueueEventBus', 'readOnlyReason' => false ];
$wgMiserMode = true;

# ImageMap Extension
wfLoadExtension( 'ImageMap' );