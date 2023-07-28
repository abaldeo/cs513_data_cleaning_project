#!/bin/bash
poetry run python populate_models.py -db foodinspections_cleaned.sqlite -csv 05-repair_location/Food_Inspections_location.csv -clean
