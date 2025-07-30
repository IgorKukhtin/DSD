-- Function: gpSelect_Movement_OrderInternalPackRemains_PrintSticker (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_PrintSticker (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPackRemains_PrintSticker (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPackRemains_PrintSticker(
    IN inMovementId        Integer   ,   -- ключ Документа 
    IN inAmount            Integer   ,
    IN inisAll             Boolean   ,
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.DescId, Movement.StatusId, Movement.OperDate
   INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

     -- проверка - с каким статусом можно печатать
     --PERFORM lfCheck_Movement_Print (inMovementDescId:= Movement.DescId, inMovementId:= Movement.Id, inStatusId:= Movement.StatusId) FROM Movement WHERE Id = inMovementId;
     -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
       /* IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF; 
        */
    END IF;

     -- Результат
     OPEN Cursor1 FOR
     WITH
     tmpMI AS (SELECT MovementItem.Id                   AS MovementItemId
                    , MovementItem.ParentId             AS ParentId
                    , CASE WHEN MIDate_Update.ValueData IS NOT NULL THEN MIDate_Update.ValueData ELSE MIDate_Insert.ValueData END AS UpdateDate
                    , MovementItem.Amount               AS Amount
                    , COALESCE (MIFloat_AmountPack.ValueData,0)
                    + COALESCE (MIFloat_AmountPackSecond.ValueData,0)
                    + COALESCE (MIFloat_AmountPackNext.ValueData,0)
                    + COALESCE (MIFloat_AmountPackNextSecond.ValueData,0) AS AmountPackAllTotal
                      -- № п/п
                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id ASC) AS Ord
               FROM MovementItem
                    LEFT JOIN MovementItemFloat AS MIFloat_AmountPack
                                                ON MIFloat_AmountPack.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountPack.DescId = zc_MIFloat_AmountPack()
                    LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond
                                                ON MIFloat_AmountPackSecond.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountPackSecond.DescId = zc_MIFloat_AmountPackSecond()

                    LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext
                                                ON MIFloat_AmountPackNext.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountPackNext.DescId = zc_MIFloat_AmountPackNext()
                    LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond
                                                ON MIFloat_AmountPackNextSecond.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountPackNextSecond.DescId = zc_MIFloat_AmountPackNextSecond()

                    LEFT JOIN MovementItemDate AS MIDate_Insert
                                               ON MIDate_Insert.MovementItemId = MovementItem.Id
                                              AND MIDate_Insert.DescId = zc_MIDate_Insert()
                    LEFT JOIN MovementItemDate AS MIDate_Update
                                               ON MIDate_Update.MovementItemId = MovementItem.Id
                                              AND MIDate_Update.DescId = zc_MIDate_Update()

               WHERE MovementItem.MovementId = inMovementId 
                 AND MovementItem.DescId     = zc_MI_Detail()
                 AND MovementItem.isErased   = FALSE
               )
   , tmpData AS (SELECT *
                 FROM (SELECT tmpMI.MovementItemId
                            , tmpMI.ParentId
                            , tmpMI.UpdateDate
                            , tmpMI.Amount
                            , (COALESCE (tmpMI.AmountPackAllTotal,0) - COALESCE (tmpMI_2.AmountPackAllTotal,0) ) AS AmountPackAllTotal
                            , MAX (tmpMI.Amount) OVER (PARTITION BY tmpMI.ParentId) AS Amount_max
                       FROM tmpMI
                            LEFT JOIN tmpMI AS tmpMI_2 ON tmpMI_2.ParentId = tmpMI.ParentId
                                                      AND tmpMI_2.Amount = tmpMI.Amount-1
                       ) AS tmp
                WHERE (((tmp.Amount = tmp.Amount_max AND inAmount = 0)
                      OR (tmp.Amount = inAmount AND inAmount <> 0) 
                        ) 
                     OR inisAll = TRUE
                       )
                   AND COALESCE (tmp.AmountPackAllTotal,0) <> 0 

                 )
   , tmpMI_Master AS (SELECT MovementItem.*
                      FROM MovementItem 
                      WHERE MovementItem.Id IN (SELECT DISTINCT tmpData.ParentId FROM tmpData) 
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      )
   , tmpMILO AS (SELECT MovementItemLinkObject.*
                 FROM MovementItemLinkObject
                 WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                   AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                 )

       -- Результат
       SELECT Object_Goods.Id                AS GoodsId
            , Object_Goods.ObjectCode        AS GoodsCode
            , Object_Goods.ValueData         AS GoodsName
            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
            , Object_GoodsKind.ValueData     AS GoodsKindName
            --, zfFormat_BarCode (zc_BarCodePref_Object(), Object_Goods.Id) AS IdBarCode
            , SUM (COALESCE (tmpData.AmountPackAllTotal,0))  AS Amount
            , MAX (tmpData.UpdateDate)       AS Date_Update
            , CURRENT_TIMESTAMP              AS Date_Curr  
            , ObjectString_Goods_GoodsGroupFull.ValueData
            , Object_Goods_complete.ValueData
            , Object_GoodsKind_complete.ValueData
       FROM tmpData 
            LEFT JOIN tmpMI_Master ON tmpMI_Master.Id = tmpData.ParentId 
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Master.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                              ON MILinkObject_GoodsKind.MovementItemId = tmpMI_Master.Id
                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                             ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
            LEFT JOIN Object AS Object_Goods_complete     ON Object_Goods_complete.Id = COALESCE (MILinkObject_GoodsComplete.ObjectId, 0)
            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKindComplete.DescId         = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods_complete.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

       GROUP BY Object_Goods.Id
              , Object_Goods.ObjectCode
              , Object_Goods.ValueData
              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
              , Object_GoodsKind.ValueData

            , ObjectString_Goods_GoodsGroupFull.ValueData
            , Object_Goods_complete.ValueData
            , Object_GoodsKind_complete.ValueData

       ORDER BY ObjectString_Goods_GoodsGroupFull.ValueData
              , Object_Goods_complete.ValueData
              , Object_GoodsKind_complete.ValueData
              , Object_Goods.ValueData
              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 
       ;

         
       --на этикетке Код + найменування + вид товару +  кількість продукції + время коли корректировли в последний раз строчку + время когда печатается термочек

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
28.07.25          *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternalPackRemains_PrintSticker (inMovementId := 31540397, inAmount:= 1, inisAll := False, inSession:= '5');
