#!/bin/bash
poetry run python populate_models.py -db foodinspections_raw.sqlite -csv FoodInspection.csv
