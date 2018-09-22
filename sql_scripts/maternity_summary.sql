USE vital_stats_db;

SELECT
	a.summary_id,
    a.delivery_year AS `year`,
    a.race,
    a.hispanic,
    a.age_cohort,
    a.population AS `total_births`,
    b.avg_prenatal_care_start_month,
    c.avg_num_prenatal_visits,
    d.avg_body_mass_index,
    e.prepregnancy_diabetes_count,
    e.gestational_diabetes_count,
    e.prepregnancy_hypertension_count,
    e.gestational_hypertension_count,
    e.hypertension_eclampsia_count,
    e.prev_preterm_birth_count,
    e.prev_cesarean_count,
    e.total_risk_factors,
    e.total_prev_cesareans,
    e.delivery_vaginal_count,
    e.delivery_vaginal_prior_cesarean_count,
    e.delivery_primary_cesarean_count,
    e.delivery_repeat_cesarean_count,
    e.delivery_vaginal_unknown_prior_count,
    e.delivery_cesarean_unknown_prior_count,
    e.delivery_not_stated_count,
    e.total_delivery_vaginal,
    e.total_delivery_cesarean,
    e.maternal_transfusion_count,
    e.perineal_laceration_count,
    e.ruptured_uterus_count,
    e.unplanned_hysterectomy_count,
    e.admit_intensive_care_count,
    e.total_morbidity_count,
    e.gestation_weeks
    
# Query 'a' - Base Query
FROM (SELECT
	CONCAT(delivery_year, race, 
		CASE 
			WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN '0'
            ELSE '1' END,
        CASE 
			WHEN CAST(age AS UNSIGNED) < 15 THEN '0'
			WHEN CAST(age AS UNSIGNED) >= 15 AND CAST(age AS UNSIGNED) < 20 THEN '1'
			WHEN CAST(age AS UNSIGNED) >= 20 AND CAST(age AS UNSIGNED) < 25 THEN '2'
			WHEN CAST(age AS UNSIGNED) >= 25 AND CAST(age AS UNSIGNED) < 30 THEN '3'
			WHEN CAST(age AS UNSIGNED) >= 30 AND CAST(age AS UNSIGNED) < 35 THEN '4'
			WHEN CAST(age AS UNSIGNED) >= 35 AND CAST(age AS UNSIGNED) < 40 THEN '5'
			WHEN CAST(age AS UNSIGNED) >= 40 AND CAST(age AS UNSIGNED) < 45 THEN '6'
			WHEN CAST(age AS UNSIGNED) >= 45 AND CAST(age AS UNSIGNED) < 50 THEN '7'
			WHEN CAST(age AS UNSIGNED) >= 50 AND CAST(age AS UNSIGNED) < 55 THEN '8' END    
	) AS `summary_id`,
	delivery_year,
    CASE 
		WHEN race = '1' AND (hispanic_origin = '0' OR hispanic_origin = '9') THEN 'White, Non-Hispanic'
        WHEN race = '1' AND hispanic_origin != '0' AND hispanic_origin != '9' THEN 'Hispanic'
		WHEN race = '2' THEN 'Black'
        WHEN race = '3' THEN 'American Indian/Alaskan Native'
        WHEN race = '4' THEN 'Asian/Pacific Islander' 
	END AS `race`,
    CASE
		WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN 'Non-Hispanic'
        ELSE 'Hispanic'
    END AS `hispanic`,
    CASE 
		WHEN CAST(age AS UNSIGNED) < 15 THEN '10-14'
        WHEN CAST(age AS UNSIGNED) >= 15 AND CAST(age AS UNSIGNED) < 20 THEN '15-19'
        WHEN CAST(age AS UNSIGNED) >= 20 AND CAST(age AS UNSIGNED) < 25 THEN '20-24'
        WHEN CAST(age AS UNSIGNED) >= 25 AND CAST(age AS UNSIGNED) < 30 THEN '25-29'
        WHEN CAST(age AS UNSIGNED) >= 30 AND CAST(age AS UNSIGNED) < 35 THEN '30-34'
        WHEN CAST(age AS UNSIGNED) >= 35 AND CAST(age AS UNSIGNED) < 40 THEN '35-39'
        WHEN CAST(age AS UNSIGNED) >= 40 AND CAST(age AS UNSIGNED) < 45 THEN '40-44'
        WHEN CAST(age AS UNSIGNED) >= 45 AND CAST(age AS UNSIGNED) < 50 THEN '45-49'
        WHEN CAST(age AS UNSIGNED) >= 50 AND CAST(age AS UNSIGNED) < 55 THEN '50-54'
	END AS `age_cohort`,
    COUNT(delivery_year) AS `population`
FROM maternity
WHERE CAST(delivery_time AS UNSIGNED) > 10
GROUP BY delivery_year, race, hispanic, age_cohort) AS a

# Query 'b' - Average Prenatal Start
LEFT JOIN (SELECT
	CONCAT(delivery_year, race, 
		CASE 
			WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN '0'
            ELSE '1' END,
        CASE 
			WHEN CAST(age AS UNSIGNED) < 15 THEN '0'
			WHEN CAST(age AS UNSIGNED) >= 15 AND CAST(age AS UNSIGNED) < 20 THEN '1'
			WHEN CAST(age AS UNSIGNED) >= 20 AND CAST(age AS UNSIGNED) < 25 THEN '2'
			WHEN CAST(age AS UNSIGNED) >= 25 AND CAST(age AS UNSIGNED) < 30 THEN '3'
			WHEN CAST(age AS UNSIGNED) >= 30 AND CAST(age AS UNSIGNED) < 35 THEN '4'
			WHEN CAST(age AS UNSIGNED) >= 35 AND CAST(age AS UNSIGNED) < 40 THEN '5'
			WHEN CAST(age AS UNSIGNED) >= 40 AND CAST(age AS UNSIGNED) < 45 THEN '6'
			WHEN CAST(age AS UNSIGNED) >= 45 AND CAST(age AS UNSIGNED) < 50 THEN '7'
			WHEN CAST(age AS UNSIGNED) >= 50 AND CAST(age AS UNSIGNED) < 55 THEN '8' END       
	) AS `summary_id`,
    CASE
		WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN 'Non-Hispanic'
        ELSE 'Hispanic'
    END AS `hispanic`,
    CASE 
		WHEN CAST(age AS UNSIGNED) < 15 THEN '10-14'
        WHEN CAST(age AS UNSIGNED) >= 15 AND CAST(age AS UNSIGNED) < 20 THEN '15-19'
        WHEN CAST(age AS UNSIGNED) >= 20 AND CAST(age AS UNSIGNED) < 25 THEN '20-24'
        WHEN CAST(age AS UNSIGNED) >= 25 AND CAST(age AS UNSIGNED) < 30 THEN '25-29'
        WHEN CAST(age AS UNSIGNED) >= 30 AND CAST(age AS UNSIGNED) < 35 THEN '30-34'
        WHEN CAST(age AS UNSIGNED) >= 35 AND CAST(age AS UNSIGNED) < 40 THEN '35-29'
        WHEN CAST(age AS UNSIGNED) >= 40 AND CAST(age AS UNSIGNED) < 45 THEN '40-44'
        WHEN CAST(age AS UNSIGNED) >= 45 AND CAST(age AS UNSIGNED) < 50 THEN '45-49'
        WHEN CAST(age AS UNSIGNED) >= 50 AND CAST(age AS UNSIGNED) < 55 THEN '50-54'
	END AS `age_cohort`,
    AVG(CAST(month_prenatal_care_began AS UNSIGNED)) AS `avg_prenatal_care_start_month`
FROM maternity
WHERE CAST(delivery_time AS UNSIGNED) > 10
AND month_prenatal_care_began != '99'
GROUP BY delivery_year, race, hispanic, age_cohort) AS b ON b.summary_id = a.summary_id

# Query 'c' - Average Number of Prenatal Visits
LEFT JOIN (SELECT
	CONCAT(delivery_year, race, 
		CASE 
			WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN '0'
            ELSE '1' END,
        CASE 
			WHEN CAST(age AS UNSIGNED) < 15 THEN '0'
			WHEN CAST(age AS UNSIGNED) >= 15 AND CAST(age AS UNSIGNED) < 20 THEN '1'
			WHEN CAST(age AS UNSIGNED) >= 20 AND CAST(age AS UNSIGNED) < 25 THEN '2'
			WHEN CAST(age AS UNSIGNED) >= 25 AND CAST(age AS UNSIGNED) < 30 THEN '3'
			WHEN CAST(age AS UNSIGNED) >= 30 AND CAST(age AS UNSIGNED) < 35 THEN '4'
			WHEN CAST(age AS UNSIGNED) >= 35 AND CAST(age AS UNSIGNED) < 40 THEN '5'
			WHEN CAST(age AS UNSIGNED) >= 40 AND CAST(age AS UNSIGNED) < 45 THEN '6'
			WHEN CAST(age AS UNSIGNED) >= 45 AND CAST(age AS UNSIGNED) < 50 THEN '7'
			WHEN CAST(age AS UNSIGNED) >= 50 AND CAST(age AS UNSIGNED) < 55 THEN '8' END       
	) AS `summary_id`,
    CASE
		WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN 'Non-Hispanic'
        ELSE 'Hispanic'
    END AS `hispanic`,
    CASE 
		WHEN CAST(age AS UNSIGNED) < 15 THEN '10-14'
        WHEN CAST(age AS UNSIGNED) >= 15 AND CAST(age AS UNSIGNED) < 20 THEN '15-19'
        WHEN CAST(age AS UNSIGNED) >= 20 AND CAST(age AS UNSIGNED) < 25 THEN '20-24'
        WHEN CAST(age AS UNSIGNED) >= 25 AND CAST(age AS UNSIGNED) < 30 THEN '25-29'
        WHEN CAST(age AS UNSIGNED) >= 30 AND CAST(age AS UNSIGNED) < 35 THEN '30-34'
        WHEN CAST(age AS UNSIGNED) >= 35 AND CAST(age AS UNSIGNED) < 40 THEN '35-29'
        WHEN CAST(age AS UNSIGNED) >= 40 AND CAST(age AS UNSIGNED) < 45 THEN '40-44'
        WHEN CAST(age AS UNSIGNED) >= 45 AND CAST(age AS UNSIGNED) < 50 THEN '45-49'
        WHEN CAST(age AS UNSIGNED) >= 50 AND CAST(age AS UNSIGNED) < 55 THEN '50-54'
	END AS `age_cohort`,
    AVG(CAST(num_prenatal_visits AS UNSIGNED)) AS `avg_num_prenatal_visits`
FROM maternity
WHERE CAST(delivery_time AS UNSIGNED) > 10
AND num_prenatal_visits != '99'
GROUP BY delivery_year, race, hispanic, age_cohort) AS c ON c.summary_id = a.summary_id

# Query 'd' - Average BMI
LEFT JOIN (SELECT
	CONCAT(delivery_year, race, 
		CASE 
			WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN '0'
            ELSE '1' END,
        CASE 
			WHEN CAST(age AS UNSIGNED) < 15 THEN '0'
			WHEN CAST(age AS UNSIGNED) >= 15 AND CAST(age AS UNSIGNED) < 20 THEN '1'
			WHEN CAST(age AS UNSIGNED) >= 20 AND CAST(age AS UNSIGNED) < 25 THEN '2'
			WHEN CAST(age AS UNSIGNED) >= 25 AND CAST(age AS UNSIGNED) < 30 THEN '3'
			WHEN CAST(age AS UNSIGNED) >= 30 AND CAST(age AS UNSIGNED) < 35 THEN '4'
			WHEN CAST(age AS UNSIGNED) >= 35 AND CAST(age AS UNSIGNED) < 40 THEN '5'
			WHEN CAST(age AS UNSIGNED) >= 40 AND CAST(age AS UNSIGNED) < 45 THEN '6'
			WHEN CAST(age AS UNSIGNED) >= 45 AND CAST(age AS UNSIGNED) < 50 THEN '7'
			WHEN CAST(age AS UNSIGNED) >= 50 AND CAST(age AS UNSIGNED) < 55 THEN '8' END     
	) AS `summary_id`,
    CASE
		WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN 'Non-Hispanic'
        ELSE 'Hispanic'
    END AS `hispanic`,
    CASE 
		WHEN CAST(age AS UNSIGNED) < 15 THEN '10-14'
        WHEN CAST(age AS UNSIGNED) >= 15 AND CAST(age AS UNSIGNED) < 20 THEN '15-19'
        WHEN CAST(age AS UNSIGNED) >= 20 AND CAST(age AS UNSIGNED) < 25 THEN '20-24'
        WHEN CAST(age AS UNSIGNED) >= 25 AND CAST(age AS UNSIGNED) < 30 THEN '25-29'
        WHEN CAST(age AS UNSIGNED) >= 30 AND CAST(age AS UNSIGNED) < 35 THEN '30-34'
        WHEN CAST(age AS UNSIGNED) >= 35 AND CAST(age AS UNSIGNED) < 40 THEN '35-29'
        WHEN CAST(age AS UNSIGNED) >= 40 AND CAST(age AS UNSIGNED) < 45 THEN '40-44'
        WHEN CAST(age AS UNSIGNED) >= 45 AND CAST(age AS UNSIGNED) < 50 THEN '45-49'
        WHEN CAST(age AS UNSIGNED) >= 50 AND CAST(age AS UNSIGNED) < 55 THEN '50-54'
	END AS `age_cohort`,
    AVG(CAST(body_mass_index AS DECIMAL(3,1))) AS `avg_body_mass_index`
FROM maternity
WHERE CAST(delivery_time AS UNSIGNED) > 10
AND body_mass_index != '99.9'
GROUP BY delivery_year, race, hispanic, age_cohort) AS d ON d.summary_id = a.summary_id

# Query 'e' - Risk Factors, Delivery Method, Morbidity, Gestational Period
LEFT JOIN (SELECT
	CONCAT(delivery_year, race, 
		CASE 
			WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN '0'
            ELSE '1' END,
        CASE 
			WHEN CAST(age AS UNSIGNED) < 15 THEN '0'
			WHEN CAST(age AS UNSIGNED) >= 15 AND CAST(age AS UNSIGNED) < 20 THEN '1'
			WHEN CAST(age AS UNSIGNED) >= 20 AND CAST(age AS UNSIGNED) < 25 THEN '2'
			WHEN CAST(age AS UNSIGNED) >= 25 AND CAST(age AS UNSIGNED) < 30 THEN '3'
			WHEN CAST(age AS UNSIGNED) >= 30 AND CAST(age AS UNSIGNED) < 35 THEN '4'
			WHEN CAST(age AS UNSIGNED) >= 35 AND CAST(age AS UNSIGNED) < 40 THEN '5'
			WHEN CAST(age AS UNSIGNED) >= 40 AND CAST(age AS UNSIGNED) < 45 THEN '6'
			WHEN CAST(age AS UNSIGNED) >= 45 AND CAST(age AS UNSIGNED) < 50 THEN '7'
			WHEN CAST(age AS UNSIGNED) >= 50 AND CAST(age AS UNSIGNED) < 55 THEN '8' END     
	) AS `summary_id`,
    CASE
		WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN 'Non-Hispanic'
        ELSE 'Hispanic'
    END AS `hispanic`,
    CASE 
		WHEN CAST(age AS UNSIGNED) < 15 THEN '10-14'
        WHEN CAST(age AS UNSIGNED) >= 15 AND CAST(age AS UNSIGNED) < 20 THEN '15-19'
        WHEN CAST(age AS UNSIGNED) >= 20 AND CAST(age AS UNSIGNED) < 25 THEN '20-24'
        WHEN CAST(age AS UNSIGNED) >= 25 AND CAST(age AS UNSIGNED) < 30 THEN '25-29'
        WHEN CAST(age AS UNSIGNED) >= 30 AND CAST(age AS UNSIGNED) < 35 THEN '30-34'
        WHEN CAST(age AS UNSIGNED) >= 35 AND CAST(age AS UNSIGNED) < 40 THEN '35-29'
        WHEN CAST(age AS UNSIGNED) >= 40 AND CAST(age AS UNSIGNED) < 45 THEN '40-44'
        WHEN CAST(age AS UNSIGNED) >= 45 AND CAST(age AS UNSIGNED) < 50 THEN '45-49'
        WHEN CAST(age AS UNSIGNED) >= 50 AND CAST(age AS UNSIGNED) < 55 THEN '50-54'
	END AS `age_cohort`,
    SUM(CASE WHEN prepregnancy_diabetes = 'Y' THEN 1 ELSE 0 END) AS `prepregnancy_diabetes_count`,
    SUM(CASE WHEN gestational_diabetes = 'Y' THEN 1 ELSE 0 END) AS `gestational_diabetes_count`,
    SUM(CASE WHEN prepregnancy_hypertension = 'Y' THEN 1 ELSE 0 END) AS `prepregnancy_hypertension_count`,
    SUM(CASE WHEN gestational_hypertension = 'Y' THEN 1 ELSE 0 END) AS `gestational_hypertension_count`,
    SUM(CASE WHEN hypertension_eclampsia = 'Y' THEN 1 ELSE 0 END) AS `hypertension_eclampsia_count`,
    SUM(CASE WHEN prev_preterm_birth = 'Y' THEN 1 ELSE 0 END) AS `prev_preterm_birth_count`,
    SUM(CASE WHEN prev_cesarean = 'Y' THEN 1 ELSE 0 END) AS `prev_cesarean_count`,
    (SUM(CASE WHEN prepregnancy_diabetes = 'Y' THEN 1 ELSE 0 END) + 
     SUM(CASE WHEN gestational_diabetes = 'Y' THEN 1 ELSE 0 END) + 
	 SUM(CASE WHEN prepregnancy_hypertension = 'Y' THEN 1 ELSE 0 END) + 
	 SUM(CASE WHEN gestational_hypertension = 'Y' THEN 1 ELSE 0 END) + 
     SUM(CASE WHEN hypertension_eclampsia = 'Y' THEN 1 ELSE 0 END) + 
     SUM(CASE WHEN prev_preterm_birth = 'Y' THEN 1 ELSE 0 END) +
     SUM(CASE WHEN prev_cesarean = 'Y' THEN 1 ELSE 0 END)
    ) AS `total_risk_factors`,
    SUM(num_prev_cesareans) AS `total_prev_cesareans`,
    SUM(CASE WHEN delivery_method = '1' THEN 1 ELSE 0 END) AS `delivery_vaginal_count`,
    SUM(CASE WHEN delivery_method = '2' THEN 1 ELSE 0 END) AS `delivery_vaginal_prior_cesarean_count`,
    SUM(CASE WHEN delivery_method = '3' THEN 1 ELSE 0 END) AS `delivery_primary_cesarean_count`,
    SUM(CASE WHEN delivery_method = '4' THEN 1 ELSE 0 END) AS `delivery_repeat_cesarean_count`,
    SUM(CASE WHEN delivery_method = '5' THEN 1 ELSE 0 END) AS `delivery_vaginal_unknown_prior_count`,
    SUM(CASE WHEN delivery_method = '6' THEN 1 ELSE 0 END) AS `delivery_cesarean_unknown_prior_count`,
	SUM(CASE WHEN delivery_method = '9' THEN 1 ELSE 0 END) AS `delivery_not_stated_count`,
    (SUM(CASE WHEN delivery_method = '1' THEN 1 ELSE 0 END) + 
	 SUM(CASE WHEN delivery_method = '2' THEN 1 ELSE 0 END) + 
     SUM(CASE WHEN delivery_method = '5' THEN 1 ELSE 0 END)
	) AS `total_delivery_vaginal`,
    (SUM(CASE WHEN delivery_method = '3' THEN 1 ELSE 0 END) + 
     SUM(CASE WHEN delivery_method = '4' THEN 1 ELSE 0 END) + 
     SUM(CASE WHEN delivery_method = '6' THEN 1 ELSE 0 END)
	) AS `total_delivery_cesarean`,
    SUM(CASE WHEN maternal_transfusion = 'Y' THEN 1 ELSE 0 END) AS `maternal_transfusion_count`,
    SUM(CASE WHEN perineal_laceration = 'Y' THEN 1 ELSE 0 END) AS `perineal_laceration_count`,
    SUM(CASE WHEN ruptured_uterus = 'Y' THEN 1 ELSE 0 END) AS `ruptured_uterus_count`,
    SUM(CASE WHEN unplanned_hysterectomy = 'Y' THEN 1 ELSE 0 END) AS `unplanned_hysterectomy_count`,
    SUM(CASE WHEN admit_intensive_care = 'Y' THEN 1 ELSE 0 END) AS `admit_intensive_care_count`,
    (SUM(CASE WHEN maternal_transfusion = 'Y' THEN 1 ELSE 0 END) + 
     SUM(CASE WHEN perineal_laceration = 'Y' THEN 1 ELSE 0 END) + 
     SUM(CASE WHEN ruptured_uterus = 'Y' THEN 1 ELSE 0 END) +
     SUM(CASE WHEN unplanned_hysterectomy = 'Y' THEN 1 ELSE 0 END) + 
     SUM(CASE WHEN admit_intensive_care = 'Y' THEN 1 ELSE 0 END)
	) AS `total_morbidity_count`,
    AVG(
		CASE
			WHEN gestation_period = '01' THEN 20
            WHEN gestation_period = '02' THEN 23.5
            WHEN gestation_period = '03' THEN 29.5
            WHEN gestation_period = '04' THEN 32.5
            WHEN gestation_period = '05' THEN 35
            WHEN gestation_period = '06' THEN 37.5
            WHEN gestation_period = '07' THEN 39
            WHEN gestation_period = '08' THEN 40
            WHEN gestation_period = '09' THEN 41
            WHEN gestation_period = '10' THEN 42
            ELSE NULL 
		END) AS `gestation_weeks`
FROM maternity
WHERE CAST(delivery_time AS UNSIGNED) > 10
GROUP BY delivery_year, race, hispanic, age_cohort) AS e ON e.summary_id = a.summary_id;


