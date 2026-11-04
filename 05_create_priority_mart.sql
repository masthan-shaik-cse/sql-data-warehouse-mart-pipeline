-- Step 5: Mart - Create Priority Roles Mart

DROP SCHEMA IF EXISTS priority_mart CASCADE;

CREATE SCHEMA priority_mart;

SELECT '=== Loading Roles for Priority Mart ===' AS info;
CREATE TABLE priority_mart.priority_roles (
    role_id         INTEGER     PRIMARY KEY,
    role_name       VARCHAR,
    priority_lvl    INTEGER
);


INSERT INTO priority_mart.priority_roles (role_id,role_name,priority_lvl)
VALUES
    (1, 'Data Engineer',        2),
    (2, 'Senior Data Engineer', 1),
    (3, 'Software Engineer',    3);

SELECT * FROM priority_mart.priority_roles;

SELECT '=== Loading Snapshot for Priority Mart ===' AS info;
CREATE OR REPLACE TABLE priority_mart.priority_jobs_snapshot (
    job_id              INTEGER     PRIMARY KEY,
    job_title_short     VARCHAR,
    company_name        VARCHAR,
    job_posted_date     TIMESTAMP,
    salary_year_avg     DOUBLE,
    priority_lvl        INTEGER,
    updated_at           TIMESTAMP
);

INSERT INTO priority_mart.priority_jobs_snapshot (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)

SELECT
 jpf.job_id,
 jpf.job_title_short,
 cd.name as company_name,
 jpf.job_posted_date,
 jpf.salary_year_avg,
 r.priority_lvl,
 CURRENT_TIMESTAMP
FROM
    job_postings_fact AS jpf
left join company_dim AS cd
on jpf.company_id = cd.company_id
INNER JOIN priority_mart.priority_roles AS r
on jpf.job_title_short = r.role_name;


SELECT
    job_title_short,
    count(*) AS job_count,
    min(priority_lvl) AS priority_lvl,
    min(updated_at) AS updated_at
from
    priority_mart.priority_jobs_snapshot
group by job_title_short
order by job_count desc;
