-- Function: gpSelect_Object_GoodsDocument(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsDocument(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsDocument(
    IN inGoodsId      Integer, 
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , FileName TVarChar) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsCondition());

   RETURN QUERY 
     SELECT 
           Object_GoodsDocument.Id        AS Id,
           Object_GoodsDocument.ValueData AS FileName
     FROM Object AS Object_GoodsDocument
          JOIN ObjectLink AS ObjectLink_GoodsDocument_Goods
            ON ObjectLink_GoodsDocument_Goods.ObjectId = Object_GoodsDocument.Id
           AND ObjectLink_GoodsDocument_Goods.DescId = zc_ObjectLink_GoodsDocument_Goods()
           AND ObjectLink_GoodsDocument_Goods.ChildObjectId = inGoodsId
     WHERE Object_GoodsDocument.DescId = zc_Object_GoodsDocument(); 
          
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsCondition ('2')