-- Function: gpGet_DefaultValue()

DROP FUNCTION IF EXISTS gpGetConstName(TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGetConstName(
    IN inConstName   TVarChar ,     -- константа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
  DECLARE vbResult TVarChar;
BEGIN
	
  EXECUTE 'SELECT ValueData FROM Object where Id = '||inConstName||'()' INTO vbResult;	

   RETURN 
   
     vbResult;
    
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetConstName(TVarChar, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.12.14                         *

*/

-- тест
-- select gpGetConstName('zc_Enum_GlobalConst_ConnectParam', ''), gpGetConstName('zc_Enum_GlobalConst_ConnectReportParam', '')
