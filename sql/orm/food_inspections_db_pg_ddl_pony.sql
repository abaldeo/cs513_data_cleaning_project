CREATE TABLE "establishmentlocation" (
  "id" SERIAL PRIMARY KEY,
  "address" VARCHAR(50) NOT NULL,
  "city" VARCHAR(50),
  "state" CHAR(2),
  "zip" CHAR(5),
  "latitude" DECIMAL(10, 8),
  "longitude" DECIMAL(11, 8),
  "location" POINT
);

CREATE TABLE "foodestablishment" (
  "id" SERIAL PRIMARY KEY,
  "license_number" BIGINT,
  "dba_name" VARCHAR(100) NOT NULL,
  "aka_name" VARCHAR(100),
  "facility_type" VARCHAR(50),
  "location_id" BIGINT NOT NULL
);

CREATE INDEX "idx_facility_type"
ON "foodestablishment" ("facility_type");

CREATE INDEX "idx_foodestablishment__location_id"
ON "foodestablishment" ("location_id");

ALTER TABLE
  "foodestablishment"
ADD
  CONSTRAINT "fk_foodestablishment__location_id" FOREIGN KEY ("location_id") REFERENCES "establishmentlocation" ("id");

CREATE TABLE "foodinspection" (
  "inspection_id" BIGINT PRIMARY KEY,
  "risk" VARCHAR(15),
  "risk_level" SMALLINT,
  "risk_category" VARCHAR(10),
  "inspection_type" VARCHAR(50),
  "inspection_date" DATE NOT NULL,
  "results" VARCHAR(20) NOT NULL,
  "establishment_id" BIGINT NOT NULL
);

CREATE INDEX "idx_foodinspection__establishment_id"
ON "foodinspection" ("establishment_id");

CREATE INDEX "idx_inspection_date"
ON "foodinspection" ("inspection_date");

CREATE INDEX "idx_inspection_type"
ON "foodinspection" ("inspection_type");

CREATE INDEX "idx_results"
ON "foodinspection" ("results");

CREATE INDEX "idx_risk_category"
ON "foodinspection" ("risk_category");

ALTER TABLE
  "foodinspection"
ADD
  CONSTRAINT "fk_foodinspection__establishment_id" FOREIGN KEY ("establishment_id") REFERENCES "foodestablishment" ("id");

CREATE TABLE "violationcode" (
  "code" SMALLINT PRIMARY KEY,
  "description" TEXT NOT NULL
);

CREATE TABLE "inspectionviolation" (
  "inspection_id" BIGINT NOT NULL,
  "violation_code" SMALLINT NOT NULL,
  "comment" TEXT,
  PRIMARY KEY ("inspection_id", "violation_code")
);

CREATE INDEX "idx_inspectionviolation__violation_code"
ON "inspectionviolation" ("violation_code");

ALTER TABLE
  "inspectionviolation"
ADD
  CONSTRAINT "fk_inspectionviolation__inspection_id" FOREIGN KEY ("inspection_id") REFERENCES "foodinspection" ("inspection_id");

ALTER TABLE
  "inspectionviolation"
ADD
  CONSTRAINT "fk_inspectionviolation__violation_code" FOREIGN KEY ("violation_code") REFERENCES "violationcode" ("code")