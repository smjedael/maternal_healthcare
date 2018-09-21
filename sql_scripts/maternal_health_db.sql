-- DROP DATABASE maternal_health_db;

CREATE DATABASE maternal_health_db;

USE maternal_health_db;

DROP TABLE IF EXISTS us_female_census_summary;
CREATE TABLE us_female_census_summary (
	`universe` VARCHAR(1),
	`month` INTEGER,
    `year` INTEGER,
	`age` INTEGER,
	`age_cohort` VARCHAR(5),
	`total_population` INTEGER,
	`total_female_population` INTEGER,
	`white_nh` INTEGER,
	`hispanic` INTEGER,
	`black` INTEGER,
	`ai_an` INTEGER,
	`asian_pi` INTEGER,
	`total_race_population` INTEGER,
    `id` INTEGER AUTO_INCREMENT NOT NULL,
    PRIMARY KEY (id)
);

LOAD DATA LOCAL INFILE 'D:\\UDAB_Projects\\Racial_Health_Disparities\\CSVs\\us_female_census_summary.csv' 
INTO TABLE us_female_census_summary 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE us_female_census_summary DROP COLUMN age;

DROP TABLE IF EXISTS maternal_mortality_all;
CREATE TABLE maternal_mortality_all (
	`id` INTEGER,
    `year` INTEGER,
    `education` VARCHAR(50),
    `age_cohort` VARCHAR(5),
    `race` VARCHAR(50),
    `race_white_nh` TINYINT,
    `race_hispanic` TINYINT,
    `race_black` TINYINT,
    `race_ai_an` TINYINT,
    `race_asian_pi` TINYINT,
    `hispanic` VARCHAR(15),
    `cause_of_death` VARCHAR(50),
    `direct_obstetric_abortive` TINYINT,
    `direct_obstetric_nonabortive` TINYINT,
    `direct_obstetric_unspecified` TINYINT,
    `other_pregnancy_related` TINYINT,
    `indirect_obstetric` TINYINT,
    `don_eclampsia_preeclampsia` TINYINT,
    `don_hemorrhage` TINYINT,
    `don_puerperium_embolism` TINYINT,
    `don_puerperium_other` TINYINT,
    `don_all_other` TINYINT,
    PRIMARY KEY(id)
);

LOAD DATA LOCAL INFILE 'D:\\UDAB_Projects\\Racial_Health_Disparities\\CSVs\\maternal_mortality_all.csv' 
INTO TABLE maternal_mortality_all 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS maternity_summary;
CREATE TABLE maternity_summary (
	`summary_id` INTEGER,
    `year` INTEGER,
    `race` VARCHAR(50),
    `hispanic` VARCHAR(15),
    `age_cohort` VARCHAR(5),
    `total_births` INTEGER,
    `avg_prenatal_care_start_month` FLOAT,
    `avg_num_prenatal_visits` FLOAT,
    `avg_body_mass_index` FLOAT,
    `prepregnancy_diabetes_count` INTEGER,
    `gestational_diabetes_count` INTEGER,
    `prepregnancy_hypertension_count` INTEGER,
    `gestational_hypertension_count` INTEGER,
    `hypertension_eclampsia_count` INTEGER,
    `prev_preterm_birth_count` INTEGER,
    `prev_cesarean_count` INTEGER,
    `total_risk_factors` INTEGER,
    `total_prev_cesareans` INTEGER,
    `delivery_vaginal_count_count` INTEGER,
    `delivery_vaginal_prior_cesarean_count` INTEGER,
    `delivery_primary_cesarean_count` INTEGER,
    `delivery_repeat_cesarean_count` INTEGER,
    `delivery_vaginal_unknown_prior_count` INTEGER,
	`delivery_cesarean_unknown_prior_count` INTEGER,
	`delivery_not_stated_count` INTEGER,
	`total_delivery_vaginal` INTEGER,
    `total_delivery_cesarean` INTEGER,
    `maternal_transfusion_count` INTEGER,
    `perineal_laceration_count` INTEGER,
    `ruptured_uterus_count` INTEGER,
    `unplanned_hysterectomy_count` INTEGER,
    `admit_intensive_care_count` INTEGER,
    `total_morbidity_count` INTEGER,
    `gestation_weeks` FLOAT,
    PRIMARY KEY(summary_id)
);

LOAD DATA LOCAL INFILE 'D:\\UDAB_Projects\\Racial_Health_Disparities\\CSVs\\maternity_summary.csv' 
INTO TABLE maternity_summary 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS maternal_mortality_summary;
CREATE TABLE maternal_mortality_summary (
	`summary_id` INTEGER,
    `year` INTEGER,
    `race` VARCHAR(50),
    `hispanic` VARCHAR(15),
    `age_cohort` VARCHAR(5),
    `total_maternal_deaths` INTEGER,
    `direct_obstetric_abortive_count` INTEGER,
    `direct_obstetric_nonabortive_count` INTEGER,
    `direct_obstetric_unspecified_count` INTEGER,
    `other_pregnancy_related_count` INTEGER,
    `indirect_obstetric_count` INTEGER,
    `don_eclampsia_preeclampsia_count` INTEGER,
    `don_hemorrhage_count` INTEGER,
    `don_puerperium_embolism_count` INTEGER,
    `don_puerperium_other_count` INTEGER,
    `don_all_other_count` INTEGER,
    
    PRIMARY KEY(summary_id)
);

LOAD DATA LOCAL INFILE 'D:\\UDAB_Projects\\Racial_Health_Disparities\\CSVs\\maternal_mortality_summary.csv' 
INTO TABLE maternal_mortality_summary 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS maternity_random_sample;
CREATE TABLE maternity_random_sample (
	`id` INTEGER,
    `year` INTEGER,
    `location` VARCHAR(50),
    `age` INTEGER,
    `age_cohort` VARCHAR(5),
    `race` VARCHAR(50),
    `race_white_nh` TINYINT,
    `race_hispanic` TINYINT,
    `race_black` TINYINT,
    `race_ai_an` TINYINT,
    `race_asian_pi` TINYINT,
    `hispanic` VARCHAR(15),
    `marital_status` VARCHAR(15),
    `education` VARCHAR(50),
    `prenatal_care_start_month` TINYINT,
    `num_prenatal_visits` TINYINT,
    `body_mass_index` FLOAT,
    `prepregnancy_diabetes` TINYINT,
    `gestational_diabetes` TINYINT,
    `prepregnancy_hypertension` TINYINT,
    `gestational_hypertension` TINYINT,
    `hypertension_eclampsia` TINYINT,
    `prev_preterm_birth` TINYINT,
    `no_riskfactors_reported` TINYINT,
    `total_riskfactors_reported` TINYINT,
    `prev_cesarean` TINYINT,
    `num_prev_cesareans` TINYINT,
    `no_infections_reported` TINYINT,
	`delivery_cesarean` TINYINT,
    `maternal_transfusion` TINYINT,
    `perineal_laceration` TINYINT,
    `ruptured_uterus` TINYINT,
    `unplanned_hysterectomy` TINYINT,
    `admit_intensive_care` TINYINT,
    `no_morbidity_reported` TINYINT,
    `total_morbidity_reported` TINYINT,
    `gestation_weeks` FLOAT,
    PRIMARY KEY(id)
);

LOAD DATA LOCAL INFILE 'D:\\UDAB_Projects\\Racial_Health_Disparities\\CSVs\\maternity_random_sample.csv' 
INTO TABLE maternity_random_sample
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM us_female_census_summary;