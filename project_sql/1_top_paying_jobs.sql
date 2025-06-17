/*
Question: What are the top-paying data analyst jobs?
- Indetify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove null).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment opportunities.
*/


-- CTE to find the jobs with any location in London, United Kingdom
WITH london_jobs AS(
    SELECT 
        job_id,
        job_location
    FROM
        job_postings_fact
    WHERE 
        job_location LIKE '%London%United_Kingdom%' 
        OR job_location lIKE '%London,_UK%'
)

-- Using CTE above, find the top 10 non-Senior 'Data Analyst' jobs with the highest salaries.
-- Showing which company posted those Top 10 paying jobs.
SELECT 
    jobs.job_id,
    company_dim.name AS company_name,
    jobs.job_title,
    jobs.job_title_short,
    jobs.job_location,
    jobs.job_schedule_type,
    jobs.salary_year_avg,
    jobs.job_posted_date
FROM 
    job_postings_fact AS jobs
    INNER JOIN london_jobs ON london_jobs.job_id = jobs.job_id
    LEFT JOIN company_dim ON company_dim.company_id = jobs.company_id
WHERE 
    job_title_short LIKE '%Data%Analyst'
    AND NOT job_title_short LIKE '%Senior%'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
