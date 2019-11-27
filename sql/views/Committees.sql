CREATE TABLE public.committees
AS
  SELECT
    id as id,
    typeofcommittee as type,
    statecommittee as state_committee,
    stateid as state_id,
    localcommittee as local_committee,
    localid as local_id,
    refername as refer_name,
    name as name,
    address1 as address1,
    address2 as address2,
    address3 as address3,
    city as city,
    state as state,
    zip as zipcode,
    status as active,
    statusdate as status_date,
    creationdate as creation_date,
    creationamount as creation_amount,
    dispfundsreturn as disp_funds_return,
    dispfundspolcomm as disp_funds_political_committee,
    dispfundscharity as disp_funds_charity,
    dispfunds95 as disp_funds_95,
    dispfundsdescrip as disp_funds_description,
    cansuppopp as committee_position,
    policysuppopp as policy_position,
    partyaffiliation as party,
    purpose as purpose
  FROM raw.committees
;

ALTER TABLE public.committees ADD PRIMARY KEY (id);