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

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'b148c0c6-f31b-11f0-b1b4-1cfa94f50f6a:1-94266';

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
  `yield_pct` decimal(5,2) NOT NULL DEFAULT '100.00',
  `yield_source` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`ingredient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
-- Temporary view structure for view `location_price_variance`
--

DROP TABLE IF EXISTS `location_price_variance`;
/*!50001 DROP VIEW IF EXISTS `location_price_variance`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `location_price_variance` AS SELECT 
 1 AS `location_id`,
 1 AS `location_name`,
 1 AS `ingredient_id`,
 1 AS `ingredient_name`,
 1 AS `ingredient_category`,
 1 AS `avg_purchase_price`,
 1 AS `max_purchase_price`,
 1 AS `min_purchase_price`,
 1 AS `total_orders`*/;
SET character_set_client = @saved_cs_client;

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
-- Table structure for table `menu_price_original`
--

DROP TABLE IF EXISTS `menu_price_original`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_price_original` (
  `location_id` int NOT NULL,
  `recipe_id` int NOT NULL,
  `price` decimal(6,2) NOT NULL,
  PRIMARY KEY (`location_id`,`recipe_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `menu_profitability_by_location`
--

DROP TABLE IF EXISTS `menu_profitability_by_location`;
/*!50001 DROP VIEW IF EXISTS `menu_profitability_by_location`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `menu_profitability_by_location` AS SELECT 
 1 AS `location_id`,
 1 AS `location_name`,
 1 AS `recipe_id`,
 1 AS `recipe_name`,
 1 AS `recipe_status`,
 1 AS `menu_price`,
 1 AS `cost_per_serving`,
 1 AS `gross_profit_per_unit`,
 1 AS `profit_margin_pct`,
 1 AS `total_units_sold`,
 1 AS `total_gross_profit_dollars`*/;
SET character_set_client = @saved_cs_client;

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
) ENGINE=InnoDB AUTO_INCREMENT=2833 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=49790 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=12217 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `course` enum('Starter','Main','Dessert') NOT NULL DEFAULT 'Main',
  `program` enum('Restaurant','QSR','Pronto','Fresh Pasta') NOT NULL DEFAULT 'Restaurant',
  PRIMARY KEY (`recipe_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `recipe_allergens`
--

DROP TABLE IF EXISTS `recipe_allergens`;
/*!50001 DROP VIEW IF EXISTS `recipe_allergens`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `recipe_allergens` AS SELECT 
 1 AS `recipe_name`,
 1 AS `allergen_name`*/;
SET character_set_client = @saved_cs_client;

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
 1 AS `purchase_date`,
 1 AS `location_id`,
 1 AS `location_name`,
 1 AS `recipe_id`,
 1 AS `recipe_name`,
 1 AS `num_servings`,
 1 AS `total_recipe_cost`,
 1 AS `cost_per_serving`*/;
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
 1 AS `trans_fat_per_serving`,
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
  KEY `date_of_trans_index` (`date_of_trans`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=84122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `total_per_item` decimal(8,2) GENERATED ALWAYS AS ((`qty` * `price`)) STORED,
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
/*!50003 DROP PROCEDURE IF EXISTS `get_recipe_cost_as_of_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recipe_cost_as_of_date`(
    IN p_recipe_id SMALLINT UNSIGNED,
    IN p_location_id TINYINT UNSIGNED,
    IN p_target_date DATE
)
BEGIN
    WITH latest_prices AS (
        -- STEP 1: Find the single most recent purchase price for each ingredient on or before the target date
        SELECT 
            pl.ingredient_id,
            pl.ingredient_unit AS purchase_unit,
            pl.unit_price_actual,
            ROW_NUMBER() OVER (
                PARTITION BY pl.ingredient_id 
                ORDER BY po.purchase_date DESC, pl.list_id DESC
            ) AS rn
        FROM purchase_order po
        JOIN purchase_list pl ON po.order_id = pl.order_id
        WHERE po.location_id = p_location_id 
          AND po.purchase_date <= p_target_date
    )
    -- STEP 2: Join those latest prices to the recipe and sum the total cost
    SELECT 
        p_target_date AS price_as_of_date,
        p_location_id AS location_id,
        l.location_name,
        p_recipe_id AS recipe_id,
        r.recipe_name,
        r.num_servings,
        SUM(total_cost(CONVERT_INGREDIENT(ri.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, lp.purchase_unit), lp.unit_price_actual)) AS total_recipe_cost,
        (SUM(total_cost(CONVERT_INGREDIENT(ri.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, lp.purchase_unit), lp.unit_price_actual)) / r.num_servings) AS cost_per_serving
    FROM recipe_ingredients ri
    JOIN recipe r ON ri.recipe_id = r.recipe_id
    JOIN location l ON l.location_id = p_location_id
    JOIN latest_prices lp ON ri.ingredient_id = lp.ingredient_id AND lp.rn = 1
    WHERE ri.recipe_id = p_recipe_id
    GROUP BY l.location_name, r.recipe_name, r.num_servings;
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
WITH recipe_snapshot_dates AS (
    -- STEP 1: Get every date any ingredient for a recipe was purchased at a location
    SELECT DISTINCT m.location_id, ri.recipe_id, po.purchase_date AS snapshot_date
    FROM menu m
    JOIN recipe_ingredients ri ON m.recipe_id = ri.recipe_id
    JOIN purchase_list pl ON ri.ingredient_id = pl.ingredient_id
    JOIN purchase_order po ON pl.order_id = po.order_id AND m.location_id = po.location_id
    WHERE m.recipe_id = p_recipe_id AND m.location_id = p_location_id AND po.purchase_date <= p_target_date
),
recipe_full_ingredient_list AS (
    -- STEP 2: Create a row for EVERY ingredient in the recipe for EVERY snapshot date
    SELECT 
        rsd.location_id, 
        rsd.recipe_id, 
        rsd.snapshot_date, 
        ri.ingredient_id, 
        ri.ingredient_quantity, 
        ri.ingredient_unit AS recipe_unit
    FROM recipe_snapshot_dates rsd
    JOIN recipe_ingredients ri ON rsd.recipe_id = ri.recipe_id
),
historical_prices AS (
    -- STEP 3: Look backward from the snapshot date to find the most recent price
    SELECT 
        rfi.location_id,
        rfi.recipe_id,
        rfi.snapshot_date,
        rfi.ingredient_id,
        rfi.ingredient_quantity,
        rfi.recipe_unit,
        pl.unit_price_actual,
        pl.ingredient_unit AS purchase_unit,
        ROW_NUMBER() OVER (
            PARTITION BY rfi.snapshot_date, rfi.ingredient_id 
            ORDER BY po.purchase_date DESC, pl.list_id DESC
        ) AS rn
    FROM recipe_full_ingredient_list rfi
    JOIN purchase_order po 
        ON po.location_id = rfi.location_id 
        AND po.purchase_date <= rfi.snapshot_date
    JOIN purchase_list pl 
        ON po.order_id = pl.order_id 
        AND pl.ingredient_id = rfi.ingredient_id
)
-- STEP 4: Sum the full recipe using the effective prices for that specific date
SELECT 
    hp.snapshot_date AS purchase_date,
    hp.location_id,
    l.location_name,
    hp.recipe_id,
    r.recipe_name,
    r.num_servings,
    SUM(total_cost(CONVERT_INGREDIENT(hp.ingredient_id, hp.ingredient_quantity, hp.recipe_unit, hp.purchase_unit), hp.unit_price_actual)) AS total_recipe_cost,
    (SUM(total_cost(CONVERT_INGREDIENT(hp.ingredient_id, hp.ingredient_quantity, hp.recipe_unit, hp.purchase_unit), hp.unit_price_actual)) / r.num_servings) AS cost_per_serving
FROM historical_prices hp
JOIN location l ON hp.location_id = l.location_id
JOIN recipe r ON hp.recipe_id = r.recipe_id
WHERE hp.rn = 1
GROUP BY 
    hp.snapshot_date, 
    hp.location_id, 
    l.location_name, 
    hp.recipe_id, 
    r.recipe_name, 
    r.num_servings
ORDER BY purchase_date DESC;
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
-- Final view structure for view `location_price_variance`
--

/*!50001 DROP VIEW IF EXISTS `location_price_variance`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `location_price_variance` AS select `l`.`location_id` AS `location_id`,`l`.`location_name` AS `location_name`,`i`.`ingredient_id` AS `ingredient_id`,`i`.`ingredient_name` AS `ingredient_name`,`i`.`ingredient_category` AS `ingredient_category`,avg(`pl`.`unit_price_actual`) AS `avg_purchase_price`,max(`pl`.`unit_price_actual`) AS `max_purchase_price`,min(`pl`.`unit_price_actual`) AS `min_purchase_price`,count(`po`.`order_id`) AS `total_orders` from (((`purchase_order` `po` join `purchase_list` `pl` on((`po`.`order_id` = `pl`.`order_id`))) join `location` `l` on((`po`.`location_id` = `l`.`location_id`))) join `ingredient` `i` on((`pl`.`ingredient_id` = `i`.`ingredient_id`))) group by `l`.`location_id`,`l`.`location_name`,`i`.`ingredient_id`,`i`.`ingredient_name`,`i`.`ingredient_category` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `menu_profitability_by_location`
--

/*!50001 DROP VIEW IF EXISTS `menu_profitability_by_location`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `menu_profitability_by_location` AS select `m`.`location_id` AS `location_id`,`l`.`location_name` AS `location_name`,`r`.`recipe_id` AS `recipe_id`,`r`.`recipe_name` AS `recipe_name`,`m`.`recipe_status` AS `recipe_status`,`m`.`price` AS `menu_price`,`rc`.`cost_per_serving` AS `cost_per_serving`,(`m`.`price` - `rc`.`cost_per_serving`) AS `gross_profit_per_unit`,(((`m`.`price` - `rc`.`cost_per_serving`) / `m`.`price`) * 100) AS `profit_margin_pct`,sum(`si`.`qty`) AS `total_units_sold`,(sum(`si`.`qty`) * (`m`.`price` - `rc`.`cost_per_serving`)) AS `total_gross_profit_dollars` from ((((`menu` `m` join `recipe` `r` on((`m`.`recipe_id` = `r`.`recipe_id`))) join `location` `l` on((`m`.`location_id` = `l`.`location_id`))) join `recipe_cost` `rc` on(((`m`.`recipe_id` = `rc`.`recipe_id`) and (`m`.`location_id` = `rc`.`location_id`)))) join `sales_items` `si` on(((`m`.`recipe_id` = `si`.`recipe_id`) and (`m`.`location_id` = `si`.`location_id`)))) where (`m`.`recipe_status` = 'ACTIVE') group by `m`.`location_id`,`l`.`location_name`,`r`.`recipe_id`,`r`.`recipe_name`,`m`.`price`,`rc`.`cost_per_serving` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `recipe_allergens`
--

/*!50001 DROP VIEW IF EXISTS `recipe_allergens`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `recipe_allergens` AS select `r`.`recipe_name` AS `recipe_name`,`a`.`allergen_name` AS `allergen_name` from (((`ingredient_allergens` `ia` join `allergens` `a` on((`ia`.`allergen_id` = `a`.`allergen_id`))) join `recipe_ingredients` `ri` on((`ia`.`ingredient_id` = `ri`.`ingredient_id`))) join `recipe` `r` on((`ri`.`recipe_id` = `r`.`recipe_id`))) group by `r`.`recipe_name`,`a`.`allergen_name` order by `r`.`recipe_name` */;
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
/*!50001 VIEW `recipe_cost_historical` AS with `last_line_per_day` as (select `po`.`location_id` AS `location_id`,`pl`.`ingredient_id` AS `ingredient_id`,`po`.`purchase_date` AS `purchase_date`,`pl`.`unit_price_actual` AS `unit_price_actual`,`pl`.`ingredient_unit` AS `ingredient_unit`,row_number() OVER (PARTITION BY `po`.`location_id`,`pl`.`ingredient_id`,`po`.`purchase_date` ORDER BY `pl`.`list_id` desc )  AS `rn_day` from (`purchase_order` `po` join `purchase_list` `pl` on((`pl`.`order_id` = `po`.`order_id`)))), `price_events` as (select `last_line_per_day`.`location_id` AS `location_id`,`last_line_per_day`.`ingredient_id` AS `ingredient_id`,`last_line_per_day`.`purchase_date` AS `purchase_date`,`last_line_per_day`.`unit_price_actual` AS `unit_price_actual`,`last_line_per_day`.`ingredient_unit` AS `ingredient_unit` from `last_line_per_day` where (`last_line_per_day`.`rn_day` = 1)), `converted` as (select distinct `ri`.`recipe_id` AS `recipe_id`,`ri`.`ingredient_id` AS `ingredient_id`,`pu`.`ingredient_unit` AS `purchase_unit`,`convert_ingredient`(`ri`.`ingredient_id`,(`ri`.`ingredient_quantity` / (`i`.`yield_pct` / 100)),`ri`.`ingredient_unit`,`pu`.`ingredient_unit`) AS `qty` from ((`recipe_ingredients` `ri` join `ingredient` `i` on((`i`.`ingredient_id` = `ri`.`ingredient_id`))) join (select distinct `purchase_list`.`ingredient_id` AS `ingredient_id`,`purchase_list`.`ingredient_unit` AS `ingredient_unit` from `purchase_list`) `pu` on((`pu`.`ingredient_id` = `ri`.`ingredient_id`)))), `line_cost` as (select `pe`.`location_id` AS `location_id`,`ri`.`recipe_id` AS `recipe_id`,`ri`.`ingredient_id` AS `ingredient_id`,`pe`.`purchase_date` AS `purchase_date`,round((`cv`.`qty` * `pe`.`unit_price_actual`),2) AS `line_cost` from (((`price_events` `pe` join `recipe_ingredients` `ri` on((`ri`.`ingredient_id` = `pe`.`ingredient_id`))) join `menu` `m` on(((`m`.`location_id` = `pe`.`location_id`) and (`m`.`recipe_id` = `ri`.`recipe_id`)))) join `converted` `cv` on(((`cv`.`recipe_id` = `ri`.`recipe_id`) and (`cv`.`ingredient_id` = `ri`.`ingredient_id`) and (`cv`.`purchase_unit` = `pe`.`ingredient_unit`))))), `moves` as (select `line_cost`.`location_id` AS `location_id`,`line_cost`.`recipe_id` AS `recipe_id`,`line_cost`.`purchase_date` AS `purchase_date`,(coalesce(`line_cost`.`line_cost`,0) - coalesce(lag(`line_cost`.`line_cost`) OVER (PARTITION BY `line_cost`.`location_id`,`line_cost`.`recipe_id`,`line_cost`.`ingredient_id` ORDER BY `line_cost`.`purchase_date` ) ,0)) AS `move`,(case when (lag(`line_cost`.`line_cost`) OVER (PARTITION BY `line_cost`.`location_id`,`line_cost`.`recipe_id`,`line_cost`.`ingredient_id` ORDER BY `line_cost`.`purchase_date` )  is null) then 1 else 0 end) AS `first_buy` from `line_cost`), `per_day` as (select `moves`.`location_id` AS `location_id`,`moves`.`recipe_id` AS `recipe_id`,`moves`.`purchase_date` AS `purchase_date`,sum(`moves`.`move`) AS `move`,sum(`moves`.`first_buy`) AS `first_buys` from `moves` group by `moves`.`location_id`,`moves`.`recipe_id`,`moves`.`purchase_date`), `running` as (select `per_day`.`location_id` AS `location_id`,`per_day`.`recipe_id` AS `recipe_id`,`per_day`.`purchase_date` AS `purchase_date`,sum(`per_day`.`move`) OVER (PARTITION BY `per_day`.`location_id`,`per_day`.`recipe_id` ORDER BY `per_day`.`purchase_date` )  AS `total_recipe_cost`,sum(`per_day`.`first_buys`) OVER (PARTITION BY `per_day`.`location_id`,`per_day`.`recipe_id` ORDER BY `per_day`.`purchase_date` )  AS `ingredients_priced` from `per_day`), `recipe_size` as (select `recipe_ingredients`.`recipe_id` AS `recipe_id`,count(distinct `recipe_ingredients`.`ingredient_id`) AS `n_ingredients` from `recipe_ingredients` group by `recipe_ingredients`.`recipe_id`) select `c`.`purchase_date` AS `purchase_date`,`c`.`location_id` AS `location_id`,`l`.`location_name` AS `location_name`,`c`.`recipe_id` AS `recipe_id`,`r`.`recipe_name` AS `recipe_name`,`r`.`num_servings` AS `num_servings`,`c`.`total_recipe_cost` AS `total_recipe_cost`,(`c`.`total_recipe_cost` / `r`.`num_servings`) AS `cost_per_serving` from (((`running` `c` join `recipe_size` `rs` on(((`rs`.`recipe_id` = `c`.`recipe_id`) and (`c`.`ingredients_priced` = `rs`.`n_ingredients`)))) join `location` `l` on((`l`.`location_id` = `c`.`location_id`))) join `recipe` `r` on((`r`.`recipe_id` = `c`.`recipe_id`))) */;
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
/*!50001 VIEW `recipe_nutritional_info` AS select `ri`.`recipe_id` AS `recipe_id`,`r`.`recipe_name` AS `recipe_name`,cast(sum(((`ni`.`calories` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as unsigned) AS `calories_per_serving`,cast(sum(((`ni`.`total_fat_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `fat_per_serving`,cast(sum(((`ni`.`saturated_fat_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `saturated_fat_per_serving`,cast(sum(((`ni`.`trans_fat_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `trans_fat_per_serving`,cast(sum(((`ni`.`cholesterol_mg` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `cholesterol_per_serving`,cast(sum(((`ni`.`sodium_mg` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `sodium_per_serving`,cast(sum(((`ni`.`total_carbs_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `carbs_per_serving`,cast(sum(((`ni`.`sugars_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `sugars_per_serving`,cast(sum(((`ni`.`fiber_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `fiber_per_serving`,cast(sum(((`ni`.`protein_g` * (`convert_ingredient`(`ni`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,3) / 100)) / `r`.`num_servings`)) as decimal(5,1)) AS `protein_per_serving` from ((((`nutritional_info` `ni` join `recipe_ingredients` `ri` on((`ni`.`ingredient_id` = `ri`.`ingredient_id`))) join `recipe` `r` on((`ri`.`recipe_id` = `r`.`recipe_id`))) join `ingredient` `i` on((`ni`.`ingredient_id` = `i`.`ingredient_id`))) join `unit` `u` on((`ri`.`ingredient_unit` = `u`.`unit_id`))) group by `ri`.`recipe_id`,`r`.`recipe_name`,`r`.`num_servings` */;
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
/*!50001 VIEW `recipe_to_purchase_conversion` AS select `lpp`.`supplier_id` AS `supplier_id`,`s`.`supplier_name` AS `supplier_name`,`m`.`location_id` AS `location_id`,`l`.`location_name` AS `location_name`,`ri`.`recipe_id` AS `recipe_id`,`r`.`recipe_name` AS `recipe_name`,`r`.`num_servings` AS `num_servings`,`ri`.`ingredient_id` AS `ingredient_id`,`i`.`ingredient_name` AS `ingredient_name`,`ri`.`ingredient_quantity` AS `ingredient_quantity`,`ri`.`ingredient_unit` AS `recipe_unit`,`ru`.`unit_name` AS `recipe_unit_name`,`CONVERT_INGREDIENT`(`ri`.`ingredient_id`,(`ri`.`ingredient_quantity` / (`i`.`yield_pct` / 100)),`ri`.`ingredient_unit`,`lpp`.`unit_id`) AS `converted_quantity`,`lpp`.`unit_id` AS `purchase_unit`,`pu`.`unit_name` AS `purchase_unit_name`,`lpp`.`unit_price` AS `unit_price`,`total_cost`(`CONVERT_INGREDIENT`(`ri`.`ingredient_id`,(`ri`.`ingredient_quantity` / (`i`.`yield_pct` / 100)),`ri`.`ingredient_unit`,`lpp`.`unit_id`),`lpp`.`unit_price`) AS `total_cost` from ((((((((`recipe_ingredients` `ri` join `latest_purchase_price` `lpp` on((`ri`.`ingredient_id` = `lpp`.`ingredient_id`))) join `menu` `m` on(((`ri`.`recipe_id` = `m`.`recipe_id`) and (`lpp`.`location_id` = `m`.`location_id`)))) join `unit` `ru` on((`ri`.`ingredient_unit` = `ru`.`unit_id`))) join `unit` `pu` on((`lpp`.`unit_id` = `pu`.`unit_id`))) join `recipe` `r` on((`ri`.`recipe_id` = `r`.`recipe_id`))) join `supplier` `s` on((`lpp`.`supplier_id` = `s`.`supplier_id`))) join `location` `l` on((`lpp`.`location_id` = `l`.`location_id`))) join `ingredient` `i` on((`ri`.`ingredient_id` = `i`.`ingredient_id`))) where (`m`.`recipe_status` = 'ACTIVE') group by `m`.`recipe_id`,`ri`.`ingredient_id`,`lpp`.`supplier_id`,`m`.`location_id`,`lpp`.`unit_id`,`converted_quantity`,`lpp`.`unit_price` order by `m`.`location_id`,`r`.`recipe_id`,`ri`.`ingredient_id`,`s`.`supplier_id` */;
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

-- Dump completed on 2026-10-09 17:07:31
