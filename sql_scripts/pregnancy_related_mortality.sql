USE vital_stats_db;

SELECT
	a.id,
	a.year,
    CASE
		WHEN a.education = '1' THEN '8th Grade or Less'
        WHEN a.education = '2' THEN '9-12th Grade, No Diploma'
        WHEN a.education = '3' THEN 'High School Graduate, GED'
        WHEN a.education = '4' THEN 'Some College, No Degree'
        WHEN a.education = '5' THEN 'Associate Degree'
        WHEN a.education = '6' THEN 'Bachelor\'s Degree'
        WHEN a.education = '7' THEN 'Master\'s Degree'
        WHEN a.education = '8' THEN 'Doctorate/Professional Degree'
        WHEN a.education = '9' THEN 'Unknown'
	END AS `education`,
    a.age,
    CASE 
		WHEN a.race = '1' THEN 'White'
		WHEN a.race = '2' THEN 'Black'
        WHEN a.race = '3' THEN 'American Indian/Alaskan Native'
        WHEN a.race = '4' THEN 'Asian/Pacific Islander' 
	END AS `race`,
    CASE
		WHEN CAST(a.hispanic_origin AS UNSIGNED) > 5 THEN 'Non-Hispanic'
        ELSE 'Hispanic'
    END AS `hispanic`,
    CASE 
		WHEN cause_of_death = '341' THEN 'Ectopic Pregnancy'
        WHEN cause_of_death = '342' THEN 'Spontaneous Abortion'
        WHEN cause_of_death = '343' THEN 'Medical Abortion'
        WHEN cause_of_death = '344' THEN 'Other Abortion'
        WHEN cause_of_death = '345' THEN 'Other Abortive Outcome'
        WHEN cause_of_death = '347' THEN 'Eclampsia/Pre-Eclampsia'
        WHEN cause_of_death = '348' THEN 'Hemorrhage'
        WHEN cause_of_death = '350' THEN 'Obstetric Embolism'
        WHEN cause_of_death = '351' THEN 'Other Puerperium Complications'
        WHEN cause_of_death = '352' THEN 'All Other Direct Obstetric'
        WHEN cause_of_death = '353' THEN 'Obstetric Unspecified'
        WHEN cause_of_death = '354' THEN 'Other Pregnancy Related'
        WHEN cause_of_death = '355' THEN 'Indirect Obstetric'
	END AS `cause_of_death`
FROM     
	(SELECT * FROM mortality WHERE CAST(cause_of_death AS UNSIGNED) >= 340 AND CAST(cause_of_death AS UNSIGNED) < 356) AS a;