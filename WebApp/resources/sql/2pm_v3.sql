INSERT INTO `two_pm`.`user_menu_master` (`menu_description`, `created_by`) VALUES ('Dashboard', '1');

INSERT INTO `two_pm`.`user_menu_master` (`menu_description`, `created_by`) VALUES ('Delivery', '1');

INSERT INTO `two_pm`.`role_menu_map` (`role_id`, `menu_id`, `created_by`) VALUES ('1', '7', '1');

INSERT INTO `two_pm`.`role_menu_map` (`role_id`, `menu_id`, `created_by`) VALUES ('1', '8', '1');

INSERT INTO `two_pm`.`role_master` (`role_id`, `role_description`, `created_by`) VALUES ('3', 'Delivery Boy', '1');

INSERT INTO `two_pm`.`user_master` (`first_name`, `last_name`, `email`, `user_name`, `password`, `is_active`, `role_id`) VALUES ('pankaj', 'patil', 'pankaj@gmail.com', 'pankaj', 'pankaj', '1', '3');

INSERT INTO `two_pm`.`role_menu_map` (`role_id`, `menu_id`, `created_by`) VALUES ('3', '7', '1');
INSERT INTO `two_pm`.`role_menu_map` (`role_id`, `menu_id`, `created_by`) VALUES ('3', '8', '1');


