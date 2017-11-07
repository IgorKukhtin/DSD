-- Function: gpGet_DefaultValue()

DROP FUNCTION IF EXISTS gpGetDefaultEDI(TVarChar);

CREATE OR REPLACE FUNCTION gpGetDefaultEDI(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Host TVarChar, UserName TVarChar, Password TVarChar)
AS
$BODY$
BEGIN

   -- IF inSession = '14610'
   IF inSession <> zfCalc_UserAdmin()
   THEN
   RETURN QUERY
    SELECT  'ftpex.edi.su'::TVarChar AS Host
          , 'uatovalanftp'::TVarChar   AS UserName
          , 'ftp349067'::TVarChar      AS Password;
   ELSE
   RETURN QUERY
    SELECT  'ruftpex.edi.su'::TVarChar AS Host
          , 'uatovalanftp'::TVarChar   AS UserName
          , 'ftp349067'::TVarChar      AS Password;
   END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetDefaultEDI (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.14                         *
*/

-- тест
-- SELECT * FROM gpGetDefaultEDI (zfCalc_UserAdmin())
