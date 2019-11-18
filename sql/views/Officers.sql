CREATE TABLE public.officers AS
    SELECT * FROM raw.officers
;
ALTER TABLE public.officers ADD PRIMARY KEY (id);