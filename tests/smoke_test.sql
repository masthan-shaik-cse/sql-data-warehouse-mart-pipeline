-- Fast, network-free pipeline test.
-- Run from the repository root with:
-- duckdb :memory: -c ".read tests/smoke_test.sql"

.read 01_create_tables_dw.sql

INSERT INTO company_dim (company_id, name)
VALUES
    (1, 'Northstar Analytics'),
    (2, 'Vector Labs');

INSERT INTO skills_dim (skill_id, skills, type)
VALUES
    (1, 'SQL', 'Programming'),
    (2, 'Python', 'Programming'),
    (3, 'DuckDB', 'Database');

INSERT INTO job_postings_fact (
    job_id,
    company_id,
    job_title_short,
    job_title,
    job_location,
    job_via,
    job_schedule_type,
    job_work_from_home,
    search_location,
    job_posted_date,
    job_no_degree_mention,
    job_health_insurance,
    job_country,
    salary_rate,
    salary_year_avg,
    salary_hour_avg
)
VALUES
    (101, 1, 'Data Engineer', 'Cloud Data Engineer', 'Bengaluru, India', 'LinkedIn', 'Full-time', TRUE, 'India', TIMESTAMP '2026-01-15 09:00:00', FALSE, TRUE, 'India', 'year', 95000, NULL),
    (102, 1, 'Senior Data Engineer', 'Senior Analytics Engineer', 'Hyderabad, India', 'Company Site', 'Full-time', TRUE, 'India', TIMESTAMP '2026-02-10 09:00:00', FALSE, TRUE, 'India', 'year', 125000, NULL),
    (103, 2, 'Software Engineer', 'Backend Software Engineer', 'Pune, India', 'Indeed', 'Full-time', FALSE, 'India', TIMESTAMP '2026-02-20 09:00:00', TRUE, FALSE, 'India', 'year', 85000, NULL),
    (104, 2, 'Data Scientist', 'Applied Data Scientist', 'Chennai, India', 'LinkedIn', 'Full-time', TRUE, 'India', TIMESTAMP '2026-03-05 09:00:00', TRUE, TRUE, 'India', 'year', 110000, NULL);

INSERT INTO skills_job_dim (skill_id, job_id)
VALUES
    (1, 101),
    (2, 101),
    (1, 102),
    (3, 102),
    (2, 103),
    (1, 104),
    (2, 104);

.read 03_create_flat_mart.sql
.read 04_create_skills_mart.sql
.read 05_create_priority_mart.sql
.read 06_update_priority_mart.sql
.read 07_create_company_mart.sql
.read 08_validate_pipeline.sql
