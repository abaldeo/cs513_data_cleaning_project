#!/bin/bash
poetry run python populate_models.py -db foodinspections_cleaned.sqlite -csv 05-repair_location/FoodInspection_location.csv -clean
