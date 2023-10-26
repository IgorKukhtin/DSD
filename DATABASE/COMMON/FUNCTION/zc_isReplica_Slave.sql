-- Function: zc_isReplica_Slave

DROP FUNCTION IF EXISTS zc_isReplica_Slave ();

CREATE OR REPLACE FUNCTION zc_isReplica_Slave()
RETURNS Boolean
AS
$BODY$
BEGIN
     RETURN (EXISTS (SELECT 1 FROM _replica.settings WHERE Name ILIKE 'last_id'));
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

ALTER FUNCTION zc_isReplica_Slave() OWNER TO postgres;
ALTER FUNCTION zc_isReplica_Slave() OWNER TO project;
ALTER FUNCTION zc_isReplica_Slave() OWNER TO admin;

/*ALTER TABLE _replica.settings OWNER TO postgres;
ALTER TABLE _replica.settings OWNER TO project;
ALTER TABLE _replica.settings OWNER TO admin;*/

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.23                                        *
*/

-- тест
-- SELECT zc_isReplica_Slave()
