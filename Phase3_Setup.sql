/*-- 1. Create the Table
CREATE TABLE delivery1_logs (
order_id SERIAL PRIMARY KEY,
region VARCHAR(50),
status VARCHAR(20),
load_shedding_stage INT,
delivery_time_min INT,
driver_rating INT,
customer_note TEXT,
order_timestamp TIMESTAMP
);*/
/*-- 2. Populate with 500 rows of South African Mock Data
INSERT INTO delivery_logs (region, status, load_shedding_stage,
delivery_time_min, driver_rating, customer_note, order_timestamp)
SELECT
-- Randomly assign SA Regions
(ARRAY['Sandton' , 'Soweto' , 'Midrand' , 'Khayelitsha' ,
'Stellenbosch'])[floor(random() * 5 + 1)] as region,
-- Assign Status based on probability
CASE
WHEN random() < 0.7 THEN 'Delivered'
WHEN random() < 0.85 THEN 'Delayed'
ELSE 'Failed'
END as status,
-- Random Load Shedding Stages (0-6)
floor(random() * 7) as load_shedding_stage,
-- Generate Delivery Time (influenced by status)
CASE
WHEN random() < 0.1 THEN NULL -- Simulate missing data
ELSE floor(random() * 90 + 20)
END as delivery_time_min,
-- Random Driver Ratings (1-5)
floor(random() * 5 + 1) as driver_rating,
-- Common SA Customer Notes
(ARRAY['None' , 'Gate code 1234' , 'Corner house' , 'Security is strict' , 'Call on
arrival' , 'Dogs behind gate'])[floor(random() * 6 + 1)] as customer_note,
-- Timestamps for the first quarter of 2026
TIMESTAMP '2026-01-01 00:00:00' + random() * (TIMESTAMP '2026-03-31 23:59:59' -
TIMESTAMP '2026-01-01 00:00:00')
FROM generate_series(1, 500);
-- 3. Ingest some "Bad Data"
UPDATE delivery1_logs SET region = 'Soweto ' WHERE order_id % 10 = 0; 
-- Trailingspaces
UPDATE delivery1_logs SET delivery_time_min = 999 WHERE order_id % 15 = 0; 
--Outliers*/

/*SELECT 
    order_id, 
    region, 
    status, 
    customer_note 
FROM delivery1_logs 
WHERE region LIKE 'Soweto%' 
AND status = 'Failed';*/

 /*CLEANING THE DATA
UPDATE delivery1_logs 
SET region = TRIM(region);*/

/*FIXING NULLS
UPDATE delivery1_logs 
SET delivery_time_min = 0 
WHERE delivery_time_min IS NULL;*/

/*OUTLIERS 
UPDATE delivery1_logs 
SET delivery_time_min = 120 
WHERE delivery_time_min = 999;*/

/*POPIA Compliance Data, creating a protected viewof data*/
SELECT 
    order_id, 
    region, 
    status,
    -- This 'masks' the note if it contains a gate code
    CASE 
        WHEN customer_note LIKE '%Gate code%' THEN 'DATA MASKED FOR POPIA'
        ELSE customer_note 
    END AS safe_customer_note
FROM delivery__logs;