SELECT
  [id],
  [license_number],
  [dba_name],
  [aka_name],
  [facility_type],
  [location_id]
FROM
  [FoodEstablishment]
  
  
SELECT 
  COUNT(*) - COUNT(id) AS NullsInId,
  COUNT(*) - COUNT(license_number) AS NullsInLicenseNumber,
  COUNT(*) - COUNT(dba_name) AS NullsInDbaName,
  COUNT(*) - COUNT(aka_name) AS NullsInAkaName,
  COUNT(*) - COUNT(facility_type) AS NullsInFacilityType,
  COUNT(*) - COUNT(location_id) AS NullsInLocationId
FROM 
  FoodEstablishment;
 
  
SELECT 
  COUNT(CASE WHEN id = 'NaN' THEN 1 END) AS id_nan_count,
  COUNT(CASE WHEN license_number = 'NaN' THEN 1 END) AS license_number_nan_count,
  COUNT(CASE WHEN dba_name = 'NaN' THEN 1 END) AS dba_name_nan_count,
  COUNT(CASE WHEN aka_name = 'NaN' THEN 1 END) AS aka_name_nan_count,
  COUNT(CASE WHEN facility_type = 'NaN' THEN 1 END) AS facility_type_nan_count,
  COUNT(CASE WHEN location_id = 'NaN' THEN 1 END) AS location_id_nan_count 
FROM 
  FoodEstablishment;
  

SELECT 
  COUNT(CASE WHEN id = 'inf' THEN 1 END) AS id_inf_count,
  COUNT(CASE WHEN license_number = 'inf' THEN 1 END) AS license_number_inf_count,
  COUNT(CASE WHEN dba_name = 'inf' THEN 1 END) AS dba_name_inf_count,
  COUNT(CASE WHEN aka_name = 'inf' THEN 1 END) AS aka_name_inf_count,
  COUNT(CASE WHEN facility_type = 'inf' THEN 1 END) AS facility_type_inf_count,
  COUNT(CASE WHEN location_id = 'inf' THEN 1 END) AS location_id_inf_count 
FROM 
  FoodEstablishment;


select dba_name, license_number from FoodEstablishment where dba_name in (
select distinct dba_name from FoodEstablishment where license_number is null 
) --and license_number is not null 
order by 1 ,2

select  count(  license_number),   count(distinct license_number) from FoodEstablishment
 

--33,643
select  distinct license_number, dba_name from FoodEstablishment

 
--license_number, dba_name , aka_name, location_id need to be made unique 

select      license_number, count(distinct dba_name) from FoodEstablishment
group by  license_number 
having count(distinct dba_name) > 1;
 

select     dba_name, license_number, count(distinct facility_type) from FoodEstablishment
group by dba_name, license_number   
having  count(distinct facility_type) > 1;
 
select * from FoodEstablishment where dba_name = 'ALTGELD GARDENS DAYCARE'

select      dba_name, count(1) from FoodEstablishment
group by   dba_name 
having count(1) > 1 order by 2 desc; 



select      dba_name, count(distinct license_number) from FoodEstablishment
group by   dba_name 
having count(distinct license_number) > 1 order by 2 desc; 


select * from FoodEstablishment 
f join EstablishmentLocation l on f.location_id = l.id 
where license_number is null 



select f.dba_name, coalesce(f.aka_name, f.dba_name) aka_name, f.license_number, l.address, city, state,count(distinct f.facility_type)  from FoodEstablishment 
f join EstablishmentLocation l on f.location_id = l.id 
group by f.dba_name, coalesce(f.aka_name, f.dba_name), f.license_number, l.address, city, state
having count(distinct  f.facility_type)> 1
order by 6 desc


select address, count(distinct f.license_number) from FoodEstablishment 
f join EstablishmentLocation l on f.location_id = l.id 
where   f.dba_name = 'SUBWAY'
Group by address 
having count(distinct f.license_number) > 1



select * from FoodEstablishment 
f join EstablishmentLocation l on f.location_id = l.id 
where  f.dba_name='WOW BAO' and address='175 W JACKSON BLVD'
order by f.license_number
--franchises have different licenses
--can have multiple food places at same location , even for same franchise with different license number


34,012

select  distinct f.dba_name, coalesce(f.aka_name, f.dba_name)  , f.license_number, l.address, city, state 
from FoodEstablishment 
f join EstablishmentLocation l on f.location_id = l.id  


create temporary table temp as 
select *
from FoodEstablishment where aka_name is null 


update FoodEstablishment set aka_name = coalesce(aka_name, dba_name) 
  where aka_name is null 

 

select   f.license_number, f.dba_name, f.aka_name , l.address, l.city, l.state,  count(1)
from FoodEstablishment f join EstablishmentLocation l on f.location_id = l.id  
group by   f.license_number, f.dba_name, f.aka_name , l.address, l.city, l.state 
having count(  1)>1



select * from FoodEstablishment 
f join EstablishmentLocation l on f.location_id = l.id 
where  f.dba_name='CUDDLE CARE' and address='4800 S LAKE PARK AVE'
order by f.license_number
 