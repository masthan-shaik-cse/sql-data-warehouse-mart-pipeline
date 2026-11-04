-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1: DW - Create star schema tables
.read 01_create_tables_dw.sql

-- Step 2: DW - Load data from CSV files into the tables
.read 02_load_schema_dw.sql

-- Step 3: Mart - Create flat mart
.read 03_create_flat_mart.sql

-- Step 4: Mart - Create skills demand mart
.read 04_create_skills_mart.sql

-- Step 5: Mart - Create priority mart
.read 05_create_priority_mart.sql

-- Step 6: Mart - Update priority mart
.read 06_update_priority_mart.sql

-- Step 7: Mart - Create company hiring mart
.read 07_create_company_mart.sql

-- Step 8: Validate warehouse and marts
.read 08_validate_pipeline.sql
