CREATE TABLE public.filed_docs
AS
  SELECT
    id as id,
    committeeid as committee_id,
    fileddoctype as doc_type,
    docname as doc_name,
    amend as amended,
    comment as comment,
    pages as page_count,
    electiontype as election_type,
    electionyear as election_year,
    rptpdbegdate as reporting_period_begin,
    rptpdenddate as reporting_period_end,
    rcvdat as received_at,
    rcvddatetime as received_datetime,
    source as source,
    provider as provider,
    signerlastonlyname as signer_last_name,
    signerfirstname as signer_first_name,
    sbmttrlastonlyname as submitter_last_name,
    sbmttrfirstname as submitter_first_name,
    sbmttraddress1 as submitter_address1,
    sbmttraddress2 as submitter_address2,
    sbmttrcity as submitter_city,
    sbmttrstate as submitter_state,
    sbmttrzip as submitter_zip,
    b9signerlastonlyname as b9_signer_last_name,
    b9signerfirstname as b9_signer_first_name,
    archived as archived,
    clarification as clarification,
    redactionrequested as redaction_requested
  FROM raw.fileddocs
;

ALTER TABLE public.filed_docs ADD PRIMARY KEY (id);