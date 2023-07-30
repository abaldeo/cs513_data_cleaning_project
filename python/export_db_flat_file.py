from re import A
import click
import pandas as pd
import sqlite3

SQL = """select  f.dba_name 'DBA Name', f.aka_name 'AKA Name',f.license_number 'License #', f.facility_type 'Facility Type', 
l.address 'Address', l.city 'City', l.state 'State', l.zip 'Zip', l.latitude 'Latitude', l.longitude 'Longitude', l.location 'Location',
i.inspection_id 'Inspection ID', i.inspection_type 'Inspection Type', i.inspection_date 'Inspection Date', i.results 'Results', 
i.risk 'Risk', i.risk_category 'Risk Category', i.risk_level 'Risk Level',
v.violation_code 'Violation Code', c.description 'Description', v.comment 'Comment'
from FoodInspection i  
join FoodEstablishment f  on f.id = i.establishment_id
join EstablishmentLocation l on f.location_id = l.id 
join InspectionViolation v on v.inspection_id = i.inspection_id 
join violationcode c on c.code = v.violation_code
 """
 
@click.command()
@click.argument('db_path', type=click.Path())
@click.argument('output_file', type=click.Path())
def export_query_to_csv(db_path, output_file):
    # Connect to the SQLite database
    conn = sqlite3.connect(db_path)

    # Execute the query and return the results as a DataFrame
    df = pd.read_sql_query(SQL, conn)

    # Write the DataFrame to a CSV file
    df.to_csv(output_file, index=False)

if __name__ == '__main__':
    export_query_to_csv()