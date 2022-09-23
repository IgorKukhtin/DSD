-- Function:  gpSelect_eSputnikContactsMessages_Params

DROP FUNCTION IF EXISTS gpSelect_eSputnikContactsMessages_Params (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_eSputnikContactsMessages_Params (
    IN inSession TVarChar
)
RETURNS TABLE (DataStart     TDateTime
             , DataEnd       TDateTime
             , UserName      TVarChar
             , Password      TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- для остальных...
   RETURN QUERY
   SELECT (CURRENT_DATE - INTERVAL '1 MONTH')::TDateTime
        , CURRENT_DATE::TDateTime
        , 'info@neboley.dp.ua'::TVarChar
        , 'Max1256937841'::TVarChar;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.09.22                                                       *

*/

-- тест
-- 
select * from gpSelect_eSputnikContactsMessages_Params ('3');