from models import *
import pandas as pd
import re 

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
        
        df['inspection_type'] = df['inspection_type'].astype(str).replace({'nan': None,  'inf': None})
        df['violations'] = df['violations'].astype(str).replace({'nan': None,  'inf': None})

        df['license_number'] =  pd.to_numeric(df['license_number'], errors='coerce').astype('Int64')

        df['facility_type'] =  df['facility_type'].astype(str).replace({'nan': None,  'inf': None}) 
        df['aka_name'] =  df['aka_name'].astype(str).replace({'nan': None,  'inf': None})
        
        blank_rows = df[df['address'].str.strip()==''].index 
        # print(establishment_location_df.iloc[blank_rows] )
        df = df.drop(blank_rows) 
                
        df['zip'] = df['zip'].astype(str).apply(lambda x: x[:5]).replace({'nan': None,  'inf': None})
        df['city'] = df['city'].astype(str).replace({'nan': None,  'inf': None})
        df['location'] = df['location'].astype(str).replace({'nan': None,  'inf': None})
        df['latitude'] = df['latitude'].astype(str).replace({'nan': None,  'inf': None}).astype(float)
        df['longitude'] = df['longitude'].astype(str).replace({'nan': None,  'inf': None}).astype(float)
        df['state'] = df['state'].astype(str).replace({'nan': None,  'inf': None})
        return df 

def split_food_inspection_df(df):
        df = format_food_inspection_df(df)
        
        food_inspection_df = df[['inspection_id',  'risk','inspection_type', 'inspection_date', 'results']]
        food_establishment_df = df[['license_number', 'dba_name', 'aka_name', 'facility_type']]
        establishment_location_df = df[['address', 'city', 'state', 'zip', 'latitude', 'longitude', 'location']]
        
        return {'FoodInspection':food_inspection_df, 'FoodEstablishment':food_establishment_df, 
                'EstablishmentLocation':establishment_location_df}

def get_violation_codes(df):
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

    inspection_violation_df = pd.DataFrame({'inspection_id': inspections, 'violation_code': numbers, 'comment': comments})
    inspection_violation_df['inspection_id'] = inspection_violation_df['inspection_id'].astype(int)
    inspection_violation_df['violation_code'] = inspection_violation_df['violation_code'].astype(int)
    # print(len(inspection_violation_df))
    inspection_violation_df = inspection_violation_df.drop_duplicates()
    # print(len(inspection_violation_df))
    inspection_violation_df = inspection_violation_df.groupby(['inspection_id', 'violation_code'])['comment'].apply('|'.join).reset_index()
    # print(len(inspection_violation_df))

    return violation_df, inspection_violation_df


def split_row_dict(row_dict, cols):
    return {k: row_dict[k] for k in cols}
        
def main():
    db.bind(provider='sqlite', filename='foodinspections.sqlite', create_db=False)    
    set_sql_debug(True)
    db.generate_mapping(create_tables=False) 
    
    # Load the CSV file into a pandas DataFrame

    df = pd.read_csv('../dataset/Food_Inspections.csv')
    print (df.dtypes)
    df = format_food_inspection_df(df)   
    
    violation_df, inspection_violation_df = get_violation_codes(df)
    
    print(inspection_violation_df.head())
    print(len(inspection_violation_df))

    # food_inspection_dfs = get_food_inspection_dfs(df)
    # food_inspection_table = food_inspection_dfs['FoodInspection']
    # food_establishment_table = food_inspection_dfs['FoodEstablishment']
    # establishment_location_table = food_inspection_dfs['EstablishmentLocation']
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
                
            # location_records = establishment_location_table.to_dict('records')
            # establishment_records = food_establishment_table.to_dict('records')
            # for loc_record, establishment_record in zip(location_records, establishment_records):
            #     location = EstablishmentLocation(**loc_record)
            #     FoodEstablishment(**establishment_record, location_id=location)
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
    


