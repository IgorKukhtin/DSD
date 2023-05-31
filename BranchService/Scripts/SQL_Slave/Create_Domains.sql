-- Создание DOMAIN
DO $$
BEGIN


  IF NOT EXISTS(select * from information_schema.domains AS ISD where ISD.domain_schema = 'public' AND domain_name ILIKE 'TVarChar')
  THEN
    CREATE DOMAIN TVarChar AS character varying(255);
    ALTER DOMAIN TVarChar OWNER TO postgres;
  END IF;

  IF NOT EXISTS(select * from information_schema.domains AS ISD where ISD.domain_schema = 'public' AND domain_name ILIKE 'TFloat')
  THEN
    CREATE DOMAIN TFloat  AS numeric(20,4);
    ALTER DOMAIN TFloat OWNER TO postgres;
  END IF;

  IF NOT EXISTS(select * from information_schema.domains AS ISD where ISD.domain_schema = 'public' AND domain_name ILIKE 'TDateTime')
  THEN
    CREATE DOMAIN TDateTime AS timestamp with time zone;
    ALTER DOMAIN TDateTime OWNER TO postgres;
  END IF;

  IF NOT EXISTS(select * from information_schema.domains AS ISD where ISD.domain_schema = 'public' AND domain_name ILIKE 'TBlob')
  THEN
    CREATE DOMAIN TBlob AS text;
    ALTER DOMAIN TBlob OWNER TO postgres;
  END IF;

END $$; 