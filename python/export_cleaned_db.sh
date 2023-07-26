#!/bin/bash
poetry run python export_db_flat_file.py foodinspections_cleaned.sqlite ../dataset/food_inspections_db_cleaned.csv
