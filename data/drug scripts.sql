SELECT COUNT(total_claim_count), prescriber.npi
FROM prescription
INNER JOIN prescriber
ON prescription.npi = prescriber.npi
GROUP BY prescriber.npi
ORDER BY count DESC;
-----Q1.B
SELECT COUNT(total_claim_count),prescriber.npi,prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name,prescriber.specialty_description
FROM prescription
INNER JOIN prescriber
ON prescription.npi = prescriber.npi
GROUP BY prescriber.npi,prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name,prescriber.specialty_description
ORDER BY count DESC;
----- 2.A
SELECT prescriber.specialty_description, COUNT(total_claim_count)
FROM prescription
INNER JOIN prescriber
ON prescription.npi = prescriber.npi
GROUP BY prescriber.specialty_description
ORDER BY count DESC;
-----2.B
SELECT prescriber.specialty_description, COUNT(total_claim_count),drug.drug_name,drug.opioid_drug_flag,drug.long_acting_opioid_drug_flag
FROM prescription
INNER JOIN prescriber
ON prescription.npi = prescriber.npi
INNER JOIN drug
ON drug.drug_name = prescription.drug_name
WHERE drug.opioid_drug_flag = 'Y' OR drug.long_acting_opioid_drug_flag = 'Y'
GROUP BY prescriber.specialty_description,drug.drug_name,drug.opioid_drug_flag,drug.long_acting_opioid_drug_flag
ORDER BY count DESC;
-----3.A
SELECT drug.generic_name,prescription.total_drug_cost
FROM drug
INNER JOIN prescription
ON drug.drug_name=prescription.drug_name
ORDER BY total_drug_cost DESC;
-- PIRFENIDONE
-----3.B
SELECT drug.generic_name,ROUND(total_drug_cost/total_day_supply,2) AS cost_per_day
FROM drug
INNER JOIN prescription
ON drug.drug_name=prescription.drug_name
ORDER BY cost_per_day DESC;
-----4.A
SELECT drug_name,
    CASE
        WHEN opioid_drug_flag = 'Y' THEN 'opioid'
        WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
        ELSE 'neither'
    END AS drug_type
FROM drug;
-----4.B
SELECT
  	 CAST(SUM(CASE WHEN opioid_drug_flag = 'Y' THEN prescription.total_drug_cost ELSE 0 END) AS money) AS opioid_total_cost,
     CAST(SUM(CASE WHEN antibiotic_drug_flag = 'Y' THEN prescription.total_drug_cost ELSE 0 END) AS money) AS antibiotic_total_cost
FROM prescription
INNER JOIN drug
ON drug.drug_name = prescription.drug_name;
-----5.A
SELECT COUNT (DISTINCT cbsa.cbsa),fips_county.state
FROM cbsa
INNER JOIN fips_county
ON cbsa.fipscounty = fips_county.fipscounty
WHERE state = 'TN'
GROUP BY fips_county.state;
---10
-----5.B
SELECT cbsa.cbsa,cbsa.cbsaname, SUM(population.population) AS total_pop
FROM cbsa
INNER JOIN population
ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa.cbsa,cbsa.cbsaname
ORDER BY cbsa DESC;
---Nashville had most--Chatt had least--
-----5.C
SELECT population.population,fips_county.county
FROM population
INNER JOIN fips_county
USING(fipscounty)
ORDER by population DESC;
---Shelby County
-----6.A
SELECT drug_name,total_claim_count
FROM prescription
WHERE total_claim_count >= 3000;
-----6.B
SELECT drug_name,total_claim_count,
	CASE
        WHEN opioid_drug_flag = 'Y' THEN 'Opioid'
		ELSE 'Not Opioid'
		END AS drug_type
FROM prescription
INNER JOIN drug
USING(drug_name)
WHERE total_claim_count >= 3000;
-----6.C
SELECT drug_name,total_claim_count,prescriber.nppes_provider_last_org_name,prescriber.nppes_provider_first_name,
	CASE
        WHEN opioid_drug_flag = 'Y' THEN 'Opioid'
		ELSE 'Not Opioid'
		END AS drug_type
FROM prescription
INNER JOIN drug
USING(drug_name)
INNER JOIN prescriber
USING(npi)
WHERE total_claim_count >= 3000;
-----7.A 
SELECT pr.specialty_description,dr.drug_name,pr.nppes_provider_city,pr.npi
FROM prescriber AS pr
CROSS JOIN drug AS dr
WHERE pr.nppes_provider_city = 'NASHVILLE' AND pr.specialty_description = 'Pain Management' AND dr.opioid_drug_flag = 'Y';
-----7.B
SELECT drug.drug_name,prescriber.npi,SUM(prescription.total_claim_count)
FROM prescriber
CROSS JOIN drug 
LEFT JOIN prescription
USING(npi)
WHERE prescriber.nppes_provider_city = 'NASHVILLE' AND prescriber.specialty_description = 'Pain Management' AND drug.opioid_drug_flag = 'Y'
GROUP BY drug.drug_name,prescriber.npi
ORDER BY SUM(prescription.total_claim_count)DESC;
-----7.C
SELECT drug.drug_name,prescriber.npi,COALESCE(SUM(prescription.total_claim_count), 0) AS RESULT
FROM prescriber
CROSS JOIN drug 
LEFT JOIN prescription
USING(npi)
WHERE prescriber.nppes_provider_city = 'NASHVILLE' AND prescriber.specialty_description = 'Pain Management' AND drug.opioid_drug_flag = 'Y'
GROUP BY drug.drug_name,prescriber.npi
ORDER BY RESULT DESC;








