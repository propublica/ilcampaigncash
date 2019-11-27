 CREATE TABLE public.condensed_receipts AS
 SELECT r.id,
    r.committee_id,
    r.filed_doc_id,
    r.etrans_id,
    r.last_name,
    r.first_name,
    r.received_date,
    r.amount,
    r.aggregate_amount,
    r.loan_amount,
    r.occupation,
    r.employer,
    r.address1,
    r.address2,
    r.city,
    r.state,
    r.zipcode,
    r.d2_part,
    r.description,
    r.vendor_last_name,
    r.vendor_first_name,
    r.vendor_address1,
    r.vendor_address2,
    r.vendor_city,
    r.vendor_state,
    r.vendor_zipcode,
    r.archived,
    r.country,
    r.redaction_requested
   FROM (receipts r
     LEFT JOIN most_recent_filings m USING (committee_id))
  WHERE ((r.received_date > COALESCE(m.reporting_period_end, '1900-01-01 00:00:00'::timestamp without time zone)) AND (r.archived = false))
UNION
 SELECT r.id,
    r.committee_id,
    r.filed_doc_id,
    r.etrans_id,
    r.last_name,
    r.first_name,
    r.received_date,
    r.amount,
    r.aggregate_amount,
    r.loan_amount,
    r.occupation,
    r.employer,
    r.address1,
    r.address2,
    r.city,
    r.state,
    r.zipcode,
    r.d2_part,
    r.description,
    r.vendor_last_name,
    r.vendor_first_name,
    r.vendor_address1,
    r.vendor_address2,
    r.vendor_city,
    r.vendor_state,
    r.vendor_zipcode,
    r.archived,
    r.country,
    r.redaction_requested
   FROM (receipts r
     JOIN ( SELECT DISTINCT ON (filed_docs.reporting_period_begin, filed_docs.reporting_period_end, filed_docs.committee_id) filed_docs.id AS filed_doc_id
           FROM filed_docs
          WHERE ((filed_docs.doc_name)::text <> 'Pre-election'::text)
          ORDER BY filed_docs.reporting_period_begin, filed_docs.reporting_period_end, filed_docs.committee_id, filed_docs.received_datetime DESC) f USING (filed_doc_id))
  ;

ALTER TABLE public.condensed_receipts ADD PRIMARY KEY (id);

ALTER TABLE public.condensed_receipts ADD CONSTRAINT condensed_receipt_committee FOREIGN KEY (committee_id) REFERENCES public.committees (id) NOT VALID;
