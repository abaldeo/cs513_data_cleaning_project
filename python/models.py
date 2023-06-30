from datetime import date
from decimal import Decimal
from pony.orm import *


db = Database()

class FoodEstablishment(db.Entity):
    id = PrimaryKey(int, auto=True, unsigned=True)
    license_number = Optional(int, nullable=True, unsigned=True)
    dba_name = Required(str, 100)
    aka_name = Optional(str, 100, nullable=True)
    facility_type = Optional(str, 50, nullable=True, index='idx_facility_type')
    location_id = Required('EstablishmentLocation')
    food_inspections = Optional('FoodInspection')


class EstablishmentLocation(db.Entity):
    id = PrimaryKey(int, auto=True, unsigned=True)
    address = Required(str, 50)
    city = Optional(str, 50, nullable=True)
    state = Optional(str, 2, nullable=True)
    zip = Optional(str, 5, nullable=True)
    latitude = Optional(Decimal, precision=9, scale=6)
    longitude = Optional(Decimal, precision=9, scale=6)
    location = Optional(str, nullable=True, sql_type='point')
    food_establishments = Optional(FoodEstablishment)


class FoodInspection(db.Entity):
    inspection_id = PrimaryKey(int, unsigned=True)
    risk = Optional(str, 15, nullable=True)
    risk_level = Optional(int, size=8)
    risk_category = Optional(str, 10, nullable=True, index='idx_risk_category')
    inspection_type = Optional(str, 50, nullable=True, index='idx_inspection_type')
    inspection_date = Optional(date, index='idx_inspection_date')
    results = Optional(str, 20, nullable=True, index='idx_results')
    establishment_id = Required(FoodEstablishment)
    inspection_violations = Set('InspectionViolation', cascade_delete=False)


class ViolationCode(db.Entity):
    code = PrimaryKey(int, size=8, unsigned=True)
    description = Optional(str, nullable=True, sql_type='text')
    inspection_violations = Set('InspectionViolation', cascade_delete=False)


class InspectionViolation(db.Entity):
    inspection_id = Required(FoodInspection)
    violation_code = Required(ViolationCode)
    comment = Optional(str, nullable=True, sql_type='text')
    PrimaryKey(inspection_id, violation_code)


if __name__ == '__main__':
    db.bind(provider='sqlite', filename='foodinspections.sqlite', create_db=False)    
    set_sql_debug(True)
    db.generate_mapping(create_tables=False)