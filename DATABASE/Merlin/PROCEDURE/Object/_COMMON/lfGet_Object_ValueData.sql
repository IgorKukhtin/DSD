-- Function: lfGet_Object_ValueData (Integer) - Используется для дефолтов в Get-процедурах (т.е. сократить код и не писать строку запроса)

DROP FUNCTION IF EXISTS lfGet_Object_ValueData (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_ValueData (IN inId Integer)
  RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN COALESCE ((SELECT CASE WHEN ObjectCode <> 0 AND DescId NOT IN (zc_Object_User()) THEN '(' || ObjectCode :: TVarChar || ')' ELSE '' END || ValueData FROM Object where Id = inId), '');
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_Object_ValueData (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.10.13                                        *                            
*/

-- тест
-- SELECT * FROM lfGet_Object_ValueData (1)
