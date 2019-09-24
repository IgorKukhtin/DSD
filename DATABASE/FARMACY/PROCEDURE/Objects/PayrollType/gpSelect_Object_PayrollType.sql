-- Function: gpSelect_Object_PayrollType()

DROP FUNCTION IF EXISTS gpSelect_Object_PayrollType(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PayrollType(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , ShortName TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PayrollType());

   RETURN QUERY
   SELECT
          Object_PayrollType.Id             AS Id
        , Object_PayrollType.ObjectCode     AS Code
        , Object_PayrollType.ValueData      AS Name
        
        , ObjectString_ShortName.ValueData  AS ShortName

        , Object_PayrollType.isErased       AS isErased
   FROM Object AS Object_PayrollType

        LEFT JOIN ObjectString AS ObjectString_ShortName
                               ON ObjectString_ShortName.ObjectId = Object_PayrollType.Id 
                              AND ObjectString_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

   WHERE Object_PayrollType.DescId = zc_Object_PayrollType()
   UNION ALL
   SELECT -1, 0, 'Служебный выход'::TVarChar, 'СВ'::TVarChar, False;

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.09.19                                                        *
 22.08.19                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PayrollType('3')