CREATE TABLE public.condensed_expenditures AS
 SELECT e.id,
    e.committee_id,
    e.filed_doc_id,
    e.etrans_id,
    e.last_name,
    e.first_name,
    e.expended_date,
    e.amount,
    e.aggregate_amount,
    e.address1,
    e.address2,
    e.city,
    e.state,
    e.zipcode,
    e.d2_part,
    e.purpose,
    e.candidate_name,
    e.office,
    e.supporting,
    e.opposing,
    e.archived,
    e.country,
    e.redaction_requested
   FROM (expenditures e
     JOIN most_recent_filings m USING (committee_id))
  WHERE ((e.expended_date > COALESCE(m.reporting_period_end, '1900-01-01 00:00:00'::timestamp without time zone)) AND (e.archived = false))
UNION
 SELECT e.id,
    e.committee_id,
    e.filed_doc_id,
    e.etrans_id,
    e.last_name,
    e.first_name,
    e.expended_date,
    e.amount,
    e.aggregate_amount,
    e.address1,
    e.address2,
    e.city,
    e.state,
    e.zipcode,
    e.d2_part,
    e.purpose,
    e.candidate_name,
    e.office,
    e.supporting,
    e.opposing,
    e.archived,
    e.country,
    e.redaction_requested
   FROM (expenditures e
     JOIN ( SELECT DISTINCT ON (filed_docs.reporting_period_begin, filed_docs.reporting_period_end, filed_docs.committee_id) filed_docs.id AS filed_doc_id
           FROM filed_docs
          WHERE ((filed_docs.doc_name)::text <> 'Pre-election'::text)
          ORDER BY filed_docs.reporting_period_begin, filed_docs.reporting_period_end, filed_docs.committee_id, filed_docs.received_datetime DESC) f USING (filed_doc_id))
  ;

ALTER TABLE public.condensed_expenditures ADD PRIMARY KEY (id);

ALTER TABLE public.condensed_expenditures ADD CONSTRAINT condensed_expenditure_committee FOREIGN KEY (committee_id) REFERENCES public.committees (id) NOT VALID;