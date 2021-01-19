-- Function: gpSelect_Movement_ProductionUnion_Ceh_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnion_Ceh_Print (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnion_Ceh_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inMovementId_Weighing        Integer  , -- ключ Документа взвешивания
    IN inIsAll                      Boolean  ,
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);



    --
    OPEN Cursor1 FOR
    
    WITH tmpMovement AS (SELECT Movement.Id
                              , Movement.DescId
                              , Movement.InvNumber
                              , Movement.OperDate
                              , MD_StartWeighing.ValueData    AS StartWeighing
                              , MD_EndWeighing.ValueData      AS EndWeighing
                              , MLO_User.ObjectId             AS UserId
                              , MLO_From.ObjectId             AS FromId
                              , MLO_To.ObjectId               AS ToId
                              , Object_DocumentKind.Id        AS DocumentKindId
                              , Object_DocumentKind.ValueData AS DocumentKindName
                         FROM Movement
                               LEFT JOIN MovementLinkObject AS MLO_User
                                                            ON MLO_User.MovementId = Movement.Id
                                                           AND MLO_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN MovementDate AS MD_StartWeighing
                                                      ON MD_StartWeighing.MovementId =  Movement.Id
                                                     AND MD_StartWeighing.DescId = zc_MovementDate_StartWeighing()
                               LEFT JOIN MovementDate AS MD_EndWeighing
                                                      ON MD_EndWeighing.MovementId =  Movement.Id
                                                     AND MD_EndWeighing.DescId = zc_MovementDate_EndWeighing()
                               LEFT JOIN MovementLinkObject AS MLO_From
                                                            ON MLO_From.MovementId = Movement.Id
                                                           AND MLO_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN MovementLinkObject AS MLO_To
                                                            ON MLO_To.MovementId = Movement.Id
                                                           AND MLO_To.DescId     = zc_MovementLinkObject_To()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                                            ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
                               LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

                         WHERE Movement.Id       IN (inMovementId, inMovementId_Weighing)
                           AND Movement.DescId   IN (zc_Movement_ProductionUnion(), zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                        )
        -- Результат - Мастер (1 строка)
        SELECT
           inIsAll :: Boolean AS isAll
         , CASE WHEN tmpMovement.Id = inMovementId_Weighing THEN tmpMovement.InvNumber ELSE '' END :: TVarChar AS InvNumber
         , tmpMovement.OperDate

         , tmpMovement.StartWeighing
         , tmpMovement.EndWeighing

         , Object_From.ValueData     AS FromName
         , Object_To.ValueData       AS ToName

         , Object_User.ValueData      AS StoreKeeper -- кладовщик

         , tmpMovement.DocumentKindId
         , tmpMovement.DocumentKindName

     FROM tmpMovement
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
          LEFT JOIN Object AS Object_To   ON Object_To.Id   = tmpMovement.ToId
          LEFT JOIN Object AS Object_User ON Object_User.Id = tmpMovement.UserId
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
          WITH tmpMI AS (SELECT SUM (MovementItem.Amount)                       AS Amount_Weighing
                              , MIFloat_MovementItemId.ValueData :: Integer     AS MovementItemId
                              , MI_partion.ObjectId                             AS GoodsId
                              , MILO_GoodsKindComplete.ObjectId                 AS GoodsKindId_Complete
                              , CASE WHEN Movement_partion.Id > 0 THEN MI_partion.Amount             ELSE 0 END AS Amount
                              , CASE WHEN Movement_partion.Id > 0 THEN MIFloat_CuterWeight.ValueData ELSE 0 END AS CuterWeight
                              , CASE WHEN Movement_partion.Id > 0 THEN MIFloat_CuterCount.ValueData  ELSE 0 END AS CuterCount
                              , Movement_partion.InvNumber
                              , Movement_partion.OperDate
                         FROM Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                          ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()

                              LEFT JOIN MovementItem AS MI_partion ON MI_partion.Id = MIFloat_MovementItemId.ValueData :: Integer
                                                                  AND MI_partion.isErased = FALSE
                              LEFT JOIN Movement AS Movement_partion ON Movement_partion.Id = MI_partion.MovementId
                                                                    AND Movement_partion.StatusId = zc_Enum_Status_Complete()
                              LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                               ON MILO_GoodsKindComplete.MovementItemId = MI_partion.Id
                                                              AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                              LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                          ON MIFloat_CuterCount.MovementItemId = MI_partion.Id
                                                         AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                              LEFT JOIN MovementItemFloat AS MIFloat_CuterWeight
                                                          ON MIFloat_CuterWeight.MovementItemId = MI_partion.Id
                                                         AND MIFloat_CuterWeight.DescId = zc_MIFloat_CuterWeight()

                         WHERE Movement.Id       = inMovementId_Weighing
                           AND Movement.DescId   IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         GROUP BY MIFloat_MovementItemId.ValueData
                                , MI_partion.ObjectId
                                , MILO_GoodsKindComplete.ObjectId
                                , CASE WHEN Movement_partion.Id > 0 THEN MI_partion.Amount             ELSE 0 END
                                , CASE WHEN Movement_partion.Id > 0 THEN MIFloat_CuterWeight.ValueData ELSE 0 END
                                , CASE WHEN Movement_partion.Id > 0 THEN MIFloat_CuterCount.ValueData  ELSE 0 END
                                , Movement_partion.InvNumber
                                , Movement_partion.OperDate
                        UNION ALL
                         SELECT 0                                               AS Amount_Weighing
                              , MI_partion.Id                                   AS MovementItemId
                              , MI_partion.ObjectId                             AS GoodsId
                              , MILO_GoodsKindComplete.ObjectId                 AS GoodsKindId_Complete
                              , MI_partion.Amount                               AS Amount
                              , MIFloat_CuterWeight.ValueData                   AS CuterWeight
                              , MIFloat_CuterCount.ValueData                    AS CuterCount
                              , Movement_partion.InvNumber
                              , Movement_partion.OperDate
                         FROM (SELECT Movement.Id, Movement.OperDate, Movement.InvNumber
                               FROM Movement AS Movement_find
                                    INNER JOIN MovementLinkObject AS MLO_From_find
                                                                  ON MLO_From_find.MovementId = Movement_find.Id
                                                                 AND MLO_From_find.DescId = zc_MovementLinkObject_From()
                                    INNER JOIN MovementLinkObject AS MLO_To_find
                                                                  ON MLO_To_find.MovementId = Movement_find.Id
                                                                 AND MLO_To_find.DescId = zc_MovementLinkObject_To()
                                    INNER JOIN Movement ON Movement.OperDate = Movement_find.OperDate
                                                       AND Movement.DescId   = Movement_find.DescId
                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                    INNER JOIN MovementLinkObject AS MLO_From
                                                                  ON MLO_From.MovementId = Movement.Id
                                                                 AND MLO_From.DescId = zc_MovementLinkObject_From()
                                                                 AND MLO_From.ObjectId = MLO_From_find.ObjectId
                                    INNER JOIN MovementLinkObject AS MLO_To
                                                                  ON MLO_To.MovementId = Movement.Id
                                                                 AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                                 AND MLO_To.ObjectId   = MLO_To_find.ObjectId
                               WHERE Movement_find.Id = inMovementId
                                 AND inIsAll = TRUE
                              UNION ALL
                               SELECT Movement.Id, Movement.OperDate, Movement.InvNumber
                               FROM Movement
                               WHERE Movement.Id       = inMovementId
                                 AND Movement.DescId   = zc_Movement_ProductionUnion()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                 AND inIsAll = FALSE
                              ) AS Movement_partion
                              LEFT JOIN MovementItem AS MI_partion ON MI_partion.MovementId = Movement_partion.Id
                                                                  AND MI_partion.DescId     = zc_MI_Master()
                                                                  AND MI_partion.isErased   = FALSE
                              LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                               ON MILO_GoodsKindComplete.MovementItemId = MI_partion.Id
                                                              AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                              LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                          ON MIFloat_CuterCount.MovementItemId = MI_partion.Id
                                                         AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                              LEFT JOIN MovementItemFloat AS MIFloat_CuterWeight
                                                          ON MIFloat_CuterWeight.MovementItemId = MI_partion.Id
                                                         AND MIFloat_CuterWeight.DescId = zc_MIFloat_CuterWeight()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MI_partion.Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                         WHERE MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() OR inIsAll = FALSE
                        )
       -- Результат - Все элементы
       SELECT ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Goods.ObjectCode  			  AS GoodsCode
            , Object_Goods.ValueData   			  AS GoodsName
            , Object_GoodsKindComplete.ObjectCode         AS GoodsKindCompleteCode
            , Object_GoodsKindComplete.ValueData          AS GoodsKindCompleteName
            , Object_Measure.ValueData                    AS MeasureName
            , tmpMI.Amount                      :: TFloat AS Amount
            , tmpMI.Amount_Weighing             :: TFloat AS Amount_Weighing
            , tmpMI.CuterWeight                 :: TFloat AS CuterWeight
            , tmpMI.CuterCount                  :: TFloat AS CuterCount
            , tmpMI.InvNumber
            , tmpMI.OperDate
            , ObjectString_Receipt_Code.ValueData         AS ReceiptCode
            , Object_Receipt.ValueData                    AS ReceiptName
       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpMI.GoodsKindId_Complete

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                             ON MILinkObject_Receipt.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILinkObject_Receipt.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

       ORDER BY ObjectString_Goods_GoodsGroupFull.ValueData, Object_Goods.ValueData, Object_GoodsKindComplete.ValueData, tmpMI.InvNumber
      ;
      

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ProductionUnion_Ceh_Print (Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.16                                        *
*/
-- тест
-- SELECT * FROM gpSelect_Movement_ProductionUnion_Ceh_Print (inMovementId := 3857346, inMovementId_Weighing:= 0, inIsAll:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_Movement_ProductionUnion_Ceh_Print (inMovementId := 3857346, inMovementId_Weighing:= 0, inIsAll:= TRUE, inSession:= zfCalc_UserAdmin());
