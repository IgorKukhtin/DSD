-- Function: gpGet_MIInventory_Partion_byBarcode()

DROP FUNCTION IF EXISTS gpGet_MIInventory_Partion_byBarcode (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MIInventory_Partion_byBarcode(
    IN inBarCode           TVarChar   , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (PartionId          Integer
             , GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , GoodsGroupNameFull TVarChar
             , LabelId            Integer
             , LabelName          TVarChar
             , GoodsSizeId        Integer
             , GoodsSizeName      TVarChar
             , PartnerId          Integer
             , PartnerName        TVarChar
             , OperPriceList      TFloat
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbClientId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY

       SELECT tmp.PartionId                  AS PartionId
            , Object_Goods.Id                AS GoodsId
            , Object_Goods.ObjectCode        AS GoodsCode
            , Object_Goods.ValueData         AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Label.Id                AS LabelId
            , Object_Label.ValueData         AS LabelName
            , Object_GoodsSize.Id            AS GoodsSizeId
            , Object_GoodsSize.ValueData     AS GoodsSizeName
            , Object_Partner.ObjectCode      AS PartnerId
            , Object_Partner.ValueData       AS PartnerName
            , tmp.OperPriceList    :: TFloat AS OperPriceList
       FROM gpGet_MISale_Partion_byBarCode (inBarCode, inSession) AS tmp
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
            LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = tmp.GoodsSizeId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmp.PartionId
            
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Object_PartionGoods.PartnerId
            LEFT JOIN Object AS Object_Label   ON Object_Label.Id   = Object_PartionGoods.LabelId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmp.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 11.04.18         *
*/

-- тест
-- SELECT * FROM gpGet_MIInventory_Partion_byBarcode (inMovementId := 0, inBarCode:= '2010002606122'::TVarChar, inSession:= zfCalc_UserAdmin());
-- select * from gpGet_MIInventory_Partion_byBarcode(inMovementId := 278127 , inBarCode := '74860575060024' ::TVarChar,  inSession := '2' ::TVarChar);
