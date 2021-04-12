-- Function: gpSelect_MI_Invoice_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderClient_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderClient_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, DescName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , Amount TFloat, AmountPartner TFloat
             , OperPrice TFloat
             , isErased Boolean
             , Article TVarChar
             , UnitName_in TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , MeasureName TVarChar
             , GoodsTagName   TVarChar
             , GoodsTypeName  TVarChar
             , ProdColorName  TVarChar
             , TaxKindName    TVarChar
             , Amount_in      TFloat -- Итого кол-во Приход от поставщика
             , EKPrice        TFloat -- Цена вх.
             , CountForPrice  TFloat -- Кол. в цене вх.
             , OperPriceList  TFloat -- Цена по прайсу  
             , CostPrice      TFloat -- Цена вх + затрата 
             , OperPrice_cost TFloat -- сумма затраты
             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

      RETURN QUERY
        SELECT
             MovementItem.Id                          AS Id
           , Object_Goods.Id                          AS GoodsId
           , Object_Goods.ObjectCode                  AS GoodsCode
           , Object_Goods.ValueData                   AS GoodsName
           , Object_Unit.Id                           AS UnitId
           , Object_Unit.ValueData                    AS UnitName 
           , Object_Partner.Id                        AS PartnerId
           , Object_Partner.ValueData                 AS PartnerName 
           , MovementItem.Amount             ::TFloat AS Amount            --Количество резерв
           , MIFloat_AmountPartner.ValueData ::TFloat AS AmountPartner     --Количество заказ поставщику
           , MIFloat_OperPrice.ValueData     ::TFloat AS OperPrice         -- Цена вх без НДС
           , MovementItem.isErased

           , ObjectString_Article.ValueData AS Article
           , Object_Unit_in.ValueData       AS UnitName_in
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName
           , Object_GoodsTag.ValueData      AS GoodsTagName
           , Object_GoodsType.ValueData     AS GoodsTypeName
           , Object_ProdColor.ValueData     AS ProdColorName
           , Object_TaxKind.ValueData       AS TaxKindName
           , Object_PartionGoods.Amount     AS Amount_in
           , Object_PartionGoods.EKPrice
           , Object_PartionGoods.CountForPrice
           , Object_PartionGoods.OperPriceList ::TFloat                                                                                                     -- Цена по прайсу
           , Object_PartionGoods.CostPrice     ::TFloat                                                                                                     -- Цена затраты без НДС 
           , (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice,0) ) ::TFloat AS OperPrice_cost     -- Цена вх. с затратами без НДС
                           
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                             ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_Goods.Id
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                 ON ObjectLink_ProdColor.ObjectId = Object_Goods.Id
                                AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsTag
                                 ON ObjectLink_GoodsTag.ObjectId = Object_Goods.Id
                                AND ObjectLink_GoodsTag.DescId   = zc_ObjectLink_Goods_GoodsTag()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsType
                                 ON ObjectLink_GoodsType.ObjectId = Object_Goods.Id
                                AND ObjectLink_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
            LEFT JOIN ObjectLink AS ObjectLink_Measure
                                 ON ObjectLink_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            --
            LEFT JOIN Object AS Object_Unit_in    ON Object_Unit_in.Id    = Object_PartionGoods.UnitId

            LEFT JOIN Object AS Object_Partner    ON Object_Partner.Id    = COALESCE (Object_PartionGoods.FromId, MILinkObject_Partner.ObjectId)
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = COALESCE (Object_PartionGoods.GoodsGroupId, ObjectLink_GoodsGroup.ChildObjectId)
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = COALESCE (Object_PartionGoods.MeasureId, ObjectLink_Measure.ChildObjectId)
            LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = COALESCE (Object_PartionGoods.GoodsTagId, ObjectLink_GoodsTag.ChildObjectId)
            LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = COALESCE (Object_PartionGoods.GoodsTypeId, ObjectLink_GoodsType.ChildObjectId)
            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = COALESCE (Object_PartionGoods.ProdColorId, ObjectLink_ProdColor.ChildObjectId)
            LEFT JOIN Object AS Object_TaxKind    ON Object_TaxKind.Id    = Object_PartionGoods.TaxKindId
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 18.07.16         * 
*/

-- тест
-- SELECT * from gpSelect_MI_OrderClient_Child (0,False, '3');
