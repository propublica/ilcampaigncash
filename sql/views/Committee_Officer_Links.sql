CREATE TABLE public.committee_officer_links AS
    SELECT
        id as id,
        officerid as officer_id,
        committeeid as committee_id
    FROM
        raw.cmteofficerlinks
;
ALTER TABLE public.committee_officer_links ADD PRIMARY KEY (id);

ALTER TABLE public.committee_officer_links ADD CONSTRAINT committee_officer_committee FOREIGN KEY (committee_id) REFERENCES public.committees (id) NOT VALID;
ALTER TABLE public.committee_officer_links ADD CONSTRAINT committee_officer_officer FOREIGN KEY (officer_id) REFERENCES public.officers (id) NOT VALID;