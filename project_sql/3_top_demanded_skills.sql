/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market,
  providing insights into the most valuable skills for job seekers.
*/

-- TOP 5 skills all around the world
SELECT 
    skills_dim.skills,
    COUNT(skills_dim.skills) AS num_jobs_per_skill
FROM
    job_postings_fact AS jobs
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = jobs.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    jobs.job_title_short = 'Data Analyst'
GROUP BY 
    skills_dim.skills
ORDER BY
    num_jobs_per_skill DESC
LIMIT 5;


-- TOP 5 skills all around the United Kingdom

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
)

-- Find the Top 5 skills requested in jobs in the United Kingdom
SELECT 
    skills_dim.skills,
    COUNT(skills_dim.skills) AS num_jobs_per_skill
FROM
    job_postings_fact AS jobs
    INNER JOIN uk_jobs ON uk_jobs.job_id = jobs.job_id
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = jobs.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    jobs.job_title_short = 'Data Analyst'
GROUP BY 
    skills_dim.skills
ORDER BY
    num_jobs_per_skill DESC
LIMIT 5;