SELECT
  [id],
  [address],
  [city],
  [state],
  [zip],
  [latitude],
  [longitude],
  [location]
FROM
  [EstablishmentLocation]
   
 
 SELECT 
  count(*) - count(id) as Nulls_in_id,
  count(*) - count(address) as Nulls_in_address,
  count(*) - count(city) as Nulls_in_city,
  count(*) - count(state) as Nulls_in_state,
  count(*) - count(zip) as Nulls_in_zip,
  count(*) - count(latitude) as Nulls_in_latitude,
  count(*) - count(longitude) as Nulls_in_longitude,
  count(*) - count(location) as Nulls_in_location
FROM 
  EstablishmentLocation;
  
 
 SELECT
  COUNT(CASE WHEN id = 'NaN' THEN 1 END) AS id_nan_count,
  COUNT(CASE WHEN address = 'NaN' THEN 1 END) AS address_nan_count,
  COUNT(CASE WHEN city = 'NaN' THEN 1 END) AS city_nan_count,
  COUNT(CASE WHEN state = 'NaN' THEN 1 END) AS state_nan_count,
  COUNT(CASE WHEN zip = 'NaN' THEN 1 END) AS zip_nan_count,
  COUNT(CASE WHEN latitude = 'NaN' THEN 1 END) AS latitude_nan_count,
  COUNT(CASE WHEN longitude = 'NaN' THEN 1 END) AS longitude_nan_count,
  COUNT(CASE WHEN location = 'NaN' THEN 1 END) AS location_nan_count
FROM
  EstablishmentLocation


 
 SELECT
  COUNT(CASE WHEN id = 'inf' THEN 1 END) AS id_inf_count,
  COUNT(CASE WHEN address = 'inf' THEN 1 END) AS address_inf_count,
  COUNT(CASE WHEN city = 'inf' THEN 1 END) AS city_inf_count,
  COUNT(CASE WHEN state = 'inf' THEN 1 END) AS state_inf_count,
  COUNT(CASE WHEN zip = 'inf' THEN 1 END) AS zip_inf_count,
  COUNT(CASE WHEN latitude = 'inf' THEN 1 END) AS latitude_inf_count,
  COUNT(CASE WHEN longitude = 'inf' THEN 1 END) AS longitude_inf_count,
  COUNT(CASE WHEN location = 'inf' THEN 1 END) AS location_inf_count
FROM
  EstablishmentLocation
  

--find unmatched locations 
select l.id from EstablishmentLocation l
left join FoodEstablishment f on l.id = f.location_id
where f.location_id is null; 

select f.location_id from EstablishmentLocation l
right join FoodEstablishment f on l.id = f.location_id
where l.id is null;


select count(1) from EstablishmentLocation l 
inner join FoodEstablishment f on l.id = f.location_id


select    address, count(1) from EstablishmentLocation
group by  address 
having count(1) > 1;


select    address, count(distinct city) from EstablishmentLocation
group by  address 
having count(distinct city) > 1;
 
select    address,city, state, count(1) from EstablishmentLocation
group by  address,city, state   
having count(1) > 1;


select  location, latitude,   count(1) from EstablishmentLocation
group by location, latitude  
having count(1) > 1;


select  location, latitude,   count(distinct address) from EstablishmentLocation
group by location, latitude  
having count(distinct address ) > 1;

select * from EstablishmentLocation where location=  '(41.64655405113759, -87.61708299788354)';


