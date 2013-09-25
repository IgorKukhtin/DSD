CREATE OR REPLACE FUNCTION lpGetUserBySession(
IN inSession TVarChar)
RETURNS integer AS
$BODY$  
BEGIN
  RETURN to_number(inSession, '00000000000');   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpGetUserBySession(TVarChar)
  OWNER TO postgres;
