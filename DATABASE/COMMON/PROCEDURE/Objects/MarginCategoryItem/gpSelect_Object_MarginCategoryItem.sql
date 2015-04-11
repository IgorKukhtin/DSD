--Function: gpSelect_Object_MarginCategoryItem(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MarginCategoryItem(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MarginCategoryItem(
    IN inMarginCategoryId Integer,
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MarginPercent TFloat, MinPrice TFloat) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MarginCategory());

   RETURN QUERY 
   SELECT 
         Object_MarginCategoryItem.Id            AS Id 
       , Object_MarginCategoryItem.MarginPercent AS MarginPercent
       , Object_MarginCategoryItem.MinPrice      AS MinPrice
    FROM Object_MarginCategoryItem_View AS Object_MarginCategoryItem
   WHERE Object_MarginCategoryItem.MarginCategoryId = inMarginCategoryId;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MarginCategoryItem(Integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.04.15                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_MarginCategoryItem('2')