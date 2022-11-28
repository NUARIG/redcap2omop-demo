## redcap2omop Demo Project

## Prerequisites

* ruby 3.0.0
* [Bundler](https://bundler.io/)
* PostgreSQL

## Configuration

| Config file | Expected file location | Content |
|------|------------------------|---------|
|**secrets.yml**| config/secrets.yml | URL to REDCap server|

## Setup

Install required gems and set up database
```bash
$ bundle install
```
## Setup the Demo REDCap project

Find the data dictionary for the demo REDCap project in 'lib/setup/data/REDCap2SQLSandbox2Longitudinal_DataDictionary_2022-11-27.csv'
Use REDCap functionality to import.

Find the instrument mappings for REDCap project in 'lib/setup/data/REDCap2SQLSandbox2Longitudinal_DataDictionary_2022-11-27.csv'
Use REDCap functionality to import.

Mark repeatable instruments 'lib/setup/data/ Repeatable instruments and events.png'
Use REDCap functionality to set in the design UI.

Find the data for the demo REDCap project in 'lib/setup/data/REDCap2SQLSandbox2Longitudinal_DataDictionary_2022-11-27.csv'
Use REDCap functionality to import.

### Create Database

```sql
CREATE DATABASE redcap2omop_demo
CREATE USER redcap2omop_demo WITH CREATEDB PASSWORD 'redcap2omop_demo'
ALTER DATABASE redcap2omop_demo OWNER TO redcap2omop_demo
ALTER USER redcap2omop_demo SUPERUSER
```
### Install redcap2omp

The application allows to import REDcap data and map it to [OMOP](https://www.ohdsi.org/data-standardization/the-common-data-model/) structures for data analysis. 
In order to set it up, run the initializer (note: this has already been done for this repository but is here for documentation purposes):
```bash
$ rails g redcap2omop:install
```
### Load the OMOP Vocabulary Tables

Download the latest OMOP vocabulary distribution from http://athena.ohdsi.org
Unzip and copy the vocabulary to /db/migrate/CommonDataModel-5.3.1/PostgreSQL/VocabImport
```bash
$ bundle exec rake redcap2omop:data:load_omop_vocabulary_tables
$ bundle exec rake redcap2omop:data:compile_omop_vocabulary_indexes
```
### Setup redcap2omp metadata for the OMOP tables

```bash
$ bundle exec rake redcap2omop:setup:omop_tables
```
### Setup the REDCap project

```sql
select count(*)
from redcap2omop_redcap_projects
```

Make sure to replace '?' with 

```bash
$ REDCAP2_OMOP_API_TOKEN='?' bundle exec rake redcap2omop:setup:demo:project
```

```sql
select *
from redcap2omop_redcap_projects
```
### Import REDCap Data Dictionary

```sql
select 'redcap2omop_redcap_data_dictionaries' as entity
      , count(*) as total
from redcap2omop_redcap_data_dictionaries
union
select 'redcap2omop_redcap_variables' as entity
      , count(*) as total
from redcap2omop_redcap_variables
union
select 'redcap2omop_redcap_variable_choices' as entity
    , count(*) as total
from redcap2omop_redcap_variable_choices
```

```bash
$ bundle exec rake redcap2omop:ingest:data_dictionary:from_redcap
```

```sql
select 'redcap2omop_redcap_data_dictionaries' as entity
      , count(*) as total
from redcap2omop_redcap_data_dictionaries
union
select 'redcap2omop_redcap_variables' as entity
      , count(*) as total
from redcap2omop_redcap_variables
union
select 'redcap2omop_redcap_variable_choices' as entity
    , count(*) as total
from redcap2omop_redcap_variable_choices
order by total ASC
```
### Setup maps

```sql
SELECT  rv.form_name
      , rv.name                   AS variable_name
      , rv.field_label            AS varaible_description
      , rv.field_type_normalized  AS field_type
      , rv.text_validation_type
      , rv.curation_status        AS variable_curation_status
      , rrvm.map_type             AS variable_map_type
      , rot.name                  AS variable_mapped_omop_table
      , roc.name                  AS variable_mapped_omop_column
      , c1.domain_id              AS variable_map_concept_domain_id
      , c1.vocabulary_id          AS variable_map_concept_vocabulary_id
      , c1.concept_name           AS variable_map_concept_name
      , c1.concept_code           AS variable_map_concept_code
      , c1.concept_id             AS variable_map_concept_id
      , c1.standard_concept       AS variable_map_concept_standard_concept
      , rvc.curation_status       AS variable_choice_curation_status
      , rvc.choice_code_raw       AS variable_choice_code
      , rvc.choice_description    AS variable_choice_description
      , rvcm.map_type             AS variable_choice_map_type
      , c2.domain_id              AS variable_choice_map_concept_domain_id
      , c2.vocabulary_id          AS variable_choice_map_concept_vocabulary_id
      , c2.concept_name           AS variable_choice_map_concept_name
      , c2.concept_code           AS variable_choice_map_concept_code
      , c2.concept_id             AS variable_choice_map_concept_id
      , c2.standard_concept       AS variable_choice_map_concept_standard_concept
	  , rdd.version
FROM redcap2omop_redcap_variables rv  LEFT JOIN redcap2omop_redcap_variable_maps rrvm         ON rrvm.redcap_variable_id       = rv.id
                                      LEFT JOIN redcap2omop_omop_columns roc                  ON rrvm.omop_column_id           = roc.id
                                      LEFT JOIN redcap2omop_omop_tables rot                   ON roc.omop_table_id             = rot.id
                                      LEFT JOIN concept c1                                    ON rrvm.concept_id               = c1.concept_id
                                      LEFT JOIN redcap2omop_redcap_variable_choices rvc       ON rv.id                         = rvc.redcap_variable_id
                                      LEFT JOIN redcap2omop_redcap_variable_choice_maps rvcm  ON rvc.id                        = rvcm.redcap_variable_choice_id
                                      LEFT JOIN concept c2                                    ON rvcm.concept_id               = c2.concept_id
                                      JOIN redcap2omop_redcap_data_dictionaries rdd           ON rv.redcap_data_dictionary_id  = rdd.id
                                      JOIN redcap2omop_redcap_projects rp                     ON rdd.redcap_project_id         = rp.id
ORDER BY rv.form_name, rv.id
```

```bash
$ bundle exec rake redcap2omop:setup:demo:maps
```

```sql
SELECT  rv.form_name
      , rv.name                   AS variable_name
      , rv.field_label            AS varaible_description
      , rv.field_type_normalized  AS field_type
      , rv.text_validation_type
      , rv.curation_status        AS variable_curation_status
      , rrvm.map_type             AS variable_map_type
      , rot.name                  AS variable_mapped_omop_table
      , roc.name                  AS variable_mapped_omop_column
      , c1.domain_id              AS variable_map_concept_domain_id
      , c1.vocabulary_id          AS variable_map_concept_vocabulary_id
      , c1.concept_name           AS variable_map_concept_name
      , c1.concept_code           AS variable_map_concept_code
      , c1.concept_id             AS variable_map_concept_id
      , c1.standard_concept       AS variable_map_concept_standard_concept
      , rvc.curation_status       AS variable_choice_curation_status
      , rvc.choice_code_raw       AS variable_choice_code
      , rvc.choice_description    AS variable_choice_description
      , rvc.curation_status       AS variable_choice_curation_status
      , rvcm.map_type             AS variable_choice_map_type
      , c2.domain_id              AS variable_choice_map_concept_domain_id
      , c2.vocabulary_id          AS variable_choice_map_concept_vocabulary_id
      , c2.concept_name           AS variable_choice_map_concept_name
      , c2.concept_code           AS variable_choice_map_concept_code
      , c2.concept_id             AS variable_choice_map_concept_id
      , c2.standard_concept       AS variable_choice_map_concept_standard_concept
	    , rdd.version
FROM redcap2omop_redcap_variables rv  LEFT JOIN redcap2omop_redcap_variable_maps rrvm         ON rrvm.redcap_variable_id       = rv.id
                                      LEFT JOIN redcap2omop_omop_columns roc                  ON rrvm.omop_column_id           = roc.id
                                      LEFT JOIN redcap2omop_omop_tables rot                   ON roc.omop_table_id             = rot.id
                                      LEFT JOIN concept c1                                    ON rrvm.concept_id               = c1.concept_id
                                      LEFT JOIN redcap2omop_redcap_variable_choices rvc       ON rv.id                         = rvc.redcap_variable_id
                                      LEFT JOIN redcap2omop_redcap_variable_choice_maps rvcm  ON rvc.id                        = rvcm.redcap_variable_choice_id
                                      LEFT JOIN concept c2                                    ON rvcm.concept_id               = c2.concept_id
                                      JOIN redcap2omop_redcap_data_dictionaries rdd           ON rv.redcap_data_dictionary_id  = rdd.id
                                      JOIN redcap2omop_redcap_projects rp                     ON rdd.redcap_project_id         = rp.id

WHERE rdd.version = 1
AND rv.curation_status  = 'mapped'
ORDER BY rv.form_name, rv.id
```
### Import REDCap data

```sql
select count(*)
from redcap_records_tmp_1
```

```bash
$ bundle exec rake redcap2omop:ingest:data
```

```sql
select *
from redcap_records_tmp_1
```
### Execute REDCap2OMOP ETL 

```sql
select 'person' as entity
      , count(*) as total
from person
union
select  'provider' as entity
      , count(*) as total
from provider
union
select 'condition_occurrence' as entity
      , count(*) as total
from condition_occurrence
union
select  'drug_exposure'
      , count(*) as total
from drug_exposure
union
select 'measurement' as entity
      , count(*) as total
from measurement
```

```bash
$ bundle exec rake redcap2omop:ingest:redcap2omop
```

```sql
select *
from person

select *
from provider

select  p.person_source_value
      , rp.name
      , rv.name
      , c1.concept_name
      , co.condition_start_date
      , co.condition_source_value
      , pr.provider_source_value
from condition_occurrence co left join concept c1 on co.condition_concept_id = c1.concept_id
                             join redcap2omop_redcap_source_links rsl on co.condition_occurrence_id = rsl.redcap_sourced_id and rsl.redcap_sourced_type = 'Redcap2omop::ConditionOccurrence'
                             join redcap2omop_redcap_variables rv on rv.id = rsl.redcap_source_id
                             join redcap2omop_redcap_data_dictionaries rdd on rv.redcap_data_dictionary_id = rdd.id
                             join redcap2omop_redcap_projects rp on rdd.redcap_project_id = rp.id
                             join person p on co.person_id = p.person_id
                             left join provider pr on co.provider_id = pr.provider_id

select  p.person_source_value
      , rp.name
      , rv.name
      , c1.concept_name
      , de.drug_exposure_start_date
      , de.drug_exposure_end_date
      , de.drug_source_value
from drug_exposure de left join concept c1 on de.drug_concept_id = c1.concept_id
                             join redcap2omop_redcap_source_links rsl on de.drug_exposure_id = rsl.redcap_sourced_id and rsl.redcap_sourced_type = 'Redcap2omop::DrugExposure'
                             join redcap2omop_redcap_variables rv on rv.id = rsl.redcap_source_id
                             join redcap2omop_redcap_data_dictionaries rdd on rv.redcap_data_dictionary_id = rdd.id
                             join redcap2omop_redcap_projects rp on rdd.redcap_project_id = rp.id
                             join person p on de.person_id = p.person_id

select   p.person_source_value
       , rp.name
       , rv.name
       , c1.concept_name
       , m.value_as_number
       , m.value_as_concept_id
       , c2.concept_name
       , m.measurement_source_value
       , pr.provider_source_value
from measurement m left join concept c1 on m.measurement_concept_id = c1.concept_id
                   left join concept c2 on m.value_as_concept_id = c2.concept_id
                   join redcap2omop_redcap_source_links rsl on m.measurement_id = rsl.redcap_sourced_id and rsl.redcap_sourced_type = 'Redcap2omop::Measurement'
                   join redcap2omop_redcap_variables rv on rv.id = rsl.redcap_source_id
                   join redcap2omop_redcap_data_dictionaries rdd on rv.redcap_data_dictionary_id = rdd.id
                   join redcap2omop_redcap_projects rp on rdd.redcap_project_id = rp.id
                   join person p on m.person_id = p.person_id
                   left join provider pr on m.provider_id = pr.provider_id

```