CREATE UNIQUE INDEX idx_uniq_location ON EstablishmentLocation(address, city, state, zip);
CREATE UNIQUE INDEX  idx_uniq_establishment ON FoodEstablishment(license_number, dba_name, aka_name, location_id);