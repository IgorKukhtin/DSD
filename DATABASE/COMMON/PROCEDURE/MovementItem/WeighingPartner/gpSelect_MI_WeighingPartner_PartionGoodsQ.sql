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
             , Amount TFloat, Amount_mi TFloat, AmountPartner TFloat, AmountPartnerSecond TFloat, SummPartner TFloat, AmountPartner_mi TFloat 
             , CountTare TFloat
             
             , WeightPack TFloat
             , Count TFloat, Count_mi TFloat, HeadCount TFloat, HeadCount_mi TFloat, BoxCount TFloat, BoxCount_mi TFloat
             , LevelNumber TFloat
             , PartionGoodsDate TVarChar, PartionGoodsDate_q TDateTime, PartionGoodsDate_q_old TDateTime
             , PartionGoods TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , Comment TVarChar 
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

, tmpMI_1 AS (SELECT CASE WHEN inShowAll = TRUE THEN MovementItem.Id ELSE 0 END :: Integer AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId
                  , MovementItem.Amount
                  , 0 AS Amount_mi

                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner   
                  , COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0) AS AmountPartnerSecond
                  , 0                                             AS AmountPartner_mi

                  , COALESCE (MIFloat_CountTare.ValueData, 0)           AS CountTare
                  , CASE WHEN inShowAll = TRUE THEN COALESCE (MIFloat_WeightTare.ValueData, 0) ELSE 0 END AS WeightTare

                  , CASE WHEN COALESCE (MIFloat_WeightPack.ValueData,0) > 0 THEN 0 ELSE COALESCE (MIFloat_CountPack.ValueData, 0) END AS CountPack
                  , 0 AS CountPack_mi
                  , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                  , 0 AS HeadCount_mi
                  , COALESCE (MIFloat_BoxCount.ValueData, 0)            AS BoxCount
                  , 0 AS BoxCount_mi

                  , MIFloat_WeightPack.ValueData  ::TFloat AS WeightPack

                  , COALESCE (MIFloat_LevelNumber.ValueData, 0) AS LevelNumber

                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())  ::TDateTime AS PartionGoodsDate
                  , COALESCE (MIDate_PartionGoods_q.ValueData, zc_DateStart())::TDateTime AS PartionGoodsDate_q
                  
                  , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods
                  
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
           

                  , MovementItem.isErased
                  
                  , COALESCE (MIFloat_SummPartner.ValueData,0)                ::TFloat    AS SummPartner 
                  , COALESCE (MIString_Comment.ValueData, '')                 :: TVarChar AS Comment
                  
             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                  INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = tmpIsErased.isErased

                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q
                                             ON MIDate_PartionGoods_q.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods_q.DescId = zc_MIDate_PartionGoods_q()

                  LEFT JOIN MovementItemString AS MIString_PartionGoods
                                               ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                              AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                  LEFT JOIN MovementItemString AS MIString_Comment
                                               ON MIString_Comment.MovementItemId = MovementItem.Id
                                              AND MIString_Comment.DescId = zc_MIString_Comment()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                              ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummPartner.DescId = zc_MIFloat_SummPartner()

                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                              ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountTare
                                              ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                              ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

                  LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                              ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                              ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack()
                  LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

                  LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                              ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                  LEFT JOIN MovementItemFloat AS MIFloat_LevelNumber
                                              ON MIFloat_LevelNumber.MovementItemId = MovementItem.Id
                                             AND MIFloat_LevelNumber.DescId = zc_MIFloat_LevelNumber()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

         /*   UNION ALL
             SELECT CASE WHEN inShowAll = TRUE THEN MovementItem.Id ELSE 0 END :: Integer AS MovementItemId
                  , MovementItem.ObjectId AS GoodsId

                  , 0 AS Amount
                  , MovementItem.Amount AS Amount_mi

                  , 0                                             AS AmountPartner
                  , 0                                             AS AmountPartnerSecond
                  , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner_mi

                  , 0 AS CountTare
                  , 0 AS WeightTare

                  , 0                                         AS CountPack
                  , CASE WHEN COALESCE (MIFloat_WeightPack.ValueData,0) > 0 THEN 0 ELSE COALESCE (MIFloat_CountPack.ValueData, 0) END AS CountPack_mi
                  , 0                                         AS HeadCount
                  , COALESCE (MIFloat_HeadCount.ValueData, 0) AS HeadCount_mi
                  , 0                                         AS BoxCount
                  , COALESCE (MIFloat_BoxCount.ValueData, 0)  AS BoxCount_mi

                  , 0 AS WeightPack

                  , 0 AS LevelNumber

                  , MIDate_PartionGoods.ValueData                                          AS PartionGoodsDate
                  , COALESCE (MIDate_PartionGoods_q.ValueData, zc_DateStart()) ::TDateTime AS PartionGoodsDate_q
                  , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods

                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  
                  , MovementItem.isErased
                 
                  , COALESCE (MIFloat_SummPartner.ValueData,0)                ::TFloat    AS SummPartner 
                  , COALESCE (MIString_Comment.ValueData, '')                 :: TVarChar AS Comment

             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                  INNER JOIN Movement ON Movement.Id = inMovementId
                                     AND inShowAll = FALSE
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.ParentId
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = tmpIsErased.isErased

                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods_q
                                             ON MIDate_PartionGoods_q.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods_q.DescId = zc_MIDate_PartionGoods_q()

                  LEFT JOIN MovementItemString AS MIString_PartionGoods
                                               ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                              AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                  LEFT JOIN MovementItemString AS MIString_Comment
                                               ON MIString_Comment.MovementItemId = MovementItem.Id
                                              AND MIString_Comment.DescId = zc_MIString_Comment()

                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                  LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                              ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_SummPartner.DescId = zc_MIFloat_SummPartner()

                  LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                              ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                  LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                              ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack()
                  LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

                  LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                              ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
        */

            ) 

       -- Результат     
       SELECT
             tmpMI.MovementItemId :: Integer  AS Id
           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.Amount :: TFloat           AS Amount
           , tmpMI.Amount_mi :: TFloat        AS Amount_mi

           , CASE WHEN tmpMI.AmountPartner = 0 THEN NULL ELSE tmpMI.AmountPartner END :: TFloat  AS AmountPartner
           , tmpMI.AmountPartnerSecond                                                :: TFloat  AS AmountPartnerSecond 
           , tmpMI.SummPartner                                                        :: TFloat  AS SummPartner
           
           , CASE WHEN tmpMI.AmountPartner_mi = 0 THEN NULL ELSE tmpMI.AmountPartner_mi END :: TFloat AS AmountPartner_mi

           , tmpMI.CountTare   :: TFloat      AS CountTare

           , tmpMI.WeightPack   :: TFloat   AS WeightPack

           , CASE WHEN tmpMI.CountPack = 0    THEN NULL ELSE tmpMI.CountPack    END :: TFloat AS Count
           , CASE WHEN tmpMI.CountPack_mi = 0 THEN NULL ELSE tmpMI.CountPack_mi END :: TFloat AS Count_mi
           , CASE WHEN tmpMI.HeadCount = 0    THEN NULL ELSE tmpMI.HeadCount    END :: TFloat AS HeadCount
           , CASE WHEN tmpMI.HeadCount_mi = 0 THEN NULL ELSE tmpMI.HeadCount_mi END :: TFloat AS HeadCount_mi
           , CASE WHEN tmpMI.BoxCount = 0     THEN NULL ELSE tmpMI.BoxCount     END :: TFloat AS BoxCount
           , CASE WHEN tmpMI.BoxCount_mi = 0  THEN NULL ELSE tmpMI.BoxCount_mi  END :: TFloat AS BoxCount_mi

           , CASE WHEN tmpMI.LevelNumber = 0 THEN NULL ELSE tmpMI.LevelNumber END :: TFloat AS LevelNumber

           , tmpMI.PartionGoodsDate    :: TVarChar AS PartionGoodsDate
           , CASE WHEN tmpMI.PartionGoodsDate_q = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q END :: TDateTime AS PartionGoodsDate_q
           , CASE WHEN tmpMI.PartionGoodsDate_q = zc_DateStart() THEN NULL ELSE tmpMI.PartionGoodsDate_q END :: TDateTime AS PartionGoodsDate_q_old
           , tmpMI.PartionGoods :: TVarChar AS PartionGoods

           , Object_GoodsKind.Id             AS GoodsKindId
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , tmpMI.Comment    ::TVarChar
                      
           , tmpMI.isErased

       FROM (SELECT tmpMI.MovementItemId
                  , tmpMI.GoodsId
                  , SUM (tmpMI.Amount)           AS Amount
                  , SUM (tmpMI.Amount_mi)        AS Amount_mi
                  , SUM (tmpMI.AmountPartner)    AS AmountPartner
                  , SUM (tmpMI.AmountPartnerSecond) AS AmountPartnerSecond
                  , SUM (tmpMI.AmountPartner_mi) AS AmountPartner_mi
                  , SUM (tmpMI.SummPartner)      AS SummPartner

                  , SUM (tmpMI.CountTare)      AS CountTare

                  , SUM (tmpMI.CountPack)      AS CountPack
                  , SUM (tmpMI.CountPack_mi)   AS CountPack_mi
                  , SUM (tmpMI.HeadCount)      AS HeadCount
                  , SUM (tmpMI.HeadCount_mi)   AS HeadCount_mi
                  , SUM (tmpMI.BoxCount)       AS BoxCount
                  , SUM (tmpMI.BoxCount_mi)    AS BoxCount_mi
                  
               
                  , SUM (tmpMI.WeightPack)     AS WeightPack

                  , MAX (tmpMI.LevelNumber)    AS LevelNumber -- MAX

                  , STRING_AGG (DISTINCT tmpMI.PartionGoodsDate::TVarChar, ';') ::TVarChar AS PartionGoodsDate
                  , tmpMI.PartionGoodsDate_q
                  , STRING_AGG (DISTINCT tmpMI.PartionGoods, ';') ::TVarChar AS PartionGoods
                  , tmpMI.GoodsKindId

                  , STRING_AGG (DISTINCT tmpMI.Comment, ';') ::TVarChar AS Comment
                  , tmpMI.isErased
             FROM tmpMI_1 AS tmpMI
            GROUP BY tmpMI.MovementItemId
                   , tmpMI.GoodsId
                   --, tmpMI.PartionGoodsDate
                   , tmpMI.PartionGoodsDate_q
                   --, tmpMI.PartionGoods
                   , tmpMI.GoodsKindId
                   , tmpMI.isErased

            ) AS tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
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
-- SELECT * FROM gpSelect_MI_WeighingPartner_PartionGoodsQ (inMovementId:= 14764281 , inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- select * from gpSelect_MI_WeighingPartner_PartionGoodsQ(inMovementId := 29774297  , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '9457');

