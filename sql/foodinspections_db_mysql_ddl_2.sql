CREATE TABLE `EstablishmentLocation` (
    `id` int AUTO_INCREMENT NOT NULL,
    `address` varchar(50) NOT NULL,
    `city` char(7) NOT NULL,
    `state` char(2) NOT NULL,
    `zip` int NOT NULL,
    `latitude` double precision NOT NULL,
    `longitude` double precision NOT NULL,
    `location` point NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `FoodEstablishment` (
    `license_number` int NOT NULL,
    `dba_name` varchar(50) NOT NULL,
    `aka_name` varchar(50) NOT NULL,
    `facilityType` varchar(50) NOT NULL,
    `location_id` int NOT NULL,
    PRIMARY KEY (`license_number`)
);

CREATE TABLE `FoodInspection` (
    `inspection_id` int NOT NULL,
    `risk` varchar(15) NOT NULL,
    `inspection_type` varchar(25) NOT NULL,
    `inspection_date` date NOT NULL,
    `license_number` int NOT NULL,
    PRIMARY KEY (`inspection_id`)
);

CREATE TABLE `ViolationCode` (
    `code` int NOT NULL,
    `description` text NOT NULL,
    PRIMARY KEY (`code`)
);

CREATE TABLE `InspectionViolation` (
    `inspection_id` int NOT NULL,
    `violation_code` int NOT NULL,
    PRIMARY KEY (`inspection_id`, `violation_code`)
);

ALTER TABLE
    `FoodEstablishment`
ADD
    CONSTRAINT `fk_FoodEstablishment_location_id` FOREIGN KEY(`location_id`) REFERENCES `EstablishmentLocation` (`id`);

ALTER TABLE
    `FoodInspection`
ADD
    CONSTRAINT `fk_FoodInspection_license_number` FOREIGN KEY(`license_number`) REFERENCES `FoodEstablishment` (`license_number`);

ALTER TABLE
    `InspectionViolation`
ADD
    CONSTRAINT `fk_InspectionViolation_inspection_id` FOREIGN KEY(`inspection_id`) REFERENCES `FoodInspection` (`inspection_id`);

ALTER TABLE
    `InspectionViolation`
ADD
    CONSTRAINT `fk_InspectionViolation_violation_code` FOREIGN KEY(`violation_code`) REFERENCES `ViolationCode` (`code`);