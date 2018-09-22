USE vital_stats_db;

SELECT
	a.id,
    a.delivery_year AS `year`,
    CASE
		WHEN a.delivery_loc = '1' THEN 'Hospital'
        WHEN a.delivery_loc = '2' THEN 'Freestanding Birth Center'
        WHEN a.delivery_loc = '3' OR a.delivery_loc = '4' OR a.delivery_loc = '5' THEN 'Home'
        WHEN a.delivery_loc = '6' THEN 'Clinic/Doctor\'s Office'
        WHEN a.delivery_loc = '7' THEN 'Other'
        WHEN a.delivery_loc = '9' THEN 'Unknown'
	END AS `location`,
    a.age,
    CASE 
		WHEN CAST(a.age AS UNSIGNED) < 15 THEN '10-14'
        WHEN CAST(a.age AS UNSIGNED) >= 15 AND CAST(a.age AS UNSIGNED) < 20 THEN '15-19'
        WHEN CAST(a.age AS UNSIGNED) >= 20 AND CAST(a.age AS UNSIGNED) < 25 THEN '20-24'
        WHEN CAST(a.age AS UNSIGNED) >= 25 AND CAST(a.age AS UNSIGNED) < 30 THEN '25-29'
        WHEN CAST(a.age AS UNSIGNED) >= 30 AND CAST(a.age AS UNSIGNED) < 35 THEN '30-34'
        WHEN CAST(a.age AS UNSIGNED) >= 35 AND CAST(a.age AS UNSIGNED) < 40 THEN '35-39'
        WHEN CAST(a.age AS UNSIGNED) >= 40 AND CAST(a.age AS UNSIGNED) < 45 THEN '40-44'
        WHEN CAST(a.age AS UNSIGNED) >= 45 AND CAST(a.age AS UNSIGNED) < 50 THEN '45-49'
        WHEN CAST(a.age AS UNSIGNED) >= 50 AND CAST(a.age AS UNSIGNED) < 55 THEN '50-54'
	END AS `age_cohort`,
    CASE 
		WHEN a.race = '1' AND (hispanic_origin = '0' OR hispanic_origin = '9') THEN 'White, Non-Hispanic'
        WHEN a.race = '1' AND hispanic_origin != '0' AND hispanic_origin != '9' THEN 'Hispanic'
		WHEN a.race = '2' THEN 'Black'
        WHEN a.race = '3' THEN 'American Indian/Alaskan Native'
        WHEN a.race = '4' THEN 'Asian/Pacific Islander' 
	END AS `race`,
    CASE
		WHEN a.race = '1' AND (hispanic_origin = '0' OR hispanic_origin = '9') THEN 1
        ELSE 0
	END AS `race_white_nh`,
    CASE
		WHEN a.race = '1' AND hispanic_origin != '0' AND hispanic_origin != '9' THEN 1
        ELSE 0
	END AS `race_hispanic`,
    CASE
		WHEN a.race = '2' THEN 1
        ELSE 0
	END AS `race_black`,
    CASE
		WHEN a.race = '3' THEN 1
        ELSE 0
	END AS `race_ai_an`,
    CASE
		WHEN a.race = '4' THEN 1
        ELSE 0
	END AS `race_asian_pi`,
    CASE
		WHEN hispanic_origin = '0' OR hispanic_origin = '9' THEN 'Non-Hispanic'
        ELSE 'Hispanic'
    END AS `hispanic`,
    CASE
		WHEN a.marital_status = '1' THEN 'Married'
        ELSE 'Unmarried'
	END AS `marital_status`,
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
    CASE
		WHEN a.month_prenatal_care_began = '00' THEN 10
        ELSE CAST(a.month_prenatal_care_began AS UNSIGNED)
	END AS `prenatal_care_start_month`,
    CAST(a.num_prenatal_visits AS UNSIGNED) AS `num_prenatal_visits`,
    a.body_mass_index,
    CASE
		WHEN a.prepregnancy_diabetes = 'Y' THEN 1
        ELSE 0
	END AS `prepregnancy_diabetes`,
    CASE
		WHEN a.gestational_diabetes = 'Y' THEN 1
        ELSE 0
	END AS `gestational_diabetes`,
    CASE
		WHEN a.prepregnancy_hypertension = 'Y' THEN 1
        ELSE 0
	END AS `prepregnancy_hypertension`,
    CASE
		WHEN a.gestational_hypertension = 'Y' THEN 1
        ELSE 0
	END AS `gestational_hypertension`,
    CASE
		WHEN a.hypertension_eclampsia = 'Y' THEN 1
        ELSE 0
	END AS `hypertension_eclampsia`,
    CASE
		WHEN a.prev_preterm_birth = 'Y' THEN 1
        ELSE 0
	END AS `prev_preterm_birth`,
    CASE
		WHEN a.prepregnancy_diabetes = 'N' 
			AND a.gestational_diabetes = 'N' 
            AND a.prepregnancy_hypertension = 'N' 
            AND a.gestational_hypertension = 'N' 
            AND a.hypertension_eclampsia = 'N' 
            AND a.prev_preterm_birth = 'N' THEN 1
        ELSE 0
	END AS `no_riskfactors_reported`,
    (CASE
		WHEN a.prepregnancy_diabetes = 'Y' THEN 1
		ELSE 0
	END +
	CASE
		WHEN a.gestational_diabetes = 'Y' THEN 1
		ELSE 0
	END +
	CASE
		WHEN a.prepregnancy_hypertension = 'Y' THEN 1
		ELSE 0
	END +
	CASE
		WHEN a.gestational_hypertension = 'Y' THEN 1
		ELSE 0
	END +
	CASE
		WHEN a.hypertension_eclampsia = 'Y' THEN 1
		ELSE 0
	END +
	CASE
		WHEN a.prev_preterm_birth = 'Y' THEN 1
		ELSE 0
	END) AS `total_riskfactors_reported`,
    CASE
		WHEN a.prev_cesarean = 'Y' THEN 1
        ELSE 0
	END AS `prev_cesarean`,
    CAST(a.num_prev_cesareans AS UNSIGNED) AS `num_prev_cesareans`,
    CASE 
		WHEN a.no_infections_reported = '1' THEN 1
        ELSE 0
	END AS `no_infections_reported`,
    CASE
		WHEN a.delivery_method = '3' 
			OR a.delivery_method = '4' 
            OR a.delivery_method = '6' THEN 1 
		ELSE 0
	END AS `delivery_cesarean`,
    CASE
		WHEN a.maternal_transfusion = 'Y' THEN 1
        ELSE 0
	END AS `maternal_transfusion`,
    CASE
		WHEN a.perineal_laceration = 'Y' THEN 1
        ELSE 0
	END AS `perineal_laceration`,
    CASE
		WHEN a.ruptured_uterus = 'Y' THEN 1
        ELSE 0
	END AS `ruptured_uterus`,
    CASE
		WHEN a.unplanned_hysterectomy = 'Y' THEN 1
        ELSE 0
	END AS `unplanned_hysterectomy`,
    CASE
		WHEN a.admit_intensive_care = 'Y' THEN 1
        ELSE 0
	END AS `admit_intensive_care`,
    CASE
		WHEN a.maternal_transfusion = 'N' 
			AND a.perineal_laceration = 'N' 
			AND a.ruptured_uterus = 'N' 
            AND a.unplanned_hysterectomy = 'N' 
            AND a.admit_intensive_care = 'N' THEN 1
        ELSE 0
	END AS `no_morbidity_reported`,
    (CASE
		WHEN a.maternal_transfusion = 'Y' THEN 1
		ELSE 0
	END +
	CASE
		WHEN a.perineal_laceration = 'Y' THEN 1
		ELSE 0
	END +
	CASE
		WHEN a.ruptured_uterus = 'Y' THEN 1
		ELSE 0
	END +
	CASE
		WHEN a.unplanned_hysterectomy = 'Y' THEN 1
		ELSE 0
	END +
	CASE
		WHEN a.admit_intensive_care = 'Y' THEN 1
		ELSE 0
	END) AS `total_morbidity_reported`,
    CASE
		WHEN a.gestation_period = '01' THEN 20
		WHEN a.gestation_period = '02' THEN 23.5
		WHEN a.gestation_period = '03' THEN 29.5
		WHEN a.gestation_period = '04' THEN 32.5
		WHEN a.gestation_period = '05' THEN 35
		WHEN a.gestation_period = '06' THEN 37.5
		WHEN a.gestation_period = '07' THEN 39
		WHEN a.gestation_period = '08' THEN 40
		WHEN a.gestation_period = '09' THEN 41
		WHEN a.gestation_period = '10' THEN 42
	END AS `gestation_weeks`
FROM (SELECT * 
		FROM maternity 
        WHERE 
			CAST(delivery_time AS UNSIGNED) > 10
			AND month_prenatal_care_began != '99'
            AND num_prenatal_visits != '99'
            AND body_mass_index != '99.9'
            AND prepregnancy_diabetes != 'U'
            AND gestational_diabetes != 'U'
            AND prepregnancy_hypertension != 'U'
            AND gestational_hypertension != 'U'
            AND hypertension_eclampsia != 'U'
            AND prev_preterm_birth != 'U'
            AND prev_cesarean != 'U'
            AND num_prev_cesareans != '99'
            AND no_infections_reported != '9'
            AND delivery_method != '9'
            AND maternal_transfusion != 'U'
            AND perineal_laceration != 'U'
            AND ruptured_uterus != 'U'
            AND unplanned_hysterectomy != 'U'
            AND admit_intensive_care != 'U'
            AND gestation_period != '99'
        ORDER BY RAND() LIMIT 280000
	 ) AS a;