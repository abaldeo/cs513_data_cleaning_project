SELECT
  [inspection_id],
  [violation_code],
  [comment]
FROM
  [InspectionViolation]
  

SELECT
  count(*) - count([inspection_id]) Nulls_in_inspection_id, 
  count(*) - count([violation_code]) Nulls_in_violation_code,
  count(*) - count([comment]) Nulls_in_comment 

FROM
  [InspectionViolation];

SELECT
  COUNT(CASE WHEN inspection_id = 'NaN' THEN 1 END) AS inspection_id_nan_count,
  COUNT(CASE WHEN violation_code = 'NaN' THEN 1 END) AS violation_code_nan_count,
  COUNT(CASE WHEN comment = 'NaN' THEN 1 END) AS comment_nan_count 

FROM
  [InspectionViolation];


SELECT
  COUNT(CASE WHEN inspection_id = 'inf' THEN 1 END) AS inspection_id_inf_count,
  COUNT(CASE WHEN violation_code = 'inf' THEN 1 END) AS violation_code_inf_count,
  COUNT(CASE WHEN comment = 'inf' THEN 1 END) AS comment_inf_count 
FROM
  [InspectionViolation];

 