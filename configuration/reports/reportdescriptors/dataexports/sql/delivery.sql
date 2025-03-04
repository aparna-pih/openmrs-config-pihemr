-- set @startDate = '2020-04-27';
-- set @endDate = '2021-04-27';

SET @locale = GLOBAL_PROPERTY_VALUE('default_locale', 'en');

select encounter_type_id into @delivery_note from encounter_type where uuid = '00e5ebb2-90ec-11e8-9eb6-529269fb1459'; 

DROP TEMPORARY TABLE IF EXISTS temp_delivery;
CREATE TEMPORARY TABLE temp_delivery
(
    patient_id            int(11),
    dossierId             varchar(50),
    zlemrid               varchar(50),
    loc_registered        varchar(255), 
    encounter_datetime    datetime,
    encounter_location    varchar(255), 
    encounter_type        varchar(255),                
    provider              varchar(255), 
    encounter_id          int(11),
    delivery_datetime     datetime,
    dystocia              varchar(255),
    prolapsed_cord        varchar(255),
    Postpartum_hemorrhage varchar(10),
    Intrapartum_hemorrhage varchar(10),
    Placental_abruption   varchar(10),
    Placenta_praevia      varchar(10),
    Rupture_of_uterus     varchar(10),
    Other_hemorrhage      varchar(10),
    Other_hemorrhage_details varchar(255),
    late_cord_clamping    varchar(255),
    placenta_delivery     varchar(255),
    AMTSL                 varchar(255),
    Placenta_completeness varchar(255),
    Intact_membranes      varchar(255),   
    Retained_placenta     varchar(255),
    Perineal_laceration   varchar(255),
    Perineal_suture       varchar(255),
    Episiotomy            varchar(255),
    Postpartum_blood_loss varchar(255),
    Transfusion           varchar(255),
    Type_of_delivery      varchar(1000),
    c_section_reasons     varchar(1000),
    other_c_section_reason_details varchar(255),
    Caesarean_hysterectomy varchar(10),
    C_section_with_tubal_ligation varchar(10),
    Malpresentation_of_fetus varchar(10),
    Cephalopelvic_disproportion varchar(10),
    Extreme_premature     varchar(10),
    Very_premature        varchar(10),
    Moderate_to_late_preterm varchar(10),
    Respiratory_distress  varchar(10),
    Birth_asphyxia        varchar(10),
    Acute_fetal_distress  varchar(10),
    Intrauterine_growth_retardation varchar(10),
    Congenital_malformation varchar(10),
    Meconium_aspiration   varchar(10),
    Premature_rupture_of_membranes varchar(10),
    Chorioamnionitis      varchar(10),
    Placental_abnormality varchar(10),
    Hypertension          varchar(10),
    Severe_pre_eclampsia  varchar(10),
    Eclampsia             varchar(10),
    Acute_pulmonary_edema varchar(10),
    Puerperal_infection   varchar(10),
    Victim_of_GBV         varchar(10),
    Herpes_simplex        varchar(10),
    Syphilis              varchar(10),
    Other_STI             varchar(10),
    Other_mother_finding  varchar(10),
    Other_mother_finding_details varchar(255),
    Mental_health_assessment varchar(1000),
    Birth_1_outcome       varchar(255),
    Birth_1_weight        double,
    Birth_1_APGAR         int,
    Birth_1_neonatal_resuscitation varchar(255),
    Birth_1_macerated_fetus varchar(255),
    Birth_2_outcome       varchar(255),
    Birth_2_weight        double,
    Birth_2_APGAR         int,
    Birth_2_neonatal_resuscitation varchar(255),
    Birth_2_macerated_fetus varchar(255),
    Birth_3_outcome       varchar(255),
    Birth_3_weight        double,
    Birth_3_APGAR         int,
    Birth_3_neonatal_resuscitation varchar(255),
    Birth_3_macerated_fetus varchar(255)  ,  
    number_prenatal_visits int,
    referred_by             varchar(1000),
    referred_by_other_details varchar(255),
    nutrition_newborn_counseling varchar(255),
    family_planning_after_delivery varchar(255),
    diagnosis_1             varchar(255),
    diagnosis_1_certainty   varchar(255),
    diagnosis_1_order       varchar(255),
    diagnosis_2             varchar(255),
    diagnosis_2_certainty   varchar(255),
    diagnosis_2_order       varchar(255),
    diagnosis_3             varchar(255),
    diagnosis_3_certainty   varchar(255),
    diagnosis_3_order       varchar(255),
    diagnosis_4             varchar(255),
    diagnosis_4_certainty   varchar(255),
    diagnosis_4_order       varchar(255),
    diagnosis_5             varchar(255),
    diagnosis_5_certainty   varchar(255),
    diagnosis_5_order       varchar(255),
    diagnosis_6             varchar(255),
    diagnosis_6_certainty   varchar(255),
    diagnosis_6_order       varchar(255),
    diagnosis_7             varchar(255),
    diagnosis_7_certainty   varchar(255),
    diagnosis_7_order       varchar(255),
    diagnosis_8             varchar(255),
    diagnosis_8_certainty   varchar(255),
    diagnosis_8_order       varchar(255),
    diagnosis_9             varchar(255),
    diagnosis_9_certainty   varchar(255),
    diagnosis_9_order       varchar(255),
    diagnosis_10            varchar(255),
    diagnosis_10_certainty  varchar(255),
    diagnosis_10_order      varchar(255),
    disposition             varchar(255),
    disposition_comment     varchar(255),
    return_visit_date       datetime
    );

-- insert encounters into temp table
insert into temp_delivery (
  patient_id,
  encounter_id,
  encounter_datetime,
  encounter_type)
select
  patient_id,
  encounter_id,
  encounter_datetime,
  et.name
from encounter e
inner join encounter_type et on et.encounter_type_id = e.encounter_type
where e.encounter_type in (@delivery_note)
AND date(e.encounter_datetime) >=@startDate
AND date(e.encounter_datetime) <=@endDate
and voided = 0
;
-- encounter and demo info
update temp_delivery set zlemrid = zlemr(patient_id);
update temp_delivery set dossierid = dosid(patient_id);
update temp_delivery set loc_registered = loc_registered(patient_id);
update temp_delivery set encounter_location = encounter_location_name(encounter_id);
update temp_delivery set provider = provider(encounter_id);


update temp_delivery set delivery_datetime = obs_value_datetime(encounter_id,'PIH','5599');
update temp_delivery set dystocia = obs_value_coded_list(encounter_id,'CIEL','163449',@locale);
update temp_delivery set prolapsed_cord = obs_value_coded_list(encounter_id,'CIEL','113617',@locale);

-- vaginal hemorrhage details 
update temp_delivery set Postpartum_hemorrhage = obs_single_value_coded(encounter_id, 'PIH','3064','CIEL','230');
update temp_delivery set Intrapartum_hemorrhage = obs_single_value_coded(encounter_id, 'PIH','3064','CIEL','136601');
update temp_delivery set Placental_abruption = obs_single_value_coded(encounter_id, 'PIH','3064','CIEL','130108');
update temp_delivery set Placenta_praevia = obs_single_value_coded(encounter_id, 'PIH','3064','CIEL','114127');
update temp_delivery set Rupture_of_uterus = obs_single_value_coded(encounter_id, 'PIH','3064','CIEL','127259');
update temp_delivery set Other_hemorrhage = obs_single_value_coded(encounter_id, 'PIH','3064','CIEL','150802');
update temp_delivery set Other_hemorrhage_details = obs_from_group_id_comment(obs_group_id_of_coded_answer(encounter_id,'CIEL','150802'), 'PIH','3064');

update temp_delivery set late_cord_clamping = obs_value_coded_list(encounter_id,'CIEL','163450',@locale);
update temp_delivery set placenta_delivery = obs_value_coded_list(encounter_id,'PIH','13550',@locale);
update temp_delivery set AMTSL = obs_value_coded_list(encounter_id,'CIEL','163452',@locale);
update temp_delivery set Placenta_completeness = obs_value_coded_list(encounter_id,'CIEL','163454',@locale);

update temp_delivery set Intact_membranes = obs_value_coded_list(encounter_id,'CIEL','164900',@locale);
update temp_delivery set Retained_placenta = obs_value_coded_list(encounter_id,'CIEL','127592',@locale);
update temp_delivery set Perineal_laceration = obs_value_coded_list(encounter_id,'CIEL','114244',@locale);

update temp_delivery set Perineal_suture = obs_single_value_coded(encounter_id, 'CIEL','1651','CIEL','164157');
update temp_delivery set Episiotomy = obs_single_value_coded(encounter_id, 'CIEL','1651','CIEL','5577');  


update temp_delivery set Postpartum_blood_loss = obs_value_coded_list(encounter_id,'CIEL','162092',@locale);
update temp_delivery set Transfusion = obs_value_coded_list(encounter_id,'CIEL','1063',@locale);

update temp_delivery set Type_of_delivery = obs_value_coded_list(encounter_id,'PIH','11663',@locale);
update temp_delivery set c_section_reasons = obs_value_coded_list(encounter_id,'CIEL','166400',@locale);
update temp_delivery set other_c_section_reason_details = obs_comments(encounter_id,'CIEL','166400', 'CIEL','5622');

update temp_delivery set Caesarean_hysterectomy = obs_single_value_coded(encounter_id, 'CIEL','1651','CIEL','161848');  
update temp_delivery set C_section_with_tubal_ligation = obs_single_value_coded(encounter_id, 'CIEL','1651','CIEL','161890');

-- findings for baby
update temp_delivery set Malpresentation_of_fetus = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','115939');  
update temp_delivery set Cephalopelvic_disproportion = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','145935');  
update temp_delivery set Extreme_premature = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','111523');  
update temp_delivery set Very_premature = obs_single_value_coded(encounter_id, 'CIEL','1284','PIH','11789');  
update temp_delivery set Moderate_to_late_preterm = obs_single_value_coded(encounter_id, 'CIEL','1284','PIH','11790');  
update temp_delivery set Respiratory_distress = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','127639');  
update temp_delivery set Birth_asphyxia = obs_single_value_coded(encounter_id, 'CIEL','1284','PIH','7557');  
update temp_delivery set Acute_fetal_distress = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','118256');  
update temp_delivery set Intrauterine_growth_retardation = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','118245');  
update temp_delivery set Congenital_malformation = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','143849');  
update temp_delivery set Meconium_aspiration = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','115866');  

-- findings for mother
update temp_delivery set Premature_rupture_of_membranes = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','129211');  
update temp_delivery set Chorioamnionitis = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','145548');  
update temp_delivery set Placental_abnormality = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','130109');  
update temp_delivery set Hypertension = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','117399');  
update temp_delivery set Severe_pre_eclampsia = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','113006');  
update temp_delivery set Eclampsia = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','118744');  
update temp_delivery set Acute_pulmonary_edema = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','121856');  
update temp_delivery set Puerperal_infection = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','130');  
update temp_delivery set Victim_of_GBV = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','165088');  
update temp_delivery set Herpes_simplex = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','138706');  
update temp_delivery set Syphilis = obs_single_value_coded(encounter_id, 'CIEL','1284','CIEL','112493');  
update temp_delivery set Other_STI = obs_single_value_coded(encounter_id, 'PIH','6644','CIEL','112992');  
update temp_delivery set Other_mother_finding = obs_single_value_coded(encounter_id, 'PIH','6644','CIEL','5622');  
update temp_delivery set Other_mother_finding_details = obs_comments(encounter_id, 'PIH','6644','CIEL','5622');  

update temp_delivery set Mental_health_assessment = obs_value_coded_list(encounter_id,'PIH','10594',@locale);

-- birth details (1 to 3)
update temp_delivery set Birth_1_outcome = obs_from_group_id_value_coded_list(obs_id(encounter_id,'CIEL','1585', 0),'CIEL','161033',@locale);
update temp_delivery set Birth_1_weight = obs_from_group_id_value_numeric(obs_id(encounter_id,'CIEL','1585', 0),'CIEL','5916');
update temp_delivery set Birth_1_APGAR = obs_from_group_id_value_numeric(obs_id(encounter_id,'CIEL','1585', 0),'CIEL','1504');
update temp_delivery set Birth_1_neonatal_resuscitation = obs_from_group_id_value_coded_list(obs_id(encounter_id,'CIEL','1585', 0),'CIEL','162131',@locale);
update temp_delivery set Birth_1_macerated_fetus = obs_from_group_id_value_coded_list(obs_id(encounter_id,'CIEL','1585', 0),'CIEL','135437',@locale);

update temp_delivery set Birth_2_outcome = obs_from_group_id_value_coded_list(obs_id(encounter_id,'CIEL','1585', 1),'CIEL','161033',@locale);
update temp_delivery set Birth_2_weight = obs_from_group_id_value_numeric(obs_id(encounter_id,'CIEL','1585', 1),'CIEL','5916');
update temp_delivery set Birth_2_APGAR = obs_from_group_id_value_numeric(obs_id(encounter_id,'CIEL','1585', 1),'CIEL','1504');
update temp_delivery set Birth_2_neonatal_resuscitation = obs_from_group_id_value_coded_list(obs_id(encounter_id,'CIEL','1585', 1),'CIEL','162131',@locale);
update temp_delivery set Birth_2_macerated_fetus = obs_from_group_id_value_coded_list(obs_id(encounter_id,'CIEL','1585', 1),'CIEL','135437',@locale);

update temp_delivery set Birth_3_outcome = obs_from_group_id_value_coded_list(obs_id(encounter_id,'CIEL','1585', 2),'CIEL','161033',@locale);
update temp_delivery set Birth_3_weight = obs_from_group_id_value_numeric(obs_id(encounter_id,'CIEL','1585', 2),'CIEL','5916');
update temp_delivery set Birth_3_APGAR = obs_from_group_id_value_numeric(obs_id(encounter_id,'CIEL','1585', 2),'CIEL','1504');
update temp_delivery set Birth_3_neonatal_resuscitation = obs_from_group_id_value_coded_list(obs_id(encounter_id,'CIEL','1585', 2),'CIEL','162131',@locale);
update temp_delivery set Birth_3_macerated_fetus = obs_from_group_id_value_coded_list(obs_id(encounter_id,'CIEL','1585', 2),'CIEL','135437',@locale);


update temp_delivery set number_prenatal_visits = obs_value_numeric(encounter_id,'CIEL','1590');
update temp_delivery set referred_by = obs_value_coded_list(encounter_id,'PIH','10635',@locale);
update temp_delivery set referred_by_other_details = obs_comments(encounter_id, 'PIH','10635','CIEL','5622');
update temp_delivery set nutrition_newborn_counseling = obs_value_coded_list(encounter_id,'CIEL','161651',@locale);
update temp_delivery set family_planning_after_delivery = obs_value_coded_list(encounter_id,'PIH','13564',@locale);

-- diagnoses
update temp_delivery t set diagnosis_1 =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',0),'PIH','3064',@locale);
update temp_delivery t set diagnosis_1_certainty =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',0),'PIH','1379',@locale);
update temp_delivery t set diagnosis_1_order =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',0),'PIH','7537',@locale);

update temp_delivery t set diagnosis_2 =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',1),'PIH','3064',@locale);
update temp_delivery t set diagnosis_2_certainty =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',1),'PIH','1379',@locale);
update temp_delivery t set diagnosis_2_order =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',1),'PIH','7537',@locale);

update temp_delivery t set diagnosis_3 =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',2),'PIH','3064',@locale);
update temp_delivery t set diagnosis_3_certainty =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',2),'PIH','1379',@locale);
update temp_delivery t set diagnosis_3_order =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',2),'PIH','7537',@locale);

update temp_delivery t set diagnosis_4 =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',3),'PIH','3064',@locale);
update temp_delivery t set diagnosis_4_certainty =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',3),'PIH','1379',@locale);
update temp_delivery t set diagnosis_4_order =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',3),'PIH','7537',@locale);

update temp_delivery t set diagnosis_5 =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',4),'PIH','3064',@locale);
update temp_delivery t set diagnosis_5_certainty =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',4),'PIH','1379',@locale);
update temp_delivery t set diagnosis_5_order =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',4),'PIH','7537',@locale);

update temp_delivery t set diagnosis_6 =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',5),'PIH','3064',@locale);
update temp_delivery t set diagnosis_6_certainty =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',5),'PIH','1379',@locale);
update temp_delivery t set diagnosis_6_order =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',5),'PIH','7537',@locale);

update temp_delivery t set diagnosis_7 =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',6),'PIH','3064',@locale);
update temp_delivery t set diagnosis_7_certainty =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',6),'PIH','1379',@locale);
update temp_delivery t set diagnosis_7_order =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',6),'PIH','7537',@locale);

update temp_delivery t set diagnosis_8 =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',7),'PIH','3064',@locale);
update temp_delivery t set diagnosis_8_certainty =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',7),'PIH','1379',@locale);
update temp_delivery t set diagnosis_8_order =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',7),'PIH','7537',@locale);

update temp_delivery t set diagnosis_9 =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',8),'PIH','3064',@locale);
update temp_delivery t set diagnosis_9_certainty =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',8),'PIH','1379',@locale);
update temp_delivery t set diagnosis_9_order =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',8),'PIH','7537',@locale);

update temp_delivery t set diagnosis_10 =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',9),'PIH','3064',@locale);
update temp_delivery t set diagnosis_10_certainty =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',9),'PIH','1379',@locale);
update temp_delivery t set diagnosis_10_order =obs_from_group_id_value_coded_list(obs_id(t.encounter_id,'PIH','7539',9),'PIH','7537',@locale);

-- disposition info
update temp_delivery set disposition = obs_value_coded_list(encounter_id,'PIH','8620',@locale);
update temp_delivery set disposition_comment = obs_value_text(encounter_id,'PIH','DISPOSITION COMMENTS');
update temp_delivery set return_visit_date = obs_value_datetime(encounter_id,'PIH','5096');

-- select final output
select * from temp_delivery;
