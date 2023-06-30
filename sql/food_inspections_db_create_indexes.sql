CREATE INDEX idx_address
ON EstablishmentLocation(address, city, state, zip);

CREATE INDEX idx_foodestablishment__location_id
ON FoodEstablishment (location_id);

CREATE INDEX idx_facility_type
ON FoodEstablishment(facility_type);

CREATE INDEX idx_foodinspection__establishment_id
ON FoodInspection (establishment_id);

CREATE INDEX idx_risk_category
ON FoodInspection(risk_category);

CREATE INDEX idx_inspection_date
ON FoodInspection(inspection_date);

CREATE INDEX idx_inspection_type
ON FoodInspection(inspection_type);

CREATE INDEX idx_results
ON FoodInspection(results);


CREATE UNIQUE INDEX idx_uniq_location ON EstablishmentLocation(address, city, state, zip);

CREATE UNIQUE INDEX  idx_uniq_establishment ON FoodEstablishment(license_number, dba_name, aka_name, location_id);
