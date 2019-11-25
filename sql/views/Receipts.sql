CREATE TABLE public.receipts
AS
  SELECT
    id as id,
    committeeid as committee_id,
    fileddocid as filed_doc_id,
    etransid as etrans_id,
    lastonlyname as last_name,
    firstname as first_name,
    rcvdate as received_date,
    amount as amount,
    aggregateamount as aggregate_amount,
    loanamount as loan_amount,
    occupation as occupation,
    employer as employer,
    address1 as address1,
    address2 as address2,
    city as city,
    state as state,
    zip as zipcode,
    d2part as d2_part,
    description as description,
    vendorlastonlyname as vendor_last_name,
    vendorfirstname as vendor_first_name,
    vendoraddress1 as vendor_address1,
    vendoraddress2 as vendor_address2,
    vendorcity as vendor_city,
    vendorstate as vendor_state,
    vendorzip as vendor_zipcode,
    archived as archived,
    country as country,
    redactionrequested as redaction_requested
  FROM raw.receipts
;

ALTER TABLE public.receipts ADD PRIMARY KEY (id);

ALTER TABLE public.receipts ADD CONSTRAINT receipt_committee FOREIGN KEY (committee_id) REFERENCES public.committees (id) NOT VALID;