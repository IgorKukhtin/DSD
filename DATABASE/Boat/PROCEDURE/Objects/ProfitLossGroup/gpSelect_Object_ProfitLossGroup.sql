-- Function: gpSelect_Object_ProfitLossGroup (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ProfitLossGroup (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProfitLossGroup(
    IN inIsShowAll      Boolean  ,     --
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ProfitLossGroup());

   RETURN QUERY 
   SELECT
         Object_ProfitLossGroup.Id         AS Id 
       , Object_ProfitLossGroup.ObjectCode AS Code
       , Object_ProfitLossGroup.ValueData  AS Name
       , Object_ProfitLossGroup.isErased   AS isErased
   FROM Object AS Object_ProfitLossGroup
   WHERE Object_ProfitLossGroup.DescId = zc_Object_ProfitLossGroup()
     AND (Object_ProfitLossGroup.isErased = FALSE OR inIsShowAll = TRUE);
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.06.17         *
 18.06.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ProfitLossGroup(True,'2')
