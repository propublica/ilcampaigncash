DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'candidacy_race_type') THEN
      CREATE TYPE candidacy_race_type AS ENUM (
          'incumbent',
          'challenger',
          'open seat',
          'retired'
      );
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'candidacy_outcome') THEN
        CREATE TYPE candidacy_outcome AS ENUM (
            'won',
            'lost'
        );
    END IF;
END$$;


CREATE UNLOGGED TABLE IF NOT EXISTS raw.canelections (
    id integer primary key,
    candidateid integer,
    electiontype character varying,
    electionyear integer,
    incchallopen character varying,
    wonlost character varying,
    faircampaign boolean,
    limitsoff boolean,
    limitsoffreason character varying
);
