CREATE UNLOGGED TABLE IF NOT EXISTS raw.candidates (
    id integer primary key,
    lastname character varying,
    firstname character varying,
    address1 character varying,
    address2 character varying,
    city character varying,
    state character varying,
    zip character varying,
    office character varying,
    districttype character varying,
    district character varying,
    residencecounty character varying,
    partyaffiliation character varying,
    redactionrequested boolean
);
