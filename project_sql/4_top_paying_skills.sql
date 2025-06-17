/*
Question: What are the top paying skills in terms of on salary?
- Look at the average salary associated with each skill for Data Analyst positons
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and 
  helps identify the most financially rewarding skills to acquire or improve
*/

-- For job postings per skill to be any number 

-- TOP-paying skills all around the world
SELECT 
    skills_dim.skills,
    COUNT(skills_dim.skills) AS num_jobs_per_skill,
    ROUND(AVG(jobs.salary_year_avg)) AS avg_salary
FROM
    job_postings_fact AS jobs
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = jobs.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    jobs.job_title_short = 'Data Analyst'
    AND jobs.salary_year_avg IS NOT NULL
GROUP BY 
    skills_dim.skills
ORDER BY
    avg_salary DESC
LIMIT 10;

-- TOP-paying skills all around the United Kingdom -> High value skills to to learn

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

SELECT 
    skills_dim.skills,
    COUNT(skills_dim.skills) AS num_jobs_per_skill,
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
    skills_dim.skills
ORDER BY
    avg_salary DESC
LIMIT 10;




-- For job postings per skill greater than 5:

-- TOP-paying skills all around the world
SELECT 
    skills_dim.skills,
    COUNT(skills_dim.skills) AS num_jobs_per_skill,
    ROUND(AVG(jobs.salary_year_avg)) AS avg_salary
FROM
    job_postings_fact AS jobs
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = jobs.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    jobs.job_title_short = 'Data Analyst'
    AND jobs.salary_year_avg IS NOT NULL
GROUP BY 
    skills_dim.skills
HAVING
    COUNT(skills_dim.skills) > 5
ORDER BY
    avg_salary DESC
LIMIT 10;

-- TOP-paying skills all around the United Kingdom -> High value skills to to learn

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

-- Find the skills with the highest salary, with the skill needing to appear in more than 5 job postings
SELECT 
    skills_dim.skills,
    COUNT(skills_dim.skills) AS num_jobs_per_skill,
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
    skills_dim.skills
HAVING
    COUNT(skills_dim.skills) > 5
ORDER BY
    avg_salary DESC
LIMIT 10;