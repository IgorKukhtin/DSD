-- Function: gpSelect_MI_Reestr_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_Reestr_BarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Reestr_BarCode(
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (BarCode TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Reestr());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 

       SELECT CAST (Null AS TVarChar)  AS BarCode;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.10.16         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_Reestr_BarCode (inStartDate:= '01.01.2015', inEndDate:= '01.02.2015', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())


