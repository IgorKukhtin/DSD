-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BranchLink (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BranchLink(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, BranchLinkName TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     -- Результат
     RETURN QUERY 
         SELECT Object_BranchLink_View.id,
                Object_BranchLink_View.BranchLinkName
       FROM Object_BranchLink_View;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.08.14                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsByGoodsKind1CLink (zfCalc_UserAdmin()) WHERE Code = 