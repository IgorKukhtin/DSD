/*ReceiptGoodsForm - в закладке "Шаблон" - еще одна кнопка "***Добавить" - открывается точно такая же эдит форма - с возможностью ввода в гриде группа товара + название товара - в проц-ке insert gooods и формируется zc_ObjectString_Article = AGL + код группы + последний код в Article из этой группы + 1, т.е. был AGL-33-255 новый должен быть AGL-33-256, потом insert zc_Object_ReceiptGoods
*/
-- Function: gpSelect_Object_GoodsChild()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsChild (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsChild(
    IN inGoodsId     Integer,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Article TVarChar
             , ProdColorId Integer, ProdColorName TVarChar, Color_Value Integer
             , Value TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPriceWithVAT Boolean;
BEGIN

        -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_Goods());
     vbUserId:= lpGetUserBySession (inSession);


     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     -- Результат
     RETURN QUERY


     select Object_Goods.Id                                        AS Id
          , Object_Goods.ObjectCode                                AS Code
          , SUBSTRING (Object_Goods.ValueData, 1, 128) :: TVarChar AS Name
          , ObjectString_Article.ValueData             :: TVarChar AS Article
          , Object_ProdColor.Id                                    AS ProdColorId
          , Object_ProdColor.ValueData                             AS ProdColorName 
            , COALESCE(ObjectFloat_ProdColor_Value.ValueData, zc_Color_White())::Integer  AS Color_Value
          , ObjectFloat_Value.ValueData                ::TFloat    AS Value
     from ObjectLink AS ObjectLink_ReceiptGoods_Object
          INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = ObjectLink_ReceiptGoods_Object.ObjectId
                               AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
          INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_Object
                                ON ObjectLink_ReceiptGoodsChild_Object.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                               AND ObjectLink_ReceiptGoodsChild_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
     
     	 JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_ReceiptGoodsChild_Object.ChildObjectId
     
         LEFT JOIN ObjectString AS ObjectString_Article
                                ON ObjectString_Article.ObjectId = Object_Goods.Id
                               AND ObjectString_Article.DescId = zc_ObjectString_Article()
         LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                              ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
         LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
         LEFT JOIN ObjectFloat AS ObjectFloat_ProdColor_Value
                               ON ObjectFloat_ProdColor_Value.ObjectId = Object_ProdColor.Id
                              AND ObjectFloat_ProdColor_Value.DescId   = zc_ObjectFloat_ProdColor_Value()

         LEFT JOIN ObjectFloat AS ObjectFloat_Value
                               ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value() 

     WHERE ObjectLink_ReceiptGoods_Object.DescId = zc_ObjectLink_ReceiptGoods_Object()
     AND ObjectLink_ReceiptGoods_Object.ChildObjectId = inGoodsId -- 236732   
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsChild (inGoodsId:= 236732, inSession := zfCalc_UserAdmin())
