-- MySQL dump 10.13  Distrib 8.0.33, for Linux (x86_64)
--
-- Host: localhost    Database: DogWalkService
-- ------------------------------------------------------
-- Server version	8.0.33-0ubuntu0.22.04.2

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
-- Table structure for table `Dogs`
--

DROP TABLE IF EXISTS `Dogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Dogs` (
  `dog_id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `size` enum('small','medium','large') NOT NULL,
  PRIMARY KEY (`dog_id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `Dogs_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Dogs`
--

LOCK TABLES `Dogs` WRITE;
/*!40000 ALTER TABLE `Dogs` DISABLE KEYS */;
INSERT INTO `Dogs` VALUES (1,1,'Max','medium'),(2,3,'Bella','small'),(3,5,'Ronnie','large'),(4,5,'Wayne','large'),(5,5,'Donna','medium');
/*!40000 ALTER TABLE `Dogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('owner','walker') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'alice123','alice@example.com','hashed123','owner','2025-06-20 07:08:58'),(2,'bobwalker','bob@example.com','hashed456','walker','2025-06-20 07:08:58'),(3,'carol123','carol@example.com','hashed789','owner','2025-06-20 07:08:58'),(4,'ottowalker','otto@otto.com','hashed000','walker','2025-06-20 07:08:58'),(5,'ottoowner','otto@owner.com','hashed111','owner','2025-06-20 07:08:58'),(6,'demo','demo@example.com','demo123','walker','2025-06-20 07:58:08');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WalkApplications`
--

DROP TABLE IF EXISTS `WalkApplications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WalkApplications` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `walker_id` int NOT NULL,
  `applied_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','accepted','rejected') DEFAULT 'pending',
  PRIMARY KEY (`application_id`),
  UNIQUE KEY `unique_application` (`request_id`,`walker_id`),
  KEY `walker_id` (`walker_id`),
  CONSTRAINT `WalkApplications_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `WalkRequests` (`request_id`),
  CONSTRAINT `WalkApplications_ibfk_2` FOREIGN KEY (`walker_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WalkApplications`
--

LOCK TABLES `WalkApplications` WRITE;
/*!40000 ALTER TABLE `WalkApplications` DISABLE KEYS */;
INSERT INTO `WalkApplications` VALUES (1,1,6,'2025-06-20 10:33:01','pending'),(2,4,6,'2025-06-20 10:33:03','pending'),(3,5,6,'2025-06-20 10:33:04','pending'),(4,8,6,'2025-06-20 10:34:42','pending');
/*!40000 ALTER TABLE `WalkApplications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WalkRatings`
--

DROP TABLE IF EXISTS `WalkRatings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WalkRatings` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `walker_id` int NOT NULL,
  `owner_id` int NOT NULL,
  `rating` int DEFAULT NULL,
  `comments` text,
  `rated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  UNIQUE KEY `unique_rating_per_walk` (`request_id`),
  KEY `walker_id` (`walker_id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `WalkRatings_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `WalkRequests` (`request_id`),
  CONSTRAINT `WalkRatings_ibfk_2` FOREIGN KEY (`walker_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `WalkRatings_ibfk_3` FOREIGN KEY (`owner_id`) REFERENCES `Users` (`user_id`),
  CONSTRAINT `WalkRatings_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WalkRatings`
--

LOCK TABLES `WalkRatings` WRITE;
/*!40000 ALTER TABLE `WalkRatings` DISABLE KEYS */;
/*!40000 ALTER TABLE `WalkRatings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WalkRequests`
--

DROP TABLE IF EXISTS `WalkRequests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WalkRequests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `dog_id` int NOT NULL,
  `requested_time` datetime NOT NULL,
  `duration_minutes` int NOT NULL,
  `location` varchar(255) NOT NULL,
  `status` enum('open','accepted','completed','cancelled') DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `dog_id` (`dog_id`),
  CONSTRAINT `WalkRequests_ibfk_1` FOREIGN KEY (`dog_id`) REFERENCES `Dogs` (`dog_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WalkRequests`
--

LOCK TABLES `WalkRequests` WRITE;
/*!40000 ALTER TABLE `WalkRequests` DISABLE KEYS */;
INSERT INTO `WalkRequests` VALUES (1,1,'2025-06-10 08:00:00',30,'Parklands','accepted','2025-06-20 07:09:18'),(2,2,'2025-06-10 09:30:00',45,'Beachside Ave','accepted','2025-06-20 07:09:18'),(3,3,'2021-06-11 07:00:00',60,'The Moon','completed','2025-06-20 07:09:18'),(4,4,'2025-06-11 11:30:00',40,'Goolwa','accepted','2025-06-20 07:09:18'),(5,5,'2025-06-12 18:15:00',35,'Burnside','accepted','2025-06-20 07:09:18'),(6,3,'2025-06-11 19:15:00',4,'3 bp','open','2025-06-20 09:45:37'),(7,1,'2025-06-29 19:47:00',45,'Dog','open','2025-06-20 10:17:40'),(8,4,'2025-07-06 20:04:00',43,'place','accepted','2025-06-20 10:34:28');
/*!40000 ALTER TABLE `WalkRequests` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-20 11:33:05
