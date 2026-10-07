CREATE DATABASE  IF NOT EXISTS `restaurant` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `restaurant`;
-- MySQL dump 10.13  Distrib 26.7.0, for macos15 (arm64)
--
-- Host: 127.0.0.1    Database: restaurant
-- ------------------------------------------------------
-- Server version	26.7.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'b148c0c6-f31b-11f0-b1b4-1cfa94f50f6a:1-93133';

--
-- Temporary view structure for view `all_recipes`
--

DROP TABLE IF EXISTS `all_recipes`;
/*!50001 DROP VIEW IF EXISTS `all_recipes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `all_recipes` AS SELECT 
 1 AS `recipe_name`,
 1 AS `ingredient_name`,
 1 AS `ingredient_quantity`,
 1 AS `unit_name`,
 1 AS `num_servings`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `allergens`
--

DROP TABLE IF EXISTS `allergens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allergens` (
  `allergen_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `allergen_name` varchar(25) NOT NULL,
  PRIMARY KEY (`allergen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `convert_ingred`
--

DROP TABLE IF EXISTS `convert_ingred`;
/*!50001 DROP VIEW IF EXISTS `convert_ingred`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `convert_ingred` AS SELECT 
 1 AS `ingredient_name`,
 1 AS `from_unit`,
 1 AS `to_unit`,
 1 AS `rate`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ingredient`
--

DROP TABLE IF EXISTS `ingredient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredient` (
  `ingredient_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `ingredient_name` varchar(50) NOT NULL,
  `ingredient_category` varchar(50) NOT NULL,
  PRIMARY KEY (`ingredient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ingredient_allergens`
--

DROP TABLE IF EXISTS `ingredient_allergens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredient_allergens` (
  `ingredient_id` smallint unsigned NOT NULL,
  `allergen_id` tinyint unsigned NOT NULL,
  PRIMARY KEY (`ingredient_id`,`allergen_id`),
  KEY `allergen_id` (`allergen_id`),
  CONSTRAINT `ingredient_allergens_ibfk_1` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`),
  CONSTRAINT `ingredient_allergens_ibfk_2` FOREIGN KEY (`allergen_id`) REFERENCES `allergens` (`allergen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ingredient_conversion`
--

DROP TABLE IF EXISTS `ingredient_conversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredient_conversion` (
  `ingredient_id` smallint unsigned NOT NULL,
  `from_unit` tinyint unsigned NOT NULL,
  `to_unit` tinyint unsigned NOT NULL,
  `rate` decimal(15,9) NOT NULL,
  PRIMARY KEY (`ingredient_id`,`from_unit`,`to_unit`),
  KEY `fk_ingconv_from` (`from_unit`),
  KEY `fk_ingconv_to` (`to_unit`),
  CONSTRAINT `fk_ingconv_from` FOREIGN KEY (`from_unit`) REFERENCES `unit` (`unit_id`),
  CONSTRAINT `fk_ingconv_ingredient` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`),
  CONSTRAINT `fk_ingconv_to` FOREIGN KEY (`to_unit`) REFERENCES `unit` (`unit_id`),
  CONSTRAINT `ingredient_conversion_chk_1` CHECK ((`rate` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `ingredient_conversion_rate`
--

DROP TABLE IF EXISTS `ingredient_conversion_rate`;
/*!50001 DROP VIEW IF EXISTS `ingredient_conversion_rate`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ingredient_conversion_rate` AS SELECT 
 1 AS `ingredient_id`,
 1 AS `purchase_unit`,
 1 AS `recipe_unit`,
 1 AS `uc_from_unit`,
 1 AS `uc_to_unit`,
 1 AS `uc_rate`,
 1 AS `ic_from_unit`,
 1 AS `ic_to_unit`,
 1 AS `ic_rate`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `ingredient_id` smallint unsigned NOT NULL,
  `inventory_date` datetime NOT NULL,
  `location_id` tinyint unsigned NOT NULL,
  `ingredient_quantity` decimal(8,3) DEFAULT NULL,
  `ingredient_unit` tinyint unsigned NOT NULL,
  PRIMARY KEY (`ingredient_id`,`inventory_date`,`location_id`),
  KEY `location_id` (`location_id`),
  KEY `ingredient_unit` (`ingredient_unit`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`),
  CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `inventory_ibfk_3` FOREIGN KEY (`ingredient_unit`) REFERENCES `unit` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `latest_purchase_price`
--

DROP TABLE IF EXISTS `latest_purchase_price`;
/*!50001 DROP VIEW IF EXISTS `latest_purchase_price`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `latest_purchase_price` AS SELECT 
 1 AS `rn`,
 1 AS `order_id`,
 1 AS `purchase_date`,
 1 AS `supplier_id`,
 1 AS `supplier`,
 1 AS `ingredient_id`,
 1 AS `ingredient_name`,
 1 AS `unit_price`,
 1 AS `quantity`,
 1 AS `unit_id`,
 1 AS `unit`,
 1 AS `location_id`,
 1 AS `location`,
 1 AS `total ($)`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `location_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `location_name` varchar(50) NOT NULL,
  `address` varchar(30) NOT NULL,
  `city` varchar(30) NOT NULL,
  `state` varchar(30) NOT NULL,
  `zip_code` varchar(10) NOT NULL,
  `region_id` tinyint unsigned NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `manager_name` varchar(25) NOT NULL,
  PRIMARY KEY (`location_id`),
  KEY `location_ibfk_1` (`region_id`),
  CONSTRAINT `location_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `location_id` tinyint unsigned NOT NULL,
  `recipe_id` smallint unsigned NOT NULL,
  `price` decimal(6,2) NOT NULL,
  `recipe_status` enum('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`location_id`,`recipe_id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `menu_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nutritional_info`
--

DROP TABLE IF EXISTS `nutritional_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nutritional_info` (
  `ingredient_id` smallint unsigned NOT NULL,
  `calories` smallint unsigned DEFAULT NULL,
  `total_fat_g` decimal(5,2) DEFAULT NULL,
  `saturated_fat_g` decimal(5,2) DEFAULT NULL,
  `trans_fat_g` decimal(5,2) DEFAULT NULL,
  `cholesterol_mg` mediumint unsigned DEFAULT NULL,
  `sodium_mg` mediumint unsigned DEFAULT NULL,
  `total_carbs_g` decimal(5,2) DEFAULT NULL,
  `sugars_g` decimal(5,2) DEFAULT NULL,
  `fiber_g` decimal(5,2) DEFAULT NULL,
  `protein_g` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`ingredient_id`),
  CONSTRAINT `nutritional_info_ibfk_1` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `price_quote`
--

DROP TABLE IF EXISTS `price_quote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `price_quote` (
  `quote_id` int NOT NULL AUTO_INCREMENT,
  `supplier_id` smallint unsigned NOT NULL,
  `ingredient_id` smallint unsigned NOT NULL,
  `unit_price_quote` decimal(6,2) NOT NULL,
  `ingredient_unit` tinyint unsigned NOT NULL,
  `quote_date` date NOT NULL,
  `units_per_case` tinyint unsigned NOT NULL,
  `case_unit` tinyint unsigned NOT NULL,
  `region_id` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`quote_id`),
  KEY `fk_pq_supplier` (`supplier_id`),
  KEY `fk_pq_ingredient` (`ingredient_id`),
  KEY `fk_pq_unit` (`ingredient_unit`),
  KEY `fk_pq_caseunit` (`case_unit`),
  KEY `fk_region` (`region_id`),
  CONSTRAINT `fk_pq_caseunit` FOREIGN KEY (`case_unit`) REFERENCES `unit` (`unit_id`),
  CONSTRAINT `fk_pq_ingredient` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`),
  CONSTRAINT `fk_pq_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`),
  CONSTRAINT `fk_pq_unit` FOREIGN KEY (`ingredient_unit`) REFERENCES `unit` (`unit_id`),
  CONSTRAINT `fk_region` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`)
) ENGINE=InnoDB AUTO_INCREMENT=662 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `purchase_list`
--

DROP TABLE IF EXISTS `purchase_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_list` (
  `list_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `ingredient_id` smallint unsigned NOT NULL,
  `unit_price_actual` decimal(6,2) NOT NULL,
  `ingredient_unit` tinyint unsigned NOT NULL,
  `ingredient_quantity` decimal(8,3) DEFAULT NULL,
  PRIMARY KEY (`list_id`),
  KEY `fk_pl_ingredient` (`ingredient_id`),
  KEY `fk_pl_order` (`order_id`),
  KEY `fk_pl_unit` (`ingredient_unit`),
  CONSTRAINT `fk_pl_ingredient` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`),
  CONSTRAINT `fk_pl_order` FOREIGN KEY (`order_id`) REFERENCES `purchase_order` (`order_id`),
  CONSTRAINT `fk_pl_unit` FOREIGN KEY (`ingredient_unit`) REFERENCES `unit` (`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1407 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `purchase_order`
--

DROP TABLE IF EXISTS `purchase_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `supplier_id` smallint unsigned NOT NULL,
  `purchase_date` date NOT NULL,
  `location_id` tinyint unsigned NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `fk_po_supplier` (`supplier_id`),
  KEY `fk_location` (`location_id`),
  CONSTRAINT `fk_location` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `fk_po_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=593 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recipe`
--

DROP TABLE IF EXISTS `recipe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipe` (
  `recipe_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `recipe_name` varchar(50) NOT NULL,
  `num_servings` int DEFAULT NULL,
  PRIMARY KEY (`recipe_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `recipe_cost`
--

DROP TABLE IF EXISTS `recipe_cost`;
/*!50001 DROP VIEW IF EXISTS `recipe_cost`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `recipe_cost` AS SELECT 
 1 AS `recipe_id`,
 1 AS `recipe_name`,
 1 AS `num_servings`,
 1 AS `location_id`,
 1 AS `location_name`,
 1 AS `total_recipe_cost`,
 1 AS `cost_per_serving`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `recipe_cost_historical`
--

DROP TABLE IF EXISTS `recipe_cost_historical`;
/*!50001 DROP VIEW IF EXISTS `recipe_cost_historical`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `recipe_cost_historical` AS SELECT 
 1 AS `rn`,
 1 AS `purchase_date`,
 1 AS `supplier_id`,
 1 AS `supplier_name`,
 1 AS `location_id`,
 1 AS `location_name`,
 1 AS `recipe_id`,
 1 AS `recipe_name`,
 1 AS `num_servings`,
 1 AS `ingredient_id`,
 1 AS `ingredient_name`,
 1 AS `ingredient_quantity`,
 1 AS `recipe_unit`,
 1 AS `recipe_unit_name`,
 1 AS `converted_quantity`,
 1 AS `purchase_unit`,
 1 AS `purchase_unit_name`,
 1 AS `unit_price_actual`,
 1 AS `total_cost`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `recipe_ingredients`
--

DROP TABLE IF EXISTS `recipe_ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipe_ingredients` (
  `recipe_id` smallint unsigned NOT NULL,
  `ingredient_id` smallint unsigned NOT NULL,
  `ingredient_quantity` decimal(8,3) DEFAULT NULL,
  `ingredient_unit` tinyint unsigned NOT NULL,
  PRIMARY KEY (`recipe_id`,`ingredient_id`),
  KEY `fk_recing_ingredient` (`ingredient_id`),
  KEY `fk_recing_unit` (`ingredient_unit`),
  CONSTRAINT `fk_recing_ingredient` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`),
  CONSTRAINT `fk_recing_recipe` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`),
  CONSTRAINT `fk_recing_unit` FOREIGN KEY (`ingredient_unit`) REFERENCES `unit` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `recipe_nutritional_info`
--

DROP TABLE IF EXISTS `recipe_nutritional_info`;
/*!50001 DROP VIEW IF EXISTS `recipe_nutritional_info`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `recipe_nutritional_info` AS SELECT 
 1 AS `recipe_id`,
 1 AS `recipe_name`,
 1 AS `calories_per_serving`,
 1 AS `fat_per_serving`,
 1 AS `saturated_fat_per_serving`,
 1 AS `tans_fat_per_serving`,
 1 AS `cholesterol_per_serving`,
 1 AS `sodium_per_serving`,
 1 AS `carbs_per_serving`,
 1 AS `sugars_per_serving`,
 1 AS `fiber_per_serving`,
 1 AS `protein_per_serving`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `recipe_to_purchase_conversion`
--

DROP TABLE IF EXISTS `recipe_to_purchase_conversion`;
/*!50001 DROP VIEW IF EXISTS `recipe_to_purchase_conversion`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `recipe_to_purchase_conversion` AS SELECT 
 1 AS `supplier_id`,
 1 AS `supplier_name`,
 1 AS `location_id`,
 1 AS `location_name`,
 1 AS `recipe_id`,
 1 AS `recipe_name`,
 1 AS `num_servings`,
 1 AS `ingredient_id`,
 1 AS `ingredient_name`,
 1 AS `ingredient_quantity`,
 1 AS `recipe_unit`,
 1 AS `recipe_unit_name`,
 1 AS `converted_quantity`,
 1 AS `purchase_unit`,
 1 AS `purchase_unit_name`,
 1 AS `unit_price`,
 1 AS `total_cost`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `region` (
  `region_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `region_name` varchar(25) NOT NULL,
  PRIMARY KEY (`region_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `running_purchase_list`
--

DROP TABLE IF EXISTS `running_purchase_list`;
/*!50001 DROP VIEW IF EXISTS `running_purchase_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `running_purchase_list` AS SELECT 
 1 AS `order_id`,
 1 AS `purchase_date`,
 1 AS `supplier_id`,
 1 AS `supplier`,
 1 AS `ingredient_id`,
 1 AS `ingredient_name`,
 1 AS `unit_price`,
 1 AS `quantity`,
 1 AS `unit_id`,
 1 AS `unit`,
 1 AS `location_id`,
 1 AS `location`,
 1 AS `total ($)`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `transaction_id` int unsigned NOT NULL AUTO_INCREMENT,
  `location_id` tinyint unsigned DEFAULT NULL,
  `date_of_trans` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  KEY `location_id` (`location_id`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sales_items`
--

DROP TABLE IF EXISTS `sales_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_items` (
  `transaction_id` int unsigned NOT NULL,
  `location_id` tinyint unsigned NOT NULL,
  `recipe_id` smallint unsigned NOT NULL,
  `qty` tinyint unsigned NOT NULL,
  `price` decimal(6,2) NOT NULL,
  PRIMARY KEY (`transaction_id`,`recipe_id`),
  KEY `location_id` (`location_id`,`recipe_id`),
  CONSTRAINT `sales_items_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `sales` (`transaction_id`),
  CONSTRAINT `sales_items_ibfk_2` FOREIGN KEY (`location_id`, `recipe_id`) REFERENCES `menu` (`location_id`, `recipe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `supplier_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `supplier_name` varchar(50) NOT NULL,
  `address` varchar(25) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `zip_code` varchar(10) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `contact_name` varchar(25) NOT NULL,
  `supplier_status` enum('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unit`
--

DROP TABLE IF EXISTS `unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit` (
  `unit_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `unit_name` varchar(10) NOT NULL,
  PRIMARY KEY (`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unit_conversion`
--

DROP TABLE IF EXISTS `unit_conversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit_conversion` (
  `from_unit` tinyint unsigned NOT NULL,
  `to_unit` tinyint unsigned NOT NULL,
  `rate` decimal(15,9) NOT NULL,
  PRIMARY KEY (`from_unit`,`to_unit`),
  KEY `fk_unitconv_to` (`to_unit`),
  CONSTRAINT `fk_unitconv_from` FOREIGN KEY (`from_unit`) REFERENCES `unit` (`unit_id`),
  CONSTRAINT `fk_unitconv_to` FOREIGN KEY (`to_unit`) REFERENCES `unit` (`unit_id`),
  CONSTRAINT `unit_conversion_chk_1` CHECK ((`rate` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'restaurant'
--
/*!50003 DROP FUNCTION IF EXISTS `calculate_margin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_margin`(p_recipe_price DECIMAL(6,2), p_recipe_cost DECIMAL(6,2)) RETURNS decimal(6,2)
    DETERMINISTIC
BEGIN
	DECLARE profit DECIMAL(6,2);

	SET profit = (p_recipe_price - p_recipe_cost);
    RETURN profit / p_recipe_price;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_percent_change` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_percent_change`(prev_amnt decimal(6,2), curr_amnt decimal(6,2)) RETURNS decimal(10,3)
    DETERMINISTIC
BEGIN
	DECLARE pct_change DECIMAL(10, 5);
    
	SET pct_change = ((curr_amnt - prev_amnt) / prev_amnt) * 100;
    RETURN pct_change;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `convert_ingredient` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `convert_ingredient`(p_ingredient_id smallint unsigned, p_ingredient_quantity DECIMAL(8,3), p_from_unit tinyint unsigned, p_to_unit tinyint unsigned) RETURNS decimal(8,3)
    DETERMINISTIC
BEGIN
	DECLARE uc_rate DECIMAL(15,9);
    DECLARE ic_rate DECIMAL(15,9);
    
    if ((p_from_unit = p_to_unit) OR (p_to_unit = p_from_unit)) THEN
    RETURN p_ingredient_quantity;
    END IF;
    
    SELECT rate FROM unit_conversion WHERE p_from_unit = from_unit AND p_to_unit = to_unit INTO uc_rate;
    IF uc_rate IS NOT NULL THEN
    return p_ingredient_quantity * uc_rate;
    END IF;
    
	SELECT rate FROM unit_conversion WHERE p_from_unit = to_unit AND p_to_unit = from_unit INTO uc_rate;
    IF uc_rate IS NOT NULL THEN
    return p_ingredient_quantity * (1/uc_rate);
    END IF;

    SELECT rate FROM ingredient_conversion WHERE ingredient_id = p_ingredient_id AND p_from_unit = from_unit AND p_to_unit = to_unit INTO ic_rate;
    IF ic_rate IS NOT NULL THEN
    return p_ingredient_quantity * ic_rate;
    END IF;
    
	SELECT rate FROM ingredient_conversion WHERE ingredient_id = p_ingredient_id AND p_from_unit = to_unit AND p_to_unit = from_unit INTO ic_rate;
    IF ic_rate IS NOT NULL THEN
    return p_ingredient_quantity * (1/ic_rate);
    END IF;
	
    RETURN NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `total_cost` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `total_cost`(ingredient_quantity decimal(8,3), unit_price decimal(10,2)) RETURNS decimal(6,2)
    DETERMINISTIC
BEGIN
	RETURN (ingredient_quantity * unit_price);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_profit_margin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_profit_margin`(p_recipe_id smallint unsigned, p_location_id tinyint unsigned)
SELECT 
        rc.recipe_id,
        rc.recipe_name,
        rc.num_servings,
        rc.location_id,
        rc.location_name,
        (SUM(total_cost) / num_servings) AS cost_per_serving,
        m.price AS price_per_serving,
        calculate_margin(m.price, (SUM(total_cost) / num_servings)) AS profit_margin
    FROM recipe_to_purchase_conversion rc
    JOIN menu m ON rc.recipe_id = m.recipe_id AND rc.location_id = m.location_id
    WHERE rc.recipe_id = p_recipe_id AND rc.location_id = p_location_id
    GROUP BY rc.recipe_id, rc.recipe_name, rc.location_id, rc.location_id, num_servings, m.price ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_recipe_cost` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recipe_cost`(
    IN p_recipe_id SMALLINT UNSIGNED,
    IN p_location_id TINYINT UNSIGNED
)
BEGIN
    SELECT 
        recipe_id,
        recipe_name,
        num_servings,
        location_id,
        location_name,
        SUM(total_cost) AS total_recipe_cost,
        (SUM(total_cost) / num_servings) AS cost_per_serving
    FROM recipe_to_purchase_conversion
    WHERE recipe_id = p_recipe_id AND location_id = p_location_id
    GROUP BY recipe_id, recipe_name, num_servings, location_id, location_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_recipe_cost_historical` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recipe_cost_historical`(
    IN p_recipe_id SMALLINT UNSIGNED,
    IN p_location_id TINYINT UNSIGNED,
    IN p_target_date DATE
)
BEGIN
    -- STEP 1: Exactly mirrors 'latest_purchase_price' view
    WITH latest AS (
        SELECT
            ROW_NUMBER() OVER (
                PARTITION BY po.supplier_id, pl.ingredient_id, po.location_id 
                ORDER BY po.purchase_date DESC, pl.list_id DESC 
            ) AS rn,
            po.order_id,
            po.purchase_date,
            po.supplier_id,
            s.supplier_name AS supplier,
            pl.ingredient_id,
            i.ingredient_name,
            pl.unit_price_actual AS unit_price,
            pl.ingredient_quantity AS quantity,
            pl.ingredient_unit AS unit_id,
            u.unit_name AS unit,
            po.location_id,
            l.location_name AS location,
            total_cost(pl.ingredient_quantity, pl.unit_price_actual) AS `total ($)`
        FROM purchase_order po
        JOIN purchase_list pl ON po.order_id = pl.order_id
        JOIN supplier s ON po.supplier_id = s.supplier_id
        JOIN ingredient i ON pl.ingredient_id = i.ingredient_id
        JOIN unit u ON pl.ingredient_unit = u.unit_id
        JOIN location l ON po.location_id = l.location_id
        WHERE po.purchase_date <= p_target_date
    ),
    latest_purchase_price_cte AS (
        SELECT * FROM latest WHERE rn = 1
    ),
    -- STEP 2: Exactly mirrors 'recipe_to_purchase_conversion' view
    recipe_to_purchase_conversion_cte AS (
        SELECT 
            lpp.supplier_id AS supplier_id,
            s.supplier_name AS supplier_name,
            m.location_id AS location_id,
            l.location_name AS location_name,
            ri.recipe_id AS recipe_id,
            r.recipe_name AS recipe_name,
            r.num_servings,
            ri.ingredient_id AS ingredient_id,
            i.ingredient_name AS ingredient_name,
            ri.ingredient_quantity AS ingredient_quantity,
            ri.ingredient_unit AS recipe_unit,
            ru.unit_name AS recipe_unit_name,
            CONVERT_INGREDIENT(ri.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, lpp.unit_id) AS converted_quantity,
            lpp.unit_id AS purchase_unit,
            pu.unit_name AS purchase_unit_name,
            lpp.unit_price,
            total_cost(CONVERT_INGREDIENT(ri.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, lpp.unit_id), lpp.unit_price) AS total_cost
        FROM
            recipe_ingredients ri
            JOIN latest_purchase_price_cte lpp 
                ON ri.ingredient_id = lpp.ingredient_id
            JOIN menu m 
                ON ri.recipe_id = m.recipe_id 
                AND lpp.location_id = m.location_id
            JOIN unit ru 
                ON ri.ingredient_unit = ru.unit_id
            JOIN unit pu 
                ON lpp.unit_id = pu.unit_id
            JOIN recipe r 
                ON ri.recipe_id = r.recipe_id
            JOIN supplier s 
                ON lpp.supplier_id = s.supplier_id
            JOIN location l 
                ON lpp.location_id = l.location_id
            JOIN ingredient i 
                ON ri.ingredient_id = i.ingredient_id
        WHERE m.recipe_status = 'ACTIVE'
    )
    -- STEP 3: Exactly mirrors your 'get_recipe_cost' standard procedure
    SELECT 
        recipe_id,
        recipe_name,
        num_servings,
        location_id,
        location_name,
        p_target_date AS price_as_of_date,
        SUM(total_cost(converted_quantity, unit_price)) AS total_recipe_cost,
        (SUM(total_cost(converted_quantity, unit_price))/ num_servings) AS cost_per_serving
    FROM recipe_to_purchase_conversion_cte
    WHERE recipe_id = p_recipe_id AND location_id = p_location_id
    GROUP BY recipe_id, recipe_name, num_servings, location_id, location_name, p_target_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `all_recipes`
--

/*!50001 DROP VIEW IF EXISTS `all_recipes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `all_recipes` AS select distinct `r`.`recipe_name` AS `recipe_name`,`i`.`ingredient_name` AS `ingredient_name`,`ri`.`ingredient_quantity` AS `ingredient_quantity`,`u`.`unit_name` AS `unit_name`,`r`.`num_servings` AS `num_servings` from (((`recipe_ingredients` `ri` join `recipe` `r` on((`ri`.`recipe_id` = `r`.`recipe_id`))) join `unit` `u` on((`ri`.`ingredient_unit` = `u`.`unit_id`))) join `ingredient` `i` on((`ri`.`ingredient_id` = `i`.`ingredient_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `convert_ingred`
--

/*!50001 DROP VIEW IF EXISTS `convert_ingred`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `convert_ingred` AS select `i`.`ingredient_name` AS `ingredient_name`,`uf`.`unit_name` AS `from_unit`,`ut`.`unit_name` AS `to_unit`,`ic`.`rate` AS `rate` from (((`ingredient_conversion` `ic` join `unit` `uf` on((`ic`.`from_unit` = `uf`.`unit_id`))) join `unit` `ut` on((`ic`.`to_unit` = `ut`.`unit_id`))) join `ingredient` `i` on((`ic`.`ingredient_id` = `i`.`ingredient_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ingredient_conversion_rate`
--

/*!50001 DROP VIEW IF EXISTS `ingredient_conversion_rate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ingredient_conversion_rate` AS with `recipe_purchase` as (select `ri`.`ingredient_id` AS `ingredient_id`,`pl`.`ingredient_unit` AS `purchase_unit`,`ri`.`ingredient_unit` AS `recipe_unit` from (`recipe_ingredients` `ri` join `purchase_list` `pl` on((`ri`.`ingredient_id` = `pl`.`ingredient_id`))) group by `ri`.`ingredient_id`,`purchase_unit`,`recipe_unit` having (`recipe_unit` <> `purchase_unit`) order by `ri`.`ingredient_id`) select `rp`.`ingredient_id` AS `ingredient_id`,`rp`.`purchase_unit` AS `purchase_unit`,`rp`.`recipe_unit` AS `recipe_unit`,`uc`.`from_unit` AS `uc_from_unit`,`uc`.`to_unit` AS `uc_to_unit`,`uc`.`rate` AS `uc_rate`,`ic`.`from_unit` AS `ic_from_unit`,`ic`.`to_unit` AS `ic_to_unit`,`ic`.`rate` AS `ic_rate` from ((`recipe_purchase` `rp` left join `unit_conversion` `uc` on(((`uc`.`from_unit` = `rp`.`purchase_unit`) and (`uc`.`to_unit` = `rp`.`recipe_unit`)))) left join `ingredient_conversion` `ic` on(((`ic`.`from_unit` = `rp`.`purchase_unit`) and (`ic`.`to_unit` = `rp`.`recipe_unit`) and (`ic`.`ingredient_id` = `rp`.`ingredient_id`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `latest_purchase_price`
--

/*!50001 DROP VIEW IF EXISTS `latest_purchase_price`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `latest_purchase_price` AS with `latest` as (select row_number() OVER (PARTITION BY `po`.`supplier_id`,`pl`.`ingredient_id`,`l`.`location_id` ORDER BY `po`.`purchase_date` desc,`pl`.`list_id` desc )  AS `rn`,`po`.`order_id` AS `order_id`,`po`.`purchase_date` AS `purchase_date`,`po`.`supplier_id` AS `supplier_id`,`s`.`supplier_name` AS `supplier`,`pl`.`ingredient_id` AS `ingredient_id`,`i`.`ingredient_name` AS `ingredient_name`,`pl`.`unit_price_actual` AS `unit_price`,`pl`.`ingredient_quantity` AS `quantity`,`pl`.`ingredient_unit` AS `unit_id`,`u`.`unit_name` AS `unit`,`po`.`location_id` AS `location_id`,`l`.`location_name` AS `location`,`total_cost`(`pl`.`ingredient_quantity`,`pl`.`unit_price_actual`) AS `total ($)` from (((((`purchase_order` `po` join `purchase_list` `pl` on((`po`.`order_id` = `pl`.`order_id`))) join `supplier` `s` on((`po`.`supplier_id` = `s`.`supplier_id`))) join `ingredient` `i` on((`pl`.`ingredient_id` = `i`.`ingredient_id`))) join `unit` `u` on((`pl`.`ingredient_unit` = `u`.`unit_id`))) join `location` `l` on((`po`.`location_id` = `l`.`location_id`)))) select `latest`.`rn` AS `rn`,`latest`.`order_id` AS `order_id`,`latest`.`purchase_date` AS `purchase_date`,`latest`.`supplier_id` AS `supplier_id`,`latest`.`supplier` AS `supplier`,`latest`.`ingredient_id` AS `ingredient_id`,`latest`.`ingredient_name` AS `ingredient_name`,`latest`.`unit_price` AS `unit_price`,`latest`.`quantity` AS `quantity`,`latest`.`unit_id` AS `unit_id`,`latest`.`unit` AS `unit`,`latest`.`location_id` AS `location_id`,`latest`.`location` AS `location`,`latest`.`total ($)` AS `total ($)` from `latest` where (`latest`.`rn` = 1) order by `latest`.`location`,`latest`.`ingredient_name`,`latest`.`supplier_id`,`latest`.`purchase_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `recipe_cost`
--

/*!50001 DROP VIEW IF EXISTS `recipe_cost`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `recipe_cost` AS select `recipe_to_purchase_conversion`.`recipe_id` AS `recipe_id`,`recipe_to_purchase_conversion`.`recipe_name` AS `recipe_name`,`recipe_to_purchase_conversion`.`num_servings` AS `num_servings`,`recipe_to_purchase_conversion`.`location_id` AS `location_id`,`recipe_to_purchase_conversion`.`location_name` AS `location_name`,sum(`recipe_to_purchase_conversion`.`total_cost`) AS `total_recipe_cost`,(sum(`recipe_to_purchase_conversion`.`total_cost`) / `recipe_to_purchase_conversion`.`num_servings`) AS `cost_per_serving` from `recipe_to_purchase_conversion` group by `recipe_to_purchase_conversion`.`recipe_id`,`recipe_to_purchase_conversion`.`recipe_name`,`recipe_to_purchase_conversion`.`num_servings`,`recipe_to_purchase_conversion`.`location_id`,`recipe_to_purchase_conversion`.`location_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `recipe_cost_historical`
--

/*!50001 DROP VIEW IF EXISTS `recipe_cost_historical`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `recipe_cost_historical` AS with `purchase_record_rn` as (select row_number() OVER (PARTITION BY `ri`.`ingredient_id`,`m`.`location_id`,`po`.`supplier_id` ORDER BY `po`.`purchase_date` desc )  AS `rn`,`po`.`purchase_date` AS `purchase_date`,`pl`.`ingredient_id` AS `ingredient_id`,`po`.`supplier_id` AS `supplier_id`,`m`.`location_id` AS `location_id`,`m`.`recipe_id` AS `recipe_id`,`ri`.`ingredient_quantity` AS `ingredient_quantity`,`ri`.`ingredient_unit` AS `recipe_unit`,`pl`.`ingredient_unit` AS `purchase_unit`,`pl`.`unit_price_actual` AS `unit_price_actual` from (((`purchase_list` `pl` join `purchase_order` `po` on((`pl`.`order_id` = `po`.`order_id`))) join `recipe_ingredients` `ri` on((`pl`.`ingredient_id` = `ri`.`ingredient_id`))) join `menu` `m` on(((`ri`.`recipe_id` = `m`.`recipe_id`) and (`po`.`location_id` = `m`.`location_id`)))) order by `m`.`location_id`,`m`.`recipe_id`,`po`.`purchase_date`) select `pr`.`rn` AS `rn`,`pr`.`purchase_date` AS `purchase_date`,`pr`.`supplier_id` AS `supplier_id`,`s`.`supplier_name` AS `supplier_name`,`pr`.`location_id` AS `location_id`,`l`.`location_name` AS `location_name`,`pr`.`recipe_id` AS `recipe_id`,`r`.`recipe_name` AS `recipe_name`,`r`.`num_servings` AS `num_servings`,`pr`.`ingredient_id` AS `ingredient_id`,`i`.`ingredient_name` AS `ingredient_name`,`pr`.`ingredient_quantity` AS `ingredient_quantity`,`pr`.`recipe_unit` AS `recipe_unit`,`ru`.`unit_name` AS `recipe_unit_name`,`CONVERT_INGREDIENT`(`pr`.`ingredient_id`,`pr`.`ingredient_quantity`,`pr`.`recipe_unit`,`pr`.`purchase_unit`) AS `converted_quantity`,`pr`.`purchase_unit` AS `purchase_unit`,`pu`.`unit_name` AS `purchase_unit_name`,`pr`.`unit_price_actual` AS `unit_price_actual`,`total_cost`(`CONVERT_INGREDIENT`(`pr`.`ingredient_id`,`pr`.`ingredient_quantity`,`pr`.`recipe_unit`,`pr`.`purchase_unit`),`pr`.`unit_price_actual`) AS `total_cost` from ((((((`purchase_record_rn` `pr` join `unit` `ru` on((`pr`.`recipe_unit` = `ru`.`unit_id`))) join `unit` `pu` on((`pr`.`purchase_unit` = `pu`.`unit_id`))) join `recipe` `r` on((`pr`.`recipe_id` = `r`.`recipe_id`))) join `supplier` `s` on((`pr`.`supplier_id` = `s`.`supplier_id`))) join `location` `l` on((`pr`.`location_id` = `l`.`location_id`))) join `ingredient` `i` on((`pr`.`ingredient_id` = `i`.`ingredient_id`))) group by `pr`.`recipe_id`,`pr`.`ingredient_id`,`pr`.`supplier_id`,`pr`.`location_id`,`pr`.`purchase_unit`,`pr`.`recipe_unit`,`pr`.`unit_price_actual`,`pr`.`purchase_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `recipe_nutritional_info`
--

/*!50001 DROP VIEW IF EXISTS `recipe_nutritional_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `recipe_nutritional_info` AS select `ri`.`recipe_id` AS `recipe_id`,`r`.`recipe_name` AS `recipe_name`,cast(sum(((`ni`.`calories` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as unsigned) AS `calories_per_serving`,cast(sum(((`ni`.`total_fat_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `fat_per_serving`,cast(sum(((`ni`.`saturated_fat_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `saturated_fat_per_serving`,cast(sum(((`ni`.`trans_fat_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `tans_fat_per_serving`,cast(sum(((`ni`.`cholesterol_mg` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `cholesterol_per_serving`,cast(sum(((`ni`.`sodium_mg` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `sodium_per_serving`,cast(sum(((`ni`.`total_carbs_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `carbs_per_serving`,cast(sum(((`ni`.`sugars_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `sugars_per_serving`,cast(sum(((`ni`.`fiber_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `fiber_per_serving`,cast(sum(((`ni`.`protein_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `protein_per_serving` from ((((`nutritional_info` `ni` join `recipe_ingredients` `ri` on((`ni`.`ingredient_id` = `ri`.`ingredient_id`))) join `recipe` `r` on((`ri`.`recipe_id` = `r`.`recipe_id`))) join `ingredient` `i` on((`ni`.`ingredient_id` = `i`.`ingredient_id`))) join `unit` `u` on((`ri`.`ingredient_unit` = `u`.`unit_id`))) group by `ri`.`recipe_id`,`r`.`recipe_name`,`r`.`num_servings` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `recipe_to_purchase_conversion`
--

/*!50001 DROP VIEW IF EXISTS `recipe_to_purchase_conversion`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `recipe_to_purchase_conversion` AS select `lpp`.`supplier_id` AS `supplier_id`,`s`.`supplier_name` AS `supplier_name`,`m`.`location_id` AS `location_id`,`l`.`location_name` AS `location_name`,`ri`.`recipe_id` AS `recipe_id`,`r`.`recipe_name` AS `recipe_name`,`r`.`num_servings` AS `num_servings`,`ri`.`ingredient_id` AS `ingredient_id`,`i`.`ingredient_name` AS `ingredient_name`,`ri`.`ingredient_quantity` AS `ingredient_quantity`,`ri`.`ingredient_unit` AS `recipe_unit`,`ru`.`unit_name` AS `recipe_unit_name`,`CONVERT_INGREDIENT`(`ri`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,`lpp`.`unit_id`) AS `converted_quantity`,`lpp`.`unit_id` AS `purchase_unit`,`pu`.`unit_name` AS `purchase_unit_name`,`lpp`.`unit_price` AS `unit_price`,`total_cost`(`CONVERT_INGREDIENT`(`ri`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,`lpp`.`unit_id`),`lpp`.`unit_price`) AS `total_cost` from ((((((((`recipe_ingredients` `ri` join `latest_purchase_price` `lpp` on((`ri`.`ingredient_id` = `lpp`.`ingredient_id`))) join `menu` `m` on(((`ri`.`recipe_id` = `m`.`recipe_id`) and (`lpp`.`location_id` = `m`.`location_id`)))) join `unit` `ru` on((`ri`.`ingredient_unit` = `ru`.`unit_id`))) join `unit` `pu` on((`lpp`.`unit_id` = `pu`.`unit_id`))) join `recipe` `r` on((`ri`.`recipe_id` = `r`.`recipe_id`))) join `supplier` `s` on((`lpp`.`supplier_id` = `s`.`supplier_id`))) join `location` `l` on((`lpp`.`location_id` = `l`.`location_id`))) join `ingredient` `i` on((`ri`.`ingredient_id` = `i`.`ingredient_id`))) where (`m`.`recipe_status` = 'ACTIVE') group by `m`.`recipe_id`,`ri`.`ingredient_id`,`lpp`.`supplier_id`,`m`.`location_id`,`lpp`.`unit_id`,`converted_quantity`,`lpp`.`unit_price` order by `m`.`location_id`,`r`.`recipe_id`,`ri`.`ingredient_id`,`s`.`supplier_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `running_purchase_list`
--

/*!50001 DROP VIEW IF EXISTS `running_purchase_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `running_purchase_list` AS with `latest` as (select `po`.`order_id` AS `order_id`,`po`.`purchase_date` AS `purchase_date`,`po`.`supplier_id` AS `supplier_id`,`s`.`supplier_name` AS `supplier`,`pl`.`ingredient_id` AS `ingredient_id`,`i`.`ingredient_name` AS `ingredient_name`,`pl`.`unit_price_actual` AS `unit_price`,`pl`.`ingredient_quantity` AS `quantity`,`pl`.`ingredient_unit` AS `unit_id`,`u`.`unit_name` AS `unit`,`po`.`location_id` AS `location_id`,`l`.`location_name` AS `location`,`total_cost`(`pl`.`ingredient_quantity`,`pl`.`unit_price_actual`) AS `total ($)` from (((((`purchase_order` `po` join `purchase_list` `pl` on((`po`.`order_id` = `pl`.`order_id`))) join `supplier` `s` on((`po`.`supplier_id` = `s`.`supplier_id`))) join `ingredient` `i` on((`pl`.`ingredient_id` = `i`.`ingredient_id`))) join `unit` `u` on((`pl`.`ingredient_unit` = `u`.`unit_id`))) join `location` `l` on((`po`.`location_id` = `l`.`location_id`)))) select `latest`.`order_id` AS `order_id`,`latest`.`purchase_date` AS `purchase_date`,`latest`.`supplier_id` AS `supplier_id`,`latest`.`supplier` AS `supplier`,`latest`.`ingredient_id` AS `ingredient_id`,`latest`.`ingredient_name` AS `ingredient_name`,`latest`.`unit_price` AS `unit_price`,`latest`.`quantity` AS `quantity`,`latest`.`unit_id` AS `unit_id`,`latest`.`unit` AS `unit`,`latest`.`location_id` AS `location_id`,`latest`.`location` AS `location`,`latest`.`total ($)` AS `total ($)` from `latest` order by `latest`.`location`,`latest`.`supplier_id`,`latest`.`purchase_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-07 18:51:45
