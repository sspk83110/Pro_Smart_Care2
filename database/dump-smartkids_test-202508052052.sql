/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.7.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: smartkids_test
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_years`
--

LOCK TABLES `academic_years` WRITE;
/*!40000 ALTER TABLE `academic_years` DISABLE KEYS */;
INSERT INTO `academic_years` VALUES
(13,'2568','2025-05-16','2025-03-31','2025-07-07 19:47:31',1,'2025-07-07 21:40:56',1),
(14,'2569','2026-05-18','2027-03-31','2025-07-07 21:41:58',1,'2025-07-07 21:41:58',NULL),
(15,'2570','2025-08-01','2026-08-31','2025-08-01 21:14:33',1,'2025-08-01 21:14:33',NULL);
/*!40000 ALTER TABLE `academic_years` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
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
(21,4,'absent','2025-08-01','36.5',1,1,0,1,0,1,1,'20250801_4.jpg',NULL,9,'2025-08-01 21:19:29',1,'2025-08-01 21:19:29',NULL,'uploads\\20250801\\9');
/*!40000 ALTER TABLE `health_records` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `behavior_records`
--

LOCK TABLES `behavior_records` WRITE;
/*!40000 ALTER TABLE `behavior_records` DISABLE KEYS */;
INSERT INTO `behavior_records` VALUES
(2,3,7,9,'2025-07-31','no','refill','yes','yes','some','yes',NULL,NULL,'2025-07-31 22:38:15',1,'2025-07-31 22:38:15',NULL),
(3,1,7,9,'2025-08-01','yes','clear','yes','yes','some','yes',NULL,NULL,'2025-08-01 21:11:10',1,'2025-08-01 21:11:10',NULL);
/*!40000 ALTER TABLE `behavior_records` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classroom_teachers`
--

LOCK TABLES `classroom_teachers` WRITE;
/*!40000 ALTER TABLE `classroom_teachers` DISABLE KEYS */;
INSERT INTO `classroom_teachers` VALUES
(12,9,1),
(13,9,2),
(24,12,2),
(25,15,1),
(26,15,3);
/*!40000 ALTER TABLE `classroom_teachers` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teachers`
--

LOCK TABLES `teachers` WRITE;
/*!40000 ALTER TABLE `teachers` DISABLE KEYS */;
INSERT INTO `teachers` VALUES
(1,'ครู','หญิง','รักเด็ก',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,'ครู','สมชาย','ใจดี',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(3,'นาง','สมชาย','สามารถ',22,'xxd@gmail.com','0812345678','2025-08-01 21:13:16',1,NULL,NULL);
/*!40000 ALTER TABLE `teachers` ENABLE KEYS */;
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
(7,'อนุบาล 1',22,'2025-07-06 23:30:21',1,NULL,NULL),
(8,'อนุบาล 2',22,'2025-07-06 23:30:54',1,'2025-07-06 23:31:07',1),
(9,'อนุบาล 3',22,'2025-07-06 23:31:20',1,NULL,NULL);
/*!40000 ALTER TABLE `classes` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES
(1,'0000000000000','0000','เด็กหญิง','รุ่งนภา','เด่นหล้า','รุ่ง','หญิง','2019-07-23','5 ปี 11 เดือน','0000','10 พระบรมมหาราชวัง พระนคร กรุงเทพมหานคร 10200','144/4 บ้านโกทา ในเมือง เมืองขอนแก่น ขอนแก่น 40000',13.70539822,100.59518588,1,'student_1111.jpg',NULL,'A','2025-07-17 17:15:36',1,'2025-07-17 17:40:31',1),
(2,'0000000000001','0001','เด็กชาย','กร','เด่นภัย','กร','ชาย','2019-07-23','5 ปี 11 เดือน','0001','10 พระบรมมหาราชวัง พระนคร กรุงเทพมหานคร 10200','144/4 บ้านโกทา ในเมือง เมืองขอนแก่น ขอนแก่น 40000',13.70539822,100.59518588,1,'student_1111.jpg',NULL,'A','2025-07-17 17:15:36',1,'2025-07-17 17:40:31',1),
(3,'0000000000002','0002','เด็กชาย','พิรัชต์','เด่นดี','รัช','ชาย','2019-07-23','5 ปี 11 เดือน','0002','10 พระบรมมหาราชวัง พระนคร กรุงเทพมหานคร 10200','144/4 บ้านโกทา ในเมือง เมืองขอนแก่น ขอนแก่น 40000',13.70539822,100.59518588,1,'student_1111.jpg',NULL,'A','2025-07-17 17:15:36',1,'2025-07-17 17:40:31',1),
(4,'0000000000003','0003','เด็กหญิง','ลิซ่า','เด่นจัง','ลิลลี่','หญิง','2019-07-23','5 ปี 11 เดือน','0003','10 พระบรมมหาราชวัง พระนคร กรุงเทพมหานคร 10200','144/4 บ้านโกทา ในเมือง เมืองขอนแก่น ขอนแก่น 40000',13.70539822,100.59518588,1,'student_1111.jpg',NULL,'A','2025-07-17 17:15:36',1,'2025-07-17 17:40:31',1),
(46,'1111111111111','1111','เด็กชาย','เรียนดี','สุดๆ','ดี','ชาย','2019-07-23','5 ปี 11 เดือน','1111','10 พระบรมมหาราชวัง พระนคร กรุงเทพมหานคร 10200','144/4 บ้านโกทา ในเมือง เมืองขอนแก่น ขอนแก่น 40000',13.70539822,100.59518588,1,'student_1111.jpg',NULL,'A','2025-07-17 17:15:36',1,'2025-07-17 17:40:31',1),
(47,'1234567890123','0005','เด็กชาย','aaa','bbb','ccc','หญิง','2019-08-07','5 ปี 11 เดือน','0005','บางเลน บางกรวย นนทบุรี 11140','บางเลน บางใหญ่ นนทบุรี 11140',13.73734232,100.52082566,1,'student_0005.jpg',NULL,'B','2025-08-01 21:16:12',1,'2025-08-01 21:16:29',1);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classrooms`
--

LOCK TABLES `classrooms` WRITE;
/*!40000 ALTER TABLE `classrooms` DISABLE KEYS */;
INSERT INTO `classrooms` VALUES
(9,'อนุบาล 1/1',7,15,20,35,22,'2025-07-07 16:00:19',1,NULL,NULL),
(12,'อนุบาล 1/2',7,12,25,37,22,'2025-07-07 16:04:00',1,'2025-07-08 18:28:54',1),
(15,'อ 2/1',8,20,15,35,22,'2025-08-01 21:13:57',1,NULL,NULL);
/*!40000 ALTER TABLE `classrooms` ENABLE KEYS */;
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
(22,'โรงเรียนใจดี','2025-07-06 23:30:04',1,NULL,NULL);
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
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
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'admin','$2b$12$.LwkoScEUCM66micm4c51ukttEaf/aRBIFwmIgrzebHp3WHr3CG1.','phcstenkku@gmail.com',NULL,NULL,NULL,NULL),
(55,'test@gmail.com','$2b$12$v.L/KHD1z2q7TNw8FsQRqep7fHjvdwBy4qc90upISgMOVhbBngv5a','test@gmail.com','2025-07-04 09:33:58',1,'2025-07-04 09:34:22',1),
(56,'1','$2b$12$zWezmbLnh3hntJQUTA6hC.OqJaRDxZbnvCmKEtCce4jTPxQJYnyTC','1111@gmail.com','2025-07-04 23:13:03',1,'2025-07-07 19:46:12',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-08-05 20:52:34
