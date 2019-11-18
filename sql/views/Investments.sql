CREATE TABLE public.investments AS
    SELECT * FROM raw.investments
;
ALTER TABLE public.investments ADD PRIMARY KEY (id);