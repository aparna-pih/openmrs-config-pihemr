CREATE TABLE mch_pregnancy
(
pregnancy_id                    INT,
encounter_id                    INT,
patient_id                      INT,
emr_id                          VARCHAR(25),
encounter_date                  DATE,
gravidity                       INT,
parity                          INT,
num_abortions                   INT,
num_living_children             INT,
last_period_date                DATE,
expected_delivery_date          DATE,
calculated_gestational_age      FLOAT,
pregnancy_1_birth_order         INT,
pregnancy_1_delivery_type       VARCHAR(150),
pregnancy_1_outcome             TEXT,
pregnancy_2_birth_order         INT,
pregnancy_2_delivery_type       VARCHAR(150),
pregnancy_2_outcome             TEXT,
pregnancy_3_birth_order         INT,
pregnancy_3_delivery_type       VARCHAR(150),
pregnancy_3_outcome             TEXT,
pregnancy_4_birth_order         INT,
pregnancy_4_delivery_type       VARCHAR(150),
pregnancy_4_outcome             TEXT,
pregnancy_5_birth_order         INT,
pregnancy_5_delivery_type       VARCHAR(150),
pregnancy_5_outcome             TEXT,
pregnancy_6_birth_order         INT,
pregnancy_6_delivery_type       VARCHAR(150),
pregnancy_6_outcome             TEXT,
pregnancy_7_birth_order         INT,
pregnancy_7_delivery_type       VARCHAR(150),
pregnancy_7_outcome             TEXT,
pregnancy_8_birth_order         INT,
pregnancy_8_delivery_type       VARCHAR(150),
pregnancy_8_outcome             TEXT,
pregnancy_9_birth_order         INT,
pregnancy_9_delivery_type       VARCHAR(150),
pregnancy_9_outcome             TEXT,
pregnancy_10_birth_order        INT,
pregnancy_10_delivery_type      VARCHAR(150),
pregnancy_10_outcome            TEXT,
pmtct_club                      VARCHAR(5),
delivery_location_plan          VARCHAR(15)
);
