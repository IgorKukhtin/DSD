 -- Function: gpSelect_MovementItem_SendOnPrice_Detail()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SendOnPrice_Detail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SendOnPrice_Detail(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , ReasonId Integer, ReasonCode Integer, ReasonName  TVarChar
             , ReturnKindId Integer, ReturnKindName TVarChar
             , Value5 Integer, Value10 Integer
             , isErased Boolean
             , Ord Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_SendOnPrice());
     vbUserId:= lpGetUserBySession (inSession);
     

     -- Результат
     RETURN QUERY
       WITH tmpMI_Master AS (SELECT MovementItem.Id
                                  , MovementItem.ObjectId                         AS GoodsId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                  , MovementItem.Amount
                             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            )
          , tmpMI_Detail AS (SELECT MovementItem.Id
                                  , MovementItem.ParentId
                                  , MovementItem.ObjectId          AS GoodsId
                                  , MovementItem.Amount
                                  , Object_Reason.Id               AS ReasonId
                                  , Object_Reason.ObjectCode       AS ReasonCode
                                  , Object_Reason.ValueData        AS ReasonName
                                  , Object_ReturnKind.Id           AS ReturnKindId
                                  , Object_ReturnKind.ValueData    AS ReturnKindName
                                  , SUM (COALESCE (MovementItem.Amount,0)) OVER (PARTITION BY MovementItem.ParentId) AS TotalAmount 
                             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId     = zc_MI_Detail()
                                                   AND MovementItem.isErased   = tmpIsErased.isErased
                                  LEFT JOIN MovementItemLinkObject AS MILO_Reason
                                                                   ON MILO_Reason.MovementItemId = MovementItem.Id
                                                                  AND MILO_Reason.DescId = zc_MILinkObject_Reason()
                                  LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = MILO_Reason.ObjectId

                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_ReturnKind
                                                                   ON MILinkObject_ReturnKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_ReturnKind.DescId = zc_MILinkObject_ReturnKind()
                                  LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = MILinkObject_ReturnKind.ObjectId
                            )
         , tmpDiff AS (SELECT tmpMI_Master.Id
                            , tmpMI_Master.GoodsId
                            , tmpMI_Master.GoodsKindId
                            , COALESCE (tmpMI_Master.Amount,0) - COALESCE (tmpDetail.TotalAmount,0) AS Amount
                       FROM tmpMI_Master
                            LEFT JOIN (SELECT DISTINCT tmpMI_Detail.ParentId, tmpMI_Detail.TotalAmount FROM tmpMI_Detail) AS tmpDetail ON tmpDetail.ParentId = tmpMI_Master.Id
                       WHERE COALESCE (tmpMI_Master.Amount,0) - COALESCE (tmpDetail.TotalAmount,0) > 0
                      )
          , tmpAll AS (SELECT COALESCE (tmpMI_Detail.Id,0) AS Id
                            , COALESCE (tmpMI_Detail.ParentId, tmpMI_Master.Id) AS ParentId
                            , tmpMI_Master.GoodsId
                            , tmpMI_Master.GoodsKindId
                            , COALESCE (tmpMI_Detail.Amount, tmpMI_Master.Amount) :: TFloat AS Amount
                            , tmpMI_Detail.ReasonId   ::Integer
                            , tmpMI_Detail.ReasonCode ::Integer
                            , tmpMI_Detail.ReasonName ::TVarChar
                            , tmpMI_Detail.ReturnKindId   ::Integer
                            , tmpMI_Detail.ReturnKindName ::TVarChar
                              -- № п.п.
                            , ROW_NUMBER () OVER (PARTITION BY tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId ORDER BY tmpMI_Detail.Id ASC) AS Ord
                       FROM tmpMI_Master
                            INNER JOIN tmpMI_Detail ON tmpMI_Detail.ParentId = tmpMI_Master.Id
                     UNION 
                       SELECT 0 :: integer AS Id
                            , tmpMI_Master.Id AS ParentId
                            , tmpMI_Master.GoodsId
                            , tmpMI_Master.GoodsKindId
                            , tmpDiff.Amount :: TFloat AS Amount
                            , 0   ::Integer  AS ReasonId
                            , 0   ::Integer  AS ReasonCode
                            , ''  ::TVarChar AS ReasonName
                            , 0   ::Integer  AS ReturnKindId
                            , ''  ::TVarChar AS ReturnKindName
                              -- № п.п. - здесь всегда последний
                            , 10000          AS ord
                       FROM tmpMI_Master
                            INNER JOIN tmpDiff ON tmpDiff.Id = tmpMI_Master.Id
                      )

       -- StickerProperty -  кількість діб  + кількість діб - второй срок
     , tmpStickerProperty AS (SELECT ObjectLink_Sticker_Goods.ChildObjectId              AS GoodsId
                                   , ObjectLink_StickerProperty_GoodsKind.ChildObjectId  AS GoodsKindId
                                   , COALESCE (ObjectFloat_Value5.ValueData, 0)          AS Value5
                                   , COALESCE (ObjectFloat_Value10.ValueData, 0)         AS Value10
                                     --  № п/п
                                   , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Sticker_Goods.ChildObjectId, ObjectLink_StickerProperty_GoodsKind.ChildObjectId ORDER BY COALESCE (ObjectFloat_Value5.ValueData, 0) DESC) AS Ord
                              FROM Object AS Object_StickerProperty
                                    LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_Sticker
                                                         ON ObjectLink_StickerProperty_Sticker.ObjectId = Object_StickerProperty.Id
                                                        AND ObjectLink_StickerProperty_Sticker.DescId   = zc_ObjectLink_StickerProperty_Sticker()
                                    LEFT JOIN ObjectLink AS ObjectLink_Sticker_Goods
                                                         ON ObjectLink_Sticker_Goods.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                        AND ObjectLink_Sticker_Goods.DescId   = zc_ObjectLink_Sticker_Goods()
                                    LEFT JOIN ObjectLink AS ObjectLink_Sticker_Juridical
                                                         ON ObjectLink_Sticker_Juridical.ObjectId = ObjectLink_StickerProperty_Sticker.ChildObjectId
                                                        AND ObjectLink_Sticker_Juridical.DescId   = zc_ObjectLink_StickerProperty_GoodsKind()

                                    LEFT JOIN ObjectLink AS ObjectLink_StickerProperty_GoodsKind
                                                         ON ObjectLink_StickerProperty_GoodsKind.ObjectId = Object_StickerProperty.Id
                                                        AND ObjectLink_StickerProperty_GoodsKind.DescId = zc_ObjectLink_StickerProperty_GoodsKind()
                                    -- кількість діб
                                    LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                                          ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id
                                                         AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()
                                   -- кількість діб - второй срок
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value10
                                                         ON ObjectFloat_Value10.ObjectId = Object_StickerProperty.Id 
                                                        AND ObjectFloat_Value10.DescId = zc_ObjectFloat_StickerProperty_Value10()
                              WHERE Object_StickerProperty.DescId   = zc_Object_StickerProperty()
                                AND Object_StickerProperty.isErased = FALSE
                                AND ObjectLink_Sticker_Juridical.ChildObjectId IS NULL -- !!!обязательно БЕЗ Покупателя!!!
                             )

       -- Результат
       SELECT
             COALESCE (tmpAll.Id,0) AS Id
           , tmpAll.ParentId
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , tmpAll.Amount :: TFloat AS Amount
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
 
           , tmpAll.ReasonId   ::Integer
           , tmpAll.ReasonCode ::Integer
           , tmpAll.ReasonName ::TVarChar
           , tmpAll.ReturnKindId   ::Integer
           , tmpAll.ReturnKindName ::TVarChar

           , tmpStickerProperty.Value5  :: Integer AS Value5
           , tmpStickerProperty.Value10 :: Integer AS Value10

           , FALSE                      AS isErased
             -- № п.п.
           , ROW_NUMBER () OVER (PARTITION BY tmpAll.GoodsId, tmpAll.GoodsKindId ORDER BY tmpAll.Ord ASC) :: Integer AS ord  
       FROM tmpAll
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpAll.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpAll.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpAll.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpStickerProperty ON tmpStickerProperty.GoodsId     = tmpAll.GoodsId
                                        AND tmpStickerProperty.GoodsKindId = tmpAll.GoodsKindId
                                        AND tmpStickerProperty.Ord         = 1
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.21         *
*/

-- тест
--
-- SELECT * FROM gpSelect_MovementItem_SendOnPrice_Detail (inMovementId:= 20081622,  inIsErased:= FALSE, inSession:= '9818')
