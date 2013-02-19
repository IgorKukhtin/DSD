-- Function: lpCheckUnique_Object_ValueData(integer, tvarchar)

-- DROP FUNCTION lpCheckUnique_Object_ValueData(integer, tvarchar);

CREATE OR REPLACE FUNCTION lpCheckUnique_Object_ValueData(
inId integer, 
inValueData tvarchar)
  RETURNS void AS
$BODY$BEGIN

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpCheckUnique_Object_ValueData(integer, tvarchar)
  OWNER TO postgres;
