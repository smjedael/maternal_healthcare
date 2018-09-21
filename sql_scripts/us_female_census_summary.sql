USE census_data_db;

SELECT
	universe,
    month,
    year,
    age,
    CASE 
		WHEN age < 15 THEN '10-14'
        WHEN age >= 15 AND age < 20 THEN '15-19'
        WHEN age >= 20 AND age < 25 THEN '20-24'
        WHEN age >= 25 AND age < 30 THEN '25-29'
        WHEN age >= 30 AND age < 35 THEN '30-34'
        WHEN age >= 35 AND age < 40 THEN '35-39'
        WHEN age >= 40 AND age < 45 THEN '40-44'
        WHEN age >= 45 AND age < 50 THEN '45-49'
        WHEN age >= 50 AND age < 55 THEN '50-54'
	END AS `age_cohort`,
    SUM(tot_pop) AS `total_population`,
    SUM(tot_female) AS `total_female_population`,
    SUM(nhwa_female) AS `white_nh`,
    SUM(hwac_female) AS `hispanic`,
    SUM(bac_female) AS `black`,
    SUM(ia_female) AS `ai_an`,
    SUM(aac_female + nac_female) AS `asian_pi`,
    SUM(nhwa_female + hwac_female + bac_female + ia_female + aac_female + nac_female) AS `total_race_population`
    FROM us_population
    WHERE age >= 10 AND age <= 54
    GROUP BY universe, year, month, age_cohort;
    
    