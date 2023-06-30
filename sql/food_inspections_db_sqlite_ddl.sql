CREATE TABLE EstablishmentLocation (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    address VARCHAR(50) NOT NULL,
    city VARCHAR(50),
    state CHAR(2),
    zip CHAR(5),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(10, 8),
    location POINT,
    UNIQUE (address, city, state, zip)
);

CREATE TABLE FoodEstablishment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    license_number INTEGER,
    dba_name VARCHAR(100) NOT NULL,
    aka_name VARCHAR(100),
    facility_type VARCHAR(50),
    location_id INTEGER,
    UNIQUE (license_number, dba_name, aka_name, location_id)
);

CREATE TABLE FoodInspection (
    inspection_id INTEGER PRIMARY KEY,
    risk VARCHAR(15),
    risk_level INTEGER,
    risk_category VARCHAR(10),
    inspection_type VARCHAR(50),
    inspection_date DATE,
    results VARCHAR(20) NOT NULL,
    establishment_id INTEGER
);

CREATE TABLE ViolationCode (
    code INTEGER PRIMARY KEY,
    description TEXT NOT NULL
);

CREATE TABLE InspectionViolation (
    inspection_id INTEGER,
    violation_code INTEGER,
    comment TEXT,
    PRIMARY KEY (inspection_id, violation_code),
    FOREIGN KEY (inspection_id) REFERENCES FoodInspection(inspection_id),
    FOREIGN KEY (violation_code) REFERENCES ViolationCode(code)
);