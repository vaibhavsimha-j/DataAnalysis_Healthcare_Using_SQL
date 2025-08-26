/*PROBLEM STATEMENT 1*/
SELECT
    CASE
        WHEN TIMESTAMPDIFF(YEAR, p.dob, CURDATE()) BETWEEN 0 AND 14 THEN 'Children'
        WHEN TIMESTAMPDIFF(YEAR, p.dob, CURDATE()) BETWEEN 15 AND 24 THEN 'Youth'
        WHEN TIMESTAMPDIFF(YEAR, p.dob, CURDATE()) BETWEEN 25 AND 64 THEN 'Adults'
        WHEN TIMESTAMPDIFF(YEAR, p.dob, CURDATE()) >= 65 THEN 'Seniors'
    END AS age_category,
    COUNT(t.treatmentID) AS treatment_count
FROM Patient p
JOIN Treatment t ON p.patientID = t.patientID
WHERE YEAR(t.date) = 2022
GROUP BY age_category; 

/*PROBLEM STATEMENT 2*/
SELECT
    t.diseaseID ,
    SUM(CASE WHEN pr.gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN pr.gender = 'Female' THEN 1 ELSE 0 END) AS female_count,
    (SUM(CASE WHEN pr.gender = 'Male' THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN pr.gender = 'Female' THEN 1 ELSE 0 END), 0)) AS male_to_female_ratio
FROM Treatment t
JOIN Patient pa ON t.patientID = pa.patientID
JOIN Person pr ON pa.patientID = pr.personID
GROUP BY t.diseaseID
ORDER BY male_to_female_ratio DESC;


/*PROBLEM STATEMENT 3*/
WITH TreatmentCounts AS (
  SELECT
    per.gender,
    COUNT(DISTINCT t.treatmentid) AS total_treatments
  FROM treatment AS t
  JOIN patient AS p ON t.patientID = p.patientID
  JOIN person AS per ON p.patientID = per.personID
  GROUP BY per.gender
),
ClaimCounts AS (
  SELECT
    per.gender,
    COUNT(DISTINCT c.claimid) AS total_claims
  FROM treatment AS t
  JOIN patient AS p ON t.patientID = p.patientID
  JOIN claim AS c ON t.claimID = c.claimID
  JOIN person AS per ON p.patientID = per.personID
  GROUP BY per.gender
)
SELECT
  tc.gender,
  tc.total_treatments,
  cc.total_claims,
  tc.total_treatments / cc.total_claims AS treatment_to_claim_ratio
FROM TreatmentCounts AS tc
JOIN ClaimCounts AS cc ON tc.gender = cc.gender
ORDER BY tc.gender;


/*PROBLEM STATEMENT 4*/
SELECT
    medicineID,
    SUM(productType) AS total_units,
    SUM(productType * maxPrice) AS total_max_retail_price,
    SUM(productType * maxPrice * (1 - governmentDiscount / 100)) AS total_price_after_discount
FROM
    medicine
GROUP BY
    medicineID;


/*PROBLEM STATEMENT 5*/
SELECT 
    p.pharmacyName,
    MAX(pr.quantity) AS max_medicines,
    MIN(pr.quantity) AS min_medicines,
    AVG(pr.quantity) AS avg_medicines
FROM 
    keep pr
JOIN 
    pharmacy p ON pr.pharmacyID = p.pharmacyID
GROUP BY 
    p.pharmacyName