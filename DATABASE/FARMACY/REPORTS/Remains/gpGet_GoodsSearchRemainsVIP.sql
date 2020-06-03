-- Function: gpGet_GoodsSearchRemainsVIP()

DROP FUNCTION IF EXISTS gpGet_GoodsSearchRemainsVIP (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GoodsSearchRemainsVIP(
    IN inSession        TVarChar     -- сессия пользователя
)
RETURNS TABLE (ID Integer
            , SummaUrgentlySendVIP TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbSummaFormSendVIP TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    SELECT Object_CashSettings.Id                                                          AS Id
         , COALESCE(ObjectFloat_CashSettings_SummaUrgentlySendVIP.ValueData, 0)::TFloat    AS SummaUrgentlySendVIP
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_SummaUrgentlySendVIP
                               ON ObjectFloat_CashSettings_SummaUrgentlySendVIP.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_SummaUrgentlySendVIP.DescId = zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.06.20                                                       *
*/

-- тест
-- select * from gpGet_GoodsSearchRemainsVIP(inSession := '3');
