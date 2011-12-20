CREATE DATABASE  IF NOT EXISTS `yam_development` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `yam_development`;

DROP TABLE IF EXISTS `yam_development`.`schema_migrations`;
CREATE TABLE  `yam_development`.`schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `yam_development`.`yfiles`;
CREATE TABLE  `yam_development`.`yfiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `yamid` int(11) NOT NULL,
  `fileid` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `ftype` varchar(16) DEFAULT NULL,
  `web_url` varchar(1024) DEFAULT NULL,
  `file_size` int(11) DEFAULT '0',
  `file_url` varchar(1024) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `yam_development`.`yimgs`;
CREATE TABLE  `yam_development`.`yimgs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `yamid` int(11) NOT NULL,
  `imgid` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `ftype` varchar(16) DEFAULT NULL,
  `web_url` varchar(1024) DEFAULT NULL,
  `image_size` int(11) DEFAULT '0',
  `image_url` varchar(1024) DEFAULT NULL,
  `image_thumbnail_url` varchar(1024) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `yam_development`.`ylikes`;
CREATE TABLE  `yam_development`.`ylikes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `yamid` int(11) NOT NULL,
  `permalink` varchar(128) NOT NULL,
  `full_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `yam_development`.`ymessages`;
CREATE TABLE  `yam_development`.`ymessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `yamid` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `replied_to_id` int(11) DEFAULT NULL,
  `thread_id` int(11) DEFAULT NULL,
  `message_type` varchar(45) DEFAULT NULL,
  `sender_type` varchar(45) DEFAULT NULL,
  `client_type` varchar(45) DEFAULT NULL,
  `url` varchar(1024) DEFAULT NULL,
  `web_url` varchar(1024) DEFAULT NULL,
  `body_parsed` text,
  `body_plain` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `yamid_ndx` (`yamid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `yam_development`.`ymodules`;
CREATE TABLE  `yam_development`.`ymodules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ymod_id` bigint(20) NOT NULL,
  `yam_id` int(11) NOT NULL,
  `thread_id` int(11) NOT NULL,
  `name` text,
  `web_url` varchar(1024) DEFAULT NULL,
  `inline_url` varchar(1024) DEFAULT NULL,
  `inline_html` text,
  `icon_url` varchar(1024) DEFAULT NULL,
  `app_id` varchar(16) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ymod_id_ndx` (`ymod_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `yam_development`.`yusers`;
CREATE TABLE  `yam_development`.`yusers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `yamid` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `full_name` varchar(128) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `network_id` int(11) NOT NULL,
  `network_name` varchar(64) NOT NULL,
  `location` varchar(128) DEFAULT NULL,
  `job_title` varchar(128) DEFAULT NULL,
  `state` varchar(45) NOT NULL,
  `stats_followers` int(11) DEFAULT NULL,
  `stats_updates` int(11) DEFAULT NULL,
  `stats_following` int(11) DEFAULT NULL,
  `expertise` text,
  `url` varchar(1024) DEFAULT NULL,
  `web_url` varchar(1024) DEFAULT NULL,
  `mugshot_url` varchar(1024) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `yamid_ndx` (`yamid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
