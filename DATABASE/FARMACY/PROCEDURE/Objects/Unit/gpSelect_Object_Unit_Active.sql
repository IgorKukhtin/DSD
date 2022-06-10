-- Function: gpSelect_Object_Unit_Active()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_Active(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_Active(
    IN inNotUnitId   Integer   ,    -- Исключить подразделение
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               ParentName TVarChar, isErased boolean, isSelect boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY 
       SELECT 
             Object_Unit_View.Id
           , Object_Unit_View.Code
           , Object_Unit_View.Name
           , Object_Unit_View.ParentName
           , Object_Unit_View.isErased
           , False                         AS isSelect
       FROM Object_Unit_View
       WHERE Object_Unit_View.iserased = False 
         AND COALESCE (Object_Unit_View.ParentId, 0) <> 377612
         AND Object_Unit_View.Id <> 389328
         AND Object_Unit_View.Id <> COALESCE (inNotUnitId, 0)
         AND Object_Unit_View.Name NOT ILIKE 'Зачинена%'
         AND COALESCE (Object_Unit_View.ParentId, 0) IN 
             (SELECT DISTINCT U.Id FROM Object_Unit_View AS U WHERE U.isErased = False AND COALESCE (U.ParentId, 0) = 0) 
       ORDER BY Object_Unit_View.Name
      ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.06.22                                                       * 

*/

-- тест
-- 

SELECT * FROM gpSelect_Object_Unit_Active (inNotUnitId := 183292, inSession := '3')