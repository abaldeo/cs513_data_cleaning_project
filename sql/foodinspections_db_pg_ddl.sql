CREATE TABLE EstablishmentLocation (
  id SERIAL PRIMARY KEY,
  address varchar(50) NOT NULL,
  city varchar(50),
  state char(2),
  zip char(5),
  latitude double precision,
  longitude double precision,
  location point
);

COMMENT
ON TABLE EstablishmentLocation IS 'Stores location information for food establishments.';

CREATE TABLE FoodEstablishment (
  id SERIAL PRIMARY KEY,
  license_number int,
  dba_name varchar(100) NOT NULL,
  aka_name varchar(100),
  facility_type varchar(50),
  location_id bigint REFERENCES EstablishmentLocation(id)
);

COMMENT
ON TABLE FoodEstablishment IS 'Stores food establishment information.';

CREATE TABLE FoodInspection (
  inspection_id int PRIMARY KEY,
  risk varchar(15),
  risk_level int,
  risk_category varchar(10),
  inspection_type varchar(50),
  inspection_date date NOT NULL,
  results varchar(20) NOT NULL,
  establishment_id bigint REFERENCES FoodEstablishment(id)
);

COMMENT
ON TABLE FoodInspection IS 'Stores food inspection information.';

CREATE TABLE ViolationCode (code int PRIMARY KEY, description text NOT NULL);

COMMENT
ON TABLE ViolationCode IS 'Stores violation codes and their descriptions.';

CREATE TABLE InspectionViolation (
  inspection_id int REFERENCES FoodInspection(inspection_id),
  violation_code int REFERENCES ViolationCode(code),
  comment text, 
  PRIMARY KEY (inspection_id, violation_code)
);

COMMENT
ON TABLE InspectionViolation IS 'Stores inspection violations.';