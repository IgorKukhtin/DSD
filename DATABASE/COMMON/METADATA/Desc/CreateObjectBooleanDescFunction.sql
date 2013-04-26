CREATE OR REPLACE FUNCTION zc_ObjectBoolean_Juridical_isCorporate()
  RETURNS integer AS
$BODY$BEGIN
  RETURN 1;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION zc_ObjectBoolean_Juridical_isCorporate()
  OWNER TO postgres;

