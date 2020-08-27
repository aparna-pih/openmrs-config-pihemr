-- TODO: add (and limit by) HIV program enrollment

SELECT
    pat.patient_id,
    pn.given_name,
    pn.family_name,
    per.gender,
    per.birthdate
FROM patient pat, person per, person_name pn
WHERE pat.patient_id = pn.person_id and pat.patient_id = per.person_id;

