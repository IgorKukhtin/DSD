-- Function: gpSelect_Object_PartionGoods()


DROP FUNCTION IF EXISTS gpSelect_Object_PartionGoods (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionGoods(
    IN inGoodsId      Integer   ,
    IN inUnitId       Integer   ,
    IN inShowAll      Boolean   ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id  Integer
             , MovementId_ Integer
             , DescName TVarChar
             , InvNumber TVarChar
             , OperDate Tdatetime 
  
             , UnitId Integer
             , UnitName TVarChar
             , PartnerName TVarChar
             , GoodsId Integer
             , GoodsCode Integer
             , GoodsName TVarChar
             , Article TVarChar
             , PartNumber TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , MeasureName TVarChar
             , GoodsTagName TVarChar
             , GoodsTypeName TVarChar
             , ProdColorName TVarChar
             , TaxKindName TVarChar
             , GoodsSizeName TVarChar
             
             , EKPrice TFloat
             , CountForPrice TFloat
             , CostPrice     TFloat
             , OperPrice_cost TFloat
             , OperPriceList  TFloat
             , Amount_in TFloat
             , isErased Boolean
              ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartionGoods());

     RETURN QUERY 
  
   --остатки
   WITH
     tmpPriceBasis AS (SELECT tmp.GoodsId
                            , tmp.ValuePrice
                       FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                , inOperDate   := CURRENT_DATE) AS tmp
                       WHERE (tmp.GoodsId = inGoodsId OR inGoodsId = 0)
                       )

   , tmpObject_PartionGoods AS (SELECT Object_PartionGoods.*
                                FROM Object_PartionGoods
                                WHERE (Object_PartionGoods.ObjectId = inGoodsId OR inGoodsId = 0)
                                  AND (Object_PartionGoods.UnitId = inUnitId OR inUnitId = 0)
                                  AND (Object_PartionGoods.isErased = FALSE OR inShowAll = TRUE)
                                )
--
     SELECT  tmpObject_PartionGoods.MovementItemId AS Id
           , tmpObject_PartionGoods.MovementId AS MovementId
           , MovementDesc_Partion.ItemName     AS DescName
           , Movement_Partion.InvNumber        AS InvNumber
           , Movement_Partion.OperDate         AS OperDate
           
           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , Object_Partner.ValueData       AS PartnerName

           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Article.ValueData AS Article
           , MIString_PartNumber.ValueData ::TVarChar AS PartNumber
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName

           , Object_GoodsTag.ValueData      AS GoodsTagName
           , Object_GoodsType.ValueData     AS GoodsTypeName
           , Object_ProdColor.ValueData     AS ProdColorName
           , Object_TaxKind.ValueData       AS TaxKindName
           , Object_GoodsSize.ValueData     AS GoodsSizeName
           
           , tmpObject_PartionGoods.EKPrice
           , tmpObject_PartionGoods.CountForPrice
             -- Цена без НДС затраты
           , tmpObject_PartionGoods.CostPrice     ::TFloat
             -- Цена вх. с затратами без НДС
           , (tmpObject_PartionGoods.EKPrice / tmpObject_PartionGoods.CountForPrice + COALESCE (tmpObject_PartionGoods.CostPrice,0) ) ::TFloat AS OperPrice_cost
           , COALESCE (tmpPriceBasis.ValuePrice, tmpObject_PartionGoods.OperPriceList) AS OperPriceList
           , tmpObject_PartionGoods.Amount     AS Amount_in
           , tmpObject_PartionGoods.isErased
 
     FROM tmpObject_PartionGoods
            LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = tmpObject_PartionGoods.UnitId
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpObject_PartionGoods.FromId
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpObject_PartionGoods.ObjectId

            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpObject_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpObject_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = tmpObject_PartionGoods.GoodsTagId
            LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = tmpObject_PartionGoods.GoodsTypeId
            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = tmpObject_PartionGoods.ProdColorId
            LEFT JOIN Object AS Object_TaxKind    ON Object_TaxKind.Id    = tmpObject_PartionGoods.TaxKindId
            LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = tmpObject_PartionGoods.GoodsSizeId


            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpObject_PartionGoods.ObjectId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpObject_PartionGoods.ObjectId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()

            LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = tmpObject_PartionGoods.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId

            LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpObject_PartionGoods.ObjectId
 
            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = tmpObject_PartionGoods.MovementItemId
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14         *
*/

-- тест
--  select * from gpSelect_Object_PartionGoods(inGoodsId := 19757 , inUnitId := 38874 , inShowAll := 'False' ,  inSession := '5');