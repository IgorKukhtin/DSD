CREATE DOMAIN TVarChar
  AS character varying(255)
  COLLATE pg_catalog."default";
ALTER DOMAIN TVarChar
  OWNER TO postgres;
CREATE DOMAIN TFloat
  AS numeric(20,4);
ALTER DOMAIN TFloat
  OWNER TO postgres;
