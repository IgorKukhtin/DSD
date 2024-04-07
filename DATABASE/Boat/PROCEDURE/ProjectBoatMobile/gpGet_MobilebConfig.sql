-- Function: gpGet_MobilebConfig()

DROP FUNCTION IF EXISTS gpGet_MobilebConfig (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MobilebConfig(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (BarCodePref        TVarChar
             , ArticleSeparators  TVarChar  
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Результат такой
     RETURN QUERY
     SELECT zc_BarCodePref_Object()::TVarChar   AS BarCodePref
          , ' ,-'::TVarChar                     AS ArticleSeparators; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.04.24                                                       *
*/

-- тест
--
 select * from gpGet_MobilebConfig(inSession := '5');