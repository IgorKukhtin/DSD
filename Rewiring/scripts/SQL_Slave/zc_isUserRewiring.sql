-- Function: _replica.zc_isUserRewiring()

-- DROP FUNCTION _replica.zc_isUserRewiring();

CREATE OR REPLACE FUNCTION _replica.zc_isUserRewiring()
RETURNS Boolean
AS
$BODY$
BEGIN 
     RETURN  session_user ILIKE '%s';
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.09.23                                                       * 
*/

-- тест
-- SELECT _replica.zc_isUserRewiring();
