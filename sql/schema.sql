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

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'b148c0c6-f31b-11f0-b1b4-1cfa94f50f6a:1-92715';

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
) ENGINE=InnoDB AUTO_INCREMENT=661 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
 1 AS `supplier_name`,
 1 AS `order_id`,
 1 AS `purchase_date`,
 1 AS `ingredient_name`,
 1 AS `unit_price_actual`,
 1 AS `ingredient_quantity`,
 1 AS `unit_name`,
 1 AS `total ($)`*/;
SET character_set_client = @saved_cs_client;

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
/*!50001 VIEW `latest_purchase_price` AS with `latest` as (select row_number() OVER (PARTITION BY `po`.`supplier_id`,`pl`.`ingredient_id`,`l`.`location_id` ORDER BY `po`.`purchase_date` desc )  AS `rn`,`po`.`order_id` AS `order_id`,`po`.`purchase_date` AS `purchase_date`,`po`.`supplier_id` AS `supplier_id`,`s`.`supplier_name` AS `supplier`,`pl`.`ingredient_id` AS `ingredient_id`,`i`.`ingredient_name` AS `ingredient_name`,`pl`.`unit_price_actual` AS `unit_price`,`pl`.`ingredient_quantity` AS `quantity`,`pl`.`ingredient_unit` AS `unit_id`,`u`.`unit_name` AS `unit`,`po`.`location_id` AS `location_id`,`l`.`location_name` AS `location`,`total_cost`(`pl`.`ingredient_quantity`,`pl`.`unit_price_actual`) AS `total ($)` from (((((`purchase_order` `po` join `purchase_list` `pl` on((`po`.`order_id` = `pl`.`order_id`))) join `supplier` `s` on((`po`.`supplier_id` = `s`.`supplier_id`))) join `ingredient` `i` on((`pl`.`ingredient_id` = `i`.`ingredient_id`))) join `unit` `u` on((`pl`.`ingredient_unit` = `u`.`unit_id`))) join `location` `l` on((`po`.`location_id` = `l`.`location_id`)))) select `latest`.`rn` AS `rn`,`latest`.`order_id` AS `order_id`,`latest`.`purchase_date` AS `purchase_date`,`latest`.`supplier_id` AS `supplier_id`,`latest`.`supplier` AS `supplier`,`latest`.`ingredient_id` AS `ingredient_id`,`latest`.`ingredient_name` AS `ingredient_name`,`latest`.`unit_price` AS `unit_price`,`latest`.`quantity` AS `quantity`,`latest`.`unit_id` AS `unit_id`,`latest`.`unit` AS `unit`,`latest`.`location_id` AS `location_id`,`latest`.`location` AS `location`,`latest`.`total ($)` AS `total ($)` from `latest` where (`latest`.`rn` = 1) */;
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
/*!50001 VIEW `recipe_cost` AS select `recipe_to_purchase_conversion`.`recipe_id` AS `recipe_id`,`recipe_to_purchase_conversion`.`recipe_name` AS `recipe_name`,`recipe_to_purchase_conversion`.`num_servings` AS `num_servings`,`recipe_to_purchase_conversion`.`location_id` AS `location_id`,`recipe_to_purchase_conversion`.`location_name` AS `location_name`,sum(`total_cost`(`recipe_to_purchase_conversion`.`converted_quantity`,`recipe_to_purchase_conversion`.`unit_price`)) AS `total_recipe_cost`,(sum(`total_cost`(`recipe_to_purchase_conversion`.`converted_quantity`,`recipe_to_purchase_conversion`.`unit_price`)) / `recipe_to_purchase_conversion`.`num_servings`) AS `cost_per_serving` from `recipe_to_purchase_conversion` group by `recipe_to_purchase_conversion`.`recipe_id`,`recipe_to_purchase_conversion`.`recipe_name`,`recipe_to_purchase_conversion`.`num_servings`,`recipe_to_purchase_conversion`.`location_id` */;
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
/*!50001 VIEW `recipe_to_purchase_conversion` AS select `lpp`.`supplier_id` AS `supplier_id`,`s`.`supplier_name` AS `supplier_name`,`m`.`location_id` AS `location_id`,`l`.`location_name` AS `location_name`,`ri`.`recipe_id` AS `recipe_id`,`r`.`recipe_name` AS `recipe_name`,`r`.`num_servings` AS `num_servings`,`ri`.`ingredient_id` AS `ingredient_id`,`i`.`ingredient_name` AS `ingredient_name`,`ri`.`ingredient_quantity` AS `ingredient_quantity`,`ri`.`ingredient_unit` AS `recipe_unit`,`ru`.`unit_name` AS `recipe_unit_name`,`CONVERT_INGREDIENT`(`ri`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,`lpp`.`unit_id`) AS `converted_quantity`,`lpp`.`unit_id` AS `purchase_unit`,`pu`.`unit_name` AS `purchase_unit_name`,`lpp`.`unit_price` AS `unit_price`,`total_cost`(`CONVERT_INGREDIENT`(`ri`.`ingredient_id`,`ri`.`ingredient_quantity`,`ri`.`ingredient_unit`,`lpp`.`unit_id`),`lpp`.`unit_price`) AS `total_cost` from ((((((((`recipe_ingredients` `ri` join `latest_purchase_price` `lpp` on((`ri`.`ingredient_id` = `lpp`.`ingredient_id`))) join `menu` `m` on(((`ri`.`recipe_id` = `m`.`recipe_id`) and (`lpp`.`location_id` = `m`.`location_id`)))) join `unit` `ru` on((`ri`.`ingredient_unit` = `ru`.`unit_id`))) join `unit` `pu` on((`lpp`.`unit_id` = `pu`.`unit_id`))) join `recipe` `r` on((`ri`.`recipe_id` = `r`.`recipe_id`))) join `supplier` `s` on((`lpp`.`supplier_id` = `s`.`supplier_id`))) join `location` `l` on((`lpp`.`location_id` = `l`.`location_id`))) join `ingredient` `i` on((`ri`.`ingredient_id` = `i`.`ingredient_id`))) where (`m`.`recipe_status` = 'ACTIVE') order by `m`.`location_id`,`r`.`recipe_id`,`ri`.`ingredient_id`,`s`.`supplier_id` */;
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
/*!50001 VIEW `running_purchase_list` AS select `s`.`supplier_name` AS `supplier_name`,`pl`.`order_id` AS `order_id`,`po`.`purchase_date` AS `purchase_date`,`i`.`ingredient_name` AS `ingredient_name`,`pl`.`unit_price_actual` AS `unit_price_actual`,`pl`.`ingredient_quantity` AS `ingredient_quantity`,`u`.`unit_name` AS `unit_name`,`total_cost`(`pl`.`ingredient_quantity`,`pl`.`unit_price_actual`) AS `total ($)` from ((((`purchase_list` `pl` join `purchase_order` `po` on((`pl`.`order_id` = `po`.`order_id`))) join `unit` `u` on((`pl`.`ingredient_unit` = `u`.`unit_id`))) join `ingredient` `i` on((`pl`.`ingredient_id` = `i`.`ingredient_id`))) join `supplier` `s` on((`po`.`supplier_id` = `s`.`supplier_id`))) order by `s`.`supplier_name`,`po`.`purchase_date` desc */;
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

-- Dump completed on 2026-10-03 16:48:53
