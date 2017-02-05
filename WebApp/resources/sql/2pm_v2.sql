CREATE TABLE `item_category` (
  `item_category_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_category_name` varchar(200) NOT NULL,
  `item_category_type` varchar(200) DEFAULT NULL,
  `item_cat_type_formatted` varchar(200) DEFAULT NULL,
  `disable_tax` char(1) DEFAULT NULL,
  `is_active` char(1) NOT NULL DEFAULT '1',
  `created_by` int(11) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COMMENT='';

CREATE TABLE `expense_item_master` (
  `expense_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `expense_item_name` varchar(45) NOT NULL,
  `item_category_id` int(11) NOT NULL,
  `is_active` char(1) NOT NULL DEFAULT '1',
  `created_by` int(11) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`expense_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `vendor_master` (
  `vendor_id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_name` varchar(250) NOT NULL,
  `contact_no` varchar(45) NOT NULL,
  `address` varchar(2000) DEFAULT NULL,
  `is_active` char(1) NOT NULL DEFAULT '1',
  `created_by` int(11) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`vendor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `expenses` (
  `expense_id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_id` int(11) NOT NULL,
  `expense_item_id` int(11) NOT NULL,
  `expense_qty` int(11) NOT NULL,
  `expense_amount` double NOT NULL,
  `expense_remark` varchar(45) DEFAULT NULL,
  `expense_vat` float DEFAULT NULL,
  `is_active` char(1) NOT NULL DEFAULT '1',
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int(11) NOT NULL,
  PRIMARY KEY (`expense_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

CREATE TABLE `invoice_master` (
  `invoice_id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_id` int(11) NOT NULL,
  `comments` varchar(1000) DEFAULT NULL,
  `expense_exist` char(1) NOT NULL DEFAULT '1',
  `amount` double NOT NULL DEFAULT '0',
  `is_active` char(1) NOT NULL DEFAULT '1',
  `created_by` int(11) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`invoice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;


CREATE TABLE `invoice_expense_map` (
  `invoice_expense_map_id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` int(11) NOT NULL,
  `expense_id` int(11) NOT NULL,
  `amount` double NOT NULL,
  `is_active` char(1) NOT NULL DEFAULT '1',
  `created_by` int(11) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`invoice_expense_map_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

CREATE TABLE `delivery_person_master` (
  `delivery_person_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(250) NOT NULL,
  `last_name` varchar(250) NOT NULL,
  `middle_name` varchar(250) DEFAULT NULL,
  `email_address` varchar(250) DEFAULT NULL,
  `mobile_number` varchar(11) NOT NULL,
  `address` varchar(2000) DEFAULT NULL,
  `is_active` char(1) NOT NULL DEFAULT '1',
  `created_by` int(11) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`delivery_person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `delivery_tracker` (
  `delivery_tracker_id` int(11) NOT NULL AUTO_INCREMENT,
  `delivery_person_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `is_active` char(1) NOT NULL DEFAULT '1',
  `created_by` int(11) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`delivery_tracker_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO `two_pm`.`status_master` (`status_code`, `status_name`, `is_active`, `created_by`) VALUES ('INDELIVERY', 'In Delivery', '1', '1');
INSERT INTO `two_pm`.`status_master` (`status_code`, `status_name`, `is_active`, `created_by`) VALUES ('DELIVERED', 'Delivered', '1', '1');

ALTER TABLE `two_pm`.`delivery_tracker` 
ADD COLUMN `order_id` INT(11) NOT NULL AFTER `delivery_tracker_id`;

