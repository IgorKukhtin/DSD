-- Function: gpSelect_Object_PartionDateWagesList (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PartionDateWagesList (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionDateWagesList(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PartionDateKindId Integer
             , DateStart TDateTime
             , Percent TFloat
             , isNotCharge Boolean
             , isErased Boolean
             ) AS
             
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_PartionDateKind());

   RETURN QUERY 
   SELECT
        Object_PartionDateWages.Id                           AS Id 
      , Object_PartionDateWages.ObjectCode                   AS Code
      , Object_PartionDateWages.ValueData                    AS Name
      , ObjectLink_PartionDateKind.ChildObjectId             AS PartionDateKindId
      , ObjectDate_DateStart.ValueData                       AS DateStart
      , COALESCE (ObjectFloat_Percent.ValueData, 0)::TFloat  AS Percent
      , COALESCE (ObjectBoolean_NotCharge.ValueData, False)  AS isNotCharge
      , Object_PartionDateWages.isErased     AS isErased
   FROM Object AS Object_PartionDateWages
        LEFT JOIN ObjectLink AS ObjectLink_PartionDateKind
                             ON ObjectLink_PartionDateKind.ObjectId = Object_PartionDateWages.Id
                            AND ObjectLink_PartionDateKind.DescId = zc_ObjectLink_PartionDateWages_PartionDateKind()
        LEFT JOIN ObjectDate AS ObjectDate_DateStart
                             ON ObjectDate_DateStart.ObjectId = Object_PartionDateWages.Id
                            AND ObjectDate_DateStart.DescId = zc_ObjectDate_PartionDateWages_DateStart()
        LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                              ON ObjectFloat_Percent.ObjectId = Object_PartionDateWages.Id
                             AND ObjectFloat_Percent.DescId = zc_ObjectFloat_PartionDateWages_Percent()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCharge
                                ON ObjectBoolean_NotCharge.ObjectId = Object_PartionDateWages.Id
                               AND ObjectBoolean_NotCharge.DescId = zc_ObjectBoolean_PartionDateWages_NotCharge()
   WHERE Object_PartionDateWages.DescId = zc_Object_PartionDateWages()
   ;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.01.23                                                       *

*/

-- тест
-- 
SELECT * FROM gpSelect_Object_PartionDateWagesList('3')