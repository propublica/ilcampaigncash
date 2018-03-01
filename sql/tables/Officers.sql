CREATE UNLOGGED TABLE IF NOT EXISTS raw.officers (
    id integer primary key,
    lastname character varying,
    firstname character varying,
    address1 character varying,
    address2 character varying,
    city character varying,
    state character varying,
    zip character varying,
    title character varying,
    phone character varying,
    redactionrequested boolean
);
