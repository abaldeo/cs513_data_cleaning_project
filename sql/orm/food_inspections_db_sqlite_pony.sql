CREATE TABLE "EstablishmentLocation" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "address" VARCHAR(50) NOT NULL,
  "city" VARCHAR(50),
  "state" CHAR(2),
  "zip" CHAR(5),
  "latitude" DECIMAL(10, 8),
  "longitude" DECIMAL(10, 8),
  "location" POINT
);

CREATE TABLE "FoodEstablishment" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "license_number" INTEGER UNSIGNED,
  "dba_name" VARCHAR(100) NOT NULL,
  "aka_name" VARCHAR(100),
  "facility_type" VARCHAR(50),
  "location_id" INTEGER NOT NULL REFERENCES "EstablishmentLocation" ("id")
);

CREATE INDEX "idx_facility_type"
ON "FoodEstablishment" ("facility_type");

CREATE INDEX "idx_foodestablishment__location_id"
ON "FoodEstablishment" ("location_id");

CREATE TABLE "FoodInspection" (
  "inspection_id" INTEGER UNSIGNED NOT NULL PRIMARY KEY,
  "risk" VARCHAR(15),
  "risk_level" TINYINT,
  "risk_category" VARCHAR(10),
  "inspection_type" VARCHAR(50),
  "inspection_date" DATE,
  "results" VARCHAR(20) NOT NULL,
  "establishment_id" INTEGER NOT NULL REFERENCES "FoodEstablishment" ("id")
);

CREATE INDEX "idx_foodinspection__establishment_id"
ON "FoodInspection" ("establishment_id");

CREATE INDEX "idx_inspection_date"
ON "FoodInspection" ("inspection_date");

CREATE INDEX "idx_inspection_type"
ON "FoodInspection" ("inspection_type");

CREATE INDEX "idx_results"
ON "FoodInspection" ("results");

CREATE INDEX "idx_risk_category"
ON "FoodInspection" ("risk_category");

CREATE TABLE "ViolationCode" (
  "code" TINYINT UNSIGNED NOT NULL PRIMARY KEY,
  "description" TEXT NOT NULL
);

CREATE TABLE "InspectionViolation" (
  "inspection_id" INTEGER UNSIGNED NOT NULL REFERENCES "FoodInspection" ("inspection_id"),
  "violation_code" TINYINT UNSIGNED NOT NULL REFERENCES "ViolationCode" ("code"),
  "comment" TEXT,
  PRIMARY KEY ("inspection_id", "violation_code")
);

CREATE INDEX "idx_inspectionviolation__violation_code"
ON "InspectionViolation" ("violation_code")