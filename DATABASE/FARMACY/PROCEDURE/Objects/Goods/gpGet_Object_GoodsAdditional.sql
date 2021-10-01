-- Function: gpGet_Object_GoodsAdditional()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsAdditional(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsAdditional(
    IN inId          Integer,       -- Код товара
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsMainId Integer, Code Integer, Name TVarChar
             , isErased Boolean
             , NameUkr TVarChar
             , MakerName TVarChar
             , FormDispensingId Integer
             , FormDispensingName TVarChar
             , NumberPlates Integer
             , QtyPackage Integer
             , isRecipe boolean
              ) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
     -- Маркетинговый контракт

      SELECT Object_Goods_Retail.Id
           , Object_Goods_Retail.GoodsMainId
           , Object_Goods_Main.ObjectCode                                             AS GoodsCodeInt
           , Object_Goods_Main.Name                                                   AS GoodsName
           , Object_Goods_Retail.isErased
           , Object_Goods_Main.NameUkr

           , Object_Goods_Main.MakerName
           , Object_Goods_Main.FormDispensingId
           , Object_FormDispensing.ValueData                                          AS FormDispensingName
           , Object_Goods_Main.NumberPlates
           , Object_Goods_Main.QtyPackage
           , Object_Goods_Main.isRecipe

      FROM Object_Goods_Retail

           LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

           LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = Object_Goods_Main.FormDispensingId
           
      WHERE Object_Goods_Retail.Id = inId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Goods_Retail(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 30.09.21                                                      *
*/

-- тест

select * from gpGet_Object_GoodsAdditional(inId := 1528417  , inSession := '3');