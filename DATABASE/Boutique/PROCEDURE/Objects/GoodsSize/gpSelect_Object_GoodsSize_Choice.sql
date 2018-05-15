-- Function: gpSelect_Object_GoodsSize_Choice (Bolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsSize_Choice (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsSize_Choice (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsSize_Choice(
    IN inGoodsId     Integer,
    IN inGoodsCode   Integer,
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (Id          Integer
             , Code        Integer
             , Name        TVarChar
 ) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsItem());
     vbUserId:= lpGetUserBySession (inSession);
  
     -- Если Ид товара нет тогда определяем товар по коду
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         inGoodsId := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DESCId = zc_Object_Goods());
         --проверка
         IF COALESCE (inGoodsId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Товар с кодом <%> не найден.', inGoodsCode; 
         END IF;        

     END IF;
      
     -- Результат
     RETURN QUERY 
       SELECT DISTINCT
             Object_GoodsSize.Id            AS id
           , Object_GoodsSize.ObjectCode    AS Code
           , Object_GoodsSize.ValueData     AS Name
       
       FROM Object_PartionGoods 
            LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = Object_PartionGoods.GoodsSizeId
       WHERE Object_PartionGoods.GoodsId = inGoodsId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
14.05.17          * add inGoodsCode
30.06.17          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsSize_Choice (0, 102330, zfCalc_UserAdmin())