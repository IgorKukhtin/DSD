-- Function: gpGet_Object_CashSettings()

DROP FUNCTION IF EXISTS gpGet_Object_CashSettings(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CashSettings(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShareFromPriceName TVarChar
             , ShareFromPriceCode TVarChar
             , isGetHardwareData Boolean
             , DateBanSUN TDateTime
             , SummaFormSendVIP TFloat
             , SummaUrgentlySendVIP TFloat
             , DaySaleForSUN Integer
             , isBlockVIP Boolean
             , isPairedOnlyPromo Boolean
             , AttemptsSub Integer
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT Object_CashSettings.Id                                                   AS Id
        , Object_CashSettings.ObjectCode                                           AS Code
        , Object_CashSettings.ValueData                                            AS Name
        , ObjectString_CashSettings_ShareFromPriceName.ValueData                   AS ShareFromPriceName
        , ObjectString_CashSettings_ShareFromPriceCode.ValueData                   AS ShareFromPriceCode
        , COALESCE(ObjectBoolean_CashSettings_GetHardwareData.ValueData, FALSE)    AS isGetHardwareData
        , ObjectDate_CashSettings_DateBanSUN.ValueData                             AS DateBanSUN
        , ObjectFloat_CashSettings_SummaFormSendVIP.ValueData                      AS SummaFormSendVIP
        , ObjectFloat_CashSettings_SummaUrgentlySendVIP.ValueData                  AS SummaUrgentlySendVIP
        , ObjectFloat_CashSettings_DaySaleForSUN.ValueData::Integer                AS DaySaleForSUN
        , COALESCE(ObjectBoolean_CashSettings_BlockVIP.ValueData, FALSE)           AS isBlockVIP
        , COALESCE(ObjectBoolean_CashSettings_PairedOnlyPromo.ValueData, FALSE)    AS isPairedOnlyPromo
        , ObjectFloat_CashSettings_AttemptsSub.ValueData::Integer                  AS AttemptsSub
   FROM Object AS Object_CashSettings
        LEFT JOIN ObjectString AS ObjectString_CashSettings_ShareFromPriceName
                               ON ObjectString_CashSettings_ShareFromPriceName.ObjectId = Object_CashSettings.Id 
                              AND ObjectString_CashSettings_ShareFromPriceName.DescId = zc_ObjectString_CashSettings_ShareFromPriceName()
        LEFT JOIN ObjectString AS ObjectString_CashSettings_ShareFromPriceCode
                               ON ObjectString_CashSettings_ShareFromPriceCode.ObjectId = Object_CashSettings.Id 
                              AND ObjectString_CashSettings_ShareFromPriceCode.DescId = zc_ObjectString_CashSettings_ShareFromPriceCode()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_GetHardwareData
                                ON ObjectBoolean_CashSettings_GetHardwareData.ObjectId = Object_CashSettings.Id 
                               AND ObjectBoolean_CashSettings_GetHardwareData.DescId = zc_ObjectBoolean_CashSettings_GetHardwareData()
        LEFT JOIN ObjectDate AS ObjectDate_CashSettings_DateBanSUN
                             ON ObjectDate_CashSettings_DateBanSUN.ObjectId = Object_CashSettings.Id 
                            AND ObjectDate_CashSettings_DateBanSUN.DescId = zc_ObjectDate_CashSettings_DateBanSUN()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_SummaFormSendVIP
                              ON ObjectFloat_CashSettings_SummaFormSendVIP.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_SummaFormSendVIP.DescId = zc_ObjectFloat_CashSettings_SummaFormSendVIP()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_SummaUrgentlySendVIP
                              ON ObjectFloat_CashSettings_SummaUrgentlySendVIP.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_SummaUrgentlySendVIP.DescId = zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DaySaleForSUN
                              ON ObjectFloat_CashSettings_DaySaleForSUN.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_DaySaleForSUN.DescId = zc_ObjectFloat_CashSettings_DaySaleForSUN()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AttemptsSub
                              ON ObjectFloat_CashSettings_AttemptsSub.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_AttemptsSub.DescId = zc_ObjectFloat_CashSettings_AttemptsSub()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_BlockVIP
                                ON ObjectBoolean_CashSettings_BlockVIP.ObjectId = Object_CashSettings.Id 
                               AND ObjectBoolean_CashSettings_BlockVIP.DescId = zc_ObjectBoolean_CashSettings_BlockVIP()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_PairedOnlyPromo
                                ON ObjectBoolean_CashSettings_PairedOnlyPromo.ObjectId = Object_CashSettings.Id 
                               AND ObjectBoolean_CashSettings_PairedOnlyPromo.DescId = zc_ObjectBoolean_CashSettings_PairedOnlyPromo()
   WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
   LIMIT 1;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CashSettings(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.08.19                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_CashSettings ('3')
