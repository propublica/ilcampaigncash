CREATE TABLE public.committee_candidate_links AS
    SELECT * from raw.cmtecandidatelinks
;
ALTER TABLE public.committee_candidate_links ADD PRIMARY KEY (id);