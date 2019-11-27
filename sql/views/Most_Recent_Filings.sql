CREATE TABLE public.most_recent_filings AS
 SELECT COALESCE(d2.end_funds_available, (0)::double precision) AS end_funds_available,
    COALESCE(d2.total_investments, (0)::double precision) AS total_investments,
    COALESCE(d2.total_debts, (0)::double precision) AS total_debts,
    COALESCE((d2.inkind_itemized + d2.inkind_non_itemized), (0)::double precision) AS total_inkind,
    cm.name AS committee_name,
    cm.id AS committee_id,
    cm.type AS committee_type,
    cm.active AS committee_active,
    fd.id AS filed_doc_id,
    fd.doc_name,
    fd.reporting_period_end,
    fd.reporting_period_begin,
    fd.received_datetime
   FROM ((committees cm
     LEFT JOIN ( SELECT DISTINCT ON (f.committee_id) f.id,
            f.committee_id,
            f.doc_name,
            f.reporting_period_end,
            f.reporting_period_begin,
            f.received_datetime
           FROM ( SELECT DISTINCT ON (filed_docs.committee_id, filed_docs.reporting_period_end) filed_docs.id,
                    filed_docs.committee_id,
                    filed_docs.doc_name,
                    filed_docs.reporting_period_end,
                    filed_docs.reporting_period_begin,
                    filed_docs.received_datetime
                   FROM filed_docs
                  WHERE ((filed_docs.doc_name)::text <> ALL ((ARRAY['A-1'::character varying, 'Statement of Organization'::character varying, 'Letter/Correspondence'::character varying, 'B-1'::character varying, 'Nonparticipation'::character varying])::text[]))
                  ORDER BY filed_docs.committee_id, filed_docs.reporting_period_end DESC, filed_docs.received_datetime DESC) f
          ORDER BY f.committee_id, f.reporting_period_end DESC) fd ON ((fd.committee_id = cm.id)))
     LEFT JOIN d2_reports d2 ON ((fd.id = d2.filed_doc_id)))
  ;

