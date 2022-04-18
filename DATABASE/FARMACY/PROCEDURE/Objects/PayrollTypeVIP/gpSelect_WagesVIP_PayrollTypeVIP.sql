-- Function: gpSelect_WagesVIP_PayrollTypeVIP()

DROP FUNCTION IF EXISTS gpSelect_WagesVIP_PayrollTypeVIP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_WagesVIP_PayrollTypeVIP(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , ShortName TVarChar
             , PercentPhone TFloat, PercentOther TFloat
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PayrollTypeVIP());

   RETURN QUERY
   SELECT
          Object_PayrollTypeVIP.Id             AS Id
        , Object_PayrollTypeVIP.ObjectCode     AS Code
        , Object_PayrollTypeVIP.ValueData      AS Name
        
        , ObjectString_ShortName.ValueData  AS ShortName

        , ObjectFloat_PercentPhone.ValueData             AS PercentPhone
        , ObjectFloat_PercentOther.ValueData             AS PercentOther 

        , Object_PayrollTypeVIP.isErased       AS isErased
   FROM Object AS Object_PayrollTypeVIP

        LEFT JOIN ObjectString AS ObjectString_ShortName
                               ON ObjectString_ShortName.ObjectId = Object_PayrollTypeVIP.Id 
                              AND ObjectString_ShortName.DescId = zc_ObjectString_PayrollTypeVIP_ShortName()

        LEFT JOIN ObjectFloat AS ObjectFloat_PercentPhone
                              ON ObjectFloat_PercentPhone.ObjectId = Object_PayrollTypeVIP.Id
                             AND ObjectFloat_PercentPhone.DescId = zc_ObjectFloat_PayrollTypeVIP_PercentPhone()

        LEFT JOIN ObjectFloat AS ObjectFloat_PercentOther
                              ON ObjectFloat_PercentOther.ObjectId = Object_PayrollTypeVIP.Id
                             AND ObjectFloat_PercentOther.DescId = zc_ObjectFloat_PayrollTypeVIP_PercentOther()
                                 
   WHERE Object_PayrollTypeVIP.DescId = zc_Object_PayrollTypeVIP()
     AND Object_PayrollTypeVIP.ObjectCode IN (1, 2);
     
END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.09.21                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_WagesVIP_PayrollTypeVIP('3')     