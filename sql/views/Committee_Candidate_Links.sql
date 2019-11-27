CREATE TABLE public.committee_candidate_links AS
    SELECT
        id as id,
        candidateid as candidate_id,
        committeeid as committee_id
    FROM
        raw.cmtecandidatelinks
;

ALTER TABLE public.committee_candidate_links ADD PRIMARY KEY (id);

ALTER TABLE public.committee_candidate_links ADD CONSTRAINT committee_candidate_committee FOREIGN KEY (committee_id) REFERENCES public.committees (id) NOT VALID;
ALTER TABLE public.committee_candidate_links ADD CONSTRAINT committee_candidate_candidate FOREIGN KEY (candidate_id) REFERENCES public.candidates (id) NOT VALID;