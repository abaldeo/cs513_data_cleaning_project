import logging 
import sqlite3
import click
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

DEFAULT_SCRIPTS = [
    ("foodinspections_raw.sqlite", "../sql/ddl/food_inspections_db_sqlite_ddl.sql"),
    #("foodinspections.sqlite", "../sql/orm/food_inspections_db_sqlite_pony.sql"),
    ("foodinspections_raw.sqlite", "../sql/ddl/food_inspections_db_create_indexes.sql"),
    #("foodinspections.sqlite", "../sql/ddl/food_inspections_db_create_unique_indexes.sql"),
    #("foodinspections.sqlite", "../sql/ddl/food_inspections_db_add_constraints.sql"),
    ]


@click.command()
@click.option('--db_scripts', type=(str, str), multiple=True, help='Pairs of DB name and DDL filename')
def run_db_scripts(db_scripts):
    if not db_scripts: db_scripts = DEFAULT_SCRIPTS
    for dbname, filename in db_scripts:
        logger.info("-- running DDL '%s'" % dbname)
        
        with open(filename, 'r') as f:
            ddl = f.read()
        with sqlite3.connect(dbname) as conn:
            cur = conn.cursor()
            # Execute the DDL
            cur.executescript(ddl)
    logger.info("Done.")



def main():
    run_db_scripts()
    
if __name__ == '__main__':
    main()