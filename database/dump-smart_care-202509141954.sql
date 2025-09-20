/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.7.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: smart_care
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `academic_years`
--

DROP TABLE IF EXISTS `academic_years`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_years` (
  `academic_year_id` int(11) NOT NULL AUTO_INCREMENT,
  `year_name` varchar(4) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`academic_year_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_years`
--

LOCK TABLES `academic_years` WRITE;
/*!40000 ALTER TABLE `academic_years` DISABLE KEYS */;
INSERT INTO `academic_years` VALUES
(13,'2568','2025-05-16','2025-03-31','2025-07-07 19:47:31',1,'2025-07-07 21:40:56',1),
(14,'2569','2026-05-18','2027-03-31','2025-07-07 21:41:58',1,'2025-07-07 21:41:58',NULL),
(15,'2570','2025-08-01','2026-08-31','2025-08-01 21:14:33',1,'2025-08-01 21:14:33',NULL),
(16,'2571','2025-08-12','2026-08-12','2025-08-12 21:47:48',1,'2025-08-12 21:47:48',NULL);
/*!40000 ALTER TABLE `academic_years` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `behavior_records`
--

DROP TABLE IF EXISTS `behavior_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `behavior_records` (
  `behavior_id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `classroom_id` int(11) NOT NULL,
  `record_date` date NOT NULL,
  `milk_status` varchar(10) DEFAULT NULL,
  `lunch_status` varchar(10) DEFAULT NULL,
  `snack_status` varchar(10) DEFAULT NULL,
  `brushing_status` varchar(10) DEFAULT NULL,
  `sleeping_status` varchar(10) DEFAULT NULL,
  `toilet_status` varchar(10) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `record_status` varchar(10) DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `created_by` int(11) NOT NULL,
  `updated_date` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`behavior_id`),
  KEY `fk_behavior_student` (`student_id`),
  KEY `fk_behavior_class` (`class_id`),
  KEY `fk_behavior_classroom` (`classroom_id`),
  KEY `fk_behavior_created_by` (`created_by`),
  KEY `fk_behavior_updated_by` (`updated_by`),
  CONSTRAINT `fk_behavior_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`),
  CONSTRAINT `fk_behavior_classroom` FOREIGN KEY (`classroom_id`) REFERENCES `classrooms` (`classroom_id`),
  CONSTRAINT `fk_behavior_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_behavior_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`),
  CONSTRAINT `fk_behavior_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `behavior_records`
--

LOCK TABLES `behavior_records` WRITE;
/*!40000 ALTER TABLE `behavior_records` DISABLE KEYS */;
INSERT INTO `behavior_records` VALUES
(2,3,7,9,'2025-07-31','no','refill','yes','yes','some','yes',NULL,NULL,'2025-07-31 22:38:15',1,'2025-07-31 22:38:15',NULL),
(3,1,7,9,'2025-08-01','yes','clear','yes','yes','some','yes',NULL,NULL,'2025-08-01 21:11:10',1,'2025-08-01 21:11:10',NULL),
(4,4,8,9,'2025-08-22','yes','refill','yes','yes','some','yes',NULL,NULL,'2025-08-22 15:21:14',58,'2025-08-22 15:21:14',NULL),
(5,4,8,9,'2025-09-07','no','refill','yes','yes','full','yes','55',NULL,'2025-09-07 22:30:45',1,'2025-09-07 22:30:45',NULL);
/*!40000 ALTER TABLE `behavior_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class_history`
--

DROP TABLE IF EXISTS `class_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_history` (
  `class_history_id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `classroom_id` int(11) NOT NULL,
  `academic_year_id` int(11) NOT NULL,
  PRIMARY KEY (`class_history_id`),
  UNIQUE KEY `student_id` (`student_id`,`academic_year_id`),
  KEY `fk_classhistory_classroom` (`classroom_id`),
  KEY `fk_classhistory_academic_year` (`academic_year_id`),
  CONSTRAINT `fk_classhistory_academic_year` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`academic_year_id`),
  CONSTRAINT `fk_classhistory_classroom` FOREIGN KEY (`classroom_id`) REFERENCES `classrooms` (`classroom_id`),
  CONSTRAINT `fk_classhistory_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_history`
--

LOCK TABLES `class_history` WRITE;
/*!40000 ALTER TABLE `class_history` DISABLE KEYS */;
INSERT INTO `class_history` VALUES
(1,1,9,13),
(2,2,9,13),
(3,3,9,13),
(4,4,9,13),
(5,46,12,13);
/*!40000 ALTER TABLE `class_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classes`
--

DROP TABLE IF EXISTS `classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `classes` (
  `class_id` int(11) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(100) DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classes`
--

LOCK TABLES `classes` WRITE;
/*!40000 ALTER TABLE `classes` DISABLE KEYS */;
INSERT INTO `classes` VALUES
(7,'ห้องเตรียมอนุบาล',22,'2025-07-06 23:30:21',1,'2025-08-25 11:27:32',1),
(8,'อนุบาล 1/1',22,'2025-07-06 23:30:54',1,'2025-08-25 11:20:36',1),
(9,'อนุบาล 1/2',22,'2025-07-06 23:31:20',1,'2025-08-25 11:20:27',1);
/*!40000 ALTER TABLE `classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classroom_teachers`
--

DROP TABLE IF EXISTS `classroom_teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `classroom_teachers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `classroom_id` int(11) DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classroom_teachers`
--

LOCK TABLES `classroom_teachers` WRITE;
/*!40000 ALTER TABLE `classroom_teachers` DISABLE KEYS */;
INSERT INTO `classroom_teachers` VALUES
(42,9,6),
(48,15,4),
(49,12,5);
/*!40000 ALTER TABLE `classroom_teachers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classrooms`
--

DROP TABLE IF EXISTS `classrooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `classrooms` (
  `classroom_id` int(11) NOT NULL AUTO_INCREMENT,
  `classroom_name` varchar(100) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL,
  `classroom_male` int(11) DEFAULT NULL,
  `classroom_female` int(11) DEFAULT NULL,
  `classroom_all` int(11) DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`classroom_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classrooms`
--

LOCK TABLES `classrooms` WRITE;
/*!40000 ALTER TABLE `classrooms` DISABLE KEYS */;
INSERT INTO `classrooms` VALUES
(9,'อนุบาล 1/1',8,15,13,28,22,'2025-07-07 16:00:19',1,'2025-08-14 09:08:00',1),
(12,'อนุบาล 1/2',9,15,12,27,22,'2025-07-07 16:04:00',1,'2025-08-29 13:42:02',1),
(15,'ห้องเตรียมอนุบาล',7,3,7,10,22,'2025-08-01 21:13:57',1,'2025-08-26 22:07:12',1);
/*!40000 ALTER TABLE `classrooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_records`
--

DROP TABLE IF EXISTS `health_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_records` (
  `health_id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `attendance_status` varchar(10) NOT NULL,
  `record_date` date NOT NULL,
  `body_temperature` varchar(10) DEFAULT NULL,
  `nails_status` tinyint(1) DEFAULT NULL,
  `hair_status` tinyint(1) DEFAULT NULL,
  `teeth_status` tinyint(1) DEFAULT NULL,
  `body_status` tinyint(1) DEFAULT NULL,
  `eye_status` tinyint(1) DEFAULT NULL,
  `ear_status` tinyint(1) DEFAULT NULL,
  `nose_status` tinyint(1) DEFAULT NULL,
  `student_photo` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `classroom_id` int(11) NOT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `created_by` int(11) NOT NULL,
  `updated_date` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_by` int(11) DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`health_id`),
  KEY `fk_student` (`student_id`),
  KEY `fk_classroom` (`classroom_id`),
  KEY `fk_healthrecords_created_by` (`created_by`),
  KEY `fk_healthrecords_updated_by` (`updated_by`),
  CONSTRAINT `fk_classroom` FOREIGN KEY (`classroom_id`) REFERENCES `classrooms` (`classroom_id`),
  CONSTRAINT `fk_healthrecords_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_healthrecords_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_records`
--

LOCK TABLES `health_records` WRITE;
/*!40000 ALTER TABLE `health_records` DISABLE KEYS */;
INSERT INTO `health_records` VALUES
(2,1,'present','2025-07-23','36.5',1,1,1,0,1,0,1,'student_1111.jpg',NULL,9,'2025-07-23 19:43:09',1,'2025-07-23 19:43:09',1,NULL),
(3,1,'present','2025-07-24','36.5',1,1,1,0,1,0,1,'student_1111.jpg',NULL,9,'2025-07-24 17:12:23',1,'2025-07-24 17:12:23',1,NULL),
(13,1,'present','2025-07-28',NULL,1,1,0,1,0,1,0,'20250728_1.jpg',NULL,9,'2025-07-28 16:17:12',1,'2025-07-28 16:26:28',1,'uploads\\20250728\\9'),
(16,4,'present','2025-07-28',NULL,1,1,0,0,1,1,0,'20250728_4.jpg',NULL,9,'2025-07-28 16:36:34',1,'2025-07-28 16:36:49',1,'uploads\\20250728\\9'),
(17,3,'present','2025-07-28',NULL,NULL,NULL,0,0,NULL,NULL,NULL,'20250728_3.jpg',NULL,9,'2025-07-28 16:37:30',1,'2025-07-28 16:37:30',NULL,'uploads\\20250728\\9'),
(18,2,'absent','2025-07-28',NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,9,'2025-07-28 16:48:40',1,'2025-07-28 16:48:46',1,NULL),
(21,4,'absent','2025-08-01','36.5',1,1,0,1,0,1,1,'20250801_4.jpg',NULL,9,'2025-08-01 21:19:29',1,'2025-08-01 21:19:29',NULL,'uploads\\20250801\\9'),
(22,4,'home','2025-08-19',NULL,1,1,1,1,0,1,1,NULL,NULL,9,'2025-08-19 19:48:02',1,'2025-08-19 19:48:02',NULL,NULL),
(23,4,'present','2025-08-22',NULL,1,1,1,1,1,1,1,NULL,NULL,9,'2025-08-22 15:20:23',58,'2025-08-22 15:20:23',NULL,NULL),
(24,3,'present','2025-08-22',NULL,1,1,1,1,NULL,1,1,NULL,NULL,9,'2025-08-22 15:20:42',58,'2025-08-22 15:20:42',NULL,NULL),
(25,4,'present','2025-08-27',NULL,1,1,1,1,1,1,1,NULL,NULL,9,'2025-08-27 09:33:02',58,'2025-08-27 09:33:02',NULL,NULL),
(26,4,'present','2025-09-06','36.5',1,1,1,1,1,1,1,NULL,NULL,9,'2025-09-06 18:03:07',1,'2025-09-06 18:03:07',NULL,NULL),
(27,2,'sick','2025-09-07',NULL,0,1,1,1,0,1,0,'20250907_2.jpg',NULL,9,'2025-09-07 19:13:25',1,'2025-09-07 23:30:44',1,'uploads\\20250907\\9'),
(28,3,'present','2025-09-14',NULL,1,1,0,0,1,0,1,NULL,NULL,9,'2025-09-14 16:33:04',1,'2025-09-14 16:33:04',NULL,NULL);
/*!40000 ALTER TABLE `health_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schools`
--

DROP TABLE IF EXISTS `schools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `schools` (
  `school_id` int(11) NOT NULL AUTO_INCREMENT,
  `school_name` varchar(255) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`school_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schools`
--

LOCK TABLES `schools` WRITE;
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
INSERT INTO `schools` VALUES
(22,'ศูนย์พัฒนาเด็กเล็กเทศบาลตำบลบางละมุง','2025-07-06 23:30:04',1,'2025-08-13 21:29:10',1);
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `student_id` int(11) NOT NULL AUTO_INCREMENT,
  `id_card_number` varchar(13) NOT NULL,
  `student_code` varchar(4) NOT NULL,
  `prefix_name` varchar(10) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `nickname` varchar(100) DEFAULT NULL,
  `gender` varchar(100) NOT NULL,
  `birth_date` date NOT NULL,
  `age_range` varchar(100) DEFAULT NULL,
  `qr_code` varchar(100) DEFAULT NULL,
  `present_address` varchar(255) NOT NULL,
  `permanent_address` varchar(255) NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `student_photo` varchar(255) DEFAULT NULL,
  `bmi` decimal(5,2) DEFAULT NULL,
  `blood_group` enum('A','B','AB','O','Unknown') DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `created_by` int(11) NOT NULL,
  `updated_date` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `id_card_number` (`id_card_number`),
  UNIQUE KEY `student_code` (`student_code`),
  UNIQUE KEY `qr_code` (`qr_code`),
  KEY `fk_created_by` (`created_by`),
  KEY `fk_updated_by` (`updated_by`),
  KEY `idx_student_code` (`student_code`),
  KEY `idx_id_card` (`id_card_number`),
  KEY `idx_name` (`first_name`,`last_name`),
  CONSTRAINT `fk_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES
(1,'1209703480931','1008','เด็กหญิง','ชญานิศ','ประทุมแดง','ใบบุญ','หญิง','2022-09-17','2 ปี 11 เดือน','0000','50/13 ม.3 บางละมุง บางละมุง ชลบุรี 20150','50/13 ม.3 บางละมุง บางละมุง ชลบุรี 20150',13.36402022,100.98257535,1,'student_1111.jpg',NULL,'A','2025-07-17 17:15:36',1,'2025-09-05 08:09:12',1),
(2,'1209602230173','1007','เด็กหญิง','พัณณิตา','เจริญยิ่ง','อลิซ','หญิง','2022-09-03','2 ปี 11 เดือน','0001','33 ม.2 บางละมุง บางละมุง ชลบุรี 20150','ุุุุ66/18 ม.2 บางละมุง บางละมุง ชลบุรี 20150',13.70539822,100.59518588,1,'student_1111.jpg',NULL,'A','2025-07-17 17:15:36',1,'2025-08-29 11:57:35',1),
(3,'1209602229230','1006','เด็กหญิง','ณัฐพร','บัวภา','ตั้งโอ๋','หญิง','2022-08-25','3 ปี 0 เดือน','0002','50/19 ม.3 บางละมุง บางละมุง ชลบุรี 20150','50/19 ม.3 บางละมุง บางละมุง ชลบุรี 20150',13.70539822,100.59518588,1,'student_1111.jpg',NULL,'A','2025-07-17 17:15:36',1,'2025-08-29 11:58:00',1),
(4,'1200902033782','1005','เด็กหญิง','อริสา','คำสงค์','ข้าวหอม','หญิง','2022-08-11','3 ปี 0 เดือน','0003','347 ม.1 บางละมุง บางละมุง ชลบุรี 20150','347 ม.1 บางละมุง บางละมุง ชลบุรี 20150',13.70539822,100.59518588,1,'student_1111.jpg',NULL,'A','2025-07-17 17:15:36',1,'2025-08-14 12:31:11',1),
(46,'1209602227245','1004','เด็กหญิง','กัญญาณัฐ','ทับฤทธิ์','เกรซ','หญิง','2022-08-04','3 ปี 0 เดือน','1111','93/19 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','93/19 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150',13.70539822,100.59518588,1,'student_1111.jpg',NULL,'A','2025-07-17 17:15:36',1,'2025-08-14 12:28:53',1),
(72,'1209602222081','1002','เด็กชาย','ชนาธิป','จังพล','แทนคุณ','ชาย','2022-06-09','3 ปี 2 เดือน','1002','บางละมุง บางละมุง ชลบุรี 20150','บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_1002.jpg',NULL,'A','2025-08-14 12:12:38',1,'2025-08-14 12:15:16',1),
(73,'1100704966619','1001','เด็กชาย','ณัฐภัทร','กมลมณีรัตน์','ปังปอนด์','ชาย','2022-05-26','3 ปี 2 เดือน','1001','5/36 ม.2 บางละมุง บางละมุง ชลบุรี 20150','279/58 ม.11 ทุ่งสุขลา ศรีราชา ชลบุรี 20230',NULL,NULL,1,'student_1001.jpg',NULL,'','2025-08-14 12:18:23',1,NULL,NULL),
(74,'1209602236708','1003','เด็กชาย','ธนันท์ชัย','เจนเขตการ','สกาย','ชาย','2022-11-04','2 ปี 9 เดือน','1003','44 ม.2 บางละมุง บางละมุง ชลบุรี 20150','44 ม.2 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_1003.jpg',NULL,'','2025-08-14 12:22:24',1,'2025-08-14 12:23:17',1),
(75,'1209703483077','1009','เด็กหญิง','นิชาภัทร','คำย้อม','ขนมผิง','หญิง','2022-10-02','2 ปี 10 เดือน','1009','บางละมุง บางละมุง ชลบุรี 20150','บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_1009.jpg',NULL,'','2025-08-14 21:08:03',1,'2025-08-14 21:11:01',1),
(76,'1159900757707','1011','เด็กหญิง','กัลยกร','สาริกา','กาจิน','หญิง','2022-09-25','2 ปี 10 เดือน','1011','126/1 ม.5 บางละมุง บางละมุง ชลบุรี 20150','126/1 ม.5 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_1011.jpg',NULL,'','2025-08-14 21:10:52',1,NULL,NULL),
(77,'1209703425409','0913','เด็กชาย','ณัฐณภัทร','สิงห์ทอง','กู้ด','ชาย','2021-06-18','4 ปี 1 เดือน','0913','105 ม.3 บางละมุง บางละมุง ชลบุรี 20150','105 ม.3 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0913.jpg',NULL,'','2025-08-14 21:15:14',1,'2025-08-14 21:20:38',1),
(78,'1209602195840','0914','เด็กชาย','วรัชญ์ฐภัค','สุนินทรบูรณ์','พร้อมเพย์','ชาย','2021-12-30','3 ปี 7 เดือน','0914','บางละมุง บางละมุง ชลบุรี 20150','บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0914.jpg',NULL,'','2025-08-14 21:18:39',1,'2025-08-14 21:18:50',1),
(79,'1209602185178','0915','เด็กชาย','ธนกฤต','แสงจันทร์','บีม','ชาย','2021-05-19','4 ปี 2 เดือน','0915','16/2 ม.3 บางละมุง บางละมุง ชลบุรี 20150','16/2 ม.3 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0915.jpg',NULL,'','2025-08-14 21:24:27',1,NULL,NULL),
(80,'1209602196382','0917','เด็กชาย','ณัฐชานนทร์','สมหนองบัว','กันต์','ชาย','2021-09-07','3 ปี 11 เดือน','0917','66/99 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','83/1 ม.2 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0917.jpg',NULL,'','2025-08-14 21:28:08',1,NULL,NULL),
(81,'1209301381318','0918','เด็กชาย','วัชระ','ก้อนเงิน','คิม','ชาย','2021-09-25','3 ปี 10 เดือน','0918','72/55 ม.4 บางละมุง บางละมุง ชลบุรี 20150','72/55 ม.4 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0918.jpg',NULL,'','2025-08-14 21:30:45',1,NULL,NULL),
(82,'1209602200843','0961','เด็กชาย','ธนกฤต','จารัตน์','พู่กัน','ชาย','2021-10-16','3 ปี 9 เดือน','0961','239 ม.5 บางละมุง บางละมุง ชลบุรี 20150','239 ม.5 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0961.jpg',NULL,'','2025-08-14 21:33:19',1,NULL,NULL),
(83,'1209602217291','0964','เด็กชาย','ชลธร','คอเซ็ม','สตาฟ','ชาย','2022-04-11','3 ปี 4 เดือน','0964','148 ม.2 บางละมุง บางละมุง ชลบุรี 20150','148 ม.2 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0964.jpg',NULL,'','2025-08-14 21:39:03',1,NULL,NULL),
(84,'1209703421683','0965','เด็กชาย','ก้องภพ','วงค์ตาผา','ก้อง','ชาย','2021-05-25','4 ปี 2 เดือน','0965','66/98 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','194 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0965.jpg',NULL,'','2025-08-14 21:43:29',1,NULL,NULL),
(85,'1209602190180','0966','เด็กชาย','จักรพรรดิ','ทัศมีชัย','อั๋น','ชาย','2021-07-10','4 ปี 1 เดือน','0966','50/3 ม.3 บางละมุง บางละมุง ชลบุรี 20150','50/3 ม.3 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0966.jpg',NULL,'','2025-08-14 21:46:05',1,NULL,NULL),
(86,'0020961284218','0967','เด็กชาย','ออง ลิน เท่','-','เบ้น','ชาย','2021-07-16','4 ปี 0 เดือน','0967','1/18 ม.2 บางละมุง บางละมุง ชลบุรี 20150','1/18 ม.2 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0967.jpg',NULL,'','2025-08-14 21:48:58',1,NULL,NULL),
(87,'1399900723321','0968','เด็กชาย','ทรงเกียรติ','ราชภักดี','อ้าย อ้าย','ชาย','2021-09-14','3 ปี 10 เดือน','0968','93/26 ม.4 บางละมุง บางละมุง ชลบุรี 20150','93/26 ม.4 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0968.jpg',NULL,'','2025-08-14 21:57:59',1,NULL,NULL),
(88,'1209703441676','0969','เด็กชาย','ณัฐวุฒิ','สนธิวงษ์','ปลื้ม','ชาย','2021-10-07','3 ปี 10 เดือน','0969','','',NULL,NULL,1,'student_0969.jpg',NULL,'','2025-08-14 22:00:20',1,NULL,NULL),
(89,'1209602202013','0970','เด็กชาย','ภูริวัฒน์','ใจคง','โนบิ','ชาย','2021-10-25','3 ปี 9 เดือน','0970','89/13 ม.5 บางละมุง บางละมุง ชลบุรี 20150','89/13 ม.5 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0970.jpg',NULL,'','2025-08-14 22:04:12',1,NULL,NULL),
(90,'1239900701492','0971','เด็กชาย','ณัฐพงษ์','อภิบาลศรี','จีโน่','ชาย','2021-10-29','3 ปี 9 เดือน','0971','77 ม.1 บางละมุง บางละมุง ชลบุรี 20150','127/5 ม.5 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0971.jpg',NULL,'','2025-08-14 22:16:28',1,NULL,NULL),
(91,'1209301377485','0932','เด็กหญิง','ปณัฏฏา','วัฒนากังชัย','เอมมิลี่','หญิง','2021-06-02','4 ปี 2 เดือน','0932','73/1 ม.1 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','388/6 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0932.jpg',NULL,'','2025-08-14 22:43:36',1,NULL,NULL),
(92,'1209602187227','0934','เด็กหญิง','ประภัสสร','เห็มชูยิ่ง','เรดี้','หญิง','2021-06-27','4 ปี 1 เดือน','0934','99/51 ม.4 บางละมุง บางละมุง ชลบุรี 20150','99/51 ม.4 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0934.jpg',NULL,'','2025-08-14 23:01:48',1,NULL,NULL),
(93,'1209703426405','0935','เด็กหญิง','อันดาลิน','คชรินทร์','อันดา','หญิง','2021-06-09','4 ปี 2 เดือน','0935','188/26 ม.1 บางละมุง บางละมุง ชลบุรี 20150','188/26 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0935.jpg',NULL,'','2025-08-14 23:06:16',1,NULL,NULL),
(94,'1209602190449','0936','เด็กหญิง','สิรินดา','อินจันทร์','กุล','หญิง','2021-07-04','4 ปี 1 เดือน','0936','118 ม.2 บางละมุง บางละมุง ชลบุรี 20150','118 ม.2 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0936.jpg',NULL,'','2025-08-14 23:08:55',1,NULL,NULL),
(95,'1209602189718','0937','เด็กหญิง','รินรดา','พัชรกุล','อลิซ','หญิง','2021-07-05','4 ปี 1 เดือน','0937','43 ม.2 บางละมุง บางละมุง ชลบุรี 20150','43 ม.2 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0937.jpg',NULL,'','2025-08-14 23:13:51',1,NULL,NULL),
(96,'1209703434114','0938','เด็กหญิง','กชนิภา','เงินวิเศษ','ปราย','หญิง','2021-08-14','3 ปี 11 เดือน','0938','106/3 ม.4 บางละมุง บางละมุง ชลบุรี 20150','106/3 ม.4 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0938.jpg',NULL,'','2025-08-14 23:16:36',1,NULL,NULL),
(97,'1209602195564','0939','เด็กหญิง','นิรมล','อ่อนเกิด','มิเกล','หญิง','2021-08-27','3 ปี 11 เดือน','0939','66/8 ม.2 บางละมุง บางละมุง ชลบุรี 20150','999 ม.6 นาเกลือ บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0939.jpg',NULL,'','2025-08-14 23:19:26',1,NULL,NULL),
(98,'1209602195441','0940','เด็กหญิง','จิณัฐตา','ม่วงหมัย','โชแปง','หญิง','2021-08-27','3 ปี 11 เดือน','0940','71/343 ม.4 บางละมุง บางละมุง ชลบุรี 20150','71/343 ม.4 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0940.jpg',NULL,'','2025-08-14 23:23:39',1,NULL,NULL),
(99,'1350102215575','0941','เด็กหญิง','อภิสรา','จันทะมาตย์','ไอด้า','หญิง','2021-06-24','4 ปี 1 เดือน','0941','90/9 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','90/9 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0941.jpg',NULL,'','2025-08-14 23:30:27',1,NULL,NULL),
(100,'1209301382683','0942','เด็กหญิง','กรชวัล','ฤทธิ์รักษา','ปลายฝน','หญิง','2021-10-31','3 ปี 9 เดือน','0942','86 ม.1 บางละมุง บางละมุง ชลบุรี 20150','216/25 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0942.jpg',NULL,'','2025-08-14 23:34:26',1,NULL,NULL),
(101,'1849701166729','0960','เด็กหญิง','สุทัตตา','พลรักษ์','ต้องมนต์','หญิง','2021-10-16','3 ปี 9 เดือน','0960','100/2 ม.1 บางละมุง บางละมุง ชลบุรี 20150','100/2 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0960.jpg',NULL,'','2025-08-14 23:39:25',1,NULL,NULL),
(102,'1209602198822','0963','เด็กหญิง','พิมพ์ณดา','โพธิ์ด้วง','ปริม','หญิง','2021-09-27','3 ปี 10 เดือน','0963','58/18 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','79/8 ม.5 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0963.jpg',NULL,'','2025-08-14 23:47:47',1,NULL,NULL),
(103,'1208900022365','1000','เด็กหญิง','พิชญธิดา','สมบุตร','ไอวี่','หญิง','2021-04-08','4 ปี 4 เดือน','1000','9/9 ม.1 บางละมุง บางละมุง ชลบุรี 20150','9/9 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,NULL,NULL,'','2025-08-14 23:50:47',1,NULL,NULL),
(104,'1209703455472','0982','เด็กชาย','ณัทณัฏฐ์','ยศประสงค์','อบอุ่น','ชาย','2022-01-24','3 ปี 6 เดือน','0982','138/419 ม.3 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','138/419 ม.3 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0982.jpg',NULL,'','2025-08-14 23:54:37',1,NULL,NULL),
(105,'1209602202838','0972','เด็กชาย','จิรายุ','โชติสันเทียะ','ต้นหนาว','ชาย','2021-11-02','3 ปี 9 เดือน','0972','270/1 ม.1 บางละมุง บางละมุง ชลบุรี 20150','270/1 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0972.jpg',NULL,'','2025-08-14 23:58:04',1,NULL,NULL),
(106,'1209602203311','0973','เด็กชาย','กวินนภัทร','แซ่เอี้ย','ก๊อตจิ','ชาย','2021-11-13','3 ปี 9 เดือน','0973','4/92 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','29 ม.5 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0973.jpg',NULL,'','2025-08-15 00:07:30',1,'2025-08-15 01:51:09',1),
(107,'1209703446473','0974','เด็กชาย','กมลเทพ','ภูจ้อย','ก๊อต','ชาย','2021-11-13','3 ปี 9 เดือน','0974','239/2 ม.1 บางละมุง บางละมุง ชลบุรี 20150','239/2 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0974.jpg',NULL,'','2025-08-15 00:11:14',1,NULL,NULL),
(108,'1209703447054','0975','เด็กชาย','ปราชญา','ชัยสิงห์หา','สิงโต','ชาย','2021-11-18','3 ปี 8 เดือน','0975','131/5 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','244 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0975.jpg',NULL,'','2025-08-15 00:15:01',1,NULL,NULL),
(109,'1209703449511','0976','เด็กชาย','วรวิทย์','สิ่งสิน','ซิมซี','ชาย','2021-12-07','3 ปี 8 เดือน','0976','15/154 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','224/85 ม.5 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0976.jpg',NULL,'','2025-08-15 00:18:18',1,NULL,NULL),
(110,'1409600693891','0977','เด็กชาย','ธนวิชญ์','ธะนีรมย์','พอร์ช','ชาย','2021-12-08','3 ปี 8 เดือน','0977','223/69 ม.5 บางละมุง บางละมุง ชลบุรี 20150','223/69 ม.5 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0977.jpg',NULL,'','2025-08-15 00:25:02',1,NULL,NULL),
(111,'1209602208526','0979','เด็กชาย','นนทกร','สมทะษะ','ชิว ชิว','ชาย','2021-12-29','3 ปี 7 เดือน','0979','113/101 ม.5 บางละมุง บางละมุง ชลบุรี 20150','113/101 ม.5 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0979.jpg',NULL,'','2025-08-15 00:28:23',1,NULL,NULL),
(112,'1209703453763','0980','เด็กชาย','ภานุพงษ์','เขียวรักษา','มาเฟีย','ชาย','2022-01-13','3 ปี 7 เดือน','0980','77/11 ม.1 บางละมุง บางละมุง ชลบุรี 20150','112/2 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0980.jpg',NULL,'','2025-08-15 00:31:13',1,NULL,NULL),
(113,'1209602210245','0981','เด็กชาย','ธนาธิป','เชิดชู','กัปตัน','ชาย','2022-01-14','3 ปี 7 เดือน','0981','150/90 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','13/3 ม.9 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0981.jpg',NULL,'','2025-08-15 00:36:22',1,NULL,NULL),
(114,'1209703459265','0984','เด็กชาย','ภานุวิชญ์','งามเจริญ','ต้นกล้า','ชาย','2022-03-03','3 ปี 5 เดือน','0984','30/10 ม.4 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','307/2 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0984.jpg',NULL,'','2025-08-15 00:43:27',1,NULL,NULL),
(115,'1209602216405','0985','เด็กชาย','สถิตคุณ','สิงสกุล','ไอซ์','ชาย','2022-03-29','3 ปี 4 เดือน','0985','28/8 ม.1 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','100/1 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0985.jpg',NULL,'','2025-08-15 00:49:43',1,'2025-08-15 01:51:00',1),
(116,'1209703462797','0986','เด็กชาย','อัครเดช','บุตรสุวรรณ','เมษ','ชาย','2022-04-08','3 ปี 4 เดือน','0986','188/54 ม.1 บางละมุง บางละมุง ชลบุรี 20150','97/2 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0986.jpg',NULL,'','2025-08-15 00:53:28',1,NULL,NULL),
(117,'1559900819229','0987','เด็กชาย','นัทธ์ฐภัค','มาพิบูลย์','ภูผา','ชาย','2022-04-11','3 ปี 4 เดือน','0987','71/175 ม.4 บางละมุง บางละมุง ชลบุรี 20150','71/175 ม.4 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0987.jpg',NULL,'','2025-08-15 00:58:13',1,'2025-08-15 01:50:51',1),
(118,'1209703439884','1010','เด็กชาย','สิรวิชญ์','บัณฑิตย์','บีฟ','ชาย','2021-09-24','3 ปี 10 เดือน','1010','351/23 ม.1 บางละมุง บางละมุง ชลบุรี 20150','351/23 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_1010.jpg',NULL,'','2025-08-15 01:01:21',1,NULL,NULL),
(119,'1209703427185','0988','เด็กหญิง','สุจินันท์','เผื่อนเกษม','ไอริน','หญิง','2021-06-25','4 ปี 1 เดือน','0988','29/1 ม.5 บางละมุง บางละมุง ชลบุรี 20150','29/1 ม.5 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0988.jpg',NULL,'','2025-08-15 01:03:50',1,NULL,NULL),
(120,'1209703428343','0989','เด็กหญิง','ณัฎฐณิชา','สุพร','ตอง','หญิง','2021-07-09','4 ปี 1 เดือน','0989','71/92 ม.4 บางละมุง บางละมุง ชลบุรี 20150','71/92 ม.4 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0989.jpg',NULL,'','2025-08-15 01:06:11',1,NULL,NULL),
(121,'1609901495442','0990','เด็กหญิง','ญาณิศา','สีเรืองพัน','เฌอแตม','หญิง','2021-07-29','4 ปี 0 เดือน','0990','63/40 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','114/3 ม.3 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0990.jpg',NULL,'','2025-08-15 01:09:48',1,NULL,NULL),
(122,'1199901852355','0991','เด็กหญิง','ธิดาภัทร','สืบจุ้ย','เก้า','หญิง','2021-09-19','3 ปี 10 เดือน','0991','15/254 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','15/254 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0991.jpg',NULL,'','2025-08-15 01:16:11',1,NULL,NULL),
(123,'1209602198997','0992','เด็กหญิง','กุลณัฐ','จอมหงษ์','ออร์เกรซ','หญิง','2021-09-29','3 ปี 10 เดือน','0992','','',NULL,NULL,1,'student_0992.jpg',NULL,'','2025-08-15 01:18:43',1,NULL,NULL),
(124,'1417100175415','0993','เด็กหญิง','มัลลิกา','ปฏิโยเก','มะลิ','หญิง','2021-11-13','3 ปี 9 เดือน','0993','95/42 ม.2 บางละมุง บางละมุง ชลบุรี 20150','95/42 ม.2 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0993.jpg',NULL,'','2025-08-15 01:21:44',1,NULL,NULL),
(125,'1209602218866','0994','เด็กหญิง','กชมณ','พาลี','นินิว','หญิง','2022-01-01','3 ปี 7 เดือน','0994','105 ม.1 บางละมุง บางละมุง ชลบุรี 20150','105 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0994.jpg',NULL,'','2025-08-15 01:24:18',1,NULL,NULL),
(126,'1209602209000','0995','เด็กหญิง','ณัฐนันท์','วงเดือน','เมอร์ลิน','หญิง','2022-01-03','3 ปี 7 เดือน','0995','46 ม.3 บางละมุง บางละมุง ชลบุรี 20150','46 ม.3 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0995.jpg',NULL,'','2025-08-15 01:26:41',1,NULL,NULL),
(127,'1209602210385','0996','เด็กหญิง','กมลชนก','บุญปรก','บะหมี่','หญิง','2022-01-17','3 ปี 6 เดือน','0996','บางละมุง บางละมุง ชลบุรี 20150','บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0996.jpg',NULL,'','2025-08-15 01:32:27',1,'2025-08-15 01:35:16',1),
(128,'1209602212728','0997','เด็กหญิง','อริสา','แย้มมีเชาว์','โมเมย์','หญิง','2022-02-15','3 ปี 5 เดือน','0997','49 ม.1 บางละมุง บางละมุง ชลบุรี 20150','49 ม.1 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0997.jpg',NULL,'','2025-08-15 01:34:31',1,NULL,NULL),
(129,'1209703458889','0998','เด็กหญิง','อันนา','หอมขจร','อันนา','หญิง','2022-02-27','3 ปี 5 เดือน','0998','15/158 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150','15/158 ม.2 ตะเคียนเตี้ย บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0998.jpg',NULL,'','2025-08-15 01:37:58',1,NULL,NULL),
(130,'1209602218751','0999','เด็กหญิง','สุภิญญ์ยุพา','ทับดารา','มายด์','หญิง','2022-04-28','3 ปี 3 เดือน','0999','137/1 ม.2 บางละมุง บางละมุง ชลบุรี 20150','137/1 ม.2 บางละมุง บางละมุง ชลบุรี 20150',NULL,NULL,1,'student_0999.jpg',NULL,'','2025-08-15 01:41:28',1,NULL,NULL),
(131,'1219901876539','0978','เด็กชาย','จิตติพัฒน์','สาระธรรม','พอร์ช','ชาย','2021-12-22','3 ปี 7 เดือน','0978','','',NULL,NULL,1,'student_0978.jpg',NULL,'','2025-08-15 01:50:26',1,NULL,NULL);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teachers`
--

DROP TABLE IF EXISTS `teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `teachers` (
  `teacher_id` int(11) NOT NULL AUTO_INCREMENT,
  `prefix_name` varchar(100) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone_number` varchar(100) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`teacher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES
(4,'นางสาว','จิรนันท์','คูสุวรรณ์',22,'','','2025-08-13 20:55:29',1,NULL,NULL),
(5,'นาง','วิชิลดา','วงศ์เกิด',22,'','','2025-08-14 09:04:34',1,NULL,NULL),
(6,'นางสาว','นภชรภัส','อินทรโคราช',22,'','','2025-08-14 09:05:44',1,NULL,NULL);
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL COMMENT 'int (FK) [user_id]',
  `updated_date` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL COMMENT 'int (FK) [user_id]',
  `teacher_id` int(11) DEFAULT NULL COMMENT 'int (FK) [teacher_id]',
  PRIMARY KEY (`user_id`),
  KEY `fk_users_teacher` (`teacher_id`),
  CONSTRAINT `fk_users_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'admin','$2b$12$Wq0aRZCarEKtuNYsONaCSOnIQ5.RGE.PFRsMM5aFcoO45Uy9lShGu','phcstenkku@gmail.com',NULL,NULL,NULL,NULL,6),
(58,'tanet','$2b$12$pSfZ5np5EQMRkKiVoFBRF.OtYD5zYQeBpRffX7OpEIW8HV1EULRTG','tanet5049@gmail.com','2025-08-15 11:00:57',1,'2025-08-15 11:00:57',NULL,NULL),
(59,'admin01','$2b$12$Wq0aRZCarEKtuNYsONaCSOnIQ5.RGE.PFRsMM5aFcoO45Uy9lShGu','admin01@gmail.com','2025-08-30 15:20:22',1,'2025-08-30 15:20:22',NULL,NULL),
(60,'teacher1','$2b$12$yBkrQWzEdEOYA8k9APgTUeCJH4bENkUZapLUXP/6HHCrXHv9CfOYS','teacher1@gmail.com','2025-09-07 17:20:29',1,'2025-09-14 19:41:32',60,6);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'smart_care'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-09-14 19:54:16
