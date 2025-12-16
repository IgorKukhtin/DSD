-- Function: gpSelect_MI_Sale_PartionGoods_Q()

DROP FUNCTION IF EXISTS gpSelect_MI_WeighingPartner_PartionGoodsQ (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_Sale_PartionGoods_Q (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Sale_PartionGoods_Q(
    IN inMovementId_sale  Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat, AmountPartner TFloat
             , CountPack TFloat, WeightPack TFloat, BoxCount TFloat

             , PartionGoodsDate TDateTime
             , PartionGoods     TVarChar

             , PartionGoodsDate_q_1 TDateTime
             , PartionGoodsDate_q_2 TDateTime
             , PartionGoodsDate_q_3 TDateTime
             , PartionGoodsDate_q_4 TDateTime
             , PartionGoodsDate_q_5 TDateTime
             , PartionGoodsDate_q_6 TDateTime
             , PartionGoodsDate_q_7 TDateTime
             , PartionGoodsDate_q_8 TDateTime
             , PartionGoodsDate_q_9 TDateTime
             , PartionGoodsDate_q_10 TDateTime

             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId          Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Sale());


     -- Результат
     RETURN QUERY
     WITH tmpMI_1 AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount                           AS Amount
                           , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner

                           , COALESCE (MIFloat_CountPack.ValueData, 0)     AS CountPack
                           , MIFloat_WeightPack.ValueData                  AS WeightPack
                           , MIFloat_BoxCount.ValueData                    AS BoxCount

                           , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())          AS PartionGoodsDate
                           , COALESCE (MIString_PartionGoods.ValueData, '')                    AS PartionGoods

                           , COALESCE (MIDate_PartionGoods_q_1.ValueData, zc_DateStart())      AS PartionGoodsDate_q_1
                           , COALESCE (MIDate_PartionGoods_q_2.ValueData, zc_DateStart())      AS PartionGoodsDate_q_2
                           , COALESCE (MIDate_PartionGoods_q_3.ValueData, zc_DateStart())      AS PartionGoodsDate_q_3
                           , COALESCE (MIDate_PartionGoods_q_4.ValueData, zc_DateStart())      AS PartionGoodsDate_q_4
                           , COALESCE (MIDate_PartionGoods_q_5.ValueData, zc_DateStart())      AS PartionGoodsDate_q_5
                           , COALESCE (MIDate_PartionGoods_q_6.ValueData, zc_DateStart())      AS PartionGoodsDate_q_6
                           , COALESCE (MIDate_PartionGoods_q_7.ValueData, zc_DateStart())      AS PartionGoodsDate_q_7
                           , COALESCE (MIDate_PartionGoods_q_8.ValueData, zc_DateStart())      AS PartionGoodsDate_q_8
                           , COALESCE (MIDate_PartionGoods_q_9.ValueData, zc_DateStart())      AS PartionGoodsDate_q_9
                           , COALESCE (MIDate_PartionGoods_q_10.ValueData, zc_DateStart())     AS PartionGoodsDate_q_10

                           , MovementItem.isErased

                     FROM MovementItem

                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                     ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q_1
                                                     ON MIDate_PartionGoods_q_1.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods_q_1.DescId         = zc_MIDate_PartionGoods_q_1()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q_2
                                                     ON MIDate_PartionGoods_q_2.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods_q_2.DescId         = zc_MIDate_PartionGoods_q_2()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q_3
                                                     ON MIDate_PartionGoods_q_3.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods_q_3.DescId         = zc_MIDate_PartionGoods_q_3()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q_4
                                                     ON MIDate_PartionGoods_q_4.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods_q_4.DescId         = zc_MIDate_PartionGoods_q_4()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q_5
                                                     ON MIDate_PartionGoods_q_5.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods_q_5.DescId         = zc_MIDate_PartionGoods_q_5()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q_6
                                                     ON MIDate_PartionGoods_q_6.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods_q_6.DescId         = zc_MIDate_PartionGoods_q_6()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q_7
                                                     ON MIDate_PartionGoods_q_7.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods_q_7.DescId         = zc_MIDate_PartionGoods_q_7()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q_8
                                                     ON MIDate_PartionGoods_q_8.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods_q_8.DescId         = zc_MIDate_PartionGoods_q_8()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q_9
                                                     ON MIDate_PartionGoods_q_9.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods_q_9.DescId         = zc_MIDate_PartionGoods_q_9()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q_10
                                                     ON MIDate_PartionGoods_q_10.MovementItemId = MovementItem.Id
                                                    AND MIDate_PartionGoods_q_10.DescId         = zc_MIDate_PartionGoods_q_10()

                          LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                       ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                      AND MIString_PartionGoods.DescId         = zc_MIString_PartionGoods()

                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                          LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                      ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountPack.DescId         = zc_MIFloat_CountPack()
                          LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                                      ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                                     AND MIFloat_WeightPack.DescId         = zc_MIFloat_WeightPack()
                          LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                      ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                     AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                    WHERE MovementItem.MovementId = inMovementId_sale -- vbMovementId_sale
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                   )
         -- Результат
         SELECT
               tmpMI.MovementItemId :: Integer  AS Id
             , Object_Goods.Id                  AS GoodsId
             , Object_Goods.ObjectCode          AS GoodsCode
             , Object_Goods.ValueData           AS GoodsName
             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

             , tmpMI.Amount        :: TFloat    AS Amount
             , tmpMI.AmountPartner :: TFloat    AS AmountPartner

             , tmpMI.CountPack    :: TFloat     AS CountPack
             , tmpMI.WeightPack   :: TFloat     AS WeightPack
             , tmpMI.BoxCount     :: TFloat     AS BoxCount

             , CASE WHEN tmpMI.PartionGoodsDate  = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate  END :: TDateTime AS PartionGoodsDate
             , tmpMI.PartionGoods      :: TVarChar  AS PartionGoods

             , CASE WHEN tmpMI.PartionGoodsDate_q_1  = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q_1  END :: TDateTime AS PartionGoodsDate_q_1
             , CASE WHEN tmpMI.PartionGoodsDate_q_2  = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q_2  END :: TDateTime AS PartionGoodsDate_q_2
             , CASE WHEN tmpMI.PartionGoodsDate_q_3  = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q_3  END :: TDateTime AS PartionGoodsDate_q_3
             , CASE WHEN tmpMI.PartionGoodsDate_q_4  = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q_4  END :: TDateTime AS PartionGoodsDate_q_4
             , CASE WHEN tmpMI.PartionGoodsDate_q_5  = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q_5  END :: TDateTime AS PartionGoodsDate_q_5
             , CASE WHEN tmpMI.PartionGoodsDate_q_6  = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q_6  END :: TDateTime AS PartionGoodsDate_q_6
             , CASE WHEN tmpMI.PartionGoodsDate_q_7  = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q_7  END :: TDateTime AS PartionGoodsDate_q_7
             , CASE WHEN tmpMI.PartionGoodsDate_q_8  = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q_8  END :: TDateTime AS PartionGoodsDate_q_8
             , CASE WHEN tmpMI.PartionGoodsDate_q_9  = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q_9  END :: TDateTime AS PartionGoodsDate_q_9
             , CASE WHEN tmpMI.PartionGoodsDate_q_10 = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q_10 END :: TDateTime AS PartionGoodsDate_q_10

             , Object_GoodsKind.Id             AS GoodsKindId
             , Object_GoodsKind.ValueData      AS GoodsKindName
             , Object_Measure.ValueData        AS MeasureName

             , tmpMI.isErased

         FROM tmpMI_1 AS tmpMI
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id         = tmpMI.GoodsId
              LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                   ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
              LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

              LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                     ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                    AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.11.25         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_Sale_PartionGoods_Q (inMovementId_sale := 29774297  , inShowAll := 'False' , inIsErased := 'False', inSession := '5');
