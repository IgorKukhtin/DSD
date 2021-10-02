--Function: gpSelect_Object(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementDesc(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementDesc(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, DocumentDesc TVarChar, DocumentName TVarChar, FormId Integer, FormName TVarChar)
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());

   RETURN QUERY 
   SELECT 
        MovementDesc.Id,
        MovementDesc.Code,
        MovementDesc.ItemName,
        Object.Id, 
        Object.ValueData

   FROM MovementDesc
        LEFT JOIN Object ON Object.Id = MovementDesc.FormId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.01.14                         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementDesc('2')
