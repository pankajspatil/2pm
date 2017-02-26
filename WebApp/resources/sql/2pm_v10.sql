ALTER TABLE `two_pm`.`sub_menu_master` 
ADD COLUMN `is_cookable` CHAR(1) NOT NULL DEFAULT 0 AFTER `ac_unit_price`;

ALTER TABLE `two_pm`.`sub_menu_master` 
CHANGE COLUMN `is_cookable` `is_cookable` CHAR(1) NOT NULL DEFAULT '1' ;


CREATE TABLE `two_pm`.`config` (
  `key_no` INT NOT NULL AUTO_INCREMENT,
  `key_code` VARCHAR(45) NULL,
  `key_name` VARCHAR(45) NULL,
  `key_value` VARCHAR(45) NULL,
  PRIMARY KEY (`key_no`));

  
  INSERT INTO `two_pm`.`config` (`key_code`, `key_name`, `key_value`) VALUES ('COOKABLE', '', 'TRUE');
