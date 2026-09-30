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

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'b148c0c6-f31b-11f0-b1b4-1cfa94f50f6a:1-91910';

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
  `rate` decimal(10,7) DEFAULT NULL,
  PRIMARY KEY (`ingredient_id`,`from_unit`,`to_unit`),
  KEY `fk_ingconv_from` (`from_unit`),
  KEY `fk_ingconv_to` (`to_unit`),
  CONSTRAINT `fk_ingconv_from` FOREIGN KEY (`from_unit`) REFERENCES `unit` (`unit_id`),
  CONSTRAINT `fk_ingconv_ingredient` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`),
  CONSTRAINT `fk_ingconv_to` FOREIGN KEY (`to_unit`) REFERENCES `unit` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `recipe_status` enum('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`location_id`,`recipe_id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `location` (`location_id`),
  CONSTRAINT `menu_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`recipe_id`)
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `region` (
  `region_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `region_name` varchar(25) NOT NULL,
  PRIMARY KEY (`region_id`)
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
  PRIMARY KEY (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `rate` decimal(10,7) DEFAULT NULL,
  PRIMARY KEY (`from_unit`,`to_unit`),
  KEY `fk_unitconv_to` (`to_unit`),
  CONSTRAINT `fk_unitconv_from` FOREIGN KEY (`from_unit`) REFERENCES `unit` (`unit_id`),
  CONSTRAINT `fk_unitconv_to` FOREIGN KEY (`to_unit`) REFERENCES `unit` (`unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-30 12:02:50
