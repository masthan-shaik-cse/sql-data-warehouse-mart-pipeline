-- Step 8: Validate the warehouse and analytical marts

SELECT CASE
    WHEN (SELECT COUNT(*) FROM job_postings_fact) > 0
        THEN 'PASS: warehouse fact table contains data'
    ELSE error('FAIL: job_postings_fact is empty')
END AS validation_result

UNION ALL

SELECT CASE
    WHEN NOT EXISTS (
        SELECT 1
        FROM job_postings_fact AS fact
        LEFT JOIN company_dim AS company
            ON fact.company_id = company.company_id
        WHERE fact.company_id IS NOT NULL
          AND company.company_id IS NULL
    )
        THEN 'PASS: all company keys resolve'
    ELSE error('FAIL: orphan company keys found')
END

UNION ALL

SELECT CASE
    WHEN NOT EXISTS (
        SELECT 1
        FROM skills_job_dim AS bridge
        LEFT JOIN skills_dim AS skill
            ON bridge.skill_id = skill.skill_id
        LEFT JOIN job_postings_fact AS fact
            ON bridge.job_id = fact.job_id
        WHERE skill.skill_id IS NULL
           OR fact.job_id IS NULL
    )
        THEN 'PASS: all skill bridge keys resolve'
    ELSE error('FAIL: orphan skill bridge keys found')
END

UNION ALL

SELECT CASE
    WHEN (SELECT COUNT(*) FROM flat_mart.job_postings) > 0
     AND (SELECT COUNT(*) FROM skills_mart.fact_skill_demand_monthly) > 0
     AND (SELECT COUNT(*) FROM priority_mart.priority_jobs_snapshot) > 0
     AND (SELECT COUNT(*) FROM company_mart.fact_company_hiring_monthly) > 0
        THEN 'PASS: every analytical mart contains data'
    ELSE error('FAIL: one or more analytical marts are empty')
END

UNION ALL

SELECT CASE
    WHEN NOT EXISTS (
        SELECT 1
        FROM company_mart.fact_company_hiring_monthly
        WHERE remote_share NOT BETWEEN 0 AND 1
           OR health_insurance_share NOT BETWEEN 0 AND 1
           OR no_degree_mention_share NOT BETWEEN 0 AND 1
    )
        THEN 'PASS: company mart share measures are valid'
    ELSE error('FAIL: company mart share measure outside 0-1 range')
END;
