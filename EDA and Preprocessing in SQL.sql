-- Data Preprocessing 
-- table created and data inserted into the raw table
select *
from wind_turbine_raw;

-- Create a new table with the same structure as the raw table
create table wind_turbine
like wind_turbine_raw;

-- View the original raw data
select * 
from wind_turbine;

-- Copy all data from raw table to the working table
insert wind_turbine
select * 
from wind_turbine_raw;

-- View the data in the new working table
select * 
from wind_turbine;

-- step 1 
-- identifying duplicates

with Duplicate_CTE as
(
select * ,
row_number() over(partition by `date` , Wind_speed, `Power` , Nacelle_ambient_temperature , Generator_bearing_temperature , 
Gear_oil_temperature , Ambient_temperature , Rotor_Speed , Nacelle_temperature , `Bearing_temperature)` , Generator_speed, Yaw_angle,
Wind_direction , Wheel_hub_temperature , Gear_box_inlet_temperature , Failure_status) as Row_Num
from wind_turbine
)
select * 
from Duplicate_CTE
where Row_Num > 1; -- Here output is empty so no duplicates

-- Remove duplicates:
-- we cannot directly remove duplicate from a cte because cts does not support DML operations
-- create a dummy table wind_turbine2

CREATE TABLE `wind_turbine2` (
  `date` text,
  `Wind_speed` double DEFAULT NULL,
  `Power` double DEFAULT NULL,
  `Nacelle_ambient_temperature` double DEFAULT NULL,
  `Generator_bearing_temperature` double DEFAULT NULL,
  `Gear_oil_temperature` double DEFAULT NULL,
  `Ambient_temperature` double DEFAULT NULL,
  `Rotor_Speed` double DEFAULT NULL,
  `Nacelle_temperature` double DEFAULT NULL,
  `Bearing_temperature)` double DEFAULT NULL,
  `Generator_speed` double DEFAULT NULL,
  `Yaw_angle` double DEFAULT NULL,
  `Wind_direction` double DEFAULT NULL,
  `Wheel_hub_temperature` double DEFAULT NULL,
  `Gear_box_inlet_temperature` double DEFAULT NULL,
  `Failure_status` text, 
  `Row_Num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from wind_turbine2;

insert into wind_turbine2
select * ,
row_number() over(
partition by `date` , Wind_speed, `Power` , Nacelle_ambient_temperature , Generator_bearing_temperature , 
Gear_oil_temperature , Ambient_temperature , Rotor_Speed , Nacelle_temperature , `Bearing_temperature)` , Generator_speed, Yaw_angle,
Wind_direction , Wheel_hub_temperature , Gear_box_inlet_temperature , Failure_status) as Row_Num
from wind_turbine;

-- removing duplicates
delete 
from wind_turbine2
where Row_Num > 1;

-- step 2
-- standardize 

-- for wind_speed:
select Wind_speed , trim(Wind_speed)
from wind_turbine2;

update wind_turbine2
set Wind_speed = trim(Wind_speed);

-- for power
select `Power` , trim(`power`)
from wind_turbine2;

update wind_turbine2
set `Power` = trim(`Power`);

-- since most of the data are continuous lets directly dive into the Date column 
-- here the datatype of date column is text so lets convert it into datetime 

select `date` 
from wind_turbine2;

select `date`, 
str_to_date(`date` , '%Y-%m-%d')
from wind_turbine2;

update wind_turbine2
set `date` = str_to_date(`date` , '%Y-%m-%d');

alter table wind_turbine2
modify column `date` DATE;

-- step 3
-- check for null values 

select * 
from wind_turbine2
where `date` is null
or Wind_speed is null
or `Power` is null 
or Nacelle_ambient_temperature is null
or Generator_bearing_temperature is null
or Gear_oil_temperature is null
or Ambient_temperature is null
or Rotor_Speed is null
or Nacelle_temperature is null
or `Bearing_temperature)` is null
or Generator_speed is null
or Yaw_angle is null
or Wind_direction is null
or Wheel_hub_temperature is null
or Gear_box_inlet_temperature is null
or Failure_status is null
or Row_Num is null;    -- here output is empty so no null values so we dont need to remove or replace anything 

-- step 4 
-- delete unwanted columns 
-- here the unwanted column is Row_Num
alter table wind_turbine2
drop column Row_Num;

-- the final cleaned data 
select * 
from wind_turbine2;

-- EDA 
-- 1st Moment: Mean/Expected value for critical features

SELECT 
    AVG(Wind_speed) AS avg_Wind_speed,
    AVG(Power) AS avg_Power,
    AVG(Nacelle_ambient_temperature) AS avg_Nacelle_ambient_temperature,
    AVG(Generator_bearing_temperature) AS avg_Generator_bearing_temperature,
    AVG(Gear_oil_temperature) AS avg_Gear_oil_temperature,
    AVG(Ambient_temperature) AS avg_Ambient_temperature,
    AVG(Rotor_Speed) AS avg_Rotor_Speed,
    AVG(Nacelle_temperature) AS avg_Nacelle_temperature,
    AVG(`Bearing_temperature)`) AS avg_Bearing_temperature,
    AVG(Generator_speed) AS avg_Generator_speed,
    AVG(Wheel_hub_temperature) AS avg_Wheel_hub_temperature,
    AVG(Gear_box_inlet_temperature) AS avg_Gear_box_inlet_temperature
FROM wind_turbine2;

-- 2nd Moment: Variance to understand variability in the data
SELECT 
    VARIANCE(Wind_speed) AS var_Wind_speed,
    VARIANCE(Power) AS var_Power,
    VARIANCE(Nacelle_ambient_temperature) AS var_Nacelle_ambient_temperature,
    VARIANCE(Generator_bearing_temperature) AS var_Generator_bearing_temperature,
    VARIANCE(Gear_oil_temperature) AS var_Gear_oil_temperature,
    VARIANCE(Ambient_temperature) AS var_Ambient_temperature,
    VARIANCE(Rotor_Speed) AS var_Rotor_Speed,
    VARIANCE(Nacelle_temperature) AS var_Nacelle_temperature,
    VARIANCE(`Bearing_temperature)`) AS var_Bearing_temperature,
    VARIANCE(Generator_speed) AS var_Generator_speed,
    VARIANCE(Wheel_hub_temperature) AS var_Wheel_hub_temperature,
    VARIANCE(Gear_box_inlet_temperature) AS var_Gear_box_inlet_temperature
FROM wind_turbine2;

-- 3rd Moment 
-- Skewness approximation could be calculated externally (Python/R), or we can look at data distribution through aggregate queries.
-- Here’s a general SQL query that could help visually inspect skewness by comparing higher and lower values.
SELECT
    COUNT(CASE WHEN Power < 2 THEN 1 END) AS Low_Power_Count,
    COUNT(CASE WHEN Power BETWEEN 2 AND 4 THEN 1 END) AS Moderate_Power_Count,
    COUNT(CASE WHEN Power > 4 THEN 1 END) AS High_Power_Count
FROM wind_turbine2;

-- 4th Moment
-- Kurtosis can be approximated by checking the number of extreme high or low values (outliers).
-- Example: checking extreme values for Power

SELECT 
    COUNT(*) AS extreme_values_count,
    AVG(Power) AS avg_Power,
    STDDEV(Power) AS std_dev_Power
FROM wind_turbine2
WHERE Power > (select AVG(Power) + 2 * STDDEV(Power) as higher from wind_turbine2)  -- High extreme outliers
   OR Power < (select AVG(Power) - 2 * STDDEV(Power) as `lower` from wind_turbine2 ); -- Low extreme outliers

-- Distribution of Failures
select 
Failure_Status , count(*) as Total_Count
from wind_turbine2
group by Failure_Status;

-- percentage failure 
SELECT 
    (COUNT(CASE WHEN Failure_status = 'Failure' THEN 1 END) * 100.0) / COUNT(*) AS percentage_failure
FROM wind_turbine2;

-- Averages of Each Feature by Failure Status
select Failure_Status,
avg(Wind_speed) as avg_Wind_speed,
avg(`Power`) as avg_Power,
avg(Nacelle_ambient_temperature) as avg_Nacelle_ambient_temperature,
avg(Generator_bearing_temperature) as avg_Generator_bearing_temperature,
avg(Gear_oil_temperature) as avg_Gear_oil_temperature,
avg(Ambient_temperature) as avg_Ambient_temperature,
avg(Rotor_Speed) as avg_Rotor_Speed,
avg(Nacelle_temperature) as avg_Nacelle_temperature,
avg(`Bearing_temperature)`) as avg_Bearing_temperature,
avg(Generator_speed) as avg_Generator_speed,
avg(Wheel_hub_temperature) as avg_Wheel_hub_temperature,
avg(Gear_box_inlet_temperature) as avg_Gear_box_inlet_temperature
from wind_turbine2
group by Failure_Status;

-- the output of the above query clearly shows that avg_Power, avg_Nacelle_ambient_temperature, avg_Gear_oil_temperature,
-- avg_Ambient_temperature, avg_Gear_box_inlet_temperature have significant differences in the values and 
-- are strong reason for failure 

select Wind_speed, Failure_Status
from wind_turbine2
where Failure_Status = 'Failure';

select Wind_speed, Failure_Status
from wind_turbine2
where Failure_Status = 'No_failure'; 
-- here in some rows wind speed is high even for non failure and low for failure so it does not directly influence the failure 

select max(`Power`), Failure_Status
from wind_turbine2
where Failure_Status = 'Failure';
-- here the max goes upto '11.88414738'

select max(`Power`), Failure_Status
from wind_turbine2
where Failure_Status = 'No_failure'; 
-- here the max goes upto '6.961823232'
-- this may influence! so lets confirm this 


SELECT 
  CASE 
    WHEN `Power` < 1 THEN 'Very Low'
    WHEN `Power` BETWEEN 1 AND 2 THEN 'Low'
    WHEN `Power` BETWEEN 2 AND 4 THEN 'Moderate'
    WHEN `Power` BETWEEN 4 AND 6 THEN 'High'
    ELSE 'Very High'
  END AS power_level,
  ROUND(SUM(CASE WHEN Failure_status = 'Failure' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_percentage
FROM wind_turbine2
GROUP BY power_level
ORDER BY failure_percentage DESC;

-- yes from this we can conclude that if the power is very high that is above 6 or very low that is below 1
-- then there is an high chance that it might fail 

-- next the most suspecious feature is Gear_oil_temperature, Ambient_temperature, Gear_box_inlet_temperature
-- so lets confrim this 

select min(Gear_oil_temperature), Failure_Status
from wind_turbine2
where Failure_Status = 'Failure';

select max(Gear_oil_temperature), Failure_Status
from wind_turbine2
where Failure_Status = 'No_failure'; 

-- here the min of Gear_oil_temperature for failure is greater that max of Gear_oil_temperature for Non Failure 
-- so from this we can conclude that Gear_oil_temperature influences the failure 
-- but lets confirm this 

select 
  case
   when Gear_oil_temperature < 50 then 'Low'
   when Gear_oil_temperature between 50 and 90 then 'Moderate'
   else 'High'
  end as Gear_oil_temperature_level,
  sum(case when Failure_status = 'Failure' then 1 else 0 end) * 100 / count(*) as failure_percentage
  from wind_turbine2
  group by Gear_oil_temperature_level;
-- here the failure percentage for high Gear_oil_temperature_level is 100%
-- from this we can conclude that if Gear_oil_temperature_level is moderate or low it does not influence 

select Ambient_temperature, Failure_Status
from wind_turbine2
where Failure_Status = 'Failure';

select Ambient_temperature, Failure_Status
from wind_turbine2
where Failure_Status = 'No_failure'; 

-- here we cannot come to a conclusion because even with low Ambient_temperature the turbine tend to change so lets work deep on this

select 
  case
    when Ambient_temperature < 1 then 'Low'
    when Ambient_temperature between 1 and 20 then 'Moderate'
    else 'High'
  end as Ambient_temperature_level, 
sum(case when Failure_Status = 'Failure' then 1 else 0 end) * 100 / count(*) as Failure_Percentage
from wind_turbine2
group by Ambient_temperature_level;

-- here high Ambient_temperature does not directly influence the failure of wind turbine but it might indirectly influence 

select Gear_box_inlet_temperature, Failure_Status
from wind_turbine2
where Failure_Status = 'Failure';

select Gear_box_inlet_temperature, Failure_Status
from wind_turbine2
where Failure_Status = 'No_failure'; 

-- here the Gear_box_inlet_temperature might influence the failure so lets do more analysis for confirmation 

select 
  case
    when Gear_box_inlet_temperature < 20 then 'Low'
    when Gear_box_inlet_temperature between 20 and 50 then 'Moderate'
    when Gear_box_inlet_temperature > 50 then 'High'
  end as Gear_box_inlet_temperature_level,
  sum(case when Failure_Status = 'Failure' then 1 else 0 end) * 100 / count(*) as Failure_rate
  from wind_turbine2
  group by Gear_box_inlet_temperature_level;
  
-- here the failure percentage for high Gear_box_inlet_temperature_level is 100% and for moderate it is '98.0033'%
-- from this we can conclude that if Gear_box_inlet_temperature_level is low it does not influence 


select * 
from wind_turbine2
where `Power` BETWEEN 4 AND 6 
and Ambient_temperature > 20;

select * 
from wind_turbine2
where `Power` BETWEEN 1 AND 2
and Ambient_temperature > 20;
-- if the Ambient_temperature is below 20 and power is in between 1 and 2 then the chances of getting failed is 100%

-- findings
-- Gear oil temperature above 90°C results in 100% failure.
-- Gear box inlet temperature above 50°C leads to 100% failure.
-- Power greater than 6 kW causes high failure rates.
-- Power less than 1 kW causes high failure rates.
-- Power between 1–2 kW with ambient temperature above 20°C leads to 100% failure.
-- Ambient temperature alone does not directly influence failure.
-- Wind speed does not consistently influence failure.
-- No null values found in the dataset.
-- No duplicate records present in the data.






