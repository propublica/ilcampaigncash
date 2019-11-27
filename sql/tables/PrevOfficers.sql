CREATE UNLOGGED TABLE IF NOT EXISTS raw.prevofficers (
    id integer primary key,
    committeeid integer,
    lastname character varying,
    firstname character varying,
    address1 character varying,
    address2 character varying,
    city character varying,
    state character varying,
    zip character varying,
    title character varying,
    resigndate timestamp without time zone,
    redactionrequested boolean
);