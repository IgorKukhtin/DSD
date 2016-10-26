-- Function: gpSelect_MI_Reestr_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_Reestr_BarCode (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_Reestr_BarCode (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_MI_Reestr_BarCode(
    IN inBarCode_Transport Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (BarCode TVarChar
             , BarCode_Transport TVarChar
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

       SELECT CAST (Null AS TVarChar)  AS BarCode
            , CASE WHEN COALESCE  (inBarCode_Transport , NUll) = Null OR COALESCE (inBarCode_Transport , NUll) = 0 THEN Null
                   ELSE COALESCE  (inBarCode_Transport , NUll) 
              END ::TVarChar  AS BarCode_Transport;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.10.16         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_Reestr_BarCode ( inSession:= zfCalc_UserAdmin())
--4323306
--4306286