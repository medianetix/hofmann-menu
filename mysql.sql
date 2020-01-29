-- Adminer 4.7.2-dev MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `meals`;
CREATE TABLE `meals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `meal_id` int(11) NOT NULL,
  `meal_name` varchar(150) COLLATE utf8_german2_ci NOT NULL,
  `price_in_cents` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `meal_id` (`meal_id`),
  FULLTEXT KEY `meal_name` (`meal_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;

INSERT INTO `meals` (`id`, `meal_id`, `meal_name`, `price_in_cents`) VALUES
(1,	8613,	'Hirschgulasch Diana',	599),
(2,	8520,	'Hähnchenchnitzel Cordon Bleu-Art',	534),
(3,	8920,	'Bunter Gemüse-Mix',	424),
(4,	8021,	'Mascarpone-Maccaroni',	418),
(5,	8966,	'Gemüsemaultaschen überbacken',	412),
(6,	8804,	'Erbseneintopf',	353),
(7,	6821,	'Soljanka Eintopf',	235),
(8,	8001,	'Herzhafter Nudelteller Gemüse-Maultaschen',	424),
(9,	8068,	'Sieben-Schwaben-Topf',	533),
(10,	8959,	'Jägertöpfchen gewürzt',	367),
(11,	6029,	'Orientalische Hähnchenbrust',	395),
(12,	8436,	'Smoked Cheese & Onions',	489),
(13,	8718,	'Schlemmerfilet Napoli',	476),
(14,	8422,	'Köttbullar',	416),
(15,	8561,	'Asia-Huhn',	440),
(16,	6815,	'Käse-Lauch Suppe',	355),
(17,	8108,	'Zarter Sauerbraten',	509),
(18,	8448,	'Currywurst Double + Red',	409),
(19,	8508,	'Schlemmerteller',	475),
(20,	8107,	'Rindergeschnetzeltes Chili',	479),
(21,	8536,	'Knusper-Hähnchenschnitte Spinaci',	423),
(22,	8032,	'Grillplatte',	534),
(23,	8045,	'Maccaroniplatte',	411),
(24,	1053,	'Filettöpfchen Jäger-Art',	534),
(25,	8705,	'Scholle paniert',	467),
(26,	8760,	'Grillfisch (Sommer 2019)',	459),
(27,	8484,	'Meatballs Cheese & Onions',	476),
(28,	8801,	'Schwäbisches Linsengericht',	380),
(29,	8289,	'BBQ Steak Whisky-Feige',	499),
(30,	8033,	'Cevapcici',	440),
(31,	6014,	'Ravioli-Pesto-Pfanne',	399),
(32,	8094,	'Stroganoff-Topf',	479),
(33,	8607,	'Wildlachsfilet u. wilder Reis',	829),
(34,	8586,	'Tandoori-Hähnchen',	489),
(35,	8013,	'Herzhafte Maultaschen',	399),
(36,	1001,	'Schweinefleisch Rügener Art',	419),
(37,	8025,	'Spaghetti Napoli',	352),
(38,	8415,	'Currywurst Hot Chilli',	479),
(39,	8811,	'Hühnersuppentopf Hausfrauenart',	364),
(40,	46977,	'Maultaschen-Pfännchen (Pappe)',	399),
(41,	8414,	'2 Currywürste und Pommes',	399),
(42,	46285,	'Pulled Pork Smoked BBQ',	440),
(43,	8004,	'Bandnudeln mit Wildlachsfiletschnitte',	429);

DROP TABLE IF EXISTS `meals_users`;
CREATE TABLE `meals_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hofmann_id` int(11) NOT NULL,
  `user_alias` varchar(3) COLLATE utf8_german2_ci NOT NULL,
  `issue_date` date NOT NULL,
  `price_in_cents` int(11) NOT NULL DEFAULT '0',
  `payment_date` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;


DELIMITER ;;

CREATE TRIGGER `meals_users_before_insert` BEFORE INSERT ON `meals_users` FOR EACH ROW
BEGIN
    DECLARE found_user, found_meal INT;

    SELECT COUNT(1) INTO found_user FROM users WHERE users.alias=NEW.user_alias;
    IF found_user = 0 THEN
        SET NEW.user_alias = NULL;
    END IF;

    SELECT COUNT(1) INTO found_meal FROM meals WHERE meals.meal_id=NEW.hofmann_id;
    IF found_meal = 0 THEN
        SET NEW.hofmann_id = NULL;
    END IF;

END;;

DELIMITER ;

DROP VIEW IF EXISTS `offene_posten`;
CREATE TABLE `offene_posten` (`full_name` varchar(100), `user_alias` varchar(3), `total` decimal(36,4), `from_date` date, `until_date` date);


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias` varchar(3) COLLATE utf8_german2_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8_german2_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_german2_ci NOT NULL,
  `blocked` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_email` (`email`),
  UNIQUE KEY `unique_alias` (`alias`),
  KEY `index_blocked` (`blocked`),
  FULLTEXT KEY `fulltext_full_name` (`full_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;


DROP TABLE IF EXISTS `offene_posten`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `offene_posten` AS select `users`.`full_name` AS `full_name`,`meals_users`.`user_alias` AS `user_alias`,(sum(`meals_users`.`price_in_cents`) / 100) AS `total`,min(`meals_users`.`issue_date`) AS `from_date`,max(`meals_users`.`issue_date`) AS `until_date` from (`meals_users` left join `users` on((`users`.`alias` = `meals_users`.`user_alias`))) group by `meals_users`.`user_alias`,`meals_users`.`payment_date` having isnull(`meals_users`.`payment_date`) order by `total` desc;

-- 2020-01-29 11:11:30
