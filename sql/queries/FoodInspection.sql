SELECT
  [inspection_id],
  [risk],
  [risk_level],
  [risk_category],
  [inspection_type],
  [inspection_date],
  [results],
  [establishment_id]
FROM
  [FoodInspection]



SELECT
  count(*) - count([inspection_id]) Nulls_in_inspection_id, 
  count(*) - count([risk]) Nulls_in_risk, 
  count(*) - count([risk_level]) Nulls_in_risk_level, 
  count(*) - count([risk_category]) Nulls_in_risk_category,
  count(*) - count([inspection_type]) Nulls_in_inspection_type, 
  count(*) - count([inspection_date]) Nulls_in_inspection_date, 
  count(*) - count([results]) Nulls_in_results, 
  count(*) - count([establishment_id]) Nulls_in_establishment_id 
FROM
  [FoodInspection]


  
SELECT 
  COUNT(CASE WHEN inspection_id = 'NaN' THEN 1 END) AS inspection_id_nan_count,
  COUNT(CASE WHEN risk = 'NaN' THEN 1 END) AS risk_nan_count,
  COUNT(CASE WHEN risk_level = 'NaN' THEN 1 END) AS risk_level_nan_count,
  COUNT(CASE WHEN risk_category = 'NaN' THEN 1 END) AS risk_category_nan_count,
  COUNT(CASE WHEN inspection_type = 'NaN' THEN 1 END) AS inspection_type_nan_count,
  COUNT(CASE WHEN inspection_date = 'NaN' THEN 1 END) AS inspection_date_nan_count, 
  COUNT(CASE WHEN results = 'NaN' THEN 1 END) AS results_nan_count, 
  COUNT(CASE WHEN establishment_id = 'NaN' THEN 1 END) AS establishment_id_nan_count  
FROM 
  FoodInspection;
  

SELECT 
  COUNT(CASE WHEN inspection_id = 'inf' THEN 1 END) AS inspection_id_inf_count,
  COUNT(CASE WHEN risk = 'inf' THEN 1 END) AS risk_inf_count,
  COUNT(CASE WHEN risk_level = 'inf' THEN 1 END) AS risk_level_inf_count,
  COUNT(CASE WHEN risk_category = 'inf' THEN 1 END) AS risk_category_inf_count,
  COUNT(CASE WHEN inspection_type = 'inf' THEN 1 END) AS inspection_type_inf_count,
  COUNT(CASE WHEN inspection_date = 'inf' THEN 1 END) AS inspection_date_inf_count, 
  COUNT(CASE WHEN results = 'inf' THEN 1 END) AS results_inf_count, 
  COUNT(CASE WHEN establishment_id = 'inf' THEN 1 END) AS establishment_id_inf_count  
FROM 
  FoodInspection;
 
--no dups
 select inspection_id, count(1)
 from FoodInspection
 group by inspection_id
 having count(1)>1 


select  f.license_number, inspection_date, results,count(distinct inspection_id) from FoodEstablishment f join FoodInspection i on f.id = i.establishment_id
group by f.license_number, inspection_date, results
having count(distinct inspection_id)> 1



select  f.license_number, inspection_date, results,  * 
from FoodEstablishment f join FoodInspection i on f.id = i.establishment_id
left join InspectionViolation v on v.inspection_id = i.inspection_id --ALWAYS USE LEFT JOIN FOR INSPECTIONVIOLATION 
left join violationcode c on c.code = v.violation_code
where license_number = '14616' and inspection_date ='2011-03-30'



--standardize/group inspection_type, ensure same case 
--make inspectionviolation comments the same sentence case. 
--when risk = All, category should be All, risk_level = 4 ? 

select distinct  risk, risk_category, risk_level from FoodInspection

select distinct  risk from FoodInspection
