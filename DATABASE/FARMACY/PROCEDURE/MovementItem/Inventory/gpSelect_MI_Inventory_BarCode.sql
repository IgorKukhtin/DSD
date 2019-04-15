-- Function: gpSelect_MI_Inventory_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_Inventory_BarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Inventory_BarCode(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (BarCode TVarChar
             , Amount Tfloat 
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 
       SELECT NULL :: TVarChar AS BarCode
            , 1    :: Tfloat   AS Amount;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.03.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_Inventory_BarCode (inSession:= zfCalc_UserAdmin())
