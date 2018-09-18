USE vital_stats_db;

SELECT
	a.summary_id,
    a.year,
    a.race,
    a.hispanic,
    a.age_cohort,
    a.ectopic_pregnancy_count,
    a.spontaneous_abortion_count,
    a.medical_abortion_count,
    a.other_abortion_count,
    a.other_abortive_outcome_count,
    a.eclampsia_preeclampsia_count,
    a.hemorrhage_count,
    a.obstetric_embolism_count,
    a.other_puerperium_complications_count,
    a.all_other_direct_obstetric_count,
    a.obstetric_unspecified_count,
    a.other_pregnancy_related_count,
    a.indirect_obstetric_count,
    a.total_pregnancy_deaths
    
# Query 'a' - Base Query
FROM (SELECT
	CONCAT(year, race, 
		CASE 
			WHEN CAST(hispanic_origin AS UNSIGNED) > 5 THEN '0'
            ELSE '1' END,
        CASE 
			WHEN age = '08' THEN '0'
            WHEN age = '09' THEN '1'
            WHEN age = '10' THEN '2'
            WHEN age = '11' THEN '3'
            WHEN age = '12' THEN '4'
            WHEN age = '13' THEN '5'
            WHEN age = '14' THEN '6'
            WHEN age = '15' THEN '7'
            WHEN age = '16' THEN '8' END
	) AS `summary_id`,
	year,
    CASE 
		WHEN race = '1' AND CAST(hispanic_origin AS UNSIGNED) > 5 THEN 'White, Non-Hispanic'
        WHEN race = '1' AND CAST(hispanic_origin AS UNSIGNED) <= 5 THEN 'Hispanic'
		WHEN race = '2' THEN 'Black'
        WHEN race = '3' THEN 'American Indian/Alaskan Native'
        WHEN race = '4' THEN 'Asian/Pacific Islander' 
	END AS `race`,
    CASE
		WHEN CAST(hispanic_origin AS UNSIGNED) > 5 THEN 'Non-Hispanic'
        ELSE 'Hispanic'
    END AS `hispanic`,
    CASE 
		WHEN age = '08' THEN '10-14'
        WHEN age = '09' THEN '15-19'
        WHEN age = '10' THEN '20-24'
        WHEN age = '11' THEN '25-29'
        WHEN age = '12' THEN '30-34'
        WHEN age = '13' THEN '35-29'
        WHEN age = '14' THEN '40-44'
        WHEN age = '15' THEN '45-49'
        WHEN age = '16' THEN '50-54'
	END AS `age_cohort`,
    SUM(CASE WHEN cause_of_death = '341' THEN 1 ELSE 0 END) AS `ectopic_pregnancy_count`,
    SUM(CASE WHEN cause_of_death = '342' THEN 1 ELSE 0 END) AS `spontaneous_abortion_count`,
    SUM(CASE WHEN cause_of_death = '343' THEN 1 ELSE 0 END) AS `medical_abortion_count`,
    SUM(CASE WHEN cause_of_death = '344' THEN 1 ELSE 0 END) AS `other_abortion_count`,
    SUM(CASE WHEN cause_of_death = '345' THEN 1 ELSE 0 END) AS `other_abortive_outcome_count`,
    SUM(CASE WHEN cause_of_death = '347' THEN 1 ELSE 0 END) AS `eclampsia_preeclampsia_count`,
    SUM(CASE WHEN cause_of_death = '348' THEN 1 ELSE 0 END) AS `hemorrhage_count`,
    SUM(CASE WHEN cause_of_death = '350' THEN 1 ELSE 0 END) AS `obstetric_embolism_count`,
    SUM(CASE WHEN cause_of_death = '351' THEN 1 ELSE 0 END) AS `other_puerperium_complications_count`,
    SUM(CASE WHEN cause_of_death = '352' THEN 1 ELSE 0 END) AS `all_other_direct_obstetric_count`,
    SUM(CASE WHEN cause_of_death = '353' THEN 1 ELSE 0 END) AS `obstetric_unspecified_count`,
    SUM(CASE WHEN cause_of_death = '354' THEN 1 ELSE 0 END) AS `other_pregnancy_related_count`,
    SUM(CASE WHEN cause_of_death = '355' THEN 1 ELSE 0 END) AS `indirect_obstetric_count`,
    SUM(CASE WHEN CAST(cause_of_death AS UNSIGNED) >= 340 AND CAST(cause_of_death AS UNSIGNED) <356 THEN 1 ELSE 0 END) AS `total_pregnancy_deaths`,
    COUNT(year) AS `total_deaths`
FROM mortality
WHERE sex = 'F'
AND CAST(age AS UNSIGNED) >= 8
AND CAST(age AS UNSIGNED) < 17
GROUP BY year, race, hispanic, age_cohort) AS a;