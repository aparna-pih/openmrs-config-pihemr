CREATE TABLE ovc_program_encounters
(
    person_id,
	emr_id,
	patient_program_id,
	location,
	encounter_id,
	encounter_date,
	ovc_program_enrollment_date,
	ovc_program_completion_date,
	program_status_start_date,
	program_status_end_date,
	program_status,
	program_outcome,
	hiv_test_date,
	hiv_status,
	services,
	other_services,
	index_asc_hiv_status,
	index_desc_hiv_status,
	index_asc_program_status,
	index_desc_program_status,
	index_asc_enrollment,
	index_desc_enrollment
);