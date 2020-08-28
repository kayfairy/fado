-- MySQL dump 10.13  Distrib 8.0.20, for Linux (x86_64)
--
-- Host: localhost    Database: fado
-- ------------------------------------------------------
-- Server version	8.0.20-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `fado_cache`
--

DROP TABLE IF EXISTS `fado_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_cache` (
  `session` varchar(64) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `value` varchar(4096) NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_cache`
--

LOCK TABLES `fado_cache` WRITE;
/*!40000 ALTER TABLE `fado_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `fado_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_currency`
--

DROP TABLE IF EXISTS `fado_currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_currency` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `currency` varchar(256) DEFAULT NULL,
  `ISO4217` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_currency`
--

LOCK TABLES `fado_currency` WRITE;
/*!40000 ALTER TABLE `fado_currency` DISABLE KEYS */;
INSERT INTO `fado_currency` VALUES (1,'Euro','€','EUR'),(2,'Dollar','$','USD'),(3,'Pound','£','GBP'),(4,'Lira','₺','ITL'),(5,'Ruble','₽','RUB'),(6,'Yen','¥','JPY'),(7,'Peso','₱','PHP'),(8,'Dong','₫','VND'),(9,'Hryvnia','₴','UAH'),(10,'Franc','₣','CHF'),(11,'Rial','﷼','YER'),(12,'Sol','S/.','PEN'),(13,'Shekel','₪','ILS'),(14,'Cedi','¢','GHS');
/*!40000 ALTER TABLE `fado_currency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_invoices`
--

DROP TABLE IF EXISTS `fado_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_invoices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id_seller` int NOT NULL,
  `shop_id_customer` int NOT NULL,
  `is_payed` int DEFAULT NULL,
  `zone_time` varchar(6) DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `changed` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shop_id_seller` (`shop_id_seller`),
  KEY `shop_id_customer` (`shop_id_customer`),
  CONSTRAINT `fado_invoices_ibfk_1` FOREIGN KEY (`shop_id_seller`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fado_invoices_ibfk_2` FOREIGN KEY (`shop_id_customer`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_invoices`
--

LOCK TABLES `fado_invoices` WRITE;
/*!40000 ALTER TABLE `fado_invoices` DISABLE KEYS */;
INSERT INTO `fado_invoices` VALUES (97,4,1,0,'+00:00','2018-07-31 22:51:08',NULL),(98,3,5,0,'+00:00','2018-07-31 22:51:51',NULL),(99,5,6,0,'+00:00','2018-08-01 11:39:56',NULL),(100,2,5,1,'+00:00','2018-08-01 20:52:47','2020-07-09 21:21:02'),(101,2,1,0,'+00:00','2018-08-01 23:22:37',NULL),(102,1,3,0,'+00:00','2018-08-02 09:49:55',NULL),(103,2,1,1,'+00:00','2018-08-02 10:18:15','2019-12-10 11:29:05'),(104,2,4,0,'+00:00','2018-08-02 10:36:53',NULL),(105,6,7,0,'+00:00','2018-08-02 10:51:01',NULL),(106,2,4,0,'+00:00','2018-08-02 11:03:09',NULL),(107,1,3,1,'+00:00','2018-08-02 11:11:01','2020-07-09 21:20:52'),(108,2,4,1,'+00:00','2018-08-02 12:39:01','2020-07-09 21:20:20');
/*!40000 ALTER TABLE `fado_invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_invoices2items`
--

DROP TABLE IF EXISTS `fado_invoices2items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_invoices2items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int NOT NULL,
  `item_id` int NOT NULL,
  `amount` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `fado_invoices2items_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `fado_invoices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fado_invoices2items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `fado_warehouse_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_invoices2items`
--

LOCK TABLES `fado_invoices2items` WRITE;
/*!40000 ALTER TABLE `fado_invoices2items` DISABLE KEYS */;
INSERT INTO `fado_invoices2items` VALUES (1,97,1,1),(2,97,6,4),(3,98,2,4),(4,98,6,3),(5,99,4,3),(6,99,6,4),(7,100,1,1),(8,100,2,2),(9,101,4,3),(10,102,1,1),(11,102,2,6),(12,102,3,2),(13,102,4,1),(48,102,5,2),(49,102,6,1),(50,103,3,2),(51,103,6,3),(52,104,7,6),(53,105,7,1),(54,106,4,2),(55,107,7,2),(56,108,1,1),(57,108,3,5),(58,108,4,1),(59,108,7,1);
/*!40000 ALTER TABLE `fado_invoices2items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_meetings`
--

DROP TABLE IF EXISTS `fado_meetings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_meetings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `meeting` VARCHAR(2048) DEFAULT NULL,
  `changed` timestamp NULL DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fado_meetings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `fado_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_meetings`
--

LOCK TABLES `fado_meetings` WRITE;
/*!40000 ALTER TABLE `fado_meetings` DISABLE KEYS */;
INSERT INTO `fado_meetings` VALUES (34,1,'meeting1','New meeting','{\"day\": \"2025-07-15\", \"stop\": \"05:17\", \"range\": \"\", \"start\": \"18:45\", \"period\": \"0\"}',NULL,'2020-02-02 11:39:04');
/*!40000 ALTER TABLE `fado_meetings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_modules`
--

DROP TABLE IF EXISTS `fado_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_modules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `description` varchar(256) NOT NULL,
  `active` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_modules`
--

LOCK TABLES `fado_modules` WRITE;
/*!40000 ALTER TABLE `fado_modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `fado_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_settings`
--

DROP TABLE IF EXISTS `fado_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `value` varchar(256) DEFAULT NULL,
  `changed` timestamp NULL DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_settings`
--

LOCK TABLES `fado_settings` WRITE;
/*!40000 ALTER TABLE `fado_settings` DISABLE KEYS */;
INSERT INTO `fado_settings` VALUES (1,'encoding','UTF-8',NULL,'2019-03-24 18:08:54'),(2,'lang_available','[\"en_GB\",\"de_DE\",\"tr_TR\"]',NULL,'2019-03-24 18:08:54'),(3,'date_time_format_available','{\"lang\":\"%c\",\"en_GB\":\"%Y/%m/%d %H:%M:%S\",\"en_US\":\"%d-%m-%Y %H:%M:%S\",\"UTC\":\"%x %H:%M:%S\",\"UTC2\":\"%a, %d. %b %Y %H:%M:%S\",\"UTC3\":\"%A %d. %B %Y %H:%M:%S\",\"de_DE\":\"%d.%m.%Y %H:%M:%S\"}',NULL,'2019-03-24 18:08:54'),(4,'cookiename','FADO','2020-07-09 21:21:40','2019-03-24 18:08:54'),(5,'cookielife_hours','8','2020-07-09 21:21:41','2019-03-24 18:08:54'),(6,'error_reporting_available','[\"0\",\"E_ALL\",\"E_ALL & ~E_NOTICE\"]',NULL,'2019-03-24 18:08:54'),(7,'error_log','1',NULL,'2019-03-24 18:08:54'),(8,'error_reporting','E_ALL',NULL,'2019-03-24 18:08:54'),(9,'memcache_on','1','2020-07-09 21:21:41','2019-03-24 18:08:54'),(10,'memcache_host','127.0.0.1','2020-07-09 21:21:41','2019-03-24 18:08:54'),(11,'memcache_port','11211','2020-07-09 21:21:41','2019-03-24 18:08:54'),(12,'memcache_life_seconds','6071','2020-07-09 21:21:41','2019-03-24 18:08:54'),(13,'memcache_compressed','0',NULL,'2019-03-24 18:08:54'),(14,'invoice_mode_available','[\"brutto\",\"netto\"]',NULL,'2019-03-24 18:08:54'),(15,'map_tile_url','{s}.tile.openstreetmap.org/{z}/{x}/{y}.png','2020-07-09 21:21:41','2019-03-24 18:08:54'),(16,'map_route_url','router.project-osrm.org/route/v1','2020-07-09 21:21:41','2019-03-24 18:08:54'),(17,'rewrite_route','1','2020-07-09 21:21:42','2019-03-24 18:08:54'),(18,'date_format_available','{\"en_GB\":\"%Y/%m/%d\",\"en_US\":\"%d-%m-%Y\",\"UTC\":\"%x\",\"UTC2\":\"%a, %d. %b %Y\",\"UTC3\":\"%A %d. %B %Y\",\"de_DE\":\"%d.%m.%Y\"}',NULL,'2019-03-24 18:08:54'),(19,'maximum_login_attempts','4',NULL,'2020-07-14 17:10:38');
/*!40000 ALTER TABLE `fado_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_shops`
--

DROP TABLE IF EXISTS `fado_shops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_shops` (
  `id` int NOT NULL AUTO_INCREMENT,
  `description` varchar(256) DEFAULT NULL,
  `city` varchar(256) DEFAULT NULL,
  `zip` varchar(256) DEFAULT NULL,
  `street` varchar(256) DEFAULT NULL,
  `streetnr` varchar(256) DEFAULT NULL,
  `country` varchar(256) DEFAULT NULL,
  `phone` varchar(256) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `information` longtext CHARACTER SET utf8 COLLATE utf8_general_ci,
  `opening_hours` longtext,
  `established` date DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `changed` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_shops`
--

LOCK TABLES `fado_shops` WRITE;
/*!40000 ALTER TABLE `fado_shops` DISABLE KEYS */;
INSERT INTO `fado_shops` VALUES (1,'My Shop','My Town','4523556','In Dark Forest','664456','Norway','00175553021114','fairy13@calendar.com','\"<p style=\\\"text-align:center\\\"><span style=\\\"color:#27ae60\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado<\\/strong><\\/span><\\/em><\\/span><\\/span><sub>&reg;<\\/sub><\\/p>\\r\\n\\r\\n<ol>\\r\\n\\t<li><span style=\\\"color:#e74c3c\\\">Point<\\/span><\\/li>\\r\\n\\t<li><span style=\\\"color:#1abc9c\\\">Comma<\\/span><\\/li>\\r\\n\\t<li><span style=\\\"background-color:#1abc9c\\\">Semicolon<\\/span><\\/li>\\r\\n<\\/ol>\\r\\n\"','{\"1\":{\"range\":\"0-2\",\"open\":\"20:42\",\"close\":\"18:32\"},\"2\":{\"range\":\"4-5\",\"open\":\"09:30\",\"close\":\"20:00\"}}','1940-11-20','2019-03-24 18:08:56','2020-03-07 12:04:00'),(2,'Tile Shop','Tilefarm','12356745','Horse Rd.','166','Spain','00173247858484','shop@tilefarm.com','\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado</strong></span></em></span><sub>&reg;</sub></p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point</li>\\r\\n\\t<li>Comma</li>\\r\\n\\t<li>Semicolon</li>\\r\\n</ol>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\"','{\"1\": {\"open\": \"13:00\", \"close\": \"09:00\", \"range\": \"0-2\"}, \"2\": {\"open\": \"18:00\", \"close\": \"10:00\", \"range\": \"3-5\"}}','1960-09-20','2019-03-24 18:08:56','2020-01-10 09:22:24'),(3,'Inferno','St. Micheal','3213556','Firebrick Rd.','67','Big Apple','004492465461','press@enter.com','\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado<\\/strong><\\/span><\\/em><\\/span><sub>&reg;<\\/sub><\\/p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point<\\/li>\\r\\n\\t<li>Comma<\\/li>\\r\\n\\t<li>Semicolon<\\/li>\\r\\n<\\/ol>\\r\\n\\r\\n<p>&nbsp;<\\/p>\\r\\n\\r\\n<p>&nbsp;<\\/p>\\r\\n\"','{\"1\":{\"range\":\"0-2\",\"open\":\"08:42\",\"close\":\"11:00\"}}','1996-10-23','2019-03-24 18:08:56','2020-03-05 15:21:31'),(4,'Test','Error City','65566MV','Malfunction Rd.','55','Big Apple','004492465461','errortest@local.com','\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado</strong></span></em></span><sub>&reg;</sub></p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point</li>\\r\\n\\t<li>Comma</li>\\r\\n\\t<li>Semicolon</li>\\r\\n</ol>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\"','{\"1\": {\"open\": \"20:45\", \"close\": \"09:30\", \"range\": \"0-3\"}, \"2\": {\"open\": \"20:00\", \"close\": \"09:00\", \"range\": \"5-5\"}}','1991-11-18','2019-03-24 18:08:56','2020-02-02 09:03:54'),(5,'Tree Market','Earth','345667','Wood Rd.','493','Universe','0017234204443584','tree@dimension.com','\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado</strong></span></em></span><sub>&reg;</sub></p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point</li>\\r\\n\\t<li>Comma</li>\\r\\n\\t<li>Semicolon</li>\\r\\n</ol>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\"','{\"1\": {\"open\": \"05:30\", \"close\": \"00:45\", \"range\": \"0-2\"}, \"2\": {\"open\": \"04:02\", \"close\": \"15:30\", \"range\": \"2-5\"}, \"3\": {\"open\": \"05:30\", \"close\": \"00:45\", \"range\": \"0-4\"}}','1990-10-24','2019-03-24 18:08:56','2020-01-11 16:24:50'),(6,'Uncle\'s Shop','Santa Maria','012356','Saintsstreet','54','Spain','005456512693548','uncle@myshop.com','\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado</strong></span></em></span><sub>&reg;</sub></p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point</li>\\r\\n\\t<li>Comma</li>\\r\\n\\t<li>Semicolon</li>\\r\\n</ol>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\"','{\"1\": {\"open\": \"20:44\", \"close\": \"09:39\", \"range\": \"0-4\"}, \"2\": {\"open\": \"12:00\", \"close\": \"21:00\", \"range\": \"5-5\"}, \"3\": {\"open\": \"20:00\", \"close\": \"11:00\", \"range\": \"6-6\"}}','1986-02-20','2019-03-24 18:08:56','2020-01-10 09:23:54'),(7,'Timeoffice Clerk','Roundvillage','1697','Star Rd.','13','New Mexiko','00563655894','contact@timeofficeclerk.co.uk','\"<p style=\\\"text-align:center\\\"><span style=\\\"font-size:20px\\\"><em><span style=\\\"font-family:Arial,Helvetica,sans-serif\\\"><strong>Fado</strong></span></em></span><sub>&reg;</sub></p>\\r\\n\\r\\n<ol>\\r\\n\\t<li>Point</li>\\r\\n\\t<li>Comma</li>\\r\\n\\t<li>Semicolon</li>\\r\\n</ol>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\\r\\n<p>&nbsp;</p>\\r\\n\"','{\"1\": {\"open\": \"06:30\", \"close\": \"16:00\", \"range\": \"0-0\"}}','1986-06-16','2019-03-24 18:08:56','2020-01-10 09:23:15');
/*!40000 ALTER TABLE `fado_shops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_shops2location`
--

DROP TABLE IF EXISTS `fado_shops2location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_shops2location` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int NOT NULL,
  `lat` double DEFAULT NULL,
  `lng` double DEFAULT NULL,
  `changed` timestamp NULL DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `fado_shops2location_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_shops2location`
--

LOCK TABLES `fado_shops2location` WRITE;
/*!40000 ALTER TABLE `fado_shops2location` DISABLE KEYS */;
INSERT INTO `fado_shops2location` VALUES (1,1,50.96534632163772,7.135620117187501,'2020-06-16 09:29:25','2019-03-24 18:08:57'),(2,2,50.94250774138692,6.968078613281251,'2020-07-09 18:58:01','2019-03-24 18:08:57'),(3,3,50.9588879493434,6.795043945312501,NULL,'2019-03-24 18:08:57'),(4,4,48.110365502683564,11.62353515625,'2020-07-09 18:58:21','2019-03-24 18:08:57'),(5,5,52.37023336352407,14.106445312500002,'2020-07-09 18:58:36','2019-03-24 18:08:57'),(6,6,50.14733840084469,8.756103515625002,'2020-07-09 18:58:56','2019-03-24 18:08:57'),(7,7,53.550915205894206,10.03875732421875,'2020-07-09 18:59:23','2019-03-24 18:08:57');
/*!40000 ALTER TABLE `fado_shops2location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_shops2user`
--

DROP TABLE IF EXISTS `fado_shops2user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_shops2user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `shop_id` (`shop_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fado_shops2user_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fado_shops2user_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `fado_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_shops2user`
--

LOCK TABLES `fado_shops2user` WRITE;
/*!40000 ALTER TABLE `fado_shops2user` DISABLE KEYS */;
INSERT INTO `fado_shops2user` VALUES (5,1,3),(11,1,1),(12,1,6);
/*!40000 ALTER TABLE `fado_shops2user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_shops2vehicles`
--

DROP TABLE IF EXISTS `fado_shops2vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_shops2vehicles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vehicle_id` int NOT NULL,
  `shop_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `vehicle_id` (`vehicle_id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `fado_shops2vehicles_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `fado_vehicles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fado_shops2vehicles_ibfk_2` FOREIGN KEY (`shop_id`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_shops2vehicles`
--

LOCK TABLES `fado_shops2vehicles` WRITE;
/*!40000 ALTER TABLE `fado_shops2vehicles` DISABLE KEYS */;
INSERT INTO `fado_shops2vehicles` VALUES (1,1,1),(2,2,1),(3,3,1),(4,4,2),(5,5,2);
/*!40000 ALTER TABLE `fado_shops2vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_user`
--

DROP TABLE IF EXISTS `fado_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `active` int DEFAULT NULL,
  `online` int DEFAULT NULL,
  `name` varchar(256) DEFAULT NULL,
  `pwd` varchar(256) DEFAULT NULL,
  `salt` varchar(256) DEFAULT NULL,
  `session` varchar(256) DEFAULT NULL,
  `phone` varchar(256) DEFAULT NULL,
  `email` varchar(256) DEFAULT NULL,
  `data` VARCHAR(2048) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `changed` timestamp NULL DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_user`
--

LOCK TABLES `fado_user` WRITE;
/*!40000 ALTER TABLE `fado_user` DISABLE KEYS */;
INSERT INTO `fado_user` VALUES (1,1,1,'fado','88dd095096cce3c169b812a0ab61f7b2f210c7312b71bafea50b97da2a9d229b','e74a86bc8eecd49f5a2bf26c4f4cfef1644a2853c27610ca45739440943160aa','49ff8aa67c48152c1320657951bba8e2f725985ddf957b2ba12cc37a138b6e28','0049111222333','fado@fado.com','\"<p><span style=\\\"color:#3498db\\\"><em>Superadmin</em></span></p>\\r\\n\"','2043-01-26','2019-08-09 10:37:03','2020-03-05 15:24:02','2020-07-14 17:27:13'),(6,1,0,'admin','b4ac4777102d2954b8dd055a6646025ecc629120b5e0de38c2121489af1ec7b8','fac10980afa86938b6970abfe3b0d0ad559ac304ca3c9f0cf5240e88428ffe86',NULL,'','admin@fado.com','\"<p><span style=\\\"color:#c0392b\\\"><em>Administrator&nbsp;</em></span></p>\\r\\n\"','1971-02-27','2019-12-10 10:45:49','2020-02-02 11:04:11','2020-07-14 16:53:33');
/*!40000 ALTER TABLE `fado_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_user_rights`
--

DROP TABLE IF EXISTS `fado_user_rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_user_rights` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `rights` VARCHAR(2048) DEFAULT NULL,
  `changed` timestamp NULL DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fado_user_rights_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `fado_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_user_rights`
--

LOCK TABLES `fado_user_rights` WRITE;
/*!40000 ALTER TABLE `fado_user_rights` DISABLE KEYS */;
INSERT INTO `fado_user_rights` VALUES (1,1,'{\"aj\": \"2\", \"at\": \"2\", \"if\": \"1\", \"in\": \"2\", \"me\": \"2\", \"na\": \"1\", \"ne\": \"2\", \"ri\": \"2\", \"sh\": \"2\", \"sq\": \"2\", \"st\": \"1\", \"ur\": 2, \"us\": \"2\", \"ut\": \"2\", \"ve\": \"2\", \"wa\": \"2\"}','2020-01-10 12:08:51','2019-08-09 10:39:48'),(6,6,'{\"aj\": \"2\", \"at\": \"2\", \"if\": \"1\", \"in\": \"2\", \"me\": \"2\", \"na\": \"1\", \"ne\": \"2\", \"ri\": \"2\", \"sh\": \"2\", \"sq\": \"2\", \"st\": \"1\", \"ur\": 2, \"us\": \"2\", \"ut\": \"2\", \"ve\": \"2\", \"wa\": \"2\"}','2020-01-10 20:19:28','2019-12-10 10:45:50');
/*!40000 ALTER TABLE `fado_user_rights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_user_routes`
--

DROP TABLE IF EXISTS `fado_user_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_user_routes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `points` varchar(256) DEFAULT 'NULL',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fado_user_routes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `fado_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_user_routes`
--

LOCK TABLES `fado_user_routes` WRITE;
/*!40000 ALTER TABLE `fado_user_routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `fado_user_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_user_settings`
--

DROP TABLE IF EXISTS `fado_user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_user_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `value` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `changed` timestamp NULL DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `fado_user_settings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `fado_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_user_settings`
--

LOCK TABLES `fado_user_settings` WRITE;
/*!40000 ALTER TABLE `fado_user_settings` DISABLE KEYS */;
INSERT INTO `fado_user_settings` VALUES (1,1,'lang','tr_TR','2020-07-14 17:27:37','2019-08-09 10:37:59'),(2,1,'timezone','Europe/London','2020-07-14 17:27:37','2019-08-09 10:37:59'),(3,1,'number_format','[\"2\",\",\",\"\\u00a0\"]','2020-07-14 17:27:37','2019-08-09 10:37:59'),(4,1,'date_time_format','%d.%m.%Y %H:%M:%S','2020-07-14 17:27:37','2019-08-09 10:37:59'),(5,1,'item_amount_units','[\"100g\",\"50g\",\"100ml\",\"1m\\u00b3\",\"1m\\u00b2\",\"1cl\",\"1oz\",\"1kg\",\"100kg\",\"500ml\",\"1l\",\"10l\",\"1mg\",\"500mg\",\"50mg\",\"1box\",\"1pcs\",\"1l \\u212e\"]','2020-07-14 17:27:38','2019-08-09 10:37:59'),(6,1,'display_errors','1','2020-07-14 17:27:38','2019-08-09 10:37:59'),(7,1,'currency','4','2020-07-14 17:27:38','2019-08-09 10:37:59'),(8,1,'tax_rates','[\"8\",\"18\",\"0\",\"9\",\"17\"]','2020-07-14 17:27:38','2019-08-09 10:37:59'),(9,1,'invoice_mode','brutto','2020-07-14 17:27:38','2019-08-09 10:37:59'),(10,1,'vat_on','1','2020-07-14 17:27:39','2019-08-09 10:37:59'),(11,1,'list_count_single','4','2020-07-14 17:27:39','2019-08-09 10:37:59'),(12,1,'date_format','%d.%m.%Y','2020-07-14 17:27:39','2019-08-09 10:37:59'),(13,1,'time_format','%H:%M',NULL,'2019-08-09 10:37:59'),(66,6,'lang','en_GB',NULL,'2019-12-10 10:45:49'),(67,6,'timezone','Europe/London',NULL,'2019-12-10 10:45:49'),(68,6,'number_format','[\"2\",\",\",\".\"]',NULL,'2019-12-10 10:45:49'),(69,6,'date_time_format','%d.%m.%Y %H:%M:%S',NULL,'2019-12-10 10:45:49'),(70,6,'item_amount_units','[\"100g\",\"50g\",\"100ml\",\"1mu00b3\",\"1mu00b2\",\"1cl\",\"1oz\",\"1kg\",\"100kg\",\"500ml\",\"1l\",\"10l\",\"1mg\",\"500mg\",\"50mg\",\"1box\",\"1pcs\",\"Transaction\",\"1oz ℮\"]',NULL,'2019-12-10 10:45:49'),(71,6,'display_errors','1',NULL,'2019-12-10 10:45:49'),(72,6,'currency','1',NULL,'2019-12-10 10:45:49'),(73,6,'tax_rates','[\"8\",\"0\"]',NULL,'2019-12-10 10:45:49'),(74,6,'invoice_mode','brutto',NULL,'2019-12-10 10:45:49'),(75,6,'vat_on','1',NULL,'2019-12-10 10:45:49'),(76,6,'list_count_single','3',NULL,'2019-12-10 10:45:49'),(77,6,'time_format','%H:%M',NULL,'2019-12-10 10:45:49'),(78,6,'date_format','%d.%m.%Y',NULL,'2019-12-10 10:45:49');
/*!40000 ALTER TABLE `fado_user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_vehicles`
--

DROP TABLE IF EXISTS `fado_vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_vehicles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `manufacturer` varchar(256) DEFAULT NULL,
  `type` varchar(256) DEFAULT NULL,
  `construction_year` int DEFAULT NULL,
  `in_use` int DEFAULT NULL,
  `keynr` int DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `changed` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_vehicles`
--

LOCK TABLES `fado_vehicles` WRITE;
/*!40000 ALTER TABLE `fado_vehicles` DISABLE KEYS */;
INSERT INTO `fado_vehicles` VALUES (1,'Ford','Ford','Type T',1920,1,22,'2019-03-24 18:08:56','2019-05-11 17:14:36'),(2,'IPorsche','Porsche','Sport',2006,1,256,'2019-03-24 18:08:56',NULL),(3,'IHyundai','Hyundai','LKW',2008,1,16,'2019-03-24 18:08:56',NULL),(4,'Truck 16','MAN','Truck',2008,1,1653312,'2019-03-24 18:08:56',NULL),(5,'BMW','BMW','M8',2012,1,23766,'2019-03-24 18:08:56',NULL);
/*!40000 ALTER TABLE `fado_vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fado_warehouse_items`
--

DROP TABLE IF EXISTS `fado_warehouse_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fado_warehouse_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shop_id` int NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `information` VARCHAR(2048) DEFAULT NULL,
  `amount` int DEFAULT NULL,
  `sold` int DEFAULT NULL,
  `unit` varchar(256) DEFAULT NULL,
  `price_unit` double DEFAULT NULL,
  `tax_rate` int DEFAULT NULL,
  `cut_rate` int DEFAULT NULL,
  `active` int DEFAULT NULL,
  `created` timestamp NULL DEFAULT NULL,
  `changed` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shop_id` (`shop_id`),
  CONSTRAINT `fado_warehouse_items_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `fado_shops` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fado_warehouse_items`
--

LOCK TABLES `fado_warehouse_items` WRITE;
/*!40000 ALTER TABLE `fado_warehouse_items` DISABLE KEYS */;
INSERT INTO `fado_warehouse_items` VALUES (1,1,'Pineapples','\"<p style=\\\"text-align:center\\\"><span style=\\\"color:#c0392b\\\">Origin Spain</span></p>\\r\\n\"',143,63,'50g',21.21,18,5,1,'2019-03-24 18:08:56','2020-07-14 17:30:37'),(2,1,'Oranges','\"<p style=\\\"text-align:center\\\"><span style=\\\"color:#1abc9c\\\">Class A</span></p>\\r\\n\"',590,36,'50g',19.99,8,75,1,'2019-03-24 18:08:56','2020-07-09 21:21:01'),(3,4,'Sweets','\"<p><span style=\\\"color:#f1c40f\\\">Bonbons</span></p>\\r\\n\"',280,25,'50g',16.45,8,0,1,'2019-03-24 18:08:56','2020-07-09 21:20:20'),(4,1,'InkaFruit','\"<p style=\\\"text-align:right\\\"><span style=\\\"color:#8e44ad\\\">Bonbons</span></p>\\r\\n\"',106,0,'100g',4.75,8,25,1,'2019-03-24 18:08:56','2020-07-09 21:20:20'),(5,1,'Honey','\"<p><span style=\\\"font-size:16px\\\">Fruit Beas&#39; Honey</span></p>\\r\\n\"',216,7,'100g',16.66,9,0,1,'2019-03-24 18:08:56','2020-02-02 11:36:46'),(6,2,'Mobilphone K9','\"<p>New Generation Mobile Technology &copy;</p>\\r\\n\"',489,8,'1pcs',99.99,8,0,1,'2019-03-24 18:08:56','2020-02-02 11:37:14'),(7,7,'Expensive Watch','\"<p><u>Precious and shiny watch</u></p>\\r\\n\"',2965,3,'1pcs',250.33,17,63,1,'2019-03-24 18:08:56','2020-07-09 21:20:52');
/*!40000 ALTER TABLE `fado_warehouse_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-07-14 19:32:08
