-- ============================================================
-- Nigeria Disease Surveillance - SQL Analysis Queries
-- Author: Shamsuddeen Yusuf
-- Database: disease_surveillance
-- ============================================================

USE disease_surveillance;

-- ============================================================
-- QUERY 1: Total meningitis cases and deaths by state
-- (Ranked by fatality rate)
-- ============================================================
SELECT 
    l.state,
    COUNT(*)                                                        AS total_cases,
    SUM(CASE WHEN dr.health_status = 'Dead' THEN 1 ELSE 0 END)     AS total_deaths,
    ROUND(
        SUM(CASE WHEN dr.health_status = 'Dead' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 2
    )                                                               AS fatality_rate_pct
FROM disease_reports dr
JOIN locations l ON dr.patient_id = l.patient_id
WHERE dr.disease = 'Meningitis'
GROUP BY l.state
ORDER BY fatality_rate_pct DESC;


-- ============================================================
-- QUERY 2: Year-on-year meningitis trend
-- ============================================================
SELECT 
    report_year,
    COUNT(*)                                                        AS total_cases,
    SUM(CASE WHEN health_status = 'Dead' THEN 1 ELSE 0 END)        AS total_deaths,
    ROUND(
        SUM(CASE WHEN health_status = 'Dead' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 2
    )                                                               AS fatality_rate_pct
FROM disease_reports
WHERE disease = 'Meningitis'
GROUP BY report_year
ORDER BY report_year;


-- ============================================================
-- QUERY 3: Meningitis cases by serotype (NmA, NmC, NmW)
-- ============================================================
SELECT
    SUM(NmA)                                                        AS NmA_cases,
    SUM(NmC)                                                        AS NmC_cases,
    SUM(NmW)                                                        AS NmW_cases,
    SUM(NmA) + SUM(NmC) + SUM(NmW)                                 AS total_typed_cases
FROM disease_reports
WHERE disease = 'Meningitis';


-- ============================================================
-- QUERY 4: Fatality by age group (Child vs Adult)
-- ============================================================
SELECT 
    p.age_group,
    COUNT(*)                                                        AS total_cases,
    SUM(CASE WHEN dr.health_status = 'Dead' THEN 1 ELSE 0 END)     AS total_deaths,
    ROUND(
        SUM(CASE WHEN dr.health_status = 'Dead' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 2
    )                                                               AS fatality_rate_pct
FROM disease_reports dr
JOIN patients p ON dr.patient_id = p.patient_id
WHERE dr.disease = 'Meningitis'
GROUP BY p.age_group;


-- ============================================================
-- QUERY 5: Rural vs Urban fatality comparison
-- ============================================================
SELECT 
    l.settlement_type,
    COUNT(*)                                                        AS total_cases,
    SUM(CASE WHEN dr.health_status = 'Dead' THEN 1 ELSE 0 END)     AS total_deaths,
    ROUND(
        AVG(CASE WHEN dr.health_status = 'Dead' THEN 1.0 ELSE 0 END) * 100, 2
    )                                                               AS fatality_rate_pct
FROM disease_reports dr
JOIN locations l ON dr.patient_id = l.patient_id
WHERE dr.disease = 'Meningitis'
GROUP BY l.settlement_type;


-- ============================================================
-- QUERY 6: Gender breakdown of meningitis cases and deaths
-- ============================================================
SELECT 
    p.gender,
    COUNT(*)                                                        AS total_cases,
    SUM(CASE WHEN dr.health_status = 'Dead' THEN 1 ELSE 0 END)     AS total_deaths,
    ROUND(
        SUM(CASE WHEN dr.health_status = 'Dead' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 2
    )                                                               AS fatality_rate_pct
FROM disease_reports dr
JOIN patients p ON dr.patient_id = p.patient_id
WHERE dr.disease = 'Meningitis'
GROUP BY p.gender;


-- ============================================================
-- QUERY 7: Confirmed vs unconfirmed meningitis cases by state
-- ============================================================
SELECT 
    l.state,
    SUM(CASE WHEN dr.report_outcome = 'Confirmed' THEN 1 ELSE 0 END)     AS confirmed_cases,
    SUM(CASE WHEN dr.report_outcome = 'Not Confirmed' THEN 1 ELSE 0 END)  AS unconfirmed_cases,
    COUNT(*)                                                               AS total_cases
FROM disease_reports dr
JOIN locations l ON dr.patient_id = l.patient_id
WHERE dr.disease = 'Meningitis'
GROUP BY l.state
ORDER BY total_cases DESC;


-- ============================================================
-- QUERY 8: Top 10 states by total meningitis cases
-- ============================================================
SELECT 
    l.state,
    COUNT(*) AS total_cases
FROM disease_reports dr
JOIN locations l ON dr.patient_id = l.patient_id
WHERE dr.disease = 'Meningitis'
GROUP BY l.state
ORDER BY total_cases DESC
LIMIT 10;


-- ============================================================
-- QUERY 9: Full export for Python & Power BI
-- (Save this result as meningitis_clean.csv)
-- ============================================================
SELECT 
    p.patient_id,
    p.gender,
    p.age,
    p.age_group,
    l.state,
    l.settlement_type,
    dr.report_year,
    dr.disease,
    dr.serotype,
    dr.NmA,
    dr.NmC,
    dr.NmW,
    dr.health_status,
    dr.report_outcome
FROM disease_reports dr
JOIN patients p  ON dr.patient_id = p.patient_id
JOIN locations l ON dr.patient_id = l.patient_id
WHERE dr.disease = 'Meningitis';
