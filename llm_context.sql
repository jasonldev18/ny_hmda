-- SCHEMA: Respondent_info
-- Contains information about the financial institution reporting the mortgage application
CREATE SCHEMA Respondent_info;

-- Government agency that oversees the lender reporting the application
-- agency_code: 1=OCC, 2=FRS, 3=FDIC, 5=NCUA, 7=HUD, 9=CFPB
CREATE TABLE Respondent_info.agency(
agency_code INT PRIMARY KEY,
agency_name TEXT,
agency_abbr TEXT
);

-- Indicates whether the application record passed data validation checks
-- edit_status: NULL=no failures, 5=validity failure, 6=quality failure, 7=both failures
CREATE TABLE Respondent_info.edit_status(
edit_status INT PRIMARY KEY,
edit_status_name TEXT
);

-- SCHEMA: Property_location
-- Contains geographic information about where the property is located
CREATE SCHEMA Property_location;

-- Metropolitan Statistical Area where the property is located (e.g. New York-Newark-Jersey City)
CREATE TABLE Property_location.msamd(
msamd INT PRIMARY KEY,
msamd_name TEXT
);

-- State where the property is located, parent of county
CREATE TABLE Property_location.state(
state_code INT PRIMARY KEY,
state_name TEXT,
state_abbr TEXT
);

-- County where the property is located, belongs to a state
CREATE TABLE Property_location.county_code(
county_code INT PRIMARY KEY,
county_name TEXT,
state_code INT,
CONSTRAINT fk_state_code   
    FOREIGN KEY (state_code)
    REFERENCES Property_location.state(state_code)
);

-- Census tract level neighborhood characteristics for the property location
-- Contains demographic and economic data: population, minority %, median income, housing units
CREATE TABLE Property_location.tract(
location_id SERIAL PRIMARY KEY, 
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

-- SCHEMA: Loan_info
-- Contains information about the loan itself including type, purpose, and outcome
CREATE SCHEMA Loan_info;

-- Type of loan being applied for
-- loan_type: 1=Conventional, 2=FHA-insured, 3=VA-guaranteed, 4=FSA/RHS
CREATE TABLE Loan_info.loan_type(
Loan_type INT PRIMARY KEY,
Loan_type_name TEXT
);

-- Type of property the loan is being used for
-- property_type: 1=One-to-four family dwelling, 2=Manufactured housing, 3=Multifamily dwelling
CREATE TABLE Loan_info.property(
Property_type INT PRIMARY KEY,
Property_type_name TEXT
);

-- Purpose of the loan
-- loan_purpose: 1=Home purchase, 2=Home improvement, 3=Refinancing
CREATE TABLE Loan_info.purpose(
Loan_purpose INT PRIMARY KEY,
Loan_purpose_name TEXT
);

-- Whether the applicant intends to occupy the property as their primary residence
-- owner_occupancy: 1=Owner-occupied, 2=Not owner-occupied, 3=Not applicable
CREATE TABLE Loan_info.owner_occupancy(
Owner_occupancy INT PRIMARY KEY,
Owner_occupancy_name TEXT
);

-- Whether the applicant requested a preapproval before applying
-- preapproval: 1=Preapproval requested, 2=Preapproval not requested, 3=Not applicable
CREATE TABLE Loan_info.preapproval(
Preapproval INT PRIMARY KEY,
Preapproval_name TEXT
);

-- Final outcome/status of the loan application
-- action_taken: 1=Loan originated, 2=Approved but not accepted, 3=Denied, 4=Withdrawn, 5=File closed, 6=Loan purchased, 7=Preapproval denied, 8=Preapproval approved but not accepted
-- Use action_taken_name = 'Application denied by financial institution' to filter for denials
CREATE TABLE Loan_info.action_taken(
Action_taken INT PRIMARY KEY,
Action_taken_name TEXT
);

-- SCHEMA: Application_information
-- Contains demographic information about the applicant and co-applicant
CREATE SCHEMA Application_information;

-- Whether the applicant identifies as Hispanic or Latino
-- applicant_ethnicity: 1=Hispanic or Latino, 2=Not Hispanic or Latino, 3=Information not provided, 4=Not applicable
CREATE TABLE Application_information.applicant_ethnicity(
Applicant_ethnicity INT PRIMARY KEY,
Applicant_ethnicity_name TEXT
);

-- Whether the co-applicant identifies as Hispanic or Latino
-- co_applicant_ethnicity: 1=Hispanic or Latino, 2=Not Hispanic or Latino, 3=Information not provided, 4=Not applicable, 5=No co-applicant
CREATE TABLE Application_information.co_applicant_ethnicity(
Co_applicant_ethnicity INT PRIMARY KEY,
Co_applicant_ethnicity_name TEXT
);

-- Lookup table for race codes used by both applicant and co-applicant
-- race_code: 1=American Indian or Alaska Native, 2=Asian, 3=Black or African American, 4=Native Hawaiian or Other Pacific Islander, 5=White, 6=Information not provided, 7=Not applicable
CREATE TABLE Application_information.race(
race_code INT PRIMARY KEY,
race_name TEXT
);

-- Applicant's race — supports multiple races per applicant via race_number (1-5)
-- JOIN to Application_information.race on race_code to get race name
CREATE TABLE Application_information.applicant_race(
applicant_id INT,
race_code INT,
race_number INT, 
PRIMARY KEY (applicant_id, race_number), 
FOREIGN KEY (race_code) REFERENCES Application_information.race(race_code)
);

-- Co-applicant's race — supports multiple races per co-applicant via race_number (1-5)
-- JOIN to Application_information.race on race_code to get race name
CREATE TABLE Application_information.co_applicant_race(
applicant_id INT,
race_code INT,
race_number INT, 
PRIMARY KEY (applicant_id, race_number),     
FOREIGN KEY (race_code) REFERENCES Application_information.race(race_code)
);

-- Applicant's sex
-- applicant_sex: 1=Male, 2=Female, 3=Information not provided, 4=Not applicable
CREATE TABLE Application_information.applicant_sex(
Applicant_sex INT PRIMARY KEY,
Applicant_sex_name TEXT
);

-- Co-applicant's sex
-- co_applicant_sex: 1=Male, 2=Female, 3=Information not provided, 4=Not applicable, 5=No co-applicant
CREATE TABLE Application_information.co_applicant_sex(
Co_applicant_sex INT PRIMARY KEY,
Co_applicant_sex_name TEXT
);

-- SCHEMA: Purchaser_and_denial_information
-- Contains information about loan purchaser and reasons for denial if applicable
CREATE SCHEMA Purchaser_and_denial_information;

-- Type of entity that purchased the loan after origination
-- purchaser_type: 0=Loan was not sold, 1=Fannie Mae, 2=Ginnie Mae, 3=Freddie Mac, 4=Farmer Mac, 5=Private securitization, 6=Commercial bank, 7=Life insurance/credit union, 8=Affiliate, 9=Other
CREATE TABLE Purchaser_and_denial_information.type(
Purchaser_type INT PRIMARY KEY,
Purchaser_type_name TEXT
);

-- Primary reason for denial (if application was denied)
-- denial_reason: 1=Debt-to-income ratio, 2=Employment history, 3=Credit history, 4=Collateral, 5=Insufficient cash, 6=Unverifiable information, 7=Credit application incomplete, 8=Mortgage insurance denied, 9=Other
CREATE TABLE Purchaser_and_denial_information.denial_reason_1(
Denial_reason_1 INT PRIMARY KEY,
Denial_reason_name_1 TEXT
); 

-- Secondary reason for denial if applicable
CREATE TABLE Purchaser_and_denial_information.denial_reason_2(
Denial_reason_2 INT PRIMARY KEY,
Denial_reason_name_2 TEXT
);

-- Tertiary reason for denial if applicable
CREATE TABLE Purchaser_and_denial_information.denial_reason_3(
Denial_reason_3 INT PRIMARY KEY,
Denial_reason_name_3 TEXT
);

-- SCHEMA: Other
-- Contains additional loan classification information
CREATE SCHEMA Other;

-- Whether the loan is subject to HOEPA (Home Ownership and Equity Protection Act) — high cost loan indicator
-- hoepa_status: 1=HOEPA loan, 2=Not a HOEPA loan
CREATE TABLE Other.hoepa_status(
Hoepa_status INT PRIMARY KEY,
Hoepa_status_name TEXT
);

-- Whether the loan is secured by a lien on the property
-- lien_status: 1=First lien, 2=Second lien, 3=Not secured by lien, 4=Not applicable
CREATE TABLE Other.lien_status(
Lien_status INT PRIMARY KEY,
Lien_status_name TEXT
);

-- MAIN APPLICATION TABLE
-- Central fact table — ties all schemas together, one row per mortgage application
-- Use this table as the base for all queries, joining to lookup tables via foreign keys
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