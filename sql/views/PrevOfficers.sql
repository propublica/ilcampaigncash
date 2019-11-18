CREATE TABLE public.prevofficers AS
    SELECT * FROM raw.prevofficers
;
ALTER TABLE public.prevofficers ADD PRIMARY KEY (id);