CREATE DATABASE  IF NOT EXISTS "giveapp_db" /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `giveapp_db`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: mysql-3a69f093-lys010921-1a6a.j.aivencloud.com    Database: giveapp_db
-- ------------------------------------------------------
-- Server version	8.0.45

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

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '44f0ba69-1f50-11f1-b5b1-722a0771f2f3:1-15,
57e10a39-2011-11f1-8738-f64a584f64a7:1-97,
9872f250-13d0-11f1-b526-ba745f8a3d20:1-27,
be54cd5c-1dff-11f1-b68a-b2acfa442128:1-16,
db016079-1cef-11f1-8f19-fa0d0c818458:1-113';

--
-- Table structure for table `CERTIFICATION_CODE`
--

DROP TABLE IF EXISTS `CERTIFICATION_CODE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CERTIFICATION_CODE` (
  `code_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int DEFAULT NULL,
  `region_code` varchar(20) NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  `used_at` datetime DEFAULT NULL,
  PRIMARY KEY (`code_id`),
  KEY `fk_certification_member` (`member_id`),
  CONSTRAINT `fk_certification_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CERTIFICATION_CODE`
--

LOCK TABLES `CERTIFICATION_CODE` WRITE;
/*!40000 ALTER TABLE `CERTIFICATION_CODE` DISABLE KEYS */;
/*!40000 ALTER TABLE `CERTIFICATION_CODE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CHAT_MESSAGE`
--

DROP TABLE IF EXISTS `CHAT_MESSAGE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CHAT_MESSAGE` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `chat_room_id` int NOT NULL,
  `sender_id` int NOT NULL,
  `content` text NOT NULL,
  `message_type` varchar(20) NOT NULL DEFAULT 'TEXT',
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  KEY `fk_chat_message_room` (`chat_room_id`),
  KEY `fk_chat_message_sender` (`sender_id`),
  CONSTRAINT `fk_chat_message_room` FOREIGN KEY (`chat_room_id`) REFERENCES `CHAT_ROOM` (`chat_room_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_message_sender` FOREIGN KEY (`sender_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_chat_message_type` CHECK ((`message_type` in (_utf8mb4'TEXT',_utf8mb4'IMAGE',_utf8mb4'SYSTEM')))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CHAT_MESSAGE`
--

LOCK TABLES `CHAT_MESSAGE` WRITE;
/*!40000 ALTER TABLE `CHAT_MESSAGE` DISABLE KEYS */;
INSERT INTO `CHAT_MESSAGE` VALUES (1,1,2,'혹시 아직 가능할까요?','TEXT',0,'2026-03-20 12:13:57'),(2,1,1,'네 가능합니다!','TEXT',0,'2026-03-20 12:13:57');
/*!40000 ALTER TABLE `CHAT_MESSAGE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CHAT_ROOM`
--

DROP TABLE IF EXISTS `CHAT_ROOM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CHAT_ROOM` (
  `chat_room_id` int NOT NULL AUTO_INCREMENT,
  `donor_id` int NOT NULL,
  `requester_id` int NOT NULL,
  `donate_id` int DEFAULT NULL,
  `request_id` int DEFAULT NULL,
  `room_status` varchar(20) NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`chat_room_id`),
  UNIQUE KEY `uq_chat_room_request` (`request_id`,`donor_id`,`requester_id`),
  UNIQUE KEY `uq_chat_room_donate` (`donate_id`,`donor_id`,`requester_id`),
  KEY `fk_chat_room_donor` (`donor_id`),
  KEY `fk_chat_room_requester` (`requester_id`),
  CONSTRAINT `fk_chat_room_donate` FOREIGN KEY (`donate_id`) REFERENCES `ITEM_DONATE` (`donate_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_room_donor` FOREIGN KEY (`donor_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_room_request` FOREIGN KEY (`request_id`) REFERENCES `ITEM_REQUEST` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_room_requester` FOREIGN KEY (`requester_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_chat_room_status` CHECK ((`room_status` in (_utf8mb4'active',_utf8mb4'closed')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CHAT_ROOM`
--

LOCK TABLES `CHAT_ROOM` WRITE;
/*!40000 ALTER TABLE `CHAT_ROOM` DISABLE KEYS */;
INSERT INTO `CHAT_ROOM` VALUES (1,1,2,1,NULL,'active','2026-03-20 12:13:57');
/*!40000 ALTER TABLE `CHAT_ROOM` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `COMMENT`
--

DROP TABLE IF EXISTS `COMMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `COMMENT` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `member_id` int NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `fk_comment_post` (`post_id`),
  KEY `fk_comment_member` (`member_id`),
  CONSTRAINT `fk_comment_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_post` FOREIGN KEY (`post_id`) REFERENCES `POST` (`post_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `COMMENT`
--

LOCK TABLES `COMMENT` WRITE;
/*!40000 ALTER TABLE `COMMENT` DISABLE KEYS */;
INSERT INTO `COMMENT` VALUES (1,1,2,'반갑습니다!','2026-03-20 12:13:58');
/*!40000 ALTER TABLE `COMMENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ITEM`
--

DROP TABLE IF EXISTS `ITEM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ITEM` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `donate_id` int DEFAULT NULL,
  `request_id` int DEFAULT NULL,
  `item_name` varchar(100) NOT NULL,
  `item_condition` varchar(30) NOT NULL,
  PRIMARY KEY (`item_id`),
  KEY `fk_item_product` (`product_id`),
  KEY `fk_item_donate` (`donate_id`),
  KEY `fk_item_request` (`request_id`),
  CONSTRAINT `fk_item_donate` FOREIGN KEY (`donate_id`) REFERENCES `ITEM_DONATE` (`donate_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_item_product` FOREIGN KEY (`product_id`) REFERENCES `PRODUCT` (`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_item_request` FOREIGN KEY (`request_id`) REFERENCES `ITEM_REQUEST` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_item_condition` CHECK ((`item_condition` in (_utf8mb4'새상품',_utf8mb4'사용감 적음',_utf8mb4'사용감 있음',_utf8mb4'상태 무관',_utf8mb4'중고 가능')))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ITEM`
--

LOCK TABLES `ITEM` WRITE;
/*!40000 ALTER TABLE `ITEM` DISABLE KEYS */;
INSERT INTO `ITEM` VALUES (1,1,1,NULL,'패딩','사용감 적음'),(2,2,NULL,1,'노트북','상태 무관'),(3,1,NULL,4,'테스트 물품','새상품');
/*!40000 ALTER TABLE `ITEM` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ITEM_DONATE`
--

DROP TABLE IF EXISTS `ITEM_DONATE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ITEM_DONATE` (
  `donate_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'open',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`donate_id`),
  KEY `fk_item_donate_member` (`member_id`),
  CONSTRAINT `fk_item_donate_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_item_donate_status` CHECK ((`status` in (_utf8mb4'open',_utf8mb4'completed',_utf8mb4'canceled',_utf8mb4'hidden')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ITEM_DONATE`
--

LOCK TABLES `ITEM_DONATE` WRITE;
/*!40000 ALTER TABLE `ITEM_DONATE` DISABLE KEYS */;
INSERT INTO `ITEM_DONATE` VALUES (1,1,'패딩 나눔합니다','상태 좋아요','open','2026-03-20 12:13:56','2026-03-20 12:13:56');
/*!40000 ALTER TABLE `ITEM_DONATE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ITEM_DONATE_IMAGE`
--

DROP TABLE IF EXISTS `ITEM_DONATE_IMAGE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ITEM_DONATE_IMAGE` (
  `donate_image_id` int NOT NULL AUTO_INCREMENT,
  `donate_id` int NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`donate_image_id`),
  KEY `fk_donate_image_donate` (`donate_id`),
  CONSTRAINT `fk_donate_image_donate` FOREIGN KEY (`donate_id`) REFERENCES `ITEM_DONATE` (`donate_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ITEM_DONATE_IMAGE`
--

LOCK TABLES `ITEM_DONATE_IMAGE` WRITE;
/*!40000 ALTER TABLE `ITEM_DONATE_IMAGE` DISABLE KEYS */;
/*!40000 ALTER TABLE `ITEM_DONATE_IMAGE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ITEM_DONATE_LIKE`
--

DROP TABLE IF EXISTS `ITEM_DONATE_LIKE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ITEM_DONATE_LIKE` (
  `donate_like_id` int NOT NULL AUTO_INCREMENT,
  `donate_id` int NOT NULL,
  `member_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`donate_like_id`),
  UNIQUE KEY `uq_donate_like` (`donate_id`,`member_id`),
  KEY `fk_donate_like_member` (`member_id`),
  CONSTRAINT `fk_donate_like_donate` FOREIGN KEY (`donate_id`) REFERENCES `ITEM_DONATE` (`donate_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_donate_like_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ITEM_DONATE_LIKE`
--

LOCK TABLES `ITEM_DONATE_LIKE` WRITE;
/*!40000 ALTER TABLE `ITEM_DONATE_LIKE` DISABLE KEYS */;
INSERT INTO `ITEM_DONATE_LIKE` VALUES (1,1,2,'2026-03-20 12:13:57');
/*!40000 ALTER TABLE `ITEM_DONATE_LIKE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ITEM_REQUEST`
--

DROP TABLE IF EXISTS `ITEM_REQUEST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ITEM_REQUEST` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'open',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `fk_item_request_member` (`member_id`),
  CONSTRAINT `fk_item_request_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_item_request_status` CHECK ((`status` in (_utf8mb4'open',_utf8mb4'completed',_utf8mb4'canceled',_utf8mb4'hidden')))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ITEM_REQUEST`
--

LOCK TABLES `ITEM_REQUEST` WRITE;
/*!40000 ALTER TABLE `ITEM_REQUEST` DISABLE KEYS */;
INSERT INTO `ITEM_REQUEST` VALUES (1,2,'노트북 필요해요','공부용입니다','open','2026-03-20 12:13:56','2026-03-20 12:13:56'),(2,4,'테스트 게시글 제목','테스트 본문 내용입니다.','open','2026-03-23 09:09:49','2026-03-23 09:09:49'),(3,4,'테스트 게시글 제목','테스트 본문 내용입니다.','open','2026-03-23 09:14:49','2026-03-23 09:14:49'),(4,4,'테스트 게시글 제목','테스트 본문 내용입니다.','open','2026-03-23 09:17:36','2026-03-23 09:17:36');
/*!40000 ALTER TABLE `ITEM_REQUEST` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ITEM_REQUEST_IMAGE`
--

DROP TABLE IF EXISTS `ITEM_REQUEST_IMAGE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ITEM_REQUEST_IMAGE` (
  `request_image_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_image_id`),
  KEY `fk_request_image_request` (`request_id`),
  CONSTRAINT `fk_request_image_request` FOREIGN KEY (`request_id`) REFERENCES `ITEM_REQUEST` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ITEM_REQUEST_IMAGE`
--

LOCK TABLES `ITEM_REQUEST_IMAGE` WRITE;
/*!40000 ALTER TABLE `ITEM_REQUEST_IMAGE` DISABLE KEYS */;
/*!40000 ALTER TABLE `ITEM_REQUEST_IMAGE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ITEM_REQUEST_LIKE`
--

DROP TABLE IF EXISTS `ITEM_REQUEST_LIKE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ITEM_REQUEST_LIKE` (
  `request_like_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `member_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_like_id`),
  UNIQUE KEY `uq_request_like` (`request_id`,`member_id`),
  KEY `fk_request_like_member` (`member_id`),
  CONSTRAINT `fk_request_like_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_request_like_request` FOREIGN KEY (`request_id`) REFERENCES `ITEM_REQUEST` (`request_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ITEM_REQUEST_LIKE`
--

LOCK TABLES `ITEM_REQUEST_LIKE` WRITE;
/*!40000 ALTER TABLE `ITEM_REQUEST_LIKE` DISABLE KEYS */;
/*!40000 ALTER TABLE `ITEM_REQUEST_LIKE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MEMBER`
--

DROP TABLE IF EXISTS `MEMBER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MEMBER` (
  `member_id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `member_pw` varchar(255) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `nickname` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `fk_member_role` (`role_id`),
  CONSTRAINT `fk_member_role` FOREIGN KEY (`role_id`) REFERENCES `ROLE` (`role_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MEMBER`
--

LOCK TABLES `MEMBER` WRITE;
/*!40000 ALTER TABLE `MEMBER` DISABLE KEYS */;
INSERT INTO `MEMBER` VALUES (1,1,'pw1','일반유저','user@test.com','010-1111-1111','2026-03-20 12:13:55','user1'),(2,3,'pw2','취약계층','benefit@test.com','010-2222-2222','2026-03-20 12:13:55','user2'),(3,2,'pw3','관리자','admin@test.com','010-3333-3333','2026-03-20 12:13:55','user3'),(4,1,'$2b$10$oAiWuLzEs3FJE91piTK4jOmsl4J.MckfRKYuSN2hqAWeeOqqMAJGC','홍길동','test@example.com','01012345678','2026-03-23 06:29:18',NULL);
/*!40000 ALTER TABLE `MEMBER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NOTICE`
--

DROP TABLE IF EXISTS `NOTICE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NOTICE` (
  `notice_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `member_id` int NOT NULL,
  PRIMARY KEY (`notice_id`),
  KEY `fk_notice_member` (`member_id`),
  CONSTRAINT `fk_notice_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NOTICE`
--

LOCK TABLES `NOTICE` WRITE;
/*!40000 ALTER TABLE `NOTICE` DISABLE KEYS */;
INSERT INTO `NOTICE` VALUES (1,'공지사항','서비스 점검 예정','2026-03-20 12:13:59',3);
/*!40000 ALTER TABLE `NOTICE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `POLICY`
--

DROP TABLE IF EXISTS `POLICY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `POLICY` (
  `policy_id` int NOT NULL AUTO_INCREMENT,
  `agency` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `target_criteria` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`policy_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `POLICY`
--

LOCK TABLES `POLICY` WRITE;
/*!40000 ALTER TABLE `POLICY` DISABLE KEYS */;
INSERT INTO `POLICY` VALUES (1,'복지부','저소득층 지원금','소득 기준');
/*!40000 ALTER TABLE `POLICY` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `POST`
--

DROP TABLE IF EXISTS `POST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `POST` (
  `post_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `view_count` int NOT NULL DEFAULT '0',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_id`),
  KEY `fk_post_member` (`member_id`),
  CONSTRAINT `fk_post_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `POST`
--

LOCK TABLES `POST` WRITE;
/*!40000 ALTER TABLE `POST` DISABLE KEYS */;
INSERT INTO `POST` VALUES (1,1,'안녕하세요','첫 커뮤니티 글입니다','2026-03-20 12:13:58',0,'2026-03-20 12:13:58');
/*!40000 ALTER TABLE `POST` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `POST_LIKE`
--

DROP TABLE IF EXISTS `POST_LIKE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `POST_LIKE` (
  `like_id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `member_id` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`like_id`),
  UNIQUE KEY `uq_post_like` (`post_id`,`member_id`),
  KEY `fk_post_like_member` (`member_id`),
  CONSTRAINT `fk_post_like_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_post_like_post` FOREIGN KEY (`post_id`) REFERENCES `POST` (`post_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `POST_LIKE`
--

LOCK TABLES `POST_LIKE` WRITE;
/*!40000 ALTER TABLE `POST_LIKE` DISABLE KEYS */;
INSERT INTO `POST_LIKE` VALUES (1,1,2,'2026-03-20 12:13:59');
/*!40000 ALTER TABLE `POST_LIKE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PRODUCT`
--

DROP TABLE IF EXISTS `PRODUCT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUCT` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(50) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUCT`
--

LOCK TABLES `PRODUCT` WRITE;
/*!40000 ALTER TABLE `PRODUCT` DISABLE KEYS */;
INSERT INTO `PRODUCT` VALUES (1,'의류','패딩'),(2,'디지털','노트북');
/*!40000 ALTER TABLE `PRODUCT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REPORT`
--

DROP TABLE IF EXISTS `REPORT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `REPORT` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `reporter_id` int NOT NULL,
  `target_type` varchar(20) NOT NULL,
  `target_id` int NOT NULL,
  `reason` text NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT '접수',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`report_id`),
  KEY `fk_report_member` (`reporter_id`),
  CONSTRAINT `fk_report_member` FOREIGN KEY (`reporter_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_report_status` CHECK ((`status` in (_utf8mb4'접수',_utf8mb4'처리중',_utf8mb4'처리완료',_utf8mb4'반려'))),
  CONSTRAINT `chk_report_target_type` CHECK ((`target_type` in (_utf8mb4'post',_utf8mb4'comment',_utf8mb4'member')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REPORT`
--

LOCK TABLES `REPORT` WRITE;
/*!40000 ALTER TABLE `REPORT` DISABLE KEYS */;
INSERT INTO `REPORT` VALUES (1,1,'post',1,'테스트 신고','접수','2026-03-20 12:13:59');
/*!40000 ALTER TABLE `REPORT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ROLE`
--

DROP TABLE IF EXISTS `ROLE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ROLE` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(30) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ROLE`
--

LOCK TABLES `ROLE` WRITE;
/*!40000 ALTER TABLE `ROLE` DISABLE KEYS */;
INSERT INTO `ROLE` VALUES (2,'ADMIN'),(3,'BENEFICIARY'),(1,'USER');
/*!40000 ALTER TABLE `ROLE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SEARCH_HISTORY`
--

DROP TABLE IF EXISTS `SEARCH_HISTORY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SEARCH_HISTORY` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `policy_id` int DEFAULT NULL,
  `query_text` varchar(255) NOT NULL,
  `search_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `recommend_policy_id` int DEFAULT NULL,
  PRIMARY KEY (`history_id`),
  KEY `fk_search_history_member` (`member_id`),
  KEY `fk_search_history_policy` (`policy_id`),
  KEY `fk_search_history_recommend_policy` (`recommend_policy_id`),
  CONSTRAINT `fk_search_history_member` FOREIGN KEY (`member_id`) REFERENCES `MEMBER` (`member_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_search_history_policy` FOREIGN KEY (`policy_id`) REFERENCES `POLICY` (`policy_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_search_history_recommend_policy` FOREIGN KEY (`recommend_policy_id`) REFERENCES `POLICY` (`policy_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SEARCH_HISTORY`
--

LOCK TABLES `SEARCH_HISTORY` WRITE;
/*!40000 ALTER TABLE `SEARCH_HISTORY` DISABLE KEYS */;
INSERT INTO `SEARCH_HISTORY` VALUES (1,2,NULL,'지원금','2026-03-20 12:13:58',1);
/*!40000 ALTER TABLE `SEARCH_HISTORY` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-29 23:20:48
