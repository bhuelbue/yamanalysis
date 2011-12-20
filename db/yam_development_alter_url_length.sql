USE `yam_development`;

ALTER TABLE `yam_development`.`yfiles` CHANGE COLUMN `web_url` `web_url` VARCHAR(1024) NULL DEFAULT NULL  , CHANGE COLUMN `file_url` `file_url` VARCHAR(1024) NULL DEFAULT NULL  ;
ALTER TABLE `yam_development`.`yimgs` CHANGE COLUMN `web_url` `web_url` VARCHAR(1024) NULL DEFAULT NULL  , CHANGE COLUMN `image_url` `image_url` VARCHAR(1024) NULL DEFAULT NULL  , CHANGE COLUMN `image_thumbnail_url` `image_thumbnail_url` VARCHAR(1024) NULL DEFAULT NULL  ;
ALTER TABLE `yam_development`.`ymessages` CHANGE COLUMN `url` `url` VARCHAR(1024) NULL DEFAULT NULL  , CHANGE COLUMN `web_url` `web_url` VARCHAR(1024) NULL DEFAULT NULL  ;
ALTER TABLE `yam_development`.`ymodules` CHANGE COLUMN `web_url` `web_url` VARCHAR(1024) NULL DEFAULT NULL  , CHANGE COLUMN `inline_url` `inline_url` VARCHAR(1024) NULL DEFAULT NULL  , CHANGE COLUMN `icon_url` `icon_url` VARCHAR(1024) NULL DEFAULT NULL  ;
ALTER TABLE `yam_development`.`yusers` CHANGE COLUMN `url` `url` VARCHAR(1024) NULL DEFAULT NULL  , CHANGE COLUMN `web_url` `web_url` VARCHAR(1024) NULL DEFAULT NULL  , CHANGE COLUMN `mugshot_url` `mugshot_url` VARCHAR(1024) NULL DEFAULT NULL  ;

