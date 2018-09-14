CREATE DATABASE vital_stats_db;

USE vital_stats_db;

DROP TABLE IF EXISTS maternity_test;
CREATE TABLE maternity_test (
	`id` INTEGER AUTO_INCREMENT NOT NULL,
    `delivery_year` VARCHAR(4) NOT NULL,
    `delivery_time` VARCHAR(4),
    `delivery_loc` VARCHAR(1),
    `age` VARCHAR(2),
    `nativity` VARCHAR(1),
    `resident_status` VARCHAR(1),
    `race` VARCHAR(1),
    `hispanic_origin` VARCHAR(1),
    `marital_status` VARCHAR(1),
    `education` VARCHAR(1),
    `month_prenatal_care_began` VARCHAR(2),
    `num_prenatal_visits` VARCHAR(2),
    `body_mass_index` VARCHAR(4),
    `prepregnancy_diabetes` VARCHAR(1),
    `gestational_diabetes` VARCHAR(1),
    `prepregnancy_hypertension` VARCHAR(1),
    `gestational_hypertension` VARCHAR(1),
    `hypertension_eclampsia` VARCHAR(1),
    `prev_preterm_birth` VARCHAR(1),
    `prev_cesarean` VARCHAR(1),
    `num_prev_cesareans` VARCHAR(2),
    `no_infections_reported` VARCHAR(1),
    `delivery_method` VARCHAR(1),
    `maternal_transfusion` VARCHAR(1),
    `perineal_laceration` VARCHAR(1),
    `ruptured_uterus` VARCHAR(1),
    `unplanned_hysterectomy` VARCHAR(1),
    `admit_intensive_care` VARCHAR(1),
    `no_morbidity_reported` VARCHAR(1),
    `gestation_period` VARCHAR(2),
    PRIMARY KEY(id)
    );

DROP TABLE IF EXISTS mortality;    
CREATE TABLE mortality (
	`id` INTEGER AUTO_INCREMENT NOT NULL,
	`year` VARCHAR(4) NOT NULL,
	`resident_status` VARCHAR(1),
    `education` VARCHAR(1),
	`sex` VARCHAR(1),
    `age` VARCHAR(2),
    `race` VARCHAR(1),
    `hispanic_origin` VARCHAR(1),
    `manner_of_death` VARCHAR(1),
    `cause_of_death` VARCHAR(3),
    PRIMARY KEY(id)
);

# Import 2014-2016 natality data into tables
LOAD DATA LOCAL INFILE 
'D:\\UDAB_Projects\\Racial_Health_Disparities\\Natality_Data\\Nat2014PublicUS.txt'
INTO TABLE maternity
(@row)
SET delivery_year = TRIM(SUBSTR(@row,9,12)), #DOB_YY
	delivery_time = TRIM(SUBSTR(@row,19,22)), #DOB_TT
    delivery_loc = TRIM(SUBSTR(@row,32,32)), #BFACIL
    age = TRIM(SUBSTR(@row,75,76)), #MAGER
    nativity = TRIM(SUBSTR(@row,84,84)), #MBSTATE_REC
    resident_status = TRIM(SUBSTR(@row,104,104)), #RESTATUS
    race = TRIM(SUBSTR(@row,110,110)), #MBRACE
    hispanic_origin = TRIM(SUBSTR(@row,115,115)), #MHISP_R
    marital_status = TRIM(SUBSTR(@row,120,120)), #DMAR
    education = TRIM(SUBSTR(@row,124,124)), #MEDUC
    month_prenatal_care_began = TRIM(SUBSTR(@row,224,225)), #PRECARE
    num_prenatal_visits = TRIM(SUBSTR(@row,238,239)), #PREVIS
    body_mass_index = TRIM(SUBSTR(@row,283,286)), #BMI
    prepregnancy_diabetes = TRIM(SUBSTR(@row,313,313)), #RF_PDIAB
    gestational_diabetes = TRIM(SUBSTR(@row,314,314)), #RF_GDIAB
    prepregnancy_hypertension = TRIM(SUBSTR(@row,315,315)), #RF_PHYPE
    gestational_hypertension = TRIM(SUBSTR(@row,316,316)), #RF_GHYPE
    hypertension_eclampsia = TRIM(SUBSTR(@row,317,317)), #RF_EHYPE
    prev_preterm_birth = TRIM(SUBSTR(@row,318,318)), #RF_PPTERM	
    prev_cesarean = TRIM(SUBSTR(@row,331,331)), #RF_CESAR
    num_prev_cesareans = TRIM(SUBSTR(@row,332,333)), #RF_CESARN
    no_infections_reported = TRIM(SUBSTR(@row,353,353)), #NO_INFEC
    delivery_method = TRIM(SUBSTR(@row,407,407)), #RDMETH_REC
    maternal_transfusion = TRIM(SUBSTR(@row,415,415)), #MM_MTR
    perineal_laceration = TRIM(SUBSTR(@row,416,416)), #MM_PLAC
    ruptured_uterus = TRIM(SUBSTR(@row,417,417)), #MM_RUPT
    unplanned_hysterectomy = TRIM(SUBSTR(@row,418,418)), #MM_UHYST
    admit_intensive_care = TRIM(SUBSTR(@row,419,419)), #MM_AICU
    no_morbidity_reported = TRIM(SUBSTR(@row,427,427)), #NO_MMORB
    gestation_period = TRIM(SUBSTR(@row,492,493)) #GESTREC10
;

# Import 2009-2013 natality data into tables
LOAD DATA LOCAL INFILE 
'D:\\UDAB_Projects\\Racial_Health_Disparities\\Natality_Data\\Nat2009PublicUS.txt'
INTO TABLE maternity
(@row)
SET delivery_year = TRIM(SUBSTR(@row,15,18)), #DOB_YY
	delivery_time = TRIM(SUBSTR(@row,25,28)), #DOB_TT
    delivery_loc = TRIM(SUBSTR(@row,41,41)), #BFACIL
    age = TRIM(SUBSTR(@row,89,90)), #MAGER
    #nativity = TRIM(SUBSTR(@row,84,84)), #MBSTATE_REC
    resident_status = TRIM(SUBSTR(@row,138,138)), #RESTATUS
    race = TRIM(SUBSTR(@row,143,143)), #MRACEREC
    hispanic_origin = TRIM(SUBSTR(@row,148,148)), #UMHISP
    marital_status = TRIM(SUBSTR(@row,153,153)), #MAR
    education = TRIM(SUBSTR(@row,155,155)), #MEDUC
    month_prenatal_care_began = TRIM(SUBSTR(@row,245,246)), #PRECARE
    num_prenatal_visits = TRIM(SUBSTR(@row,270,271)), #UPREVIS
    body_mass_index = TRIM(SUBSTR(@row,529,533)), #BMI
    prepregnancy_diabetes = TRIM(SUBSTR(@row,313,313)), #RF_DIAB
    gestational_diabetes = TRIM(SUBSTR(@row,314,314)), #RF_GEST
    prepregnancy_hypertension = TRIM(SUBSTR(@row,315,315)), #RF_PHYP
    gestational_hypertension = TRIM(SUBSTR(@row,316,316)), #RF_GHYP
    hypertension_eclampsia = TRIM(SUBSTR(@row,317,317)), #RF_ECLAM
    prev_preterm_birth = TRIM(SUBSTR(@row,318,318)), #RF_PPTERM	
    prev_cesarean = TRIM(SUBSTR(@row,324,324)), #RF_CESAR
    num_prev_cesareans = TRIM(SUBSTR(@row,325,326)), #RF_CESARN
    #no_infections_reported = TRIM(SUBSTR(@row,353,353)), #NO_INFEC
    delivery_method = TRIM(SUBSTR(@row,401,401)), #RDMETH_REC
    maternal_transfusion = TRIM(SUBSTR(@row,404,404)), #MM_MTR
    perineal_laceration = TRIM(SUBSTR(@row,405,405)), #MM_PLAC
    ruptured_uterus = TRIM(SUBSTR(@row,406,406)), #MM_RUPT
    unplanned_hysterectomy = TRIM(SUBSTR(@row,407,407)), #MM_UHYST
    admit_intensive_care = TRIM(SUBSTR(@row,408,408)), #MM_ICU
    #no_morbidity_reported = TRIM(SUBSTR(@row,427,427)), #NO_MMORB
    gestation_period = TRIM(SUBSTR(@row,453,454)) #GESTREC10
;

SELECT COUNT(*) FROM maternity WHERE CAST(maternity.delivery_time AS UNSIGNED) > 10;

# Import 2009-2016 mortality data into tables
LOAD DATA LOCAL INFILE 
'D:\\UDAB_Projects\\Racial_Health_Disparities\\Mortality_Data\\VS09MORT.DUSMCPUB'
INTO TABLE mortality
(@row)
SET year = TRIM(SUBSTR(@row,102,105)),
	resident_status = TRIM(SUBSTR(@row,20,20)),
    education = TRIM(SUBSTR(@row,63,63)),
    sex = TRIM(SUBSTR(@row,69,69)),
    age = TRIM(SUBSTR(@row,77,78)), #Age Recode 27
    race = TRIM(SUBSTR(@row,450,450)), #Race Recode 5
    hispanic_origin = TRIM(SUBSTR(@row,488,488)), #Hispanic Origin/Race Recode
    manner_of_death = TRIM(SUBSTR(@row,107,107)),
    cause_of_death = TRIM(SUBSTR(@row,150,152)) #358 Cause Recode
;

SELECT * FROM mortality WHERE mortality.cause_of_death = '352';


#RANDOM SAMPLING OF MATERNITY AND MORTALITY TABLES

SELECT * FROM maternity WHERE CAST(maternity.delivery_time AS UNSIGNED) > 10 ORDER BY RAND() LIMIT 280000;

SELECT * FROM mortality WHERE CAST(cause_of_death AS UNSIGNED) >= 340 AND CAST(cause_of_death AS UNSIGNED) < 356;
