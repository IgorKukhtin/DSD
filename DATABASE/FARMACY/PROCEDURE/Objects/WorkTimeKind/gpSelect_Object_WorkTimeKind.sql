-- Function: gpSelect_Object_WorkTimeKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_WorkTimeKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_WorkTimeKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShortName TVarChar
             , Value     TVarChar
             , PayrollTypeID Integer, PayrollTypeName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_WorkTimeKind());

   RETURN QUERY 
   SELECT
        Object_WorkTimeKind.Id           AS Id 
      , Object_WorkTimeKind.ObjectCode   AS Code
      , Object_WorkTimeKind.ValueData    AS Name
      
      , ObjectString_ShortName.ValueData AS ShortName 
      , zfCalc_ViewWorkHour (0, ObjectString_ShortName.ValueData) AS Value
      
      , Object_PayrollType.ID            AS PayrollGroupID
      , Object_PayrollType.ValueData     AS PayrollGroupName

      , Object_WorkTimeKind.isErased     AS isErased
      
   FROM OBJECT AS Object_WorkTimeKind
   
        LEFT JOIN ObjectString AS ObjectString_ShortName
                               ON ObjectString_ShortName.ObjectId = Object_WorkTimeKind.Id
                              AND ObjectString_ShortName.DescId = zc_objectString_WorkTimeKind_ShortName()
                              
        LEFT JOIN ObjectLink AS ObjectLink_Goods_PayrollType
                             ON ObjectLink_Goods_PayrollType.ObjectId = Object_WorkTimeKind.Id
                            AND ObjectLink_Goods_PayrollType.DescId = zc_ObjectLink_WorkTimeKind_PayrollType()
        LEFT JOIN Object AS Object_PayrollType ON Object_PayrollType.Id = ObjectLink_Goods_PayrollType.ChildObjectId

   WHERE Object_WorkTimeKind.DescId = zc_Object_WorkTimeKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_WorkTimeKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.08.19                                                       *
 01.10.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_WorkTimeKind('2')
