DROP TABLE IF EXISTS hmda_table;

CREATE TABLE hmda_table (
    as_of_year    VARCHAR(150),
    respondent_id    VARCHAR(150),
    agency_name    VARCHAR(150),
    agency_abbr    VARCHAR(150),
    agency_code   INT,
    loan_type_name    VARCHAR(150),
    loan_type    INT,
    property_type_name       VARCHAR(150),
    property_type   INT,
    loan_purpose_name   VARCHAR(150),
    loan_purpose   INT,
    owner_occupancy_name   VARCHAR(150),
    owner_occupancy   INT,
    loan_amount_000s   INT,
    preapproval_name   VARCHAR(150),
    preapproval   INT,
    action_taken_name         VARCHAR(150),
    action_taken     INT,
    msamd_name   VARCHAR(150),
    msamd   INT,
    state_name   VARCHAR(150),
    state_abbr   VARCHAR(150),
    state_code   INT,
    county_name   VARCHAR(150),
    county_code   INT,
    census_tract_number   INT,
    applicant_ethnicity_name   VARCHAR(150),
    applicant_ethnicity   INT,
    co_applicant_ethnicity_name   VARCHAR(150),
    co_applicant_ethnicity  INT,
    applicant_race_name_1   VARCHAR(150),
    applicant_race_1   VARCHAR(150),
    applicant_race_name_   VARCHAR(150),
    applicant_race_   VARCHAR(150),
    applicant_race_name_3   VARCHAR(150),
    applicant_race_3      VARCHAR(150),
    applicant_race_name_4  VARCHAR(150),
    applicant_race_4      VARCHAR(150),
    applicant_race_name_5         VARCHAR(150),
    applicant_race_5      VARCHAR(150),
    co_applicant_race_name_1      VARCHAR(150),
    co_applicant_race_1   VARCHAR(150),
    co_applicant_race_name_      VARCHAR(150),
    co_applicant_race_   VARCHAR(150),
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
    denial_reason_name_  VARCHAR(150),
    denial_reason_  VARCHAR(150),
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
    application_date_indicator  VARCHAR(150),
);

\copy FROM '/common/home/jl3086/hmdaproj/hmda_2017_ny_all-records_labels.csv' DELIMITER ',' CSV HEADER;
ALTER TABLE hmda_table
ADD COLUMN ID SERIAL PRIMARY KEY; -- serial auto increments, primary key enforces not null and uniqueness


-- Creating the tables based on normalized relations
CREATE SCHEMA Respondent_info;

CREATE TABLE Respondent_info.agency(
agency_code INT PRIMARY KEY,
agency_name TEXT,
agency_abbr TEXT
);

CREATE TABLE Respondent_info.edit_status(
edit_status INT PRIMARY KEY,
edit_status_name TEXT
)


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
)

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

CREATE TABLE Application_information.race (
Applicant_race INT PRIMARY KEY,
Applicant_race_name TEXT
);


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
