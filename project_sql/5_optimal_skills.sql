/*
Question: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefirst (high salaries), 
  offering strategic insights for career development in data analysis.
*/

-- Finding the most optimal skills in the United Kingdom

-- CTE to find jobs in the UK
WITH uk_jobs AS(
    SELECT 
        job_id,
        job_location
    FROM
        job_postings_fact
    WHERE 
        job_location LIKE '%%United_Kingdom%' 
        OR job_location lIKE '%UK%'
), 

-- CTE to find most in-demand skills in the United Kingdom
in_demand_skills AS(
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_dim.skills) AS num_jobs_per_skill
    FROM
        job_postings_fact AS jobs
        INNER JOIN uk_jobs ON uk_jobs.job_id = jobs.job_id
        INNER JOIN skills_job_dim ON skills_job_dim.job_id = jobs.job_id
        INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        jobs.job_title_short = 'Data Analyst'
        AND jobs.salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
),

-- CTE to find top high-paying jobs in the United Kingdom
high_paying_skills AS(
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(jobs.salary_year_avg)) AS avg_salary
    FROM
        job_postings_fact AS jobs
        INNER JOIN uk_jobs ON uk_jobs.job_id = jobs.job_id
        INNER JOIN skills_job_dim ON skills_job_dim.job_id = jobs.job_id
        INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        jobs.job_title_short = 'Data Analyst'
        AND jobs.salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
)

-- Finding most optimal skills within the United Kingdom
SELECT 
    in_demand_skills.skill_id,
    in_demand_skills.skills,
    in_demand_skills.num_jobs_per_skill,
    high_paying_skills.avg_salary
FROM 
    in_demand_skills
    INNER JOIN high_paying_skills ON high_paying_skills.skill_id = in_demand_skills.skill_id
ORDER BY
    in_demand_skills.num_jobs_per_skill DESC,
    high_paying_skills.avg_salary DESC
LIMIT 10;


-- There are a lot of null values in the salary_year_avg column, that is why Tableau seems to be the 'most optimal' compared to Power BI
-- But in terms of demand count, Power Bi is more in demand.


