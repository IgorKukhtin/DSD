-- Function: gpSelect_MI_WeighingPartner_PartionGoodsQ()

DROP FUNCTION IF EXISTS gpSelect_MI_WeighingPartner_PartionGoodsQ (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_WeighingPartner_PartionGoodsQ(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , Amount TFloat, AmountPartner TFloat
             , CountPack TFloat, WeightPack TFloat
             , PartionGoodsDate TVarChar, PartionGoodsDate_q TDateTime, PartionGoodsDate_q_old TDateTime
             , PartionGoods TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingPartner());

/*if inSession <> '5' AND inShowAll = TRUE
then
    RAISE EXCEPTION 'Ошибка.Повторите действие через 3 мин.';
end if;*/


     -- inShowAll:= TRUE;
     RETURN QUERY

   WITH tmpMIList AS (SELECT MovementItem.Id AS MovementItemId
                           , MovementItem.*
                           , MovementItem.isErased AS isErasedMI
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                     )

, tmpMI_1 AS (SELECT MovementItem.Id                               AS MovementItemId
                   , MovementItem.ObjectId                         AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , MovementItem.Amount                           AS Amount
                   , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner

                   , COALESCE (MIFloat_CountPack.ValueData, 0)     AS CountPack
                   , MIFloat_WeightPack.ValueData                  AS WeightPack

                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())          AS PartionGoodsDate
                   , COALESCE (MIDate_PartionGoods_q.ValueData, zc_DateStart())        AS PartionGoodsDate_q
                   , COALESCE (MIString_PartionGoods.ValueData, '')                    AS PartionGoods

                   , MovementItem.isErased

             FROM Movement
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.ParentId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE

                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q
                                             ON MIDate_PartionGoods_q.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods_q.DescId         = zc_MIDate_PartionGoods_q()

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

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
            WHERE MovementId = inMovementId
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

           , tmpMI.PartionGoodsDate    :: TVarChar AS PartionGoodsDate
           , CASE WHEN tmpMI.PartionGoodsDate_q = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q END :: TDateTime AS PartionGoodsDate_q
           , CASE WHEN tmpMI.PartionGoodsDate_q = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q END :: TDateTime AS PartionGoodsDate_q_old
           , tmpMI.PartionGoods :: TVarChar AS PartionGoods

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
-- SELECT * FROM gpSelect_MI_WeighingPartner_PartionGoodsQ(inMovementId := 29774297  , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '9457');
