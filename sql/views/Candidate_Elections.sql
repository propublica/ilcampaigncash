CREATE TABLE public.candidate_elections AS
    SELECT * from raw.canelections
;

ALTER TABLE public.candidate_elections ADD PRIMARY KEY (id);