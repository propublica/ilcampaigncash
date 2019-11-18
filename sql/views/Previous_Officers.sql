CREATE TABLE public.previous_officers AS
    SELECT * FROM raw.prevofficers
;
ALTER TABLE public.previous_officers ADD PRIMARY KEY (id);