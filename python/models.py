from datetime import date
from decimal import Decimal
from pony.orm import *


db = Database()

class FoodEstablishment(db.Entity):
    id = PrimaryKey(int, auto=True, unsigned=True)
    license_number = Optional(int, nullable=True, unsigned=True)  # license issued by government agencies
    dba_name = Required(str, 100)  # legal business name
    aka_name = Optional(str, 100, nullable=True)  # publicly known name
    facility_type = Optional(str, 50, nullable=True, index='idx_facility_type')  # type of food establishment
    location_id = Required('EstablishmentLocation')  # foreign key to identify location
    food_inspections = Optional('FoodInspection')


class EstablishmentLocation(db.Entity):
    id = PrimaryKey(int, auto=True, unsigned=True)
    address = Required(str, 50)
    city = Optional(str, 50, nullable=True)
    state = Optional(str, 2, nullable=True)
    zip = Optional(str, 5, nullable=True)
    latitude = Optional(Decimal, precision=10, scale=8)
    longitude = Optional(Decimal, precision=10, scale=8)
    location = Optional(str, nullable=True, sql_type='point')
    food_establishments = Optional(FoodEstablishment)


class FoodInspection(db.Entity):
    inspection_id = PrimaryKey(int, unsigned=True)  # not auto-generated
    risk = Optional(str, 15, nullable=True)  # risk assigned at inspection time
    risk_level = Optional(int, size=8)  # numeric risk value parsed from risk column
    risk_category = Optional(str, 10, nullable=True, index='idx_risk_category')  # risk label parsed from risk column
    inspection_type = Optional(str, 50, nullable=True, index='idx_inspection_type')  # type of inspection done
    inspection_date = Required(date, index='idx_inspection_date')  # when inspection took place
    results = Required(str, 20, index='idx_results')  # result of inspection
    establishment_id = Required(FoodEstablishment)  # foreign key to identify food establishment
    inspection_violations = Set('InspectionViolation', cascade_delete=False)


class ViolationCode(db.Entity):
    code = PrimaryKey(int, size=8, unsigned=True)  # violation ID (not auto-generated)
    description = Required(str, sql_type='text')  # health code violation description
    inspection_violations = Set('InspectionViolation', cascade_delete=False)


class InspectionViolation(db.Entity):
    inspection_id = Required(FoodInspection)  # foreign key to map to inspection event
    violation_code = Required(ViolationCode)  # foreign key to map to violation code
    comment = Optional(str, nullable=True, sql_type='text')  # parsed from violations field
    PrimaryKey(inspection_id, violation_code)


if __name__ == '__main__':
    db.bind(provider='sqlite', filename='foodinspections.sqlite', create_db=False)    
    set_sql_debug(True)
    db.generate_mapping(create_tables=False)