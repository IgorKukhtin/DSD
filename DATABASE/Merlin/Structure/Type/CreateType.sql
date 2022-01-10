CREATE DOMAIN TVarChar
  AS character varying(255);
ALTER DOMAIN TVarChar
  OWNER TO postgres;

CREATE DOMAIN TFloat
  AS numeric(20,4);
ALTER DOMAIN TFloat
  OWNER TO postgres;

CREATE DOMAIN TDateTime
  AS timestamp with time zone;
ALTER DOMAIN TDateTime
  OWNER TO postgres;

CREATE DOMAIN TBlob
  AS text;
ALTER DOMAIN TBlob
  OWNER TO postgres;