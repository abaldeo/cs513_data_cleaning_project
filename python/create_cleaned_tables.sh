#!/bin/bash
poetry run python create_db_tables.py --db_scripts foodinspections_cleaned.sqlite ../sql/ddl/food_inspections_db_sqlite_ddl.sql --db_scripts foodinspections_cleaned.sqlite ../sql/ddl/food_inspections_db_create_indexes.sql --db_scripts foodinspections_cleaned.sqlite ../sql/ddl/food_inspections_db_create_unique_indexes.sql
