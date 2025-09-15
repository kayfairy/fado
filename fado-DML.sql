-- Adminer 5.3.0 MariaDB 10.11.13-MariaDB-deb12 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP DATABASE IF EXISTS `fado`;
CREATE DATABASE `fado` /*!40100 DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci */;
USE `fado`;

DROP TABLE IF EXISTS `fado_cache`;
CREATE TABLE `fado_cache` (
  `session` varchar(64) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `value` varchar(9999) NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_cache` (`session`, `name`, `value`) VALUES
('',	'logintrycnt',	'0'),
('',	'message',	''),
('42b26232d640046c2fcc4c25b577af9a3c8bfc3355c2d7155df0420445e1996f',	'logintrycnt',	'1'),
('42b26232d640046c2fcc4c25b577af9a3c8bfc3355c2d7155df0420445e1996f',	'message',	'INVALID_AUTH'),
('f103350b677aeb2f6d23f30c2f4004d8ba156dcdb7a2be711e6e0c489f701896',	'logintrycnt',	'0'),
('f103350b677aeb2f6d23f30c2f4004d8ba156dcdb7a2be711e6e0c489f701896',	'message',	''),
('f103350b677aeb2f6d23f30c2f4004d8ba156dcdb7a2be711e6e0c489f701896',	'p',	'1'),
('f103350b677aeb2f6d23f30c2f4004d8ba156dcdb7a2be711e6e0c489f701896',	'formStatus',	''),
('f103350b677aeb2f6d23f30c2f4004d8ba156dcdb7a2be711e6e0c489f701896',	'openNewShopForm',	'0'),
('f103350b677aeb2f6d23f30c2f4004d8ba156dcdb7a2be711e6e0c489f701896',	'newFormData',	''),
('f103350b677aeb2f6d23f30c2f4004d8ba156dcdb7a2be711e6e0c489f701896',	'newFormData2',	''),
('f103350b677aeb2f6d23f30c2f4004d8ba156dcdb7a2be711e6e0c489f701896',	'activeTab',	'SHOP_TAB_MAP');

DROP TABLE IF EXISTS `fado_currency`;
CREATE TABLE `fado_currency` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `currency` varchar(256) DEFAULT NULL,
  `ISO4217` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_currency` (`id`, `name`, `currency`, `ISO4217`) VALUES
(1,     'Euro', '€',    'EUR'),
(2,     'Dollar',       '$',    'USD'),
(3,     'Pound',        '£',    'GBP'),
(4,     'Lira', '₺',    'ITL'),
(5,     'Ruble',        '₽',    'RUB'),
(6,     'Yen',  '¥',    'JPY'),
(7,     'Peso', '₱',    'PHP'),
(8,     'Dong', '₫',    'VND'),
(9,     'Hryvnia',      '₴',    'UAH'),
(10,    'Franc',        '₣',    'CHF'),
(11,    'Rial', '﷼',    'YER'),
(12,    'Sol',  'S/.',  'PEN'),
(13,    'Shekel',       '₪',    'ILS'),
(14,    'Cedi', '¢',    'GHS');

DROP TABLE IF EXISTS `fado_invoices`;
CREATE TABLE `fado_invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_id_seller` int(11) DEFAULT NULL,
  `shop_id_customer` int(11) DEFAULT NULL,
  `is_payed` int(11) DEFAULT NULL,
  `zone_time` varchar(6) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `changed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `shop_id_seller` (`shop_id_seller`),
  KEY `shop_id_customer` (`shop_id_customer`),
  CONSTRAINT `fado_invoices_ibfk_1` FOREIGN KEY (`shop_id_seller`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fado_invoices_ibfk_2` FOREIGN KEY (`shop_id_customer`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_invoices` (`id`, `shop_id_seller`, `shop_id_customer`, `is_payed`, `zone_time`, `created`, `changed`) VALUES
(100,	2,	5,	1,	'+00:00',	'2018-08-01 22:52:47',	'2020-07-09 23:21:02'),
(103,	2,	1,	1,	'+00:00',	'2018-08-02 12:18:15',	'2019-12-10 12:29:05'),
(107,	1,	3,	1,	'+00:00',	'2018-08-02 13:11:01',	'2020-07-09 23:20:52'),
(108,	2,	4,	1,	'+00:00',	'2018-08-02 14:39:01',	'2020-07-09 23:20:20');

DROP TABLE IF EXISTS `fado_invoices2items`;
CREATE TABLE `fado_invoices2items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `fado_invoices2items_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `fado_invoices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fado_invoices2items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `fado_warehouse_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_invoices2items` (`id`, `invoice_id`, `item_id`, `amount`) VALUES
(1,	100,	1,	1),
(2,	100,	6,	4),
(3,	103,	2,	4),
(4,	103,	6,	3),
(5,	100,	4,	3),
(6,	100,	6,	4),
(7,	100,	1,	1),
(8,	100,	2,	2),
(9,	103,	4,	3),
(10,	108,	1,	1),
(11,	108,	2,	6),
(12,	108,	3,	2),
(13,	107,	4,	1),
(48,	108,	5,	2),
(49,	107,	6,	1),
(50,	107,	3,	2),
(51,	107,	6,	3),
(52,	107,	7,	6),
(53,	108,	7,	1),
(59,	108,	7,	1);

DROP TABLE IF EXISTS `fado_meetings`;
CREATE TABLE `fado_meetings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `meeting` varchar(2048) DEFAULT NULL,
  `changed` datetime DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fado_meetings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `fado_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_meetings` (`id`, `user_id`, `title`, `description`, `meeting`, `changed`, `created`) VALUES
(34,	1,	'meeting1',	'New meeting',	'{\"day\": \"2025-07-15\", \"stop\": \"05:17\", \"range\": \"\", \"start\": \"18:45\", \"period\": \"0\"}',	'2017-05-26 00:00:00',	'2020-02-02 12:39:04'),
(35,	1,	'S',	'K',	'{\"day\":\"\",\"range\":\"1-2\",\"start\":\"16:39\",\"stop\":\"\",\"period\":\"3096\"}',	'2025-01-01 12:00:00',	'2025-04-01 07:57:24'),
(36,	1,	'Ke',	'Jeue',	'{\"day\":\"\",\"range\":\"0-5\",\"start\":\"17:30\",\"stop\":\"\",\"period\":\"0\"}',	'2025-01-01 12:00:00',	'2025-04-03 17:11:41'),
(37,	1,	'Dj',	'Jeu',	'{\"day\":\"2042-04-21\",\"range\":\"\",\"start\":\"00:27\",\"stop\":\"07:46\",\"period\":\"0\"}',	'2025-01-01 12:00:00',	'2025-04-03 17:12:11'),
(39,	1,	'tt',	'77',	'{\"day\":\"\",\"range\":\"1-4\",\"start\":\"15:15\",\"stop\":\"\",\"period\":\"911\"}',	'2025-01-01 12:00:00',	'2025-05-18 11:27:01'),
(40,	1,	'shhs',	'ehhs',	'{\"day\":\"2098-04-24\",\"range\":\"\",\"start\":\"13:25\",\"stop\":\"21:38\",\"period\":\"0\"}',	'2025-01-01 12:00:00',	'2025-05-18 11:27:21'),
(41,	1,	'fghdghdz7575',	'6r4645635',	'{\"day\":\"2033-10-22\",\"range\":\"\",\"start\":\"12:43\",\"stop\":\"\",\"period\":\"457\"}',	'2025-01-01 12:00:00',	'2025-05-18 21:00:33'),
(42,	1,	'66666666666',	'inferno',	'{\"day\":\"\",\"range\":\"0-1\",\"start\":\"15:47\",\"stop\":\"20:47\",\"period\":\"0\"}',	'2025-01-01 12:00:00',	'2025-05-18 21:01:27');

DROP TABLE IF EXISTS `fado_settings`;
CREATE TABLE `fado_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `value` varchar(256) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `changed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

INSERT INTO `fado_settings` (`id`, `name`, `value`, `changed`, `created`) VALUES
(1,	'encoding',	'UTF-8',	NULL,	'2023-05-07 12:40:28'),
(2,	'lang_available',	'[\"en_GB\",\"de_DE\",\"tr_TR\",\"es_ES\",\"nl_NL\"]',	NULL,	'2023-05-07 12:40:28'),
(3,	'date_time_format_available',	'{\"lang\":\"%c\",\"en_GB\":\"%Y/%m/%d %H:%M:%S\",\"en_US\":\"%d-%m-%Y %H:%M:%S\",\"UTC\":\"%x %H:%M:%S\",\"UTC2\":\"%a, %d. %b %Y %H:%M:%S\",\"UTC3\":\"%A %d. %B %Y %H:%M:%S\",\"de_DE\":\"%d.%m.%Y %H:%M:%S\"}',	NULL,	'2023-05-07 12:40:28'),
(4,	'cookiename',	'FADO',	NULL,	'2023-05-07 12:40:28'),
(5,	'cookielife_hours',	'8',	NULL,	'2023-05-07 12:40:28'),
(6,	'error_reporting_available',	'[\"0\",\"E_ALL\",\"E_ALL & ~E_NOTICE\"]',	NULL,	'2023-05-07 12:40:28'),
(7,	'error_log',	'1',	NULL,	'2023-05-07 12:40:28'),
(8,	'error_reporting',	'E_ALL',	NULL,	'2023-05-07 12:40:28'),
(9,	'memcache_on',	'0',	NULL,	'2023-05-07 12:40:28'),
(10,	'memcache_host',	'127.0.0.1',	NULL,	'2023-05-07 12:40:28'),
(11,	'memcache_port',	'11211',	NULL,	'2023-05-07 12:40:28'),
(12,	'memcache_life_seconds',	'36000',	NULL,	'2023-05-07 12:40:28'),
(13,	'memcache_compressed',	'0',	NULL,	'2023-05-07 12:40:28'),
(14,	'invoice_mode_available',	'[\"brutto\",\"netto\"]',	NULL,	'2023-05-07 12:40:28'),
(15,	'map_tile_url',	'{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',	NULL,	'2023-05-07 12:40:28'),
(16,	'map_route_url',	'router.project-osrm.org/route/v1',	NULL,	'2023-05-07 12:40:28'),
(17,	'rewrite_route',	'0',	NULL,	'2023-05-07 12:40:28'),
(18,	'date_format_available',	'{\"en_GB\":\"%Y/%m/%d\",\"en_US\":\"%d-%m-%Y\",\"UTC\":\"%x\",\"UTC2\":\"%a, %d. %b %Y\",\"UTC3\":\"%A %d. %B %Y\",\"de_DE\":\"%d.%m.%Y\"}',	NULL,	'2023-05-07 12:40:28'),
(19,	'maximum_login_attempts',	'5',	NULL,	'2023-05-07 12:40:28');

DROP TABLE IF EXISTS `fado_shops`;
CREATE TABLE `fado_shops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(256) DEFAULT NULL,
  `city` varchar(256) DEFAULT NULL,
  `zip` varchar(256) DEFAULT NULL,
  `street` varchar(256) DEFAULT NULL,
  `streetnr` varchar(256) DEFAULT NULL,
  `country` varchar(256) DEFAULT NULL,
  `phone` varchar(256) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `information` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `opening_hours` longtext DEFAULT NULL,
  `established` date DEFAULT '0000-00-00',
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `changed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_shops` (`id`, `description`, `city`, `zip`, `street`, `streetnr`, `country`, `phone`, `email`, `information`, `opening_hours`, `established`, `created`, `changed`) VALUES
(1,	'My Shop',	'My Town',	'4523556',	'In Dark Forest',	'664456',	'Norway',	'00175553021114',	'fairy13@calendar.com',	'\"<p style=\\\"text-align:center\\\"><span style=\\\"color:#27ae60\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado<\\/strong><\\/span><\\/em><\\/span><\\/span><sub>&reg;<\\/sub><\\/p>\\r\\n\\r\\n<ol>\\r\\n\\t<li><span style=\\\"color:#e74c3c\\\">Point<\\/span><\\/li>\\r\\n\\t<li><span style=\\\"color:#1abc9c\\\">Comma<\\/span><\\/li>\\r\\n\\t<li><span style=\\\"background-color:#1abc9c\\\">Semicolon<\\/span><\\/li>\\r\\n<\\/ol>\\r\\n\"',	'{\"1\":{\"range\":\"0-2\",\"open\":\"20:42\",\"close\":\"18:32\"},\"2\":{\"range\":\"4-5\",\"open\":\"16:44\",\"close\":\"20:00\"}}',	'1958-09-22',	'2019-03-24 19:08:56',	'2025-06-25 12:47:42'),
(2,	'Tile Shop',	'Tilefarm',	'12356745',	'Horse Rd.',	'166',	'Spain',	'00173247858484',	'shop@tilefarm.com',	'\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado</strong></span></em></span><sub>&reg;</sub></p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point</li>\\r\\n\\t<li>Comma</li>\\r\\n\\t<li>Semicolon</li>\\r\\n</ol>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\"',	'{\"1\": {\"open\": \"13:00\", \"close\": \"09:00\", \"range\": \"0-2\"}, \"2\": {\"open\": \"18:00\", \"close\": \"10:00\", \"range\": \"3-5\"}}',	'1960-09-20',	'2019-03-24 19:08:56',	'2020-01-10 10:22:24'),
(3,	'Inferno',	'St. Micheal',	'3213556',	'Firebrick Rd.',	'67',	'Big Apple',	'004492465461',	'press@enter.com',	'\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado<\\/strong><\\/span><\\/em><\\/span><sub>&reg;<\\/sub><\\/p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point<\\/li>\\r\\n\\t<li>Comma<\\/li>\\r\\n\\t<li>Semicolon<\\/li>\\r\\n<\\/ol>\\r\\n\\r\\n<p>&nbsp;<\\/p>\\r\\n\\r\\n<p>&nbsp;<\\/p>\\r\\n\"',	'{\"1\":{\"range\":\"0-2\",\"open\":\"08:42\",\"close\":\"11:00\"}}',	'1996-10-23',	'2019-03-24 19:08:56',	'2020-03-05 16:21:31'),
(4,	'Test',	'Error City',	'65566MV',	'Malfunction Rd.',	'55',	'Big Apple',	'004492465461',	'errortest@local.com',	'\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado</strong></span></em></span><sub>&reg;</sub></p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point</li>\\r\\n\\t<li>Comma</li>\\r\\n\\t<li>Semicolon</li>\\r\\n</ol>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\"',	'{\"1\": {\"open\": \"20:45\", \"close\": \"09:30\", \"range\": \"0-3\"}, \"2\": {\"open\": \"20:00\", \"close\": \"09:00\", \"range\": \"5-5\"}}',	'1991-11-18',	'2019-03-24 19:08:56',	'2020-02-02 10:03:54'),
(5,	'Tree Market',	'Earth',	'345667',	'Wood Rd.',	'493',	'Universe',	'0017234204443584',	'tree@dimension.com',	'\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado</strong></span></em></span><sub>&reg;</sub></p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point</li>\\r\\n\\t<li>Comma</li>\\r\\n\\t<li>Semicolon</li>\\r\\n</ol>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\"',	'{\"1\": {\"open\": \"05:30\", \"close\": \"00:45\", \"range\": \"0-2\"}, \"2\": {\"open\": \"04:02\", \"close\": \"15:30\", \"range\": \"2-5\"}, \"3\": {\"open\": \"05:30\", \"close\": \"00:45\", \"range\": \"0-4\"}}',	'1990-10-24',	'2019-03-24 19:08:56',	'2020-01-11 17:24:50'),
(6,	'Uncle\'s Shop',	'Santa Maria',	'012356',	'Saintsstreet',	'54',	'Spain',	'005456512693548',	'uncle@myshop.com',	'\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado</strong></span></em></span><sub>&reg;</sub></p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point</li>\\r\\n\\t<li>Comma</li>\\r\\n\\t<li>Semicolon</li>\\r\\n</ol>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\"',	'{\"1\": {\"open\": \"20:44\", \"close\": \"09:39\", \"range\": \"0-4\"}, \"2\": {\"open\": \"12:00\", \"close\": \"21:00\", \"range\": \"5-5\"}, \"3\": {\"open\": \"20:00\", \"close\": \"11:00\", \"range\": \"6-6\"}}',	'1986-02-20',	'2019-03-24 19:08:56',	'2020-01-10 10:23:54'),
(7,	'Timeoffice Clerk',	'Roundvillage',	'1697',	'Star Rd.',	'13',	'New Mexiko',	'00563655894',	'contact@timeofficeclerk.co.uk',	'\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado</strong></span></em></span><sub>&reg;</sub></p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point</li>\\r\\n\\t<li>Comma</li>\\r\\n\\t<li>Semicolon</li>\\r\\n</ol>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\"',	'{\"1\": {\"open\": \"06:30\", \"close\": \"16:00\", \"range\": \"0-0\"}}',	'1986-06-16',	'2019-03-24 19:08:56',	'2020-01-10 10:23:15');

DROP TABLE IF EXISTS `fado_shops2location`;
CREATE TABLE `fado_shops2location` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) DEFAULT NULL,
  `lat` double DEFAULT NULL,
  `lng` double DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `changed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `fado_shops2location_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_shops2location` (`id`, `shop_id`, `lat`, `lng`, `created`, `changed`) VALUES
(1,	1,	50.965346321638,	7.1356201171875,	'2020-06-16 11:29:25',	'2019-03-24 19:08:57'),
(2,	2,	50.942507741387,	6.9680786132813,	'2020-07-09 20:58:01',	'2019-03-24 19:08:57'),
(3,	3,	50.958887949343,	6.7950439453125,	'2017-01-01 23:59:59',	'2019-03-24 19:08:57'),
(4,	4,	48.110365502684,	11.62353515625,	'2020-07-09 20:58:21',	'2019-03-24 19:08:57'),
(5,	5,	52.370233363524,	14.1064453125,	'2020-07-09 20:58:36',	'2019-03-24 19:08:57'),
(6,	6,	50.147338400845,	8.756103515625,	'2020-07-09 20:58:56',	'2019-03-24 19:08:57'),
(7,	7,	53.550915205894,	10.038757324219,	'2020-07-09 20:59:23',	'2019-03-24 19:08:57');

DROP TABLE IF EXISTS `fado_shops2user`;
CREATE TABLE `fado_shops2user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shop_id` (`shop_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fado_shops2user_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fado_shops2user_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `fado_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_shops2user` (`id`, `shop_id`, `user_id`) VALUES
(5,	1,	1),
(12,	1,	1),
(14,	1,	1);

DROP TABLE IF EXISTS `fado_shops2vehicles`;
CREATE TABLE `fado_shops2vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle_id` int(11) DEFAULT NULL,
  `shop_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vehicle_id` (`vehicle_id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `fado_shops2vehicles_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `fado_vehicles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fado_shops2vehicles_ibfk_2` FOREIGN KEY (`shop_id`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_shops2vehicles` (`id`, `vehicle_id`, `shop_id`) VALUES
(1,	1,	1),
(2,	2,	1),
(3,	3,	1),
(5,	5,	2),
(7,	4,	3);

DROP TABLE IF EXISTS `fado_user`;
CREATE TABLE `fado_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active` int(11) DEFAULT NULL,
  `online` int(11) DEFAULT NULL,
  `name` varchar(256) DEFAULT NULL,
  `pwd` varchar(256) DEFAULT NULL,
  `salt` varchar(256) DEFAULT NULL,
  `session` varchar(256) DEFAULT NULL,
  `phone` varchar(256) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `data` varchar(2048) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `changed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  `last_login` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

(6, 1, 0, 'admin', 
'1dcf823fa422dcd13a55ee34a8a697204a3cd0ee51342f457cbfb3b9818beade', 
'b1eb2b6481fa3ec2f2220a4b2c5ea683e8fffdaa3ceca1c481313eb7143e4910', 
'', '', 'admin@fado.com', '\"<p><span 
style=\\\"color:#c0392b\\\"><em>Administrator&nbsp;<\\/em><\\/span><\\/p>\\r\\n\"', 
'1971-05-23', '2019-12-10 11:45:49', '2025-06-25 02:28:40', 
'2025-06-24 22:37:08');

INSERT INTO `fado_user` (`id`, `active`, `online`, `name`, `pwd`, `salt`, `session`, `phone`, `email`, `data`, `birthday`, `created`, `changed`, `last_login`) VALUES
(1,	1,	1,	'fado',	'c97d276995ea76933457f0dcb166d9ac19617dd935a09a17e6902c359ca14bdb',	'228961714662627273737737337372948738211738',	'f103350b677aeb2f6d23f30c2f4004d8ba156dcdb7a2be711e6e0c489f701896',	'0049111222333',	'fado@fado.com',	'\"<p><span style=\\\"color:#3498db\\\"><em>Superadmin<\\/em><\\/span><\\/p>\\r\\n\"',	'2043-01-22',	'2019-08-09 12:37:03',	'2025-09-15 03:09:12',	'2025-09-15 03:09:12'),
(6,	1,	0,	'admin',	'1dcf823fa422dcd13a55ee34a8a697204a3cd0ee51342f457cbfb3b9818beade',	'b1eb2b6481fa3ec2f2220a4b2c5ea683e8fffdaa3ceca1c481313eb7143e4910',	'',	'',	'admin@fado.com',	'\"<p><span style=\\\"color:#c0392b\\\"><em>Administrator&nbsp;<\\/em><\\/span><\\/p>\\r\\n\"',	'1971-05-23',	'2019-12-10 11:45:49',	'2025-06-25 02:28:40',	'2025-06-24 22:37:08');
-- 2025-09-15 01:09:43 UTC

DROP TABLE IF EXISTS `fado_user_ip`;
CREATE TABLE `fado_user_ip` (
  `user_id` int(11) DEFAULT NULL,
  `ip` varchar(256) DEFAULT NULL,
  `login_time` datetime DEFAULT '0000-00-00 00:00:00',
  `tries` int(11) NOT NULL DEFAULT 0,
  KEY `user_id` (`user_id`),
  CONSTRAINT `fado_user_ip_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `fado_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_uca1400_ai_ci;

INSERT INTO `fado_user_ip` (`user_id`, `ip`, `login_time`, `tries`) VALUES
(1,	'192.168.216.232',	'2025-03-31 17:34:25',	0),
(1,	'192.168.216.226',	'2025-03-31 23:01:39',	0),
(1,	'192.168.150.226',	'2025-04-01 06:59:53',	0),
(1,	'192.168.150.226',	'2025-04-01 16:15:23',	0),
(1,	'::1',	'2025-04-01 22:26:50',	0),
(1,	'127.0.0.1',	'2025-04-02 02:07:27',	0),
(1,	'192.168.150.226',	'2025-04-02 14:40:51',	0),
(1,	'172.77.77.2',	'2025-04-02 22:13:27',	0),
(1,	'192.168.150.226',	'2025-04-03 07:51:45',	0),
(1,	'172.77.77.2',	'2025-04-03 08:23:09',	0),
(1,	'192.168.150.226',	'2025-04-03 09:28:06',	0),
(1,	'127.0.0.1',	'2025-06-24 22:17:19',	0),
(1,	'127.0.0.1',	'2025-06-24 22:29:28',	0),
(1,	'127.0.0.1',	'2025-06-24 22:29:37',	0),
(1,	'127.0.0.1',	'2025-06-24 22:30:12',	0),
(1,	'127.0.0.1',	'2025-06-24 22:32:37',	0),
(1,	'192.168.164.156',	'2025-06-24 22:36:17',	0),
(1,	'192.168.164.156',	'2025-06-24 22:36:27',	0),
(6,	'192.168.164.156',	'2025-06-24 22:37:08',	0),
(1,	'192.168.164.156',	'2025-06-24 23:08:34',	0),
(1,	'192.168.164.59',	'2025-06-24 23:09:29',	0),
(1,	'192.168.164.156',	'2025-06-24 23:18:57',	0),
(1,	'127.0.0.1',	'2025-07-30 16:38:55',	0);

DROP TABLE IF EXISTS `fado_user_rights`;
CREATE TABLE `fado_user_rights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `rights` varchar(2048) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `changed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fado_user_rights_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `fado_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_user_rights` (`id`, `user_id`, `rights`, `changed`, `created`) VALUES
(1,	1,	'{\"sh\":\"2\",\"ve\":\"2\",\"wa\":\"2\",\"in\":\"2\",\"ne\":\"2\",\"na\":\"1\",\"us\":\"2\",\"ut\":\"2\",\"at\":\"2\",\"st\":\"1\",\"ri\":\"0\",\"sq\":\"2\",\"me\":\"2\",\"aj\":\"2\",\"if\":\"1\",\"ur\":\"2\"}',	'2025-06-25 03:08:43',	'2019-08-09 10:39:48'),
(6,	6,	'{\"sh\":\"2\",\"ve\":\"2\",\"wa\":\"2\",\"in\":\"2\",\"ne\":\"2\",\"na\":\"1\",\"us\":\"2\",\"ut\":\"2\",\"at\":\"2\",\"st\":\"1\",\"ri\":\"0\",\"sq\":\"2\",\"me\":\"2\",\"aj\":\"2\",\"if\":\"1\",\"ur\":\"2\"}',	'2025-05-23 17:46:53',	'2019-12-10 10:45:50');

DROP TABLE IF EXISTS `fado_user_settings`;
CREATE TABLE `fado_user_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(256) DEFAULT NULL,
  `value` varchar(256) DEFAULT NULL,
  `changed` datetime DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fado_user_settings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `fado_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

INSERT INTO `fado_user_settings` (`id`, `user_id`, `name`, `value`, `changed`, `created`) VALUES
(1,	1,	'lang',	'tr_TR',	'2025-06-25 05:21:53',	'2025-06-25 05:21:53'),
(2,	1,	'timezone',	'Europe/Ulyanovsk',	'2025-06-25 05:21:53',	'2025-06-25 05:21:53'),
(3,	1,	'number_format',	'[\"2\",\".\",\"\\u00a0,\"]',	'2025-06-25 05:21:53',	'2025-06-25 05:21:53'),
(4,	1,	'date_time_format',	'%Y/%m/%d %H:%M:%S',	'2025-07-30 16:41:11',	'2025-06-25 12:52:43'),
(5,	1,	'item_amount_units',	'[\"100g\",\"50g\",\"100ml\",\"1m\\u00b3\",\"1m\\u00b2\",\"1cl\",\"1oz\",\"1kg\",\"100kg\",\"500ml\",\"1l\",\"10l\",\"1mg\",\"500mg\",\"50mg\",\"1box\",\"1pcs\",\"1l \\u212e\"]',	'2025-06-25 05:21:53',	'2025-06-25 05:21:53'),
(6,	1,	'display_errors',	'0',	'2025-06-25 05:21:53',	'2025-06-25 06:46:41'),
(7,	1,	'currency',	'4',	'2025-06-25 05:21:53',	'2025-06-25 05:21:53'),
(8,	1,	'tax_rates',	'[\"8\",\"18\",\"0\",\"9\",\"17\"]',	'2025-06-25 05:21:53',	'2025-06-25 05:21:53'),
(9,	1,	'invoice_mode',	'brutto',	'2025-06-25 05:21:53',	'2025-06-25 05:21:53'),
(10,	1,	'vat_on',	'1',	'2025-06-25 05:21:53',	'2025-06-25 05:21:53'),
(11,	1,	'list_count_single',	'3',	'2025-06-25 05:21:53',	'2025-06-25 05:21:53'),
(12,	1,	'time_format',	'%H:%M:%S',	'2025-07-30 16:41:35',	'2025-06-25 12:52:58'),
(79,	1,	'date_format',	'%Y/%m/%d',	'2025-07-30 16:41:22',	'2025-06-25 12:52:58');

DROP TABLE IF EXISTS `fado_vehicles`;
CREATE TABLE `fado_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `manufacturer` varchar(256) DEFAULT NULL,
  `type` varchar(256) DEFAULT NULL,
  `construction_year` int(11) DEFAULT NULL,
  `in_use` int(11) DEFAULT NULL,
  `keynr` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `changed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_vehicles` (`id`, `name`, `manufacturer`, `type`, `construction_year`, `in_use`, `keynr`, `created`, `changed`) VALUES
(1,	'Ford',	'Ford',	'Type T',	1920,	1,	22,	'2019-03-24 18:08:56',	'2019-05-11 17:14:36'),
(2,	'IPorsche',	'Porsche',	'Sport',	2006,	1,	256,	'2019-03-24 18:08:56',	'2019-03-24 18:08:56'),
(3,	'IHyundai',	'Hyundai',	'LKW',	2008,	1,	16,	'2019-03-24 18:08:56',	'2019-05-11 17:14:36'),
(4,	'Truck 16',	'MAN',	'Truck',	2008,	1,	1653312,	'2019-03-24 18:08:56',	'2019-05-11 17:14:36'),
(5,	'BMW',	'BMW',	'M8',	2012,	1,	23766,	'2019-03-24 18:08:56',	'2019-05-11 17:14:36');

DROP TABLE IF EXISTS `fado_warehouse_items`;
CREATE TABLE `fado_warehouse_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) DEFAULT NULL,
  `name` varchar(256) DEFAULT NULL,
  `information` varchar(2048) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `sold` int(11) DEFAULT NULL,
  `unit` varchar(256) DEFAULT NULL,
  `price_unit` double DEFAULT NULL,
  `tax_rate` int(11) DEFAULT NULL,
  `cut_rate` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `changed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `fado_warehouse_items_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_uca1400_ai_ci;

INSERT INTO `fado_warehouse_items` (`id`, `shop_id`, `name`, `information`, `amount`, `sold`, `unit`, `price_unit`, `tax_rate`, `cut_rate`, `active`, `created`, `changed`) VALUES
(1,	1,	'Pineapples',	'\"<p style=\\\"text-align:center\\\"><span style=\\\"color:#c0392b\\\">Origin Spain</span></p>\\r\\n\"',	143,	63,	'50g',	21.21,	18,	5,	1,	'2019-03-24 19:08:56',	'2020-07-14 19:30:37'),
(2,	1,	'Oranges',	'\"<p style=\\\"text-align:center\\\"><span style=\\\"color:#1abc9c\\\">Class A</span></p>\\r\\n\"',	590,	36,	'50g',	19.99,	8,	75,	1,	'2019-03-24 19:08:56',	'2020-07-09 23:21:01'),
(3,	3,	'Sweets',	'\"<p><span style=\\\"color:#f1c40f\\\">Bonbons<\\/span><\\/p>\\r\\n\"',	280,	25,	'50g',	16.45,	8,	0,	1,	'2019-03-24 19:08:56',	'2025-06-25 03:52:41'),
(4,	1,	'InkaFruit',	'\"<p style=\\\"text-align:right\\\"><span style=\\\"color:#8e44ad\\\">Bonbons<\\/span><\\/p>\\r\\n\"',	106,	0,	'100g',	4.75,	8,	25,	1,	'2019-03-24 19:08:56',	'2025-06-25 04:33:48'),
(5,	1,	'Honey',	'\"<p><span style=\\\"font-size:16px\\\">Fruit Beas&#39; Honey</span></p>\\r\\n\"',	216,	7,	'100g',	16.66,	9,	0,	1,	'2019-03-24 19:08:56',	'2020-02-02 12:36:46'),
(6,	2,	'Mobilphone K9',	'\"<p>New Generation Mobile Technology &copy;</p>\\r\\n\"',	489,	8,	'1pcs',	99.99,	8,	0,	1,	'2019-03-24 19:08:56',	'2020-02-02 12:37:14'),
(7,	1,	'Expensive Watch',	'\"<p><u>Precious and shiny watch<\\/u><\\/p>\\r\\n\"',	2965,	3,	'1pcs',	250.33,	8,	63,	1,	'2019-03-24 19:08:56',	'2025-06-25 04:33:18');

-- 2025-07-30 14:42:25 UTC
