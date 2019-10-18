-- Function: gpSelect_Object_Unit_SaveToXls()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_SaveToXls(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_SaveToXls(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY 
       SELECT 
             Object_Unit_View.Id
           , Object_Unit_View.Name
       FROM Object_Unit_View
       WHERE COALESCE(Object_Unit_View.ParentId, 0) <> 0
         AND Object_Unit_View.isErased = false
         AND COALESCE(Object_Unit_View.ParentId, 0) not in (377612, 2141104)
         AND Object_Unit_View.Id NOT IN (183293, 183294, 183288, 389328);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 26.04.18        *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_SaveToXls ('3')