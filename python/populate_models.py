from models import *
import pandas as pd
import numpy as np
import re 
import click

def format_food_inspection_df(df):
        print(df.columns)
        df.columns = ['inspection_id', 'dba_name', 'aka_name', 'license_number', 'facility_type',
                        'risk', 'address', 'city', 'state', 'zip', 'inspection_date',
                        'inspection_type', 'results', 'violations', 'latitude', 'longitude', 'location']
        df['risk'] = df['risk'].astype(str).replace({'nan': None,  'inf': None})
        
        # Split the 'risk' column into two columns
        df[['risk_level', 'risk_category']] = df['risk'].str.split(' \(', expand=True)
        df['risk_category'] = df['risk_category'].str.strip(')')
        # Extract only the number from the 'risk level' column
        df['risk_level'] = df['risk_level'].str.extract('(\d+)').astype(str).replace({'nan': None,  'inf': None})
        
        df['inspection_date'] = pd.to_datetime(df['inspection_date'], format='%Y-%m-%dT%H:%M:%SZ', errors='coerce').fillna(pd.to_datetime(df['inspection_date'], format='%m/%d/%Y', errors='coerce'))

        df['inspection_type'] = df['inspection_type'].astype(str).replace({'nan': None,  'inf': None})
        df['violations'] = df['violations'].astype(str).replace({'nan': None,  'inf': None})

        df['license_number'] =  pd.to_numeric(df['license_number'], errors='coerce').astype('Int64')

        df['facility_type'] =  df['facility_type'].astype(str).replace({'nan': None,  'inf': None}) 
        df['aka_name'] =  df['aka_name'].astype(str).replace({'nan': None,  'inf': None})
        
        blank_rows = df[df['address'].str.strip()==''].index 
        # print(df.iloc[blank_rows] )
        df = df.drop(blank_rows) 
        
        null_rows = df[df['address'].astype('str') == 'nan'].index 
        # print(df.iloc[null_rows] )
        df = df.drop(null_rows)
                
        df['zip'] = df['zip'].astype(str).apply(lambda x: x[:5]).replace({'nan': None,  'inf': None})
        df['city'] = df['city'].astype(str).replace({'nan': None,  'inf': None})
        df['location'] = df['location'].astype(str).replace({'nan': None,  'inf': None})
        df['latitude'] =   df['latitude'].replace(np.nan, None)
        df['longitude'] =  df['longitude'].replace(np.nan, None)
        df['state'] = df['state'].astype(str).replace({'nan': None,  'inf': None})
        return df 

def split_food_inspection_df(df):        
        food_inspection_df = df[['inspection_id',  'risk','risk_level', 'risk_category','inspection_type', 'inspection_date', 'results', 'license_number', 'dba_name', 'aka_name' ]]
        food_inspection_df.loc[:, 'aka_name'] =  food_inspection_df['aka_name'].fillna(df['dba_name'], inplace=False)

        food_establishment_df = df[['license_number', 'dba_name', 'aka_name', 'facility_type', 'address', 'city', 'state', 'zip',#'latitude', 'longitude'
                                    'location']]
        food_establishment_df = format_loc_df(food_establishment_df)
        # food_establishment_df = food_establishment_df.drop(['latitude', 'longitude'], axis=1)
        
        establishment_location_df = df[['address', 'city', 'state', 'zip', 'latitude', 'longitude', 'location' ]]
        
        return {'FoodInspection':food_inspection_df, 'FoodEstablishment':food_establishment_df, 
                'EstablishmentLocation':establishment_location_df}

def get_violation_codes(df, perform_cleaning):
    # Loop through each row and extract the number and description
    inspections = []
    numbers = []
    descriptions = []
    comments = []
    for row in df.itertuples():
        if not row.violations: continue 
        for line in row.violations.split('|'):
            match = re.match(r'(\d+)\.\s+(.+?)\s+-\s+Comments:\s+(.+)', line.strip())
            if match:
                inspections.append(row.inspection_id)
                numbers.append(match.group(1))
                descriptions.append(match.group(2))
                comments.append(match.group(3))

    # Create a new DataFrame from the extracted numbers and descriptions    
    violation_df = pd.DataFrame({'code': numbers, 'description': descriptions})
    violation_df['code'] = violation_df['code'].astype(int)
    violation_df = violation_df.drop_duplicates()
    if perform_cleaning:
        # Trim leading and trailing whitespaces
        violation_df['description'] = violation_df['description'].str.strip()
        # Trim consecutive whitespaces 
        violation_df['description'] = violation_df['description'].str.replace(r'\s+', ' ', regex=True)
        # Remove asterisks
        violation_df['description'] = violation_df['description'].str.replace('*', '')
        
    inspection_violation_df = pd.DataFrame({'inspection_id': inspections, 'violation_code': numbers, 'comment': comments})
    inspection_violation_df['inspection_id'] = inspection_violation_df['inspection_id'].astype(int)
    inspection_violation_df['violation_code'] = inspection_violation_df['violation_code'].astype(int)
    # print(len(inspection_violation_df))
    inspection_violation_df = inspection_violation_df.drop_duplicates()
    # print(len(inspection_violation_df))

    if perform_cleaning:
        inspection_violation_df['comment'] = inspection_violation_df['comment'].str.strip()
        inspection_violation_df['comment'] = inspection_violation_df['comment'].str.replace(r'\s+', ' ', regex=True)
        inspection_violation_df['comment'] = inspection_violation_df['comment'].str.upper()
        
            
    inspection_violation_df = inspection_violation_df.groupby(['inspection_id', 'violation_code'])['comment'].apply(''.join).reset_index()
    # print(len(inspection_violation_df))

        
    return violation_df, inspection_violation_df


def split_row_dict(row_dict, cols):
    return {k: row_dict[k] for k in cols}

def clean_location_df(df):
    df.loc[df['address'] == '3901 S Dr Martin Luther King Jr Dr', 'location'] = '(41.823619, -87.616378)'
    df.loc[df['address'] == '4628 N Cumberland Ave', 'location'] = '(41.96389053134971, -87.83683847050548)'

    # df = format_loc_df(df)
    df = df.drop_duplicates(subset=['location'])
    # df = df.drop_duplicates(subset=['location_tmp'])   
    # df = df.drop_duplicates(subset=['address', 'city', 'state', 'zip'])
    # df = df.drop(['latitude_tmp','longitude_tmp', 'location_tmp'], axis=1) 
    return df     
    
def format_loc_df(df):
    df.loc[df['address'] == '3901 S Dr Martin Luther King Jr Dr', 'location'] = '(41.823619, -87.616378)'
    df.loc[df['address'] == '4628 N Cumberland Ave', 'location'] = '(41.96389053134971, -87.83683847050548)'

    # df['latitude'] = df.apply(lambda row: str(row['latitude'])[:str(row['latitude']).find('.')+9], axis=1)
    # df['longitude'] = df.apply(lambda row: str(row['longitude'])[:str(row['longitude']).find('.')+9], axis=1)
    # df['location'] = df.apply(lambda row: f"({row['latitude']}, {row['longitude']})", axis=1)
    return df 

def clean_establishment_df(df):
    df.loc[:, 'aka_name'] =  df['aka_name'].fillna(df['dba_name'], inplace=False)
    df = df.drop_duplicates(subset=['license_number', 'dba_name', 'aka_name'])
    # print(df.isnull().sum())
    # df.loc[:, 'aka_name'] =  df['aka_name'].fillna(df['dba_name'], inplace=False)
    # print(df.isnull().sum())
    return df 

@click.command()
@click.option('-db', '--dbfile', default='foodinspections.sqlite', type=str, help='Path to the SQLite file')
@click.option('-csv', '--csvfile', default='Food_Inspections.csv', type=str, help='Name of the Data CSV file')       
@click.option('-clean', '--cleandata', default=False, is_flag=True, help='clean data before populating models')        
def main(dbfile, csvfile, cleandata):
    db.bind(provider='sqlite', filename=dbfile, create_db=False)    
    set_sql_debug(True)
    db.generate_mapping(create_tables=False) 
    print(f'cleandata flag: {cleandata}')
    # Load the CSV file into a pandas DataFrame

    df = pd.read_csv(f'../dataset/{csvfile}')
    print (df.dtypes)
    df = format_food_inspection_df(df)   
    print(df.isnull().sum())
        
    violation_df, inspection_violation_df = get_violation_codes(df, perform_cleaning=cleandata)
    
    print(inspection_violation_df.head())
    print(len(inspection_violation_df))

    if cleandata:
        food_inspection_dfs = split_food_inspection_df(df)
        food_inspection_table = food_inspection_dfs['FoodInspection']
        food_establishment_table = food_inspection_dfs['FoodEstablishment']
        food_establishment_table = clean_establishment_df(food_establishment_table)
        
        establishment_location_table = food_inspection_dfs['EstablishmentLocation']
        establishment_location_table = clean_location_df(establishment_location_table)
        
    # print(food_establishment_table.head())

    if 1: 
        with db_session:
            InspectionViolation.select().delete(bulk=True)  
            
            FoodInspection.select().delete(bulk=True)
            
            FoodEstablishment.select().delete(bulk=True)  
                        
            EstablishmentLocation.select().delete(bulk=True)
            
            ViolationCode.select().delete(bulk=True)    
            
            commit() 
            for row in violation_df.to_dict('records'):
                violation = ViolationCode(**row)

            commit() 
            
            if cleandata:   
                for row in establishment_location_table.to_dict('records'):
                    location_record = split_row_dict(row, ['address', 'city', 'state', 'zip', 'latitude', 'longitude', 'location'])
                    assert location_record, 'location_record is empty'
                    location = EstablishmentLocation(**location_record)
                commit()
                
                establishments= []
                for row in food_establishment_table.to_dict('records'):
                    establishment_record = split_row_dict(row, ['license_number', 'dba_name', 'aka_name', 'facility_type'])
                    assert establishment_record, 'establisment_record is empty'
                    # location_id = EstablishmentLocation.select(lambda l: l.address == row['address'] and l.city == row['city'] and l.state ==row['state'] and l.zip == row['zip']).first().id 
                    location_id = EstablishmentLocation.select(lambda l: l.location == row['location']).first().id 
            
                    assert location_id, 'location_id is empty'
                    establishment_record['location_id'] = location_id
                    # print(establishment_record)
                    establishments.append(establishment_record)
                    

                establishment_df = pd.DataFrame(establishments)
                establishment_df.to_sql('FoodEstablishment', db.get_connection(), if_exists='append', index=False)
                    
                commit()
                
                
                loaded_food_establishment_df = pd.read_sql_query("SELECT id,license_number,dba_name,aka_name from FoodEstablishment", db.get_connection())
                loaded_food_establishment_df['license_number'] =  pd.to_numeric(loaded_food_establishment_df['license_number'], errors='coerce').astype('Int64')
                loaded_food_establishment_df = loaded_food_establishment_df.rename(columns={'id': 'establishment_id'})

                # print(loaded_food_establishment_df.dtypes, loaded_food_establishment_df.columns)
                # print(food_inspection_table.dtypes, food_inspection_table.columns)
                inspections_merged = pd.merge(food_inspection_table,loaded_food_establishment_df,on=['license_number', 'dba_name', 'aka_name'],how='inner')
                # print(inspections_merged.columns)
                # print(inspections_merged.isnull().sum())    
                # print(len(inspections_merged))
                inspections_merged = inspections_merged.drop(['license_number', 'dba_name', 'aka_name'], axis=1)
                inspections_merged.to_sql('FoodInspection', db.get_connection(), if_exists='append', index=False)

                commit()
                
                before_count = len(inspection_violation_df)
                inspection_violation_df = inspection_violation_df[inspection_violation_df['inspection_id'].isin(inspections_merged['inspection_id'])]
                after_count = len(inspection_violation_df)
                print(before_count, after_count, after_count-before_count)

            else:
                for row in df.to_dict('records'):
                    location_record = split_row_dict(row, ['address', 'city', 'state', 'zip', 'latitude', 'longitude', 'location'])
                    location = EstablishmentLocation(**location_record)
                    establishment_record = split_row_dict(row, ['license_number', 'dba_name', 'aka_name', 'facility_type'])
                    establishment = FoodEstablishment(**establishment_record, location_id=location)
                    inspection_record = split_row_dict(row, ['inspection_id',  'risk', 'risk_level','risk_category', 'inspection_type', 'inspection_date', 'results'])
                    inspection = FoodInspection(**inspection_record, establishment_id=establishment)
                
                commit() 
            # for row in inspection_violation_df.to_dict('records'):
            #     inspection_violation = InspectionViolation(**row)      

            inspection_violation_df.to_sql('InspectionViolation', db.get_connection(), if_exists='append', index=False)        
            
if __name__ == '__main__':
    main()
    


