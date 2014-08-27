-- Function: gpSelect_Object_AlternativeGoodsCode(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_AdditionalGoods(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AdditionalGoods(
    IN inRetailId    Integer,       -- Торговая сеть
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer             
             , GoodsId Integer, GoodsName TVarChar    
             ) AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AdditionalGoods());

   RETURN QUERY 
     SELECT 
           Object_AdditionalGoods_View.Id               
         , Object_AdditionalGoods_View.GoodsMainId
         , Object_AdditionalGoods_View.GoodsId
         , Object_AdditionalGoods_View.GoodsName
         
     FROM Object_AdditionalGoods_View
           
     WHERE Object_AdditionalGoods_View.RetailId = inRetailId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AdditionalGoods (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.08.14                        *
 02.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_AdditionalGoods ('2')
