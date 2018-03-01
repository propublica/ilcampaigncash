CREATE UNLOGGED TABLE IF NOT EXISTS raw.cmtecandidatelinks (
    id integer primary key,
    candidateid integer,
    committeeid integer
);
