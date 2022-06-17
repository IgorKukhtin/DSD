-- Function: gpGet_GoodsSearchRemainsVIP()

DROP FUNCTION IF EXISTS gpGet_GoodsSearchRemainsVIP (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GoodsSearchRemainsVIP(
    IN inSession        TVarChar     -- сессия пользователя
)
RETURNS TABLE (ID                  Integer
            , SummaUrgentlySendVIP TFloat
            , isBlockVIP           Boolean
            , SummaFormSendVIP     TFloat
            , PriceFormSendVIP     TFloat
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
         , COALESCE(ObjectBoolean_CashSettings_BlockVIP.ValueData, FALSE)                  AS isBlockVIP
         , COALESCE(ObjectFloat_CashSettings_SummaFormSendVIP.ValueData, 0)::TFloat        AS SummaFormSendVIP  
         , COALESCE(ObjectFloat_CashSettings_PriceFormSendVIP.ValueData, 0)::TFloat        AS PriceFormSendVIP
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_SummaUrgentlySendVIP
                               ON ObjectFloat_CashSettings_SummaUrgentlySendVIP.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_SummaUrgentlySendVIP.DescId = zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_SummaFormSendVIP
                               ON ObjectFloat_CashSettings_SummaFormSendVIP.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_SummaFormSendVIP.DescId = zc_ObjectFloat_CashSettings_SummaFormSendVIP()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PriceFormSendVIP
                               ON ObjectFloat_CashSettings_PriceFormSendVIP.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_PriceFormSendVIP.DescId = zc_ObjectFloat_CashSettings_PriceFormSendVIP()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_BlockVIP
                                 ON ObjectBoolean_CashSettings_BlockVIP.ObjectId = Object_CashSettings.Id 
                                AND ObjectBoolean_CashSettings_BlockVIP.DescId = zc_ObjectBoolean_CashSettings_BlockVIP()
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