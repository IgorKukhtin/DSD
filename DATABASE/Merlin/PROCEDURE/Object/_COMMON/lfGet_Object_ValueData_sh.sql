-- Function: lfGet_Object_ValueData_sh (Integer) - Используется для дефолтов в Get-процедурах (т.е. сократить код и не писать строку запроса)

DROP FUNCTION IF EXISTS lfGet_Object_ValueData_sh (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_ValueData_sh (IN inId Integer)
  RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN COALESCE ((SELECT ValueData FROM Object where Id = inId), '');
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_Object_ValueData_sh (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.01.18                                        *                            
*/

-- тест
-- SELECT * FROM lfGet_Object_ValueData_sh (1)
