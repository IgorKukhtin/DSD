-- Function: gpSelect_Movement_OrderInternalPack_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPack_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPack_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbToId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , MovementLinkObject_To.ObjectId
            INTO vbDescId, vbStatusId, vbOperDate, vbToId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;


     -- очень важная проверка
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;


     --
     OPEN Cursor1 FOR
      SELECT Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , Object_From.ValueData                      AS FromName
           , Object_To.ValueData               		AS ToName
       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
       WHERE Movement.Id =  inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       WITH tmpMI_Send AS (SELECT tmpMI.GoodsId                          AS GoodsId
                                , COALESCE (CLO_GoodsKindId.ObjectId, 0) AS GoodsKindId
                                , SUM (tmpMI.Amount)                     AS Amount
                           FROM (SELECT MIContainer.ObjectId_Analyzer AS GoodsId
                                      , MIContainer.ContainerId
                                      , -1 * SUM (MIContainer.Amount) AS Amount
                                 FROM MovementItemContainer AS MIContainer
                                 WHERE MIContainer.OperDate   = vbOperDate
                                   AND MIContainer.DescId     = zc_MIContainer_Count()
                                   AND MIContainer.WhereObjectId_Analyzer = vbToId
                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                   AND MIContainer.isActive = FALSE
                                 GROUP BY MIContainer.ObjectId_Analyzer
                                        , MIContainer.ContainerId
                                ) AS tmpMI
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKindId
                                                              ON CLO_GoodsKindId.ContainerId = tmpMI.ContainerId
                                                             AND CLO_GoodsKindId.DescId = zc_ContainerLinkObject_GoodsKind()
                            GROUP BY tmpMI.GoodsId
                                   , CLO_GoodsKindId.ObjectId
                          )
           , tmpReceipt AS (SELECT tmpMI_Send.GoodsId
                                 , tmpMI_Send.GoodsKindId
                                 , MAX (COALESCE (ObjectLink_Receipt_Goods_Parent_0.ChildObjectId, 0)) AS GoodsId_basis
                            FROM tmpMI_Send
                                 INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                       ON ObjectLink_Receipt_Goods.ObjectId = tmpMI_Send.GoodsId
                                                      AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                 INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                       ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                      AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                      AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmpMI_Send.GoodsKindId
                                 INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                    AND Object_Receipt.isErased = FALSE
                                 INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                          ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                         AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                         AND ObjectBoolean_Main.ValueData = TRUE
                                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                      ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                     AND ObjectLink_Receipt_Parent_0.DescId = zc_ObjectLink_Receipt_Parent()
                                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_Parent_0
                                                      ON ObjectLink_Receipt_Goods_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                     AND ObjectLink_Receipt_Goods_Parent_0.DescId = zc_ObjectLink_Receipt_Goods()
                            GROUP BY tmpMI_Send.GoodsId
                                   , tmpMI_Send.GoodsKindId
                          )
       SELECT
             Object_Unit.ObjectCode          AS UnitCode
           , Object_Unit.ValueData           AS UnitName 
           , Object_Goods_basis.ObjectCode   AS GoodsCode_basis
           -- , Object_Goods_basis.ValueData    AS GoodsName_basis
           , '' :: TVarChar                  AS GoodsName_basis

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData     AS GoodsGroupName
           , Object_Goods.ObjectCode  	     AS GoodsCode
           , Object_Goods.ValueData          AS GoodsName
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , zfFormat_BarCode (zc_BarCodePref_Object(), COALESCE (View_GoodsByGoodsKind.Id, Object_Goods.Id)) AS IdBarCode

           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMI.Amount       ELSE 0 END AS Amount_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMI.AmountSecond ELSE 0 END AS AmountSecond_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMI.AmountSend   ELSE 0 END AS AmountSend_sh

           , tmpMI.Amount       * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Amount
           , tmpMI.AmountSecond * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountSecond
           , tmpMI.AmountSend   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountSend
           
           , SUM (COALESCE (tmpMI.Amount,0) + COALESCE (tmpMI.AmountSecond,0)) OVER (PARTITION BY Object_Unit.Id, Object_GoodsGroup.ValueData) AS PrintGroup_Scan

       FROM (SELECT tmpMI.GoodsId
                  , tmpMI.GoodsId_basis
                  , tmpMI.GoodsKindId
                  , SUM (tmpMI.Amount) AS Amount
                  , SUM (tmpMI.AmountSecond) AS AmountSecond
                  , SUM (tmpMI.AmountSend) AS AmountSend
             FROM
            (SELECT MovementItem.ObjectId                                  AS GoodsId
                  , COALESCE (MILinkObject_Goods.ObjectId
                            , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                        THEN MovementItem.ObjectId
                                   ELSE 0
                              END) AS GoodsId_basis
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)          AS GoodsKindId
                  , SUM (MovementItem.Amount)                              AS Amount
                  , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0))     AS AmountSecond
                  , 0                                                      AS AmountSend
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                   ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_Goods.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    , ObjectLink_Goods_InfoMoney.ChildObjectId
            UNION ALL
             SELECT tmpMI_Send.GoodsId
                  , COALESCE (tmpReceipt.GoodsId, tmpMI_Send.GoodsId) AS GoodsId_basis
                  , tmpMI_Send.GoodsKindId
                  , 0 AS Amount
                  , 0 AS AmountSecond
                  , (tmpMI_Send.Amount) AS AmountSend
             FROM tmpMI_Send
                  LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMI_Send.GoodsId
                                      AND tmpReceipt.GoodsKindId = tmpMI_Send.GoodsKindId
            ) AS tmpMI
             GROUP BY tmpMI.GoodsId
                    , tmpMI.GoodsId_basis
                    , tmpMI.GoodsKindId
            ) AS tmpMI

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = tmpMI.GoodsId_basis
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderType_Unit.ChildObjectId

            LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = tmpMI.GoodsId_basis
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId_basis
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId_basis
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.GoodsId = Object_Goods.Id
                                                                           AND View_GoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id

       WHERE tmpMI.Amount <> 0 OR tmpMI.AmountSecond <> 0 OR tmpMI.AmountSend <> 0
       ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_OrderInternalPack_Print (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternalPack_Print (inMovementId := 388160, inSession:= zfCalc_UserAdmin())
