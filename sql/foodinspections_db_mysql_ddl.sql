CREATE TABLE EstablishmentLocation (
  id SERIAL PRIMARY KEY,
  address varchar(50) NOT NULL,
  city varchar(50),
  state char(2),
  zip int,
  latitude double precision,
  longitude double precision,
  location point
);

CREATE TABLE FoodEstablishment (
  id SERIAL PRIMARY KEY,
  license_number int,
  dba_name varchar(100) NOT NULL,
  aka_name varchar(100),
  facilityType varchar(50),
  location_id int REFERENCES EstablishmentLocation(id)
);

CREATE TABLE FoodInspection (
  inspection_id int PRIMARY KEY,
  risk varchar(15),
  inspection_type varchar(50),
  inspection_date date,
  establishment_id int REFERENCES FoodEstablishment(id)
);

CREATE TABLE ViolationCode (code int PRIMARY KEY, description text);

CREATE TABLE InspectionViolation (
  inspection_id int REFERENCES FoodInspection(inspection_id),
  violation_code int REFERENCES ViolationCode(code),
  comment text,
  PRIMARY KEY (inspection_id, violation_code)
);