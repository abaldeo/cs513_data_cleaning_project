ALTER TABLE
    EstablishmentLocation
ADD CONSTRAINT uc_location_key UNIQUE (address, city, state, zip);

ALTER TABLE
    FoodEstablishment
ADD CONSTRAINT uc_establishment_key UNIQUE (license_number, dba_name, aka_name, location_id);

