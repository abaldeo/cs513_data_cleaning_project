CREATE TABLE EstablishmentLocation (
  id SERIAL PRIMARY KEY,
  address varchar(50),
  city char(7),
  state char(2),
  zip int,
  latitude double precision,
  longitude double precision,
  location point
);

COMMENT
ON TABLE EstablishmentLocation IS 'Stores location information for food establishments.';

CREATE TABLE FoodEstablishment (
  license_number int PRIMARY KEY,
  dba_name varchar(50),
  aka_name varchar(50),
  facilityType varchar(50),
  location_id int REFERENCES EstablishmentLocation(id)
);

COMMENT
ON TABLE FoodEstablishment IS 'Stores food establishment information.';

CREATE TABLE FoodInspection (
  inspection_id int PRIMARY KEY,
  risk varchar(15),
  inspection_type varchar(25),
  inspection_date date,
  license_number int REFERENCES FoodEstablishment(license_number)
);

COMMENT
ON TABLE FoodInspection IS 'Stores food inspection information.';

CREATE TABLE ViolationCode (code int PRIMARY KEY, description text);

COMMENT
ON TABLE ViolationCode IS 'Stores violation codes and their descriptions.';

CREATE TABLE InspectionViolation (
  inspection_id int REFERENCES FoodInspection(inspection_id),
  violation_code int REFERENCES ViolationCode(code),
  PRIMARY KEY (inspection_id, violation_code)
);

COMMENT
ON TABLE InspectionViolation IS 'Stores inspection violations.';