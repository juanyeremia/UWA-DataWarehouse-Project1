-- ============================================
-- CITS5504 Data Warehouse Project
-- PostgreSQL Schema Creation Script
-- Authors: Juan Yovian, Jovan Aurelius Wylen
-- ============================================

-- ============================================
-- STEP 1: DROP TABLES IF THEY EXIST
-- ============================================

DROP TABLE IF EXISTS fact_flight_activity;
DROP TABLE IF EXISTS dim_airport;
DROP TABLE IF EXISTS dim_passenger;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_flight_status;
DROP TABLE IF EXISTS dim_location;

-- ============================================
-- STEP 2: CREATE DIMENSION TABLES
-- (create before fact table for FK resolution)
-- ============================================

-- dim_location
CREATE TABLE dim_location (
    location_key SERIAL PRIMARY KEY,
    country_code VARCHAR(10),
    country_name VARCHAR(100),
    continent_code VARCHAR(10),
    continent_name VARCHAR(50)
);

-- dim_passenger
CREATE TABLE dim_passenger (
    passenger_key INTEGER PRIMARY KEY,
    passenger_id VARCHAR(20),
    age INTEGER,
    age_group VARCHAR(20),
    gender VARCHAR(10),
    nationality VARCHAR(50)
);

-- dim_airport
CREATE TABLE dim_airport (
    airport_key INTEGER PRIMARY KEY,
    airport_code VARCHAR(10),
    airport_name VARCHAR(100),
    airport_type VARCHAR(50),
    municipality VARCHAR(100),
    location_key INTEGER REFERENCES dim_location(location_key)
);

-- dim_date
CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY,
    date DATE,
    day INTEGER,
    week INTEGER,
    month INTEGER,
    quarter INTEGER,
    year INTEGER
);

-- dim_flight_status
CREATE TABLE dim_flight_status (
    flight_status_key INTEGER PRIMARY KEY,
    flight_status VARCHAR(20)
);

-- ============================================
-- STEP 3: CREATE FACT TABLE
-- ============================================

-- fact_flight_activity
CREATE TABLE fact_flight_activity (
    flight_activity_id INTEGER PRIMARY KEY,
    passenger_key INTEGER REFERENCES dim_passenger(passenger_key),
    airport_key INTEGER REFERENCES dim_airport(airport_key),
    date_key INTEGER REFERENCES dim_date(date_key),
    flight_status_key INTEGER REFERENCES dim_flight_status(flight_status_key),
    passenger_count SMALLINT,
    is_international SMALLINT
);

-- ============================================
-- STEP 4: LOAD DATA FROM CSV FILES
-- Note: Adjust file paths as necessary for your environment
-- ============================================

COPY dim_location(location_key, country_code, country_name, 
    continent_code, continent_name)
FROM 'path_to_files\dim_location.csv'
DELIMITER ','
CSV HEADER;

COPY dim_passenger(passenger_key, passenger_id, age, 
    age_group, gender, nationality)
FROM 'path_to_files\dim_passenger.csv'
DELIMITER ','
CSV HEADER;

COPY dim_airport(airport_key, airport_code, airport_name, 
    airport_type, municipality, location_key)
FROM 'path_to_files\dim_airport.csv'
DELIMITER ','
CSV HEADER;

COPY dim_date(date_key, date, day, week, month, quarter, year)
FROM 'path_to_files\dim_date.csv'
DELIMITER ','
CSV HEADER;

COPY dim_flight_status(flight_status_key, flight_status)
FROM 'path_to_files\dim_flight_status.csv'
DELIMITER ','
CSV HEADER;

COPY fact_flight_activity(flight_activity_id, passenger_key, 
    airport_key, date_key, flight_status_key, 
    passenger_count, is_international)
FROM 'path_to_files\fact_flight_activity.csv'
DELIMITER ','
CSV HEADER;
