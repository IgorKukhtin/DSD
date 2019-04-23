-- Function: gpSelect_MI_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_BarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_BarCode(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, BarCode TVarChar, BarCode_str TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 
       SELECT 0    :: Integer  AS Id
            , NULL :: TVarChar AS BarCode
            , NULL :: TVarChar AS BarCode_str;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.12.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_BarCode (inSession:= zfCalc_UserAdmin())
