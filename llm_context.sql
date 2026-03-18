-- SCHEMA: Respodent_info
-- Contains respondent information including agency and edit status
CREATE SCHEMA Respondent_info;

-- contains info on agency overseeing the lender
CREATE TABLE Respondent_info.agency(
agency_code INT PRIMARY KEY,
agency_name TEXT,
agency_abbr TEXT
);

-- info on status of validity check of application
CREATE TABLE Respondent_info.edit_status(
edit_status INT PRIMARY KEY,
edit_status_name TEXT
);

-- SCHEMA: Property location
-- Contains property location information including msamd, state, county, and tract
CREATE SCHEMA Property_location;

-- geographic metro area where the property is located
CREATE TABLE Property_location.msamd(
msamd INT PRIMARY KEY,
msamd_name TEXT
);

-- state where property is located, parent of county
CREATE TABLE Property_location.state(
state_code INT PRIMARY KEY,
state_name TEXT,
state_abbr TEXT
);


-- county of property location, belongs to a state
CREATE TABLE Property_location.county_code(
county_code INT PRIMARY KEY,
county_name TEXT,
state_code INT,
CONSTRAINT fk_state_code   
    FOREIGN KEY (state_code)
    REFERENCES Property_location.state(state_code)
);

-- characteristics of census tract property is located in
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

-- SCHEMA: Loan Info
-- Contains loan type, property, purpose, owner occupancy, preapproval, and action taken info
CREATE SCHEMA Loan_info;

-- type of loan being taken
CREATE TABLE Loan_info.loan_type(
Loan_type INT PRIMARY KEY,
Loan_type_name TEXT
);

-- type of property that loan is being used for
CREATE TABLE Loan_info.property(
Property_type INT PRIMARY KEY,
Property_type_name TEXT
);

-- purpose of loan
CREATE TABLE Loan_info.purpose(
Loan_purpose INT PRIMARY KEY,
Loan_purpose_name TEXT
);

-- status of owner occupany in property
CREATE TABLE Loan_info.owner_occupancy(
Owner_occupancy INT PRIMARY KEY,
Owner_occupancy_name TEXT
);

-- status of preapproval request if applicable
CREATE TABLE Loan_info.preapproval(
Preapproval INT PRIMARY KEY,
Preapproval_name TEXT
);

-- status of loan
CREATE TABLE Loan_info.action_taken(
Action_taken INT PRIMARY KEY,
Action_taken_name TEXT
);

-- SCHEMA: Application information
-- contains info on applicant's and co-applicant's ethnicity, race, and sex
CREATE SCHEMA Application_information;

-- checks if applicant is hispanic or latnio or not applicable
CREATE TABLE Application_information.applicant_ethnicity(
Applicant_ethnicity INT PRIMARY KEY,
Applicant_ethnicity_name TEXT
);

-- checks if co-applicant is hispanic or latnio or not applicable
CREATE TABLE Application_information.co_applicant_ethnicity(
Co_applicant_ethnicity INT PRIMARY KEY,
Co_applicant_ethnicity_name TEXT
);


-- unique race code, links to applicant and coapplicant's race
CREATE TABLE Application_information.race(
race_code INT PRIMARY KEY,
race_name TEXT
);

-- applicant's race info
CREATE TABLE Application_information.applicant_race(
applicant_id INT,
race_code INT,
race_number INT, 
PRIMARY KEY (applicant_id, race_number), 
FOREIGN KEY (race_code) REFERENCES Application_information.race(race_code)
);

-- co-applicant's race info
CREATE TABLE Application_information.co_applicant_race(
applicant_id INT,
race_code INT,
race_number INT, 
PRIMARY KEY (applicant_id, race_number),     
FOREIGN KEY (race_code) REFERENCES Application_information.race(race_code)
);


-- applicant's sex
CREATE TABLE Application_information.applicant_sex(
Applicant_sex INT PRIMARY KEY,
Applicant_sex_name TEXT
);

-- coapplicant's sex
CREATE TABLE Application_information.co_applicant_sex(
Co_applicant_sex INT PRIMARY KEY,
Co_applicant_sex_name TEXT
);


--SCHEMA: Purchaser and Denial Information
-- contains denial information type and reason for denial
CREATE SCHEMA Purchaser_and_denial_information;


-- type of purchaser
CREATE TABLE Purchaser_and_denial_information.type(
Purchaser_type INT PRIMARY KEY,
Purchaser_type_name TEXT
);

-- reason for denial number 1
CREATE TABLE Purchaser_and_denial_information.denial_reason_1(
Denial_reason_1 INT PRIMARY KEY,
Denial_reason_name_1 TEXT
); 

-- reason for denial number 2
CREATE TABLE Purchaser_and_denial_information.denial_reason_2(
Denial_reason_2 INT PRIMARY KEY,
Denial_reason_name_2 TEXT
);

-- reason for denial number 3
CREATE TABLE Purchaser_and_denial_information.denial_reason_3(
Denial_reason_3 INT PRIMARY KEY,
Denial_reason_name_3 TEXT
);


--SCHEMA: Other
-- contains information on HOEPA and Lien status
CREATE SCHEMA Other;

-- checks if it's a HOEPA loan
CREATE TABLE Other.hoepa_status(
Hoepa_status INT PRIMARY KEY,
Hoepa_status_name TEXT
);

-- checks if its secured by a lien
CREATE TABLE Other.lien_status(
Lien_status INT PRIMARY KEY,
Lien_status_name TEXT
);



-- MAIN APPLICATION TABLE
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


