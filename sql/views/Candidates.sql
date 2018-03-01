CREATE MATERIALIZED VIEW candidates
AS
  SELECT
    id,
    id as ocd_id,
    lastname as last_name,
    firstname as first_name,
    address1 as address_1,
    address2 as address_2,
    city as city,
    state as state,
    zip as zipcode,
    office as office,
    districttype as district_type,
    district as district,
    residencecounty as residence_county,
    partyaffiliation as party,
    redactionrequested as redaction_requested
  FROM raw.candidates
WITH DATA;
