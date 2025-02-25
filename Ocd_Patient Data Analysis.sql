# OCD Patient Data Analysis 🏥 

--# Checking if we have the right table

SELECT *
FROM ocd_patient_dataset$

--What is the age distribution of the patients?
SELECT Age, COUNT(Gender) AS count_age
FROM ocd_patient_dataset$
GROUP BY Age
ORDER BY Age;


--What is the gender distribution of the patients?
SELECT Gender, COUNT(*) AS count
FROM ocd_patient_dataset$
GROUP BY Gender;


---What is the gender distribution of the patients?
SELECT Gender, COUNT([Education Level]) AS gender_count
FROM ocd_patient_dataset$
GROUP BY Gender
ORDER BY Gender



--How does the ethnic composition look like?
SELECT Ethnicity, COUNT([Marital Status]) AS count_etnicity
FROM ocd_patient_dataset$
GROUP BY Ethnicity;


--What is the average duration of symptoms before diagnosis?
--Average Duration of Symptoms Before Diagnosis?
SELECT Gender,Age, round(AVG([Duration of Symptoms (months)]),2) AS avg_duration
FROM ocd_patient_dataset$
WHERE Age > 30
GROUP BY Gender, Age
ORDER BY Age


--Are there patterns or trends in the types of obsessions and compulsions?
--Types of Obsessions and Compulsions?
SELECT Gender, [Obsession Type],COUNT([Obsession Type]) AS Obsession_count
FROM ocd_patient_dataset$
GROUP BY Gender, [Obsession Type]
ORDER BY Gender;



--Are there patterns or trends in the types of obsessions and compulsions?
--Types of Obsessions and Compulsions?
SELECT Gender,[Compulsion Type],  COUNT([Compulsion Type]) AS count
FROM ocd_patient_dataset$
GROUP BY Gender,[Compulsion Type];


--What percentage of patients have a family history of OCD?
--Percentage of Patients with Family History of OCD:
WITH TotalPatients AS (
    SELECT  COUNT(*) AS total_count
    FROM ocd_patient_dataset$	
),
FamilyHistoryPatients AS (
    SELECT  COUNT(*) AS family_history_count
    FROM ocd_patient_dataset$
    WHERE [Family History of OCD] = 'Yes'
)
SELECT 
    ROUND((family_history_count * 100 / total_count),2) AS percentage_with_family_history
FROM 
    TotalPatients, 
    FamilyHistoryPatients;




--What percentage of patients have a family history of OCD?
--Percentage of Patients with Family History of OCD:

WITH PatientCounts AS (
    SELECT COUNT(*) AS total_count,
           COUNT(CASE WHEN  [Family History of OCD] = 'Yes' THEN 0 END) AS family_history_count
    FROM ocd_patient_dataset$
)
SELECT 
    (family_history_count * 100.0 / total_count) AS percentage_with_family_history
FROM PatientCounts;







--Is there a correlation between family history and severity of symptoms (Y-BOCS scores)?
--Correlation Between Family History and Severity of Symptoms:
SELECT [Marital Status],[Family History of OCD], ROUND(AVG([Y-BOCS Score (Obsessions)]),2) AS avg_ybocs_obsessions,
        ROUND(AVG([Y-BOCS Score (Compulsions)]),2) AS avg_ybocs_compulsions
FROM ocd_patient_dataset$
GROUP BY [Marital Status],[Family History of OCD];






--What percentage of patients have depression and/or anxiety diagnoses?
--Percentage of Patients with Depression and/or Anxiety Diagnoses:

WITH PacPatients AS (
    SELECT 
          COUNT(CASE WHEN [Depression Diagnosis] = 'Yes' THEN 0 END) AS percentage_with_depression,
		  COUNT(CASE WHEN [Anxiety Diagnosis] = 'Yes' THEN 0 END) AS percentage_with_anxiety
    FROM ocd_patient_dataset$
)
SELECT 
    ROUND((percentage_with_depression * 100. / percentage_with_anxiety),2)  AS percentage_of_patients
FROM PacPatients
   





--Is there a significant correlation between OCD and other diagnoses (e.g., depression, anxiety)?
--Correlation Between OCD and Other Diagnoses:

SELECT Gender,Ethnicity,[Depression Diagnosis],[Anxiety Diagnosis],
    ROUND(AVG([Y-BOCS Score (Obsessions)]),2) AS avg_ybocs_obsessions,
    ROUND(AVG([Y-BOCS Score (Compulsions)]),2) AS avg_ybocs_compulsions
FROM ocd_patient_dataset$
GROUP BY Gender,Ethnicity,[Depression Diagnosis],[Anxiety Diagnosis];




--What are the common medications prescribed to patients?
--Common Medications Prescribed:
SELECT Medications, COUNT(*) AS count
FROM ocd_patient_dataset$
GROUP BY Medications
ORDER BY count DESC;




--How does medication use vary with different OCD types or severity (Y-BOCS scores)?
--Variation of Medication Use with OCD Types or Severity:
SELECT [Obsession Type], [Compulsion Type], [Medications], 
    ROUND(AVG([Y-BOCS Score (Obsessions)]) AS avg_ybocs_obsessions,
    ROUND(AVG([Y-BOCS Score (Compulsions)]) AS avg_ybocs_compulsions
FROM ocd_patient_dataset$
GROUP BY [Obsession Type], [Compulsion Type], Medications;






--Is there a correlation between age and the severity of OCD symptoms (Y-BOCS scores)?
WITH CorrelationData AS (
    SELECT  Age, ([Y-BOCS Score (Obsessions)] + [Y-BOCS Score (Compulsions)]) AS Total_Y_BOCS_Score
    FROM ocd_patient_dataset$
)
SELECT 
    AVG(Total_Y_BOCS_Score) AS Age_YBOCS_Correlation
FROM CorrelationData




--Are there any correlations between education level and the type or severity of OCD symptoms?

WITH EducationCorrelation AS (
    SELECT [Education Level],[Obsession Type],[Compulsion Type],
        ([Y-BOCS Score (Obsessions)] + [Y-BOCS Score (Compulsions)]) AS Total_Y_BOCS_Score
    FROM ocd_patient_dataset$
)
SELECT 
    [Education Level],[Obsession Type],[Compulsion Type],
    ROUND(AVG(Total_Y_BOCS_Score),2) AS Avg_YBOCS_Score
FROM EducationCorrelation
GROUP BY [Education Level], [Obsession Type],[Compulsion Type];






--Trend Analysis:

--Are there any trends over time in the diagnosis dates (e.g., increasing or decreasing diagnoses)?

SELECT 
    CAST(YEAR([OCD Diagnosis Date]) AS VARCHAR) + '-' + 
    CAST(MONTH([OCD Diagnosis Date]) AS VARCHAR) AS Diagnosis_Month,
    COUNT(*) AS Diagnosis_Count
FROM ocd_patient_dataset$
GROUP BY CAST(YEAR([OCD Diagnosis Date]) AS VARCHAR) + '-' + 
         CAST(MONTH([OCD Diagnosis Date]) AS VARCHAR)
ORDER BY Diagnosis_Month;



--How do the Y-BOCS scores change over time?

SELECT 
    CAST(YEAR([OCD Diagnosis Date]) AS VARCHAR) + '-' + 
    CAST(MONTH([OCD Diagnosis Date]) AS VARCHAR) AS Diagnosis_Month,
    ROUND(AVG([Y-BOCS Score (Obsessions)] + [Y-BOCS Score (Compulsions)]),2) AS Avg_YBOCS_Score
FROM ocd_patient_dataset$
GROUP BY [OCD Diagnosis Date]
ORDER BY [OCD Diagnosis Date];



--Comparative Analysis:

--How do different demographic groups (age, gender, ethnicity) compare in terms of OCD symptoms and comorbidities?
SELECT TOP (20) Gender,Age,Ethnicity, 
   ROUND(AVG([Y-BOCS Score (Obsessions)] + [Y-BOCS Score (Compulsions)]),2) AS Avg_YBOCS_Score,
    COUNT(CASE WHEN [Depression Diagnosis] = 'Yes' THEN 1 END) AS Depression_Count,
    COUNT(CASE WHEN [Anxiety Diagnosis] = 'Yes' THEN 1 END) AS Anxiety_Count
FROM ocd_patient_dataset$
GROUP BY Gender, Age, Ethnicity ;





--Are there differences in treatment approaches (medications) based on demographics or symptom severity?
SELECT top (50)Gender, Age, Ethnicity,
    ([Y-BOCS Score (Obsessions)] + [Y-BOCS Score (Compulsions)]) AS Total_YBOCS_Score, Medications
FROM ocd_patient_dataset$
ORDER BY Age, Gender, Ethnicity, Total_YBOCS_Score;






--Data Reporting and Visualization:SELECT AVG(Age) AS Mean_Age, MEDIA
--Summary Statistics:

SELECT
  COUNT(*) AS total_rows,
  MIN([Y-BOCS Score (Obsessions)]) AS min_obsession_score,
  MAX([Y-BOCS Score (Obsessions)]) AS max_obsession_score,
  AVG([Y-BOCS Score (Obsessions)]) AS avg_obsession_score,
  STDEV([Y-BOCS Score (Obsessions)]) AS std_dev_obsession_score,
  MIN([Y-BOCS Score (Compulsions)]) AS min_compulsion_score,
  MAX([Y-BOCS Score (Compulsions)]) AS max_compulsion_score,
  AVG([Y-BOCS Score (Compulsions)]) AS avg_compulsion_score,
  STDEV([Y-BOCS Score (Compulsions)]) AS std_dev_compulsion_score,
  SUM(CASE WHEN [Depression Diagnosis] = 'Yes' THEN 1 ELSE 0 END) AS num_depression_cases,
  SUM(CASE WHEN [Anxiety Diagnosis] = 'Yes' THEN 1 ELSE 0 END) AS num_anxiety_cases
FROM ocd_patient_dataset$;



--Data Security and Privacy:
--Data Privacy:

-- Creating  view
CREATE VIEW AnonymizedPatients AS
SELECT Age,Gender,Ethnicity, [Marital Status],
    [Education Level],
    [OCD Diagnosis Date],
    [Duration of Symptoms (months)],
    [Previous Diagnoses],
    [Family History of OCD],
    [Obsession Type],
    [Compulsion Type],
    [Y-BOCS Score (Obsessions)],
    [Y-BOCS Score (Compulsions)],
    [Depression Diagnosis],
    [Anxiety Diagnosis],
    Medications
FROM ocd_patient_dataset$;




-



--View for Patients with Family History of OCD:

CREATE VIEW PatientsWithFamilyHistoryOfOCD1 AS
SELECT *
FROM ocd_patient_dataset$
WHERE [Family History of OCD]= 'Yes';



--View for Patients with Severe OCD Symptoms:

CREATE VIEW SevereOCDPatients1 AS
SELECT *
FROM ocd_patient_dataset$
WHERE ([Y-BOCS Score (Obsessions)] + [Y-BOCS Score (Compulsions)]) > 20;
