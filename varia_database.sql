-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 28, 2025 at 11:54 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `varia_database`
--

-- --------------------------------------------------------

--
-- Table structure for table `contact_us`
--

CREATE TABLE `contact_us` (
  `contact_us_id` int(11) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `mobile_number` varchar(15) NOT NULL,
  `email_address` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_us`
--

INSERT INTO `contact_us` (`contact_us_id`, `full_name`, `mobile_number`, `email_address`, `message`, `created_at`) VALUES
(1, 'Suhas Gaidhane', '7972726558', 'suhasgaidhane27@gmail.com', 'hi', '2025-03-07 02:42:59');

-- --------------------------------------------------------

--
-- Table structure for table `districts`
--

CREATE TABLE `districts` (
  `district_id` int(11) NOT NULL,
  `district_name` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `districts`
--

INSERT INTO `districts` (`district_id`, `district_name`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Akola', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(2, 'Amravati', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(3, 'Buldhana', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(4, 'Bhandara', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(5, 'Chandrapur', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(6, 'Gadchiroli', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(7, 'Gondia', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(8, 'Nagpur', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(9, 'Wardha', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(10, 'Washim', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(11, 'Yavatmal', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48'),
(12, 'Company', 1, '2025-01-24 07:04:48', '2025-01-24 07:04:48');

-- --------------------------------------------------------

--
-- Table structure for table `masterfirm`
--

CREATE TABLE `masterfirm` (
  `masterFirmId` int(11) NOT NULL,
  `shop_name` varchar(255) DEFAULT NULL,
  `proprieter_name` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `taluka_id` int(11) DEFAULT NULL,
  `district_id` int(11) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `gst` varchar(20) DEFAULT NULL,
  `mfms` varchar(20) DEFAULT NULL,
  `firm_image` varchar(255) DEFAULT NULL,
  `firmOwnerImage` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `masterfirm`
--

INSERT INTO `masterfirm` (`masterFirmId`, `shop_name`, `proprieter_name`, `address`, `city`, `taluka_id`, `district_id`, `mobile`, `email`, `gst`, `mfms`, `firm_image`, `firmOwnerImage`) VALUES
(86, 'धरती धन', 'कल्पेश अनिल बेदमुथा', 'मेन रोड, जयस्तंभ चौक', 'Buldhana', 21, 3, '9422181523', 'dhartidhan2009@gmail.com', '27AAAFD8252F1ZL', NULL, NULL, NULL),
(87, 'गुरूदेव सिडस', 'विवेक विजय कथने', 'शॉप ३१, शिवाजी महाराज मार्केट, तार तलाव,', 'Buldhana', 21, 3, '9028294034', 'rajukathane123@gmail.com', NULL, NULL, NULL, NULL),
(88, 'कृषी वैभव ', 'भिष्म गौरीशंकर कालमिया', 'मेन रोड, जयस्तंभ चौक, ', 'Buldhana', 21, 3, '9309210556', 'dalmiya.rohit@gmail.com', '27AAMFK1777Q1ZO', NULL, NULL, NULL),
(89, 'ॲग्रोवन कृषी केंद्र', 'राजु देविदास घुबे', 'धाड नाका, धाड रोड, ओमकार लॉन्स, ', 'Sagwan', 21, 3, '9422941487', 'rajughube2011@gmail.com', NULL, NULL, NULL, NULL),
(90, 'महालक्ष्मी ॲग्रो सेंटर', 'केशव तोताराम घुले ', 'शॉप नं.२, येडाई लान्स ', 'Sagwan', 21, 3, '8329829743', 'keshavghuleadvp@gmail.com', '27APKPG9751M1Z7', NULL, NULL, NULL),
(91, 'किसान कृषी केंद्र ', 'शेख अलिम शेख गुलाब', 'औरंगाबाद रोड, अर्बन बँक समोर, ', 'Dhaad', 21, 3, '9767560386', 'kisankrushi@gmail.com', '27EMZPS2359D1ZB', '441966', NULL, NULL),
(92, 'ऋषिकेश फर्टीलायझर्स', 'दत्तात्रय वसंतराव उबाळे', 'छ. संभाजीनगर रोड', 'Dhaad', 21, 3, '9975802460', 'rushikeshfertilizers55@gmail.com', '27ABEPU6246R1ZQ', '166330', NULL, NULL),
(93, 'त्रिमुर्ती कृषी सेवा केंद्र ', 'नरहर केशवराव गुळवे', ' ', 'Dhaad', 21, 3, '9422182077', 'trimurti_swami@rediffmail.com', '27ABIPG9924C1Z0', '166410', NULL, NULL),
(94, 'साईकृपा कृषी केंद्र ', 'शरद गोमाजी ठवकर ', ' ', 'Kondhi', 34, 4, '9823591022', 'saradthawkar1975@gmail.com', '27ANLPT9977B1Z8', '382707', NULL, NULL),
(95, 'माँ भगवती कृषी केंद्र  ', 'राजेश गायधने ', 'बडा बाजार ', 'Bhandara', 34, 4, '9923537989', 'rajesh.gaidhane123@gmail.com', '27BAAPG1501R1ZT', NULL, NULL, NULL),
(96, 'विलास कृषी', 'विलास कृष्णा लिचडे ', ' ', 'Mohadura', 34, 4, '9823189844', 'vilaslichade@gmail.com', '27AGUPL6732A1Z9', NULL, NULL, NULL),
(97, 'अमन कृषी केंद्र ', 'सुमदेव चिरकुट वाघमारे ', ' ', 'Chikhli', 34, 4, '8830776391', 'sumdevwaghmare@gmail.com', '27ABKPW6859N1ZF', '336261', NULL, NULL),
(98, 'सेवक कृषी केंद्र ', 'कवडू गुलाबराव वागदे ', ' ', 'Khamari Butti', 34, 4, '7020173606', 'kwagade@gmail.com', '27ACOPW1862C2ZA', '646425', NULL, NULL),
(99, 'आसावरी कृषी केंद्र ', 'सौ रंजना विवेक दहेकर ', ' ', 'Aandhalgaon', 37, 4, '8999741235', 'ranjanadahekar@gmail.com', '27AXXPD6430D1ZE', '128209', NULL, NULL),
(100, 'दीपाली कृषी केंद्र ', 'अरविंद दमये ', ' ', 'Usarla', 37, 4, '7218583097', ' ', NULL, '1132603', NULL, NULL),
(101, 'माउली कृषी सेवा केंद्र ', 'प्रल्हाद प्रभाकर किंमतकर ', ' ', 'Hardoli Jh', 37, 4, '9823925738', 'parlahadkimmatkar@gmail.com', ' ', '1281982', NULL, NULL),
(102, 'विठ्ठल कृषी केंद्र  ', 'विठ्ठल अजर्ुन नाकतोडे ', ' ', 'Bhagdi', 35, 4, '9890649968', 'vitthalnaktode@gmail.com', NULL, '128808', NULL, NULL),
(103, 'गहाणे कृषी केंद्र  ', 'सीताराम गहाणे', ' ', 'Pimpalgaon', 35, 4, '9689517343', ' ', NULL, NULL, NULL, NULL),
(104, 'सन्मय कृषी केंद्र ', 'अरुण कारू मेश्राम ', ' ', 'Soni', 35, 4, '9423668941', 'arunmeshram541968@gmail.com', NULL, '863023', NULL, NULL),
(105, 'कृष्णा कृषी केंद्र ', 'अभिलाष गजभिये ', ' ', 'Manegav', 36, 4, '9960436990', 'abhilashgajbhiye@gmail.com', '27CIIPG0294A1ZM', NULL, NULL, NULL),
(106, 'विघ्नहर्ता कृषी सेवा के', 'रुपेश नारद टेंभरे', ' ', 'Salebhata', 36, 4, '9764305017', 'rncias@gmail.com', NULL, '1201152', NULL, NULL),
(107, 'हितभाव कृषी केंद्र ', 'सौ ममता योगेश चांदेवार ', ' ', 'Pindkepaar', 39, 4, '9604069248', 'yogeshchandewar9@gmail.com', '27ALVPC8176B1ZU', NULL, NULL, NULL),
(108, 'किरणापुरे कृषी सेवा केंद्र ', 'नितेश गजानन किरणापुरे ', 'एन एच ५३, साईबाबा राईस मिल जवळ, बिरसामुंडा रोड  ', 'Sendurwafa', 39, 4, '9623002911', 'kirnapureksk17@gmail.com', '27EFNPK4319N1ZT', '681087', NULL, NULL),
(109, 'जय किसान कृषी सेवा केंद्र ', 'विलास रामदास कुर्सेकर ', 'मेन बस स्टॅन्ड ', 'Chikhli', 38, 4, '9923860329', 'kursekarvilas@gmail.com', NULL, NULL, NULL, NULL),
(110, 'सोना कृषी केंद्र  ', 'इझाज शफिक शेख ', 'मेन रोड ', 'Sihora', 40, 4, '9922296312', ' ', '27DZCPS3038E1ZD', '848412', NULL, NULL),
(111, 'श्री शिव कृषी केंद्र ', 'महेंद्र गंगाराम मोटघरे ', ' ', 'Chulhad', 40, 4, '9765236470', 'motgharemahendra5@gmal.com', NULL, '833298', NULL, NULL),
(112, 'अभिनव ॲग्रो एजन्सीज', 'बाबुराव म्हाला', 'ब्लॉक नं. १९, श्रीदेवी रतन कॉम्पलेक्स, आग्याराम देवी चौक', 'Nagpur', 78, 8, '9923005165', 'dhirajmhala@yahoo.com', ' ', '229728', NULL, NULL),
(113, 'अभिनव सिडस्‌ कंपनी', 'धीरज म्हाला', 'श्रीदेवी रतन कॉम्प्लेक्स, आग्याराम देवी चौक', 'Nagpur', 78, 8, '9970057965', ' ', ' ', '361121', NULL, NULL),
(114, 'अग्रवाल सिड्‌स एजेन्सी', 'दिपक सत्यनारायण अग्रवाल', 'ब्लॉक नं. ८, गीता मंदीर, सुभाष चौक', 'Nagpur', 78, 8, '7122721926', 'salasar.varun@gmail.com', '27AAJPA3902A1ZH', ' ', NULL, NULL),
(115, 'ॲग्री केअर', 'शेखर झाडे', '८, श्रीदेवी रतन कॉम्प्लेक्स, आग्याराम देवी चौक,', 'Nagpur', 78, 8, '9730046571', 'agricarenagpur@gmail.com', '27AAQFA2540K1ZA', ' ', NULL, NULL),
(116, 'ॲग्री टेक', 'संजय चंद्रकांत उपे ', 'श्रमिक भवन, सुभाष रोड, कॉटन मार्केट', 'Nagpur', 78, 8, '7122724149', 'agritechnagpur@gmail.com', '27AAIPU8251B1ZK', '438170', NULL, NULL),
(117, ' अमर ॲग्रो एजंसीज', 'गोपीचंद भोजवानी', '१८९, भोजवानी बिल्डींग, सुभाष रोड, कॉटन मार्केट', 'Nagpur', 78, 8, '9373241845', 'amarbeej_nagpur@yahoo.com', '27AAWFA2557L1ZT', ' ', NULL, NULL),
(118, 'अमर बीज भंडार', 'महेश भोजवानी', 'दु.क्र. २, भापकर पार्क, सुभाष रोड, कॉटन मार्केट', 'Nagpur', 78, 8, '7757002949', 'maheshbhojwani808@gmail.com', '27AAOFA2191A1ZQ', ' ', NULL, NULL),
(119, 'अनुषा ट्रेडर्स', 'लक्ष्मण यादवराव देवासे', 'जी-१५, श्रीदेवी रतन, कॉम्प्लेक्स नं. १, सुभाष रोड', 'Nagpur', 78, 8, '9422315660', 'laxmandewase@yahoo.com', '27AHQPD7687P1Z8', '338609', NULL, NULL),
(120, 'आशीर्वाद ॲग्रो', 'नितीन वामनराव भोयर', ' ३१, गीता मंदीर कॉम्प्लेक्स, सुभाष रोड', 'Nagpur', 78, 8, '8275044081', 'nitinbhoyar11@gmail.com', '27AMGPB7706C1ZG', ' ', NULL, NULL),
(121, 'अथर्व ॲग्रो इन', 'नितीन कृष्णराव वैद्य ', 'श्रीदेवी रतन कॉम्प्लेक्स, सुभाष रोड', 'Nagpur', 78, 8, '7122724632', 'nmsnasvaidya@rediffmail.com', ' ', ' ', NULL, NULL),
(122, 'बालाजी ॲग्रो एजन्सीज ', 'राधेश्याम राठी', 'दु. नं. ३६, गीता मंदीर कॉम्प्लेक्स, सुभाष रोड,', 'Nagpur', 78, 8, '7122735619', 'balajiagroag@gmail.com', '27ARPPR8215C1ZJ', ' ', NULL, NULL),
(123, 'कुल्लरकर कृषी एजंसी', 'गुणवंता मंसाराम कुल्लकर', 'उमरेड रोड', 'Bahadura', 78, 8, '9637559476', ' ', '27ALRPK2767J1ZG', '343167', NULL, NULL),
(124, ' युनिटी एंटरप्राजेस ', 'रुपेश नागदिवे', 'उमरेड रोड', 'Bahadura', 78, 8, '9422315660', ' ', '27AGFPN1569G1Z9', ' ', NULL, NULL),
(125, 'गणेश कृषी सेवा केन्द्र', 'शंकर गजानन नागपूरे', 'बोरखेडी रेल्वे', 'Borkhedi Railway', 78, 8, '8275044081', 'sankarnagpure252@gmail.com', '27AWBPN7285M1ZU', '743918', NULL, NULL),
(126, 'गारवा कृषी सेवा केंद्र ', 'निलेश आनंदराव सेलोटे ', 'बोरखेडी रेल्वे', 'Borkhedi Railway', 78, 8, '8668520415', 'nileshselote05@gmail.com', '27FNIPS9390P1ZN', '765842', NULL, NULL),
(127, 'कापसे सिडस ॲन्ड फर्टिलायझर्स ', 'विष्णु रामभाऊ कापसे ', 'बुटीबोरी ', 'Butibori', 78, 8, '9822640698', 'kapseseeds@gmail.com', '27ACUPK9369A1Z3', '267651', NULL, NULL),
(131, 'Test Shop1', 'Test Owner1', 'Test Lakhni Pimpalgaon sadak', 'Lakhni', 21, 3, '7972726558', 'suhasgaidhane123@gmail.com', '27AABCU9603R1ZL', '54215 77', 'FirmImages/1741180026_1000001176.jpg', 'FirmOwnerImages/1741240535_1000001146.heic'),
(132, 'Test Shop', 'Test Owner', 'Test Lakhni Pimpalgaon sadak', 'Lakhni', 21, 3, '7972726558', 'suhasgaidhane123@gmail.com', '27AABCU9603R1ZL', '54215', 'FirmImages/1741179763_Shop IMage.png', 'FirmOwnerImages/1741179763_farmer Image.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `masterlogin`
--

CREATE TABLE `masterlogin` (
  `MasterLoginId` int(11) NOT NULL,
  `MasterProfileId` tinyint(4) NOT NULL CHECK (`MasterProfileId` in (1,2)),
  `MobileNumber` varchar(15) NOT NULL,
  `FullName` varchar(255) NOT NULL,
  `MasterDistrictId` int(11) NOT NULL,
  `MasterCityId` int(11) NOT NULL,
  `IsVerified` tinyint(1) NOT NULL DEFAULT 0,
  `ModifiedDate` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `AvailableCredit` decimal(10,2) DEFAULT NULL,
  `LastUsedDate` datetime DEFAULT NULL,
  `FirmName` varchar(255) DEFAULT NULL,
  `UserImage` text DEFAULT NULL,
  `YourAddress` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `masterlogin`
--

INSERT INTO `masterlogin` (`MasterLoginId`, `MasterProfileId`, `MobileNumber`, `FullName`, `MasterDistrictId`, `MasterCityId`, `IsVerified`, `ModifiedDate`, `AvailableCredit`, `LastUsedDate`, `FirmName`, `UserImage`, `YourAddress`) VALUES
(1, 1, '9876543210', 'John Doe', 101, 1001, 1, '2025-01-23 12:41:39', NULL, NULL, NULL, NULL, NULL),
(2, 2, '9876543211', 'Admin One', 102, 1002, 1, '2025-01-23 12:41:39', NULL, NULL, NULL, NULL, NULL),
(3, 1, '9876543212', 'Alice Smith', 103, 1003, 0, '2025-01-23 12:41:39', NULL, NULL, NULL, NULL, NULL),
(4, 1, '9876543213', 'Bob Johnson', 104, 1004, 1, '2025-01-23 12:41:39', NULL, NULL, NULL, NULL, NULL),
(5, 2, '9876543214', 'Admin Two', 105, 1005, 0, '2025-01-23 12:41:39', NULL, NULL, NULL, NULL, NULL),
(7, 1, '7972726538', 'John Doe', 101, 1001, 0, '2025-01-23 12:59:16', NULL, NULL, NULL, NULL, NULL),
(8, 1, '79727265438', 'John Doe', 101, 1001, 0, '2025-01-23 13:02:24', NULL, NULL, NULL, NULL, NULL),
(17, 1, '79727265581', 'John Doe', 101, 1001, 1, '2025-02-12 17:56:52', NULL, NULL, NULL, NULL, NULL),
(18, 1, '797272655811', 'John Doe', 101, 1001, 0, '2025-02-19 16:36:45', 100.00, '2024-02-19 00:00:00', NULL, NULL, NULL),
(19, 1, '79727265588', 'John Doe', 101, 1001, 1, '2025-02-24 15:18:39', 100.00, '2024-02-19 00:00:00', NULL, NULL, NULL),
(20, 1, '7972726558114', 'John Doe', 101, 1001, 1, '2025-02-19 17:00:17', 100.00, '2024-02-19 00:00:00', 'Suhas Firm', NULL, NULL),
(21, 1, '79727265581124', 'John Doe', 101, 1001, 1, '2025-02-20 10:49:50', 100.00, '2024-02-19 00:00:00', 'Suhas Firm', NULL, 'Pimpalgaon sadak'),
(22, 1, '797272655813124', 'John Doe', 101, 1001, 1, '2025-02-20 10:50:42', 100.00, '2024-02-19 00:00:00', 'Suhas Firm', NULL, 'Pimpalgaon sadak'),
(23, 1, '797272655338', 'Suhas Gaidhane', 1, 1, 1, '2025-02-25 12:28:42', 5000.00, '2025-02-25 00:00:00', 'suhas firm', NULL, 'lakhni'),
(24, 1, '79727265585', 'Suhas Gaidhane', 1, 1, 1, '2025-02-25 12:41:24', 3500.00, '2025-02-25 00:00:00', 'suhas firm', NULL, 'lakhni'),
(25, 1, '79727265586', 'Suhas Gaidhane', 1, 1, 1, '2025-02-25 12:44:43', 3500.00, '2025-02-25 00:00:00', 'subas firm', NULL, 'lakhni'),
(26, 1, '79727265583', 'Suhas Gaidhane', 1, 1, 1, '2025-02-25 12:46:23', 2000.00, '2025-02-25 00:00:00', 'suhas firm', NULL, 'lakhni'),
(27, 1, '797272655833', 'Suhas Gaidhane', 1, 1, 1, '2025-03-24 14:21:00', 20750.00, '2025-02-25 00:00:00', 'Suhas Firm', 'UserImages/user_27.heic', 'lakhni'),
(28, 1, '7972726558', 'Suhas', 1, 1, 1, '2025-03-24 14:28:57', 0.00, '2025-03-24 00:00:00', 'suhas firm', 'UserImages/user_28.heic', 'lakhni');

-- --------------------------------------------------------

--
-- Table structure for table `offers`
--

CREATE TABLE `offers` (
  `offer_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `offers`
--

INSERT INTO `offers` (`offer_id`, `title`, `description`, `image_url`, `start_date`, `end_date`, `is_active`, `created_at`, `updated_at`) VALUES
(4, 'Summer Sale 2', 'Get 50% off on all products!', 'http://example.com/summer-sale.jpg', '2025-01-01 00:00:00', '2025-04-23 23:59:59', 0, '2025-01-24 14:27:09', '2025-02-25 18:02:30'),
(5, 'Summer Sale 4', 'Get 50% off on all products!', 'http://example.com/summer-sale.jpg', '2025-01-01 00:00:00', '2025-05-27 23:59:59', 0, '2025-01-24 14:29:54', '2025-01-24 14:30:31'),
(6, 'Offer Name', 'Description', '../images/offers_img/TEST2.png', '2025-01-01 00:00:00', '2025-05-27 23:59:59', 0, '2025-01-24 14:52:36', '2025-02-25 18:02:34'),
(7, 'Offer Name 1', 'Description 2', '/images/offers_img/TEST2.png', '2025-01-01 00:00:00', '2025-03-05 23:59:59', 0, '2025-01-24 14:55:14', '2025-02-25 18:02:40'),
(9, 'Offer Name 1', 'Description 2', '/images/offers_img/banner1_1740486712_4f18d547dc.png', '2025-01-01 00:00:00', '2025-05-27 23:59:59', 1, '2025-02-25 18:01:52', '2025-02-25 18:01:52'),
(10, 'Offer Name 1', 'Description 2', '/images/offers_img/banner2_1740486722_1addfe502a.png', '2025-01-01 00:00:00', '2025-05-27 23:59:59', 1, '2025-02-25 18:02:02', '2025-02-25 18:02:02'),
(11, 'Offer Name 1', 'Description 2', '/images/offers_img/banner3_1740486730_cb4202536f.png', '2025-01-01 00:00:00', '2025-05-27 23:59:59', 1, '2025-02-25 18:02:10', '2025-02-25 18:02:10');

-- --------------------------------------------------------

--
-- Table structure for table `subscriptionplans`
--

CREATE TABLE `subscriptionplans` (
  `MasterSubscriptionId` int(11) NOT NULL,
  `PlanName` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL,
  `BasePrice` decimal(10,2) DEFAULT NULL,
  `Credit` decimal(10,2) DEFAULT NULL,
  `Month` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subscriptionplans`
--

INSERT INTO `subscriptionplans` (`MasterSubscriptionId`, `PlanName`, `Description`, `BasePrice`, `Credit`, `Month`) VALUES
(1, 'Basic', 'Basic features with limited usage', 2000.00, 101.00, 3),
(2, 'Standard', 'More features and higher usage limits', 3500.00, 250.00, 6),
(3, 'Premium', 'All features with unlimited usage', 5000.00, 750.00, 12);

-- --------------------------------------------------------

--
-- Table structure for table `talukas`
--

CREATE TABLE `talukas` (
  `taluka_id` int(11) NOT NULL,
  `district_id` int(11) DEFAULT NULL,
  `taluka_name` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `talukas`
--

INSERT INTO `talukas` (`taluka_id`, `district_id`, `taluka_name`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 'Akola', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(2, 1, 'Akot', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(3, 1, 'Balapur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(4, 1, 'Barshitakli', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(5, 1, 'Murtajapur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(6, 1, 'Patur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(7, 1, 'Telhara', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(8, 2, 'Achalpur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(9, 2, 'Amravati', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(10, 2, 'Anjangaon Surji', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(11, 2, 'Bhatkuli', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(12, 2, 'Chandur Bazar', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(13, 2, 'Chandur Railway', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(14, 2, 'Chikhaldara', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(15, 2, 'Daryapur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(16, 2, 'Dhamangaon Railway', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(17, 2, 'Morshi', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(18, 2, 'Nandgaon-Khandeshwar', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(19, 2, 'Teosa', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(20, 2, 'Warud', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(21, 3, 'Buldhana', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(22, 3, 'Chikhli', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(23, 3, 'Deulgaon Raja', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(24, 3, 'Jalgaon (Jamod)', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(25, 3, 'Khamgaon', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(26, 3, 'Lonar', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(27, 3, 'Malkapur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(28, 3, 'Mehkar', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(29, 3, 'Motala', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(30, 3, 'Nandura', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(31, 3, 'Sangrampur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(32, 3, 'Shegaon', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(33, 3, 'Sindkhed Raja', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(34, 4, 'Bhandara', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(35, 4, 'Lakhandur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(36, 4, 'Lakhni', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(37, 4, 'Mohadi', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(38, 4, 'Pauni', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(39, 4, 'Sakoli', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(40, 4, 'Tumsar', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(41, 5, 'Bhadravati', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(42, 5, 'Brahmapuri', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(43, 5, 'Chandrapur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(44, 5, 'Chimur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(45, 5, 'Gondpipri', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(46, 5, 'Jiwati', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(47, 5, 'Korpana', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(48, 5, 'Mul', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(49, 5, 'Nagbhid', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(50, 5, 'Pombhurna', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(51, 5, 'Rajura', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(52, 5, 'Saoli', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(53, 5, 'Sindewahi', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(54, 5, 'Warora', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(55, 6, 'Aheri', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(56, 6, 'Armori', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(57, 6, 'Bhamragad', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(58, 6, 'Chamorshi', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(59, 6, 'Dhanora', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(60, 6, 'Etapalli', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(61, 6, 'Gadchiroli', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(62, 6, 'Kurkheda', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(63, 6, 'Mulchera', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(64, 7, 'Amgaon', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(65, 7, 'Arjuni Morgaon', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(66, 7, 'Deori', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(67, 7, 'Goregaon', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(68, 7, 'Gondia', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(69, 7, 'Salekasa', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(70, 7, 'Sadak-Arjuni', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(71, 7, 'Tirora', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(72, 8, 'Hingna', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(73, 8, 'Kalameshwar', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(74, 8, 'Kamptee', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(75, 8, 'Katol', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(76, 8, 'Kuhi', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(77, 8, 'Mauda', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(78, 8, 'Nagpur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(79, 8, 'Narkhed', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(80, 8, 'Parseoni', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(81, 8, 'Ramtek', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(82, 8, 'Saoner', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(83, 8, 'Umred', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(84, 9, 'Arvi', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(85, 9, 'Ashti', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(86, 9, 'Deoli', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(87, 9, 'Hinganghat', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(88, 9, 'Karanja', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(89, 9, 'Samudrapur', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(90, 9, 'Seloo', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(91, 9, 'Wardha', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(92, 10, 'Karanja', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(93, 10, 'Malegaon', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(94, 10, 'Mangrulpir', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(95, 10, 'Manora', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(96, 10, 'Risod', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(97, 10, 'Washim', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(98, 11, 'Arni', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(99, 11, 'Babhulgaon', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(100, 11, 'Darwha', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(101, 11, 'Digras', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(102, 11, 'Ghatanji', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(103, 11, 'Kalamb', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(104, 11, 'Mahagaon', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(105, 11, 'Maregaon', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(106, 11, 'Ner', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(107, 11, 'Pandharkawada', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(108, 11, 'Pusad', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(109, 11, 'Ralegaon', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(110, 11, 'Umarkhed', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(111, 11, 'Wani', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51'),
(112, 11, 'Yavatmal', 1, '2025-03-04 07:36:51', '2025-03-04 07:36:51');

-- --------------------------------------------------------

--
-- Table structure for table `usagehistory`
--

CREATE TABLE `usagehistory` (
  `UsageHistoryId` int(11) NOT NULL,
  `UserSubscriptionId` int(11) DEFAULT NULL,
  `UsageTimestamp` datetime DEFAULT NULL,
  `UsageCredit` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usagehistory`
--

INSERT INTO `usagehistory` (`UsageHistoryId`, `UserSubscriptionId`, `UsageTimestamp`, `UsageCredit`) VALUES
(1, 1, '2025-01-23 18:37:17', 5.00);

-- --------------------------------------------------------

--
-- Table structure for table `usersubscriptions`
--

CREATE TABLE `usersubscriptions` (
  `UserSubscriptionId` int(11) NOT NULL,
  `MasterSubscriptionId` int(11) NOT NULL,
  `MasterLoginId` varchar(255) NOT NULL,
  `IsActive` tinyint(1) DEFAULT 1,
  `SubscriptionStart` datetime DEFAULT NULL,
  `SubscriptionEnd` datetime DEFAULT NULL,
  `RenewalDate` datetime DEFAULT NULL,
  `district_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usersubscriptions`
--

INSERT INTO `usersubscriptions` (`UserSubscriptionId`, `MasterSubscriptionId`, `MasterLoginId`, `IsActive`, `SubscriptionStart`, `SubscriptionEnd`, `RenewalDate`, `district_id`) VALUES
(1, 1, '17', 1, '2025-01-24 11:55:32', '2025-02-24 11:55:32', '2025-02-24 11:55:32', 2),
(3, 2, '2', 1, '2025-01-24 11:52:46', '2025-02-24 11:52:46', '2025-02-24 11:52:46', 9),
(4, 1, '18', 1, '2024-02-19 00:00:00', '2025-02-19 00:00:00', '2025-02-01 00:00:00', 101),
(5, 1, '20', 1, '2024-02-19 00:00:00', '2025-03-25 00:00:00', '2025-02-01 00:00:00', 3),
(6, 1, '20', 1, '2024-02-19 00:00:00', '2025-02-19 00:00:00', '2025-02-01 00:00:00', 1),
(7, 1, '21', 1, '2024-02-19 00:00:00', '2025-02-19 00:00:00', '2025-02-01 00:00:00', 101),
(8, 1, '22', 1, '2024-02-19 00:00:00', '2025-02-19 00:00:00', '2025-02-01 00:00:00', 101),
(9, 3, '23', 1, '2025-02-25 00:00:00', '2026-02-20 00:00:00', '2026-02-20 00:00:00', 2),
(10, 2, '24', 1, '2025-02-25 00:00:00', '2025-08-24 00:00:00', '2025-08-24 00:00:00', 2),
(11, 2, '25', 1, '2025-02-25 00:00:00', '2025-08-24 00:00:00', '2025-08-24 00:00:00', 4),
(12, 1, '26', 1, '2025-02-25 00:00:00', '2025-05-26 00:00:00', '2025-05-26 00:00:00', 12),
(13, 3, '27', 1, '2025-02-25 00:00:00', '2026-02-20 00:00:00', '2026-02-20 00:00:00', 3),
(14, 3, '27', 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 8),
(15, 3, '27', 1, '2025-03-06 00:00:00', '2026-03-01 00:00:00', '2026-03-01 00:00:00', 9),
(16, 3, '27', 1, '2025-03-06 00:00:00', '2026-03-01 00:00:00', '2026-03-01 00:00:00', 8),
(17, 3, '27', 1, '2025-03-07 00:00:00', '2026-03-02 00:00:00', '2026-03-02 00:00:00', 1),
(18, 2, '27', 1, '2025-03-07 00:00:00', '2025-09-03 00:00:00', '2025-09-03 00:00:00', 7);

-- --------------------------------------------------------

--
-- Table structure for table `user_district_access`
--

CREATE TABLE `user_district_access` (
  `access_id` int(11) NOT NULL,
  `MasterLoginId` int(11) NOT NULL,
  `district_id` int(11) NOT NULL,
  `access_approved` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_district_access`
--

INSERT INTO `user_district_access` (`access_id`, `MasterLoginId`, `district_id`, `access_approved`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, '2025-01-24 07:21:29', '2025-01-24 07:21:29'),
(2, 1, 2, 1, '2025-01-24 07:21:29', '2025-01-24 07:46:12'),
(3, 2, 3, 1, '2025-01-24 07:21:29', '2025-01-24 07:21:29'),
(4, 3, 4, 1, '2025-01-24 07:21:29', '2025-01-24 07:21:29'),
(5, 17, 4, 1, '2025-01-24 07:50:08', '2025-01-24 07:51:50');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `contact_us`
--
ALTER TABLE `contact_us`
  ADD PRIMARY KEY (`contact_us_id`);

--
-- Indexes for table `districts`
--
ALTER TABLE `districts`
  ADD PRIMARY KEY (`district_id`);

--
-- Indexes for table `masterfirm`
--
ALTER TABLE `masterfirm`
  ADD PRIMARY KEY (`masterFirmId`);

--
-- Indexes for table `masterlogin`
--
ALTER TABLE `masterlogin`
  ADD PRIMARY KEY (`MasterLoginId`),
  ADD UNIQUE KEY `MobileNumber` (`MobileNumber`);

--
-- Indexes for table `offers`
--
ALTER TABLE `offers`
  ADD PRIMARY KEY (`offer_id`);

--
-- Indexes for table `subscriptionplans`
--
ALTER TABLE `subscriptionplans`
  ADD PRIMARY KEY (`MasterSubscriptionId`);

--
-- Indexes for table `talukas`
--
ALTER TABLE `talukas`
  ADD PRIMARY KEY (`taluka_id`),
  ADD KEY `district_id` (`district_id`);

--
-- Indexes for table `usagehistory`
--
ALTER TABLE `usagehistory`
  ADD PRIMARY KEY (`UsageHistoryId`),
  ADD KEY `UserSubscriptionId` (`UserSubscriptionId`);

--
-- Indexes for table `usersubscriptions`
--
ALTER TABLE `usersubscriptions`
  ADD PRIMARY KEY (`UserSubscriptionId`),
  ADD KEY `MasterSubscriptionId` (`MasterSubscriptionId`);

--
-- Indexes for table `user_district_access`
--
ALTER TABLE `user_district_access`
  ADD PRIMARY KEY (`access_id`),
  ADD KEY `district_id` (`district_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `contact_us`
--
ALTER TABLE `contact_us`
  MODIFY `contact_us_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `districts`
--
ALTER TABLE `districts`
  MODIFY `district_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `masterfirm`
--
ALTER TABLE `masterfirm`
  MODIFY `masterFirmId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=133;

--
-- AUTO_INCREMENT for table `masterlogin`
--
ALTER TABLE `masterlogin`
  MODIFY `MasterLoginId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `offers`
--
ALTER TABLE `offers`
  MODIFY `offer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `subscriptionplans`
--
ALTER TABLE `subscriptionplans`
  MODIFY `MasterSubscriptionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `talukas`
--
ALTER TABLE `talukas`
  MODIFY `taluka_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT for table `usagehistory`
--
ALTER TABLE `usagehistory`
  MODIFY `UsageHistoryId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `usersubscriptions`
--
ALTER TABLE `usersubscriptions`
  MODIFY `UserSubscriptionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `user_district_access`
--
ALTER TABLE `user_district_access`
  MODIFY `access_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `talukas`
--
ALTER TABLE `talukas`
  ADD CONSTRAINT `talukas_ibfk_1` FOREIGN KEY (`district_id`) REFERENCES `districts` (`district_id`);

--
-- Constraints for table `usagehistory`
--
ALTER TABLE `usagehistory`
  ADD CONSTRAINT `usagehistory_ibfk_1` FOREIGN KEY (`UserSubscriptionId`) REFERENCES `usersubscriptions` (`UserSubscriptionId`);

--
-- Constraints for table `usersubscriptions`
--
ALTER TABLE `usersubscriptions`
  ADD CONSTRAINT `usersubscriptions_ibfk_1` FOREIGN KEY (`MasterSubscriptionId`) REFERENCES `subscriptionplans` (`MasterSubscriptionId`);

--
-- Constraints for table `user_district_access`
--
ALTER TABLE `user_district_access`
  ADD CONSTRAINT `user_district_access_ibfk_1` FOREIGN KEY (`district_id`) REFERENCES `districts` (`district_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
