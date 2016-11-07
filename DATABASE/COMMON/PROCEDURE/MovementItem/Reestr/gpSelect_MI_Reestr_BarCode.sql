-- Function: gpSelect_MI_Reestr_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_Reestr_BarCode (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Reestr_BarCode(
    IN inMovementId_Transport Integer ,
    IN inSession              TVarChar    -- сессия пользователя
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
       SELECT NULL :: TVarChar AS BarCode
            , CASE WHEN inMovementId_Transport > 0
                        THEN zfFormat_BarCode (zc_BarCodePref_Movement(), inMovementId_Transport) || '0'
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
-- SELECT * FROM gpSelect_MI_Reestr_BarCode (inMovementId_Transport:= 4680679, inSession:= zfCalc_UserAdmin())
