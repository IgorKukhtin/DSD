-- Function: gpGet_Scale_PSW_delete()

DROP FUNCTION IF EXISTS gpGet_Scale_PSW_delete (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_PSW_delete(
    IN inPSW               TVarChar,
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar, PSW TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF 1=1 AND vbUserId = 5
     THEN
         -- Результат
         RETURN QUERY
           SELECT Id, ObjectCode, ValueData, '' :: TVarChar
           FROM Object 
           WHERE Id = vbUserId;

     ELSEIF   ((zfConvert_StringToNumber (SUBSTR (inPSW, 4, 13 - 4)) > 0 AND CHAR_LENGTH (inPSW) >= 12)
            OR (zfConvert_StringToNumber (inPSW) > 0 AND CHAR_LENGTH (inPSW) < 12)
              )
     AND EXISTS (SELECT 1 FROM ObjectFloat JOIN Object ON Object.Id = ObjectFloat.ObjectId AND Object.isErased = FALSE
                WHERE ObjectFloat.ValueData = CASE WHEN CHAR_LENGTH (inPSW) >= 12
                                                   THEN zfConvert_StringToNumber (SUBSTR (inPSW, 4, 13 - 4))
                                                   ELSE zfConvert_StringToNumber (inPSW)
                                              END :: TFloat
                  AND ObjectFloat.DescId = zc_ObjectFloat_Member_ScalePSW()) -- zc_ObjectFloat_User_ScalePSW
     THEN
         -- Результат
         RETURN QUERY
           SELECT Id, ObjectCode, ValueData, '' :: TVarChar
           FROM Object 
           WHERE Id = vbUserId;
     ELSE 
         -- Результат
         RETURN QUERY
           SELECT Id, ObjectCode, ValueData, 'ERROR' :: TVarChar
           FROM Object 
           WHERE Id = vbUserId;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_PSW_delete (TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.10.17                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_PSW_delete (inPSW:= '123', inSession:=zfCalc_UserAdmin())
