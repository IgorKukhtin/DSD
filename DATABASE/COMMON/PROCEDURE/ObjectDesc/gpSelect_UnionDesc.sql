--Function: gpSelect_UnionDesc(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_UnionDesc(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_UnionDesc(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code TVarChar, Name TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());

     RETURN QUERY 
    SELECT 
           ObjectDesc.Id,
           ObjectDesc.Code,
           ObjectDesc.ItemName 
      FROM ObjectDesc
     UNION
    SELECT 
           ObjectLinkDesc.Id,
           ObjectLinkDesc.Code,
           ObjectLinkDesc.ItemName 
      FROM ObjectLinkDesc
     UNION
    SELECT 
           MovementLinkObjectDesc.Id,
           MovementLinkObjectDesc.Code,
           MovementLinkObjectDesc.ItemName 
      FROM MovementLinkObjectDesc
     UNION
    SELECT 
           MovementItemLinkObjectDesc.Id,
           MovementItemLinkObjectDesc.Code,
           MovementItemLinkObjectDesc.ItemName 
      FROM MovementItemLinkObjectDesc;

  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_UnionDesc(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_ObjectDesc('2')