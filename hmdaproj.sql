-- ==========================================
-- PRELIMINARY TABLE: Load raw CSV data
-- ==========================================

CREATE TABLE hmda_table (
    as_of_year    VARCHAR(150),
    respondent_id    VARCHAR(150),
    agency_name    VARCHAR(150),
    agency_abbr    VARCHAR(150),
    agency_code   VARCHAR(150),
    loan_type_name    VARCHAR(150),
    loan_type    VARCHAR(150),
    property_type_name       VARCHAR(150),
    property_type   VARCHAR(150),
    loan_purpose_name   VARCHAR(150),
    loan_purpose   VARCHAR(150),
    owner_occupancy_name   VARCHAR(150),
    owner_occupancy   VARCHAR(150),
    loan_amount_000s   VARCHAR(150),
    preapproval_name   VARCHAR(150),
    preapproval   VARCHAR(150),
    action_taken_name         VARCHAR(150),
    action_taken     VARCHAR(150),
    msamd_name   VARCHAR(150),
    msamd   VARCHAR(150),
    state_name   VARCHAR(150),
    state_abbr   VARCHAR(150),
    state_code   VARCHAR(150),
    county_name   VARCHAR(150),
    county_code   VARCHAR(150),
    census_tract_number   VARCHAR(150),
    applicant_ethnicity_name   VARCHAR(150),
    applicant_ethnicity   VARCHAR(150),
    co_applicant_ethnicity_name   VARCHAR(150),
    co_applicant_ethnicity  VARCHAR(150),
    applicant_race_name_1   VARCHAR(150),
    applicant_race_1   VARCHAR(150),
    applicant_race_name_2   VARCHAR(150),
    applicant_race_2   VARCHAR(150),
    applicant_race_name_3   VARCHAR(150),
    applicant_race_3      VARCHAR(150),
    applicant_race_name_4  VARCHAR(150),
    applicant_race_4      VARCHAR(150),
    applicant_race_name_5         VARCHAR(150),
    applicant_race_5      VARCHAR(150),
    co_applicant_race_name_1      VARCHAR(150),
    co_applicant_race_1   VARCHAR(150),
    co_applicant_race_name_2      VARCHAR(150),
    co_applicant_race_2   VARCHAR(150),
    co_applicant_race_name_3      VARCHAR(150),
    co_applicant_race_3   VARCHAR(150),
    co_applicant_race_name_4      VARCHAR(150),
    co_applicant_race_4   VARCHAR(150),
    co_applicant_race_name_5      VARCHAR(150),
    co_applicant_race_5   VARCHAR(150),
    applicant_sex_name    VARCHAR(150),
    applicant_sex  VARCHAR(150),
    co_applicant_sex_name  VARCHAR(150),
    co_applicant_sex  VARCHAR(150),
    applicant_income_000s  VARCHAR(150),
    purchaser_type_name  VARCHAR(150),
    purchaser_type  VARCHAR(150),
    denial_reason_name_1  VARCHAR(150),
    denial_reason_1  VARCHAR(150),
    denial_reason_name_2  VARCHAR(150),
    denial_reason_2  VARCHAR(150),
    denial_reason_name_3  VARCHAR(150),
    denial_reason_3  VARCHAR(150),
    rate_spread  VARCHAR(150),
    hoepa_status_name  VARCHAR(150),
    hoepa_status  VARCHAR(150),
    lien_status_name  VARCHAR(150),
    lien_status  VARCHAR(150),
    edit_status_name  VARCHAR(150),
    edit_status  VARCHAR(150),
    sequence_number  VARCHAR(150),
    population  VARCHAR(150),
    minority_population  VARCHAR(150),
    hud_median_family_income  VARCHAR(150),
    tract_to_msamd_income  VARCHAR(150),
    number_of_owner_occupied_units  VARCHAR(150),
    number_of_1_to_4_family_units  VARCHAR(150),
    application_date_indicator  VARCHAR(150)
);

\copy hmda_table FROM '/work/hmda_2017_ny_all-records_labels.csv' DELIMITER ',' CSV HEADER;
ALTER TABLE hmda_table
ADD COLUMN ID SERIAL PRIMARY KEY; -- serial auto increments, primary key enforces not null and uniqueness


-- ==========================================
-- SCHEMA AND TABLE DEFINITIONS
-- ==========================================


CREATE SCHEMA Respondent_info;
CREATE TABLE Respondent_info.agency(
agency_code INT PRIMARY KEY,
agency_name TEXT,
agency_abbr TEXT
);

CREATE TABLE Respondent_info.edit_status(
edit_status INT PRIMARY KEY,
edit_status_name TEXT
);


CREATE SCHEMA Property_location;

CREATE TABLE Property_location.msamd(
msamd INT PRIMARY KEY,
msamd_name TEXT
);

CREATE TABLE Property_location.state(
state_code INT PRIMARY KEY,
state_name TEXT,
state_abbr TEXT
);

CREATE TABLE Property_location.county_code(
county_code INT PRIMARY KEY,
county_name TEXT,
state_code INT,
CONSTRAINT fk_state_code   -- Requires constraint because state -> county is a parent-child relation
    FOREIGN KEY (state_code)
    REFERENCES Property_location.state(state_code)
);

CREATE TABLE Property_location.tract(
location_id SERIAL PRIMARY KEY,  -- use SERIAL since it's a artificial key
msamd INT,
state_code INT,
county_code INT,
census_tract_number TEXT,
population INT, 
minority_population DOUBLE PRECISION,
hud_median_family_income INT,
tract_to_msamd_income DOUBLE PRECISION, 
number_of_owner_occupied_units INT,
number_of_1_to_4_family_units INT
);

CREATE SCHEMA Loan_info;

CREATE TABLE Loan_info.loan_type(
Loan_type INT PRIMARY KEY,
Loan_type_name TEXT
);

CREATE TABLE Loan_info.property(
Property_type INT PRIMARY KEY,
Property_type_name TEXT
);

CREATE TABLE Loan_info.purpose(
Loan_purpose INT PRIMARY KEY,
Loan_purpose_name TEXT
);

CREATE TABLE Loan_info.owner_occupancy(
Owner_occupancy INT PRIMARY KEY,
Owner_occupancy_name TEXT
);

CREATE TABLE Loan_info.preapproval(
Preapproval INT PRIMARY KEY,
Preapproval_name TEXT
);

CREATE TABLE Loan_info.action_taken(
Action_taken INT PRIMARY KEY,
Action_taken_name TEXT
);


CREATE SCHEMA Application_information;

CREATE TABLE Application_information.applicant_ethnicity(
Applicant_ethnicity INT PRIMARY KEY,
Applicant_ethnicity_name TEXT
);

CREATE TABLE Application_information.co_applicant_ethnicity(
Co_applicant_ethnicity INT PRIMARY KEY,
Co_applicant_ethnicity_name TEXT
);



CREATE TABLE Application_information.race(
race_code INT PRIMARY KEY,
race_name TEXT
);

INSERT INTO Application_information.race(race_code, race_name)
SELECT DISTINCT applicant_race_1::INT, applicant_race_name_1
FROM hmda_table
WHERE applicant_race_1 IS NOT NULL AND applicant_race_1 != ''
UNION
SELECT DISTINCT applicant_race_2::INT, applicant_race_name_2
FROM hmda_table
WHERE applicant_race_2 IS NOT NULL AND applicant_race_2 != ''
UNION
SELECT DISTINCT applicant_race_3::INT, applicant_race_name_3
FROM hmda_table
WHERE applicant_race_3 IS NOT NULL AND applicant_race_3 != ''
UNION
SELECT DISTINCT applicant_race_4::INT, applicant_race_name_4
FROM hmda_table
WHERE applicant_race_4 IS NOT NULL AND applicant_race_4 != ''
UNION
SELECT DISTINCT applicant_race_5::INT, applicant_race_name_5
FROM hmda_table
WHERE applicant_race_5 IS NOT NULL AND applicant_race_5 != ''
UNION
SELECT DISTINCT co_applicant_race_1::INT, co_applicant_race_name_1
FROM hmda_table
WHERE co_applicant_race_1 IS NOT NULL AND co_applicant_race_1 != ''
UNION
SELECT DISTINCT co_applicant_race_2::INT, co_applicant_race_name_2
FROM hmda_table
WHERE co_applicant_race_2 IS NOT NULL AND co_applicant_race_2 != ''
UNION
SELECT DISTINCT co_applicant_race_3::INT, co_applicant_race_name_3
FROM hmda_table
WHERE co_applicant_race_3 IS NOT NULL AND co_applicant_race_3 != ''
UNION
SELECT DISTINCT co_applicant_race_4::INT, co_applicant_race_name_4
FROM hmda_table
WHERE co_applicant_race_4 IS NOT NULL AND co_applicant_race_4 != ''
UNION
SELECT DISTINCT co_applicant_race_5::INT, co_applicant_race_name_5
FROM hmda_table
WHERE co_applicant_race_5 IS NOT NULL AND co_applicant_race_5 != '';

CREATE TABLE Application_information.applicant_race(
applicant_id INT,
race_code INT,
race_number INT, 
PRIMARY KEY (applicant_id, race_number), -- allows multiple race for one applicant
FOREIGN KEY (race_code) REFERENCES Application_information.race(race_code)
);

INSERT INTO Application_information.applicant_race(applicant_id, race_code, race_number)
SELECT ID, applicant_race_1::INT, 1 FROM hmda_table WHERE applicant_race_1 IS NOT NULL AND applicant_race_1 != ''
UNION ALL
SELECT ID, applicant_race_2::INT, 2 FROM hmda_table WHERE applicant_race_2 IS NOT NULL AND applicant_race_2 != ''
UNION ALL
SELECT ID, applicant_race_3::INT, 3 FROM hmda_table WHERE applicant_race_3 IS NOT NULL AND applicant_race_3 != ''
UNION ALL
SELECT ID, applicant_race_4::INT, 4 FROM hmda_table WHERE applicant_race_4 IS NOT NULL AND applicant_race_4 != ''
UNION ALL
SELECT ID, applicant_race_5::INT, 5 FROM hmda_table WHERE applicant_race_5 IS NOT NULL AND applicant_race_5 != '';

CREATE TABLE Application_information.co_applicant_race(
applicant_id INT,
race_code INT,
race_number INT, 
PRIMARY KEY (applicant_id, race_number),     
FOREIGN KEY (race_code) REFERENCES Application_information.race(race_code)
);

INSERT INTO Application_information.co_applicant_race(applicant_id, race_code, race_number)
SELECT ID, co_applicant_race_1::INT, 1 FROM hmda_table WHERE co_applicant_race_1 IS NOT NULL AND co_applicant_race_1 != ''
UNION ALL
SELECT ID, co_applicant_race_2::INT, 2 FROM hmda_table WHERE co_applicant_race_2 IS NOT NULL AND co_applicant_race_2 != ''
UNION ALL
SELECT ID, co_applicant_race_3::INT, 3 FROM hmda_table WHERE co_applicant_race_3 IS NOT NULL AND co_applicant_race_3 != ''
UNION ALL
SELECT ID, co_applicant_race_4::INT, 4 FROM hmda_table WHERE co_applicant_race_4 IS NOT NULL AND co_applicant_race_4 != ''
UNION ALL
SELECT ID, co_applicant_race_5::INT, 5 FROM hmda_table WHERE co_applicant_race_5 IS NOT NULL AND co_applicant_race_5 != '';



CREATE TABLE Application_information.applicant_sex(
Applicant_sex INT PRIMARY KEY,
Applicant_sex_name TEXT
);

CREATE TABLE Application_information.co_applicant_sex(
Co_applicant_sex INT PRIMARY KEY,
Co_applicant_sex_name TEXT
);



CREATE SCHEMA Purchaser_and_denial_information;

CREATE TABLE Purchaser_and_denial_information.type(
Purchaser_type INT PRIMARY KEY,
Purchaser_type_name TEXT
);

CREATE TABLE Purchaser_and_denial_information.denial_reason_1(
Denial_reason_1 INT PRIMARY KEY,
Denial_reason_1_name TEXT
); 

CREATE TABLE Purchaser_and_denial_information.denial_reason_2(
Denial_reason_2 INT PRIMARY KEY,
Denial_reason_2_name TEXT
);

CREATE TABLE Purchaser_and_denial_information.denial_reason_3(
Denial_reason_3 INT PRIMARY KEY,
Denial_reason_3_name TEXT
);


CREATE SCHEMA Other;

CREATE TABLE Other.hoepa_status(
Hoepa_status INT PRIMARY KEY,
Hoepa_status_name TEXT
);

CREATE TABLE Other.lien_status(
Lien_status INT PRIMARY KEY,
Lien_status_name TEXT
);


-- ==========================================
-- DATA POPULATION
-- ==========================================

INSERT INTO Respondent_info.agency(agency_code, agency_name, agency_abbr)
SELECT DISTINCT agency_code::INT, agency_name, agency_abbr
FROM hmda_table 
WHERE agency_code IS NOT NULL;

INSERT INTO Respondent_info.edit_status(edit_status, edit_status_name)
SELECT DISTINCT edit_status::INT, edit_status_name
FROM hmda_table
WHERE edit_status IS NOT NULL;

INSERT INTO Property_location.msamd(msamd, msamd_name)
SELECT DISTINCT msamd::INT, msamd_name
FROM hmda_table
WHERE msamd IS NOT NULL;

INSERT INTO Property_location.state(state_code, state_name, state_abbr)
SELECT DISTINCT state_code::INT, state_name, state_abbr
FROM hmda_table
WHERE state_code IS NOT NULL;

INSERT INTO Property_location.county_code(county_code, county_name, state_code)
SELECT DISTINCT county_code::INT, county_name, state_code::INT
FROM hmda_table
WHERE county_code IS NOT NULL;

INSERT INTO Property_location.tract(
msamd, state_code, county_code, census_tract_number, population, minority_population, hud_median_family_income, tract_to_msamd_income, number_of_owner_occupied_units, number_of_1_to_4_family_units)
SELECT DISTINCT 
    h.msamd::INT,
    c.state_code, 
    h.county_code::INT, 
    h.census_tract_number, 
    h.population::INT, 
    h.minority_population::DOUBLE PRECISION, 
    h.hud_median_family_income::INT, 
    h.tract_to_msamd_income::DOUBLE PRECISION, 
    h.number_of_owner_occupied_units::INT, 
    h.number_of_1_to_4_family_units::INT
FROM hmda_table h
JOIN Property_location.county_code c ON h.county_code::INT = c.county_code;


INSERT INTO Loan_info.loan_type(Loan_type, Loan_type_name)
SELECT DISTINCT Loan_type::INT, Loan_type_name
FROM hmda_table
WHERE Loan_type IS NOT NULL;

INSERT INTO Loan_info.property(Property_type, Property_type_name)
SELECT DISTINCT Property_type::INT, Property_type_name
FROM hmda_table
WHERE Property_type IS NOT NULL;

INSERT INTO Loan_info.purpose(Loan_purpose, Loan_purpose_name)
SELECT DISTINCT Loan_purpose::INT, Loan_purpose_name
FROM hmda_table
WHERE Loan_purpose IS NOT NULL;

INSERT INTO Loan_info.owner_occupancy(Owner_occupancy, Owner_occupancy_name)
SELECT DISTINCT Owner_occupancy::INT, Owner_occupancy_name
FROM hmda_table
WHERE Owner_occupancy IS NOT NULL;

INSERT INTO Loan_info.preapproval(Preapproval, Preapproval_name)
SELECT DISTINCT Preapproval::INT, Preapproval_name
FROM hmda_table
WHERE Preapproval IS NOT NULL;

INSERT INTO Loan_info.action_taken(Action_taken, Action_taken_name)
SELECT DISTINCT Action_taken::INT, Action_taken_name
FROM hmda_table
WHERE Action_taken IS NOT NULL;

INSERT INTO Application_information.applicant_ethnicity(Applicant_ethnicity, Applicant_ethnicity_name)
SELECT DISTINCT Applicant_ethnicity::INT, Applicant_ethnicity_name
FROM hmda_table
WHERE Applicant_ethnicity IS NOT NULL;

INSERT INTO Application_information.co_applicant_ethnicity(Co_applicant_ethnicity, Co_applicant_ethnicity_name)
SELECT DISTINCT Co_applicant_ethnicity::INT, Co_applicant_ethnicity_name
FROM hmda_table
WHERE Co_applicant_ethnicity IS NOT NULL;

INSERT INTO Application_information.applicant_sex(Applicant_sex, Applicant_sex_name)
SELECT DISTINCT Applicant_sex::INT, Applicant_sex_name
FROM hmda_table
WHERE Applicant_sex IS NOT NULL;

INSERT INTO Application_information.co_applicant_sex(Co_applicant_sex, Co_applicant_sex_name)
SELECT DISTINCT Co_applicant_sex::INT, Co_applicant_sex_name
FROM hmda_table
WHERE Co_applicant_sex IS NOT NULL;

INSERT INTO Purchaser_and_denial_information.type(Purchaser_type, Purchaser_type_name)
SELECT DISTINCT Purchaser_type::INT, Purchaser_type_name
FROM hmda_table
WHERE Purchaser_type IS NOT NULL;

INSERT INTO Purchaser_and_denial_information.denial_reason_1(Denial_reason_1, Denial_reason_1_name)
SELECT DISTINCT Denial_reason_1::INT, Denial_reason_1_name
FROM hmda_table
WHERE Denial_reason_1 IS NOT NULL;

INSERT INTO Purchaser_and_denial_information.denial_reason_2(Denial_reason_2, Denial_reason_2_name)
SELECT DISTINCT Denial_reason_2::INT, Denial_reason_2_name
FROM hmda_table
WHERE Denial_reason_2 IS NOT NULL;

INSERT INTO Purchaser_and_denial_information.denial_reason_3(Denial_reason_3, Denial_reason_3_name)
SELECT DISTINCT Denial_reason_3::INT, Denial_reason_3_name
FROM hmda_table
WHERE Denial_reason_3 IS NOT NULL;

INSERT INTO Other.hoepa_status(Hoepa_status, Hoepa_status_name)
SELECT DISTINCT Hoepa_status::INT, Hoepa_status_name
FROM hmda_table
WHERE Hoepa_status IS NOT NULL;

INSERT INTO Other.lien_status(Lien_status, Lien_status_name)
SELECT DISTINCT Lien_status::INT, Lien_status_name
FROM hmda_table
WHERE Lien_status IS NOT NULL;
 

-- ==========================================
-- MAIN APPLICATION TABLE
-- ==========================================

CREATE TABLE application (
    id INT PRIMARY KEY,
    as_of_year INT,
    respondent_id TEXT,
    agency_code INT REFERENCES Respondent_info.agency(agency_code),
    loan_type INT REFERENCES Loan_info.loan_type(loan_type),
    property_type INT REFERENCES Loan_info.property(property_type),
    loan_purpose INT REFERENCES Loan_info.purpose(loan_purpose),
    owner_occupancy INT REFERENCES Loan_info.owner_occupancy(owner_occupancy),
    loan_amount_000s INT,
    preapproval INT REFERENCES Loan_info.preapproval(preapproval),
    action_taken INT REFERENCES Loan_info.action_taken(action_taken),
    location_id INT REFERENCES Property_location.tract(location_id),
    applicant_ethnicity INT REFERENCES Application_information.applicant_ethnicity(applicant_ethnicity),
    co_applicant_ethnicity INT REFERENCES Application_information.co_applicant_ethnicity(co_applicant_ethnicity),
    applicant_sex INT REFERENCES Application_information.applicant_sex(applicant_sex),
    co_applicant_sex INT REFERENCES Application_information.co_applicant_sex(co_applicant_sex),
    applicant_income_000s INT,
    purchaser_type INT REFERENCES Purchaser_and_denial_information.type(purchaser_type),
    denial_reason_1 INT REFERENCES Purchaser_and_denial_information.denial_reason_1(denial_reason_1),
    denial_reason_2 INT REFERENCES Purchaser_and_denial_information.denial_reason_2(denial_reason_2),
    denial_reason_3 INT REFERENCES Purchaser_and_denial_information.denial_reason_3(denial_reason_3),
    rate_spread TEXT,
    hoepa_status INT REFERENCES Other.hoepa_status(hoepa_status),
    lien_status INT REFERENCES Other.lien_status(lien_status),
    edit_status INT REFERENCES Respondent_info.edit_status(edit_status),
    sequence_number INT,
    application_date_indicator INT
);


-- ==========================================
-- POPULATE MAIN APP TABLE
-- ==========================================

INSERT INTO application(
    id, as_of_year, respondent_id, agency_code, loan_type, property_type,
    loan_purpose, owner_occupancy, loan_amount_000s, preapproval, action_taken,
    location_id, applicant_ethnicity, co_applicant_ethnicity, applicant_sex,
    co_applicant_sex, applicant_income_000s, purchaser_type, denial_reason_1,
    denial_reason_2, denial_reason_3, rate_spread, hoepa_status, lien_status,
    edit_status, sequence_number, application_date_indicator
)
SELECT 
    h.id,
    h.as_of_year::INT,
    h.respondent_id,
    h.agency_code::INT,
    h.loan_type::INT,
    h.property_type::INT,
    h.loan_purpose::INT,
    h.owner_occupancy::INT,
    h.loan_amount_000s::INT,
    h.preapproval::INT,
    h.action_taken::INT,
    t.location_id,
    h.applicant_ethnicity::INT,
    h.co_applicant_ethnicity::INT,
    h.applicant_sex::INT,
    h.co_applicant_sex::INT,
    h.applicant_income_000s::INT,
    h.purchaser_type::INT,
    h.denial_reason_1::INT,
    h.denial_reason_2::INT,
    h.denial_reason_3::INT,
    h.rate_spread,
    h.hoepa_status::INT,
    h.lien_status::INT,
    h.edit_status::INT,
    h.sequence_number::INT,
    h.application_date_indicator::INT
FROM hmda_table h
JOIN Property_location.tract t
    ON h.msamd::INT IS NOT DISTINCT FROM t.msamd
    AND h.county_code::INT = t.county_code
    AND h.census_tract_number IS NOT DISTINCT FROM t.census_tract_number
    AND h.population::INT IS NOT DISTINCT FROM t.population
    AND h.minority_population::DOUBLE PRECISION IS NOT DISTINCT FROM t.minority_population
    AND h.hud_median_family_income::INT IS NOT DISTINCT FROM t.hud_median_family_income
    AND h.tract_to_msamd_income::DOUBLE PRECISION IS NOT DISTINCT FROM t.tract_to_msamd_income
    AND h.number_of_owner_occupied_units::INT IS NOT DISTINCT FROM t.number_of_owner_occupied_units
    AND h.number_of_1_to_4_family_units::INT IS NOT DISTINCT FROM t.number_of_1_to_4_family_units;
