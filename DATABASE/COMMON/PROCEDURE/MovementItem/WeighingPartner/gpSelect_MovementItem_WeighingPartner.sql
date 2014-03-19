-- Function: gpSelect_MovementItem_WeighingPartner()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WeighingPartner (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WeighingPartner(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Amount TFloat
             , InsertDate TDateTime, UpdateDate TDateTime
             , RealWeight TFloat, ChangePercentAmount TFloat, CountTare TFloat, WeightTare TFloat, Count TFloat
             , PartionGoodsDate TDateTime, PartionGoods TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , PriceListId  Integer, PriceListName  TVarChar
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingPartner());

     -- inShowAll:= TRUE;
     RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , MovementItem.Amount
           
           , MIDate_Insert.ValueData        AS InsertDate
           , MIDate_Update.ValueData        AS UpdateDate
           
           , MIFloat_RealWeight.ValueData          AS RealWeight
           , MIFloat_ChangePercentAmount.ValueData AS ChangePercentAmount
           , MIFloat_CountTare.ValueData           AS CountTare
           , MIFloat_WeightTare.ValueData          AS WeightTare
           , MIFloat_Count.ValueData               AS Count
           
           , MIDate_PartionGoods.ValueData   AS PartionGoodsDate
           , MIString_PartionGoods.ValueData AS PartionGoods

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName

           , Object_PriceList.Id        AS PriceListId
           , Object_PriceList.ValueData AS PriceListName
           
           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_Update
                                       ON MIDate_Update.MovementItemId = MovementItem.Id
                                      AND MIDate_Update.DescId = zc_MIDate_Update()
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                                                 
            LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                        ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()

            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                        ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()

            LEFT JOIN MovementItemFloat AS MIFloat_CountTare
                                        ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
                                       
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                        ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PriceList
                                             ON MILinkObject_PriceList.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PriceList.DescId = zc_MILinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MILinkObject_PriceList.ObjectId
            
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_WeighingPartner (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.03.14         *
*/

-- тест
--SELECT * FROM gpSelect_MovementItem_WeighingPartner (inMovementId:= 25173, inIsErased:= TRUE, inSession:= '2')