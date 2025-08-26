-- PROBLEM STATEMENT 6 - VAIBHAV SIMHA J
SELECT A.city, 
       COUNT(DISTINCT PH.pharmacyID) AS pharmacyCount, 
       COUNT(P.prescriptionID) AS prescriptionCount,
       COUNT(P.prescriptionID) / COUNT(DISTINCT PH.pharmacyID) AS ratio
FROM Address A JOIN Pharmacy PH ON A.addressID = PH.addressID 
	JOIN Prescription P ON PH.pharmacyID = P.pharmacyID GROUP BY A.city HAVING COUNT(P.prescriptionID) > 100 ORDER BY ratio ASC LIMIT 3;


-- PROBLEM STATEMENT 7 - VAIBHAV SIMHA J
SELECT city, diseaseName, patientCount
FROM ( SELECT A.city, D.diseaseName, COUNT(T.patientID) AS patientCount, ROW_NUMBER() OVER (PARTITION BY A.city ORDER BY COUNT(T.patientID) DESC) AS row_num FROM Treatment T
    JOIN Disease D ON T.diseaseID = D.diseaseID
    JOIN Patient P ON T.patientID = P.patientID
    JOIN Person PER ON P.patientID = PER.personID
    JOIN Address A ON PER.addressID = A.addressID WHERE A.state = 'AL' GROUP BY A.city, D.diseaseName
) AS CityDiseaseCounts WHERE row_num = 1 ORDER BY city;



-- PROBLEM STATEMENT 8 - YASH V
WITH ClaimCounts AS ( SELECT D.diseaseID, D.diseaseName, I.planName, COUNT(T.claimID) AS claimCount FROM Treatment T
    JOIN Claim C ON T.claimID = C.claimID
    JOIN InsurancePlan I ON C.UIN = I.UIN
    JOIN Disease D ON T.diseaseID = D.diseaseID
GROUP BY D.diseaseID, D.diseaseName, I.planName ) SELECT diseaseName, MAX(planName) AS mostClaimedPlan, MIN(planName) AS leastClaimedPlan
FROM ClaimCounts C1 WHERE C1.claimCount = (SELECT MAX(claimCount) FROM ClaimCounts C2 WHERE C2.diseaseID = C1.diseaseID) OR C1.claimCount = (SELECT MIN(claimCount) FROM ClaimCounts C2 WHERE C2.diseaseID = C1.diseaseID) GROUP BY diseaseName;



-- PROBLEM STATEMENT 9 - REPUDI SAMUEL HONEY
SELECT D.diseaseName, COUNT(DISTINCT PER.addressID) AS householdCount FROM Treatment T
JOIN Disease D ON T.diseaseID = D.diseaseID
JOIN Patient P ON T.patientID = P.patientID
JOIN Person PER ON P.patientID = PER.personID GROUP BY T.diseaseID HAVING COUNT(DISTINCT PER.personID) > COUNT(DISTINCT PER.addressID);



-- PROBLEM STATEMENT 10 - YASH V
SELECT A.state, 
       COUNT(T.treatmentID) AS treatmentCount, 
       COUNT(C.claimID) AS claimCount,
       COUNT(T.treatmentID) / COUNT(C.claimID) AS treatmentToClaimRatio
FROM Treatment T
JOIN Claim C ON T.claimID = C.claimID
JOIN Patient P ON T.patientID = P.patientID
JOIN Person PER ON P.patientID = PER.personID
JOIN Address A ON PER.addressID = A.addressID WHERE T.date BETWEEN '2021-04-01' AND '2022-03-31' GROUP BY A.state;
