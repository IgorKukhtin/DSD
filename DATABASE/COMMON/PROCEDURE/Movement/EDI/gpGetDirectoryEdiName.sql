-- Function: gpGetDirectoryName()

DROP FUNCTION IF EXISTS gpGetDirectoryEdiName (TVarChar);

CREATE OR REPLACE FUNCTION gpGetDirectoryEdiName(
       OUT Directory             TVarChar, 
       OUT isEDISaveLocal        Boolean, 
        IN inSession             TVarChar       -- текущий пользователь
      )
RETURNS RECORD
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
BEGIN
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);

   Directory := '\\192.168.0.234\local-error\';
   isEDISaveLocal := zc_isEDISaveLocal();
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetDirectoryEdiName (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.03.15                                        * add Object_RoleAccessKeyGuide_View...
*/

-- тест
-- SELECT * FROM gpGetDirectoryName('5')

