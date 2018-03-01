DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'committee_position') THEN
      CREATE TYPE committee_position AS ENUM (
          'support',
          'oppose'
      );
    END IF;
END$$;

CREATE UNLOGGED TABLE IF NOT EXISTS raw.committees (
    id integer primary key,
    typeofcommittee character varying,
    statecommittee boolean,
    stateid integer,
    localcommittee boolean,
    localid integer,
    refername character varying,
    name character varying,
    address1 character varying,
    address2 character varying,
    address3 character varying,
    city character varying,
    state character varying,
    zip character varying,
    status character varying,
    statusdate timestamp without time zone,
    creationdate timestamp without time zone,
    creationamount double precision,
    dispfundsreturn boolean,
    dispfundspolcomm boolean,
    dispfundscharity boolean,
    dispfunds95 boolean,
    dispfundsdescrip text,
    cansuppopp character varying,
    policysuppopp character varying,
    partyaffiliation character varying,
    purpose text
);
