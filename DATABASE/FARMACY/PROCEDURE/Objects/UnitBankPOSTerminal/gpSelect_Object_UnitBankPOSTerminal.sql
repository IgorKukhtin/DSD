-- Function: gpSelect_Object_UnitBankPOSTerminal()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitBankPOSTerminal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitBankPOSTerminal (
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, JuridicalName TVarChar
              ) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
       SELECT 
              Object_Unit_View.ID,
              Object_Unit_View.Code,
              Object_Unit_View.Name,
              Object_Unit_View.JuridicalName
       FROM Object_Unit_View
       WHERE COALESCE (ParentId, 0) <> 0
       ORDER BY JuridicalName, Code;
  

END;
$BODY$


LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.02.19                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitBankPOSTerminal('3')
