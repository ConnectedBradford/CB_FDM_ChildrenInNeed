#Stage one
CREATE TABLE `yhcr-prd-phm-bia-core.CB_FDM_ChildrenInNeed.EventdatesValid`
AS
SELECT
 a.person_id,
 b.birth_datetime,
 b.death_datetime,
 a.observation_period_start_date,
 a.observation_period_end_date,
FROM `yhcr-prd-phm-bia-core.CB_FDM_ChildrenInNeed.observation_period` a,
`yhcr-prd-phm-bia-core.CB_FDM_ChildrenInNeed.person`b
where a.person_id = b.person_id
and b.death_datetime is not null
and a.observation_period_start_date >= b.birth_datetime
and a.observation_period_start_date <= date_add(b.death_datetime, INTERVAL 42 day)
and a.observation_period_end_date <= date_add(b.death_datetime, INTERVAL 42 day)
and  a.observation_period_start_date <= (select extract_date from `yhcr-prd-phm-bia-core.CB_LOOKUPS.tbl_Dataset_ExtractDateRef` where DatasetName = 'Children in Need')
and  a.observation_period_end_date <= (select extract_date from `yhcr-prd-phm-bia-core.CB_LOOKUPS.tbl_Dataset_ExtractDateRef` where DatasetName = 'Children in Need');

# Stage two
INSERT INTO `yhcr-prd-phm-bia-core.CB_FDM_ChildrenInNeed.EventdatesValid`
SELECT DISTINCT a.person_id,
 b.birth_datetime,
 b.death_datetime,
 a.observation_period_start_date,
 a.observation_period_end_date,
 FROM `yhcr-prd-phm-bia-core.CB_FDM_ChildrenInNeed.observation_period` a,
`yhcr-prd-phm-bia-core.CB_FDM_ChildrenInNeed.person`b
where a.person_id = b.person_id
and b.death_datetime is null
and a.observation_period_start_date >= b.birth_datetime
and  a.observation_period_start_date <= (select extract_date from `yhcr-prd-phm-bia-core.CB_LOOKUPS.tbl_Dataset_ExtractDateRef` where DatasetName = 'Children in Need')
and  a.observation_period_end_date <= (select extract_date from `yhcr-prd-phm-bia-core.CB_LOOKUPS.tbl_Dataset_ExtractDateRef` where DatasetName = 'Children in Need');

# Stage three (deleted rather than replaced observation_period table as there was no obsevration_period_id or type_concept)

# Stage four
Recreate person table bu joinin to new obs table
