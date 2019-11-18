CREATE TABLE public.committee_officer_links AS
    SELECT * from raw.cmteofficerlinks
;
ALTER TABLE public.committee_officer_links ADD PRIMARY KEY (id);