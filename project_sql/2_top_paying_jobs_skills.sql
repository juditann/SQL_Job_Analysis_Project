/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
  helping job seekers understand which skills to develop that align with top salaries.
*/

-- CTE to find the jobs in any location within London, United Kingdom
WITH london_jobs AS(
    SELECT 
        jobs.job_id,
        jobs.job_location
    FROM
        job_postings_fact AS jobs
    WHERE 
        jobs.job_location LIKE '%London%United_Kingdom%' 
        OR jobs.job_location lIKE '%London,_UK%'
),

-- CTE to find the top high-paying jobs in London, UK using CTE above
top_paying_jobs AS(
    SELECT 
        jobs.job_id,
        company_dim.name AS company_name,
        jobs.job_title,
        jobs.job_title_short,
        jobs.salary_year_avg
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
    LIMIT 10
)

-- Using inner join to find the skills related to the top 10 highest-paying jobs in London
SELECT 
    top_paying_jobs.job_id,
    top_paying_jobs.company_name,
    top_paying_jobs.job_title_short,
    top_paying_jobs.salary_year_avg,
    skills_dim.skills AS skill_name
FROM 
    top_paying_jobs 
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    salary_year_avg DESC;


-- Visualise the top skills by count using Excel or Python