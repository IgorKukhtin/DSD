-- Function: gpSelect_Movement_OrderInternalBasis_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalBasis_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalBasis_Print(
    IN inMovementId    Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbFromId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , MovementLinkObject_From.ObjectId
            INTO vbDescId, vbStatusId, vbOperDate, vbFromId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
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
       WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (vbFromId) AS lfSelect_Object_Unit_byGroup)
          , tmpMI_Send AS (-- группируется Перемещение
                           SELECT tmpMI.GoodsId                          AS GoodsId
                                , tmpMI.GoodsKindId                      AS GoodsKindId
                                , SUM (tmpMI.AmountIn)                   AS AmountIn
                                , SUM (tmpMI.AmountOut)                  AS AmountOut
                                , SUM (tmpMI.AmountP)                    AS AmountP
                                , SUM (tmpMI.AmountPU_in)                AS AmountPU_in
                           FROM (SELECT MIContainer.ObjectId_Analyzer                  AS GoodsId
                                      , CASE -- !!!временно захардкодил!!!
                                             WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- Склад МИНУСОВКА
                                              -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = 0
                                                  THEN 8338 -- морож.
                                             WHEN MIContainer.ObjectIntId_Analyzer = zc_GoodsKind_Basis()
                                                  THEN 0
                                             --ELSE 0
                                             ELSE COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                        END AS GoodsKindId
                                      , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Send() AND MIContainer.isActive = TRUE  THEN      MIContainer.Amount ELSE 0 END) AS AmountIn
                                      , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Send() AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountOut
                                      , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() AND MovementBoolean_Peresort.ValueData = TRUE THEN MIContainer.Amount ELSE 0 END) AS AmountP
                                      , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                   AND MovementBoolean_Peresort.ValueData = FALSE
                                                   AND COALESCE (MIContainer.Amount,0) > 0
                                                   THEN MIContainer.Amount
                                                  ELSE 0
                                             END) AS AmountPU_in
                                 FROM MovementItemContainer AS MIContainer
                                      INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_Analyzer
                                      LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                                ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                               AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                 WHERE MIContainer.OperDate   = vbOperDate
                                   AND MIContainer.DescId     = zc_MIContainer_Count()
                                   AND (MIContainer.MovementDescId = zc_Movement_Send()
                                     OR (MIContainer.MovementDescId = zc_Movement_ProductionUnion())
                                       )
                                   -- AND MIContainer.isActive = TRUE
                                 GROUP BY MIContainer.ObjectId_Analyzer
                                        , CASE -- !!!временно захардкодил!!!
                                               WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- Склад МИНУСОВКА
                                                -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = 0
                                                    THEN 8338 -- морож.
                                               WHEN MIContainer.ObjectIntId_Analyzer = zc_GoodsKind_Basis()
                                                    THEN 0
                                               --ELSE 0
                                               ELSE COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                          END
                                 HAVING SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Send() AND MIContainer.isActive = TRUE  THEN      MIContainer.Amount ELSE 0 END) <> 0
                                     OR SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Send() AND MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) <> 0
                                     OR SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ProductionUnion() THEN MIContainer.Amount ELSE 0 END) <> 0
                                ) AS tmpMI
                            GROUP BY tmpMI.GoodsId
                                   , tmpMI.GoodsKindId
                          )
          , tmpMI AS (-- Заявка сырье
                      SELECT MovementItem.ObjectId                                  AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)          AS GoodsKindId
                           , MAX (COALESCE (MILinkObject_Receipt.ObjectId, 0))      AS ReceiptId
                           , SUM (MovementItem.Amount)                              AS Amount
                           , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0))     AS AmountSecond
                           , SUM (COALESCE (MIFloat_AmountRemains.ValueData, 0))    AS AmountRemains
                           , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))       AS AmountPartner
                           , SUM (COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0))  AS AmountPartnerPrior
                           , SUM (COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0)) AS AmountPartnerSecond
                           , 0                                                      AS AmountSend
                           , 0                                                      AS AmountSendOut
                           , 0                                                      AS AmountP
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                            ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                       ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                       ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                                       ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartnerPrior.DescId = zc_MIFloat_AmountPartnerPrior()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                                       ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                      GROUP BY MovementItem.ObjectId
                             , MILinkObject_GoodsKind.ObjectId
                      )


       SELECT
             Object_Unit.ObjectCode          AS UnitCode
           , Object_Unit.ValueData           AS UnitName 

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData     AS GoodsGroupName
           , Object_Goods.ObjectCode  	     AS GoodsCode

           , CASE WHEN ObjectString_Goods_Scale.ValueData <> '' THEN ObjectString_Goods_Scale.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
           , CASE WHEN ObjectString_Goods_Scale.ValueData <> '' THEN Object_Goods.ValueData             ELSE ''                     END :: TVarChar AS GoodsName_new

           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , zfFormat_BarCode (zc_BarCodePref_Object(), COALESCE (View_GoodsByGoodsKind.Id, Object_Goods.Id)) AS IdBarCode

           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN tmpMI.Amount              / ObjectFloat_Weight.ValueData ELSE 0 END AS Amount_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN tmpMI.AmountSecond        / ObjectFloat_Weight.ValueData ELSE 0 END AS AmountSecond_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()                                      THEN tmpMI.AmountSend                                         ELSE 0 END AS AmountSend_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()                                      THEN tmpMI.AmountSendOut                                      ELSE 0 END AS AmountSendOut_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()                                      THEN tmpMI.AmountP                                            ELSE 0 END AS AmountP_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()                                      THEN tmpMI.AmountPU_in                                        ELSE 0 END AS AmountPU_in_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN tmpMI.AmountPartner       / ObjectFloat_Weight.ValueData ELSE 0 END AS AmountPartner_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN tmpMI.AmountPartnerPrior  / ObjectFloat_Weight.ValueData ELSE 0 END AS AmountPartnerPrior_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN tmpMI.AmountPartnerSecond / ObjectFloat_Weight.ValueData ELSE 0 END AS AmountPartnerSecond_sh
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()                                      THEN tmpMI.AmountSend                                         ELSE 0 END AS Amount_sh_calc
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()                                      THEN tmpMI.AmountSendOut                                      ELSE 0 END AS AmountOut_sh_calc
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()                                      THEN tmpMI.AmountP                                            ELSE 0 END AS AmountP_sh_calc
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN tmpMI.AmountRemains       / ObjectFloat_Weight.ValueData ELSE 0 END AS AmountRemains_sh

           , tmpMI.Amount             /**CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END*/ AS Amount
           , tmpMI.AmountSecond       /**CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END*/ AS AmountSecond
           , tmpMI.AmountSend           * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountSend
           , tmpMI.AmountSendOut        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountSendOut
           , tmpMI.AmountP              * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountP
           , tmpMI.AmountPU_in          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPU_in
           , tmpMI.AmountPartner      /** CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END*/ AS AmountPartner
           , tmpMI.AmountPartnerPrior /** CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END*/ AS AmountPartnerPrior
           , tmpMI.AmountPartnerSecond/** CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END*/ AS AmountPartnerSecond
           , tmpMI.Amount_calc        /** CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END*/ AS Amount_calc
           , tmpMI.Amount_calc_Pack   /** CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END*/ AS Amount_calc_Pack
           , tmpMI.AmountRemains      /** CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END*/ AS AmountRemains

           , SUM (COALESCE (tmpMI.Amount,0) + COALESCE (tmpMI.AmountSecond,0)) OVER (PARTITION BY Object_Unit.Id, Object_GoodsGroup.ValueData) AS PrintGroup_Scan
           , SUM (COALESCE (tmpMI.Amount_calc_Pack,0)) OVER (PARTITION BY Object_Unit.Id, Object_GoodsGroup.ValueData)                         AS PrintGroup_Scan_Pack
           , SUM (COALESCE (tmpMI.Amount,0) + COALESCE (tmpMI.AmountSecond,0)) OVER (PARTITION BY Object_Unit.Id)                              AS PrintPage_Scan

       FROM (SELECT tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , MAX (tmpMI.ReceiptId)     AS ReceiptId
                  , SUM (tmpMI.Amount)        AS Amount
                  , SUM (tmpMI.AmountSecond)  AS AmountSecond
                  , SUM (tmpMI.AmountPartner) AS AmountPartner
                  , SUM (tmpMI.AmountPartnerPrior)  AS AmountPartnerPrior
                  , SUM (tmpMI.AmountPartnerSecond) AS AmountPartnerSecond
                  , SUM (tmpMI.AmountSend)    AS AmountSend
                  , SUM (tmpMI.AmountSendOut) AS AmountSendOut
                  , SUM (tmpMI.AmountP)       AS AmountP
                  , SUM (tmpMI.AmountPU_in)   AS AmountPU_in
                  , CASE WHEN SUM (tmpMI.AmountRemains + tmpMI.AmountSend - tmpMI.AmountSendOut + tmpMI.AmountP) < SUM (tmpMI.AmountPartner + tmpMI.AmountPartnerPrior + tmpMI.AmountPartnerSecond)
                              THEN SUM (tmpMI.AmountPartner + tmpMI.AmountPartnerPrior + tmpMI.AmountPartnerSecond - tmpMI.AmountRemains - tmpMI.AmountSend + tmpMI.AmountSendOut - tmpMI.AmountP)
                         ELSE 0
                    END AS Amount_calc -- Расчетный заказ
                
                  , CASE WHEN SUM (tmpMI.AmountRemains + tmpMI.AmountSend) < SUM (tmpMI.AmountPartner)
                              THEN SUM (tmpMI.AmountPartner - tmpMI.AmountRemains - tmpMI.AmountSend)
                         ELSE 0
                    END AS Amount_calc_Pack -- Расчетный заказ для Заявки на упаковку (Пленка)

                  , SUM (tmpMI.AmountRemains) AS AmountRemains
             FROM (-- Заявка сырье
                   SELECT tmpMI.GoodsId
                        , tmpMI.GoodsKindId
                        , tmpMI.ReceiptId
                        , tmpMI.Amount
                        , tmpMI.AmountSecond
                        , tmpMI.AmountRemains
                        , tmpMI.AmountPartner
                        , tmpMI.AmountPartnerPrior
                        , tmpMI.AmountPartnerSecond
                        , 0  AS AmountSend
                        , 0  AS AmountSendOut
                        , 0  AS AmountP
                        , 0  AS AmountPU_in
                   FROM tmpMI
                  UNION ALL
                   -- Перемещение
                   SELECT tmpMI_Send.GoodsId
                        , tmpMI_Send.GoodsKindId
                        , 0 AS ReceiptId
                        , 0 AS Amount
                        , 0 AS AmountSecond
                        , 0 AS AmountRemains
                        , 0 AS AmountPartner
                        , 0 AS AmountPartnerPrior
                        , 0 AS AmountPartnerSecond
                        , (tmpMI_Send.AmountIn)      AS AmountSend
                        , (tmpMI_Send.AmountOut)     AS AmountSendOut
                        , (tmpMI_Send.AmountP)       AS AmountP
                        , (tmpMI_Send.AmountPU_in)   AS AmountPU_in
                   FROM tmpMI_Send
                  ) AS tmpMI
             WHERE tmpMI.GoodsId <> zc_Goods_WorkIce()
             GROUP BY tmpMI.GoodsId
                    , tmpMI.GoodsKindId
            ) AS tmpMI

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                 ON ObjectLink_GoodsGroup_parent.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = CASE WHEN tmpMI.ReceiptId > 0
                                                                      AND (ObjectLink_Goods_GoodsGroup.ChildObjectId  IN (1942, 5064881) -- СО-ЭМУЛЬСИИ + СО-ПОСОЛ
                                                                        OR ObjectLink_GoodsGroup_parent.ChildObjectId IN (1942, 5064881) -- СО-ЭМУЛЬСИИ + СО-ПОСОЛ
                                                                          )
                                                                          THEN vbFromId
                                                                     WHEN Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                                                                                                         , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные  + Прочие материалы
                                                                                                                          )
                                                                          THEN 8455 -- Склад специй

                                                                     WHEN Object_InfoMoney_View.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_20000() -- Общефирменные
                                                                                                                    )
                                                                          THEN 8455 -- Склад специй

                                                                     ELSE 8439 -- Участок мясного сырья
                                                                END

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
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()


            LEFT JOIN Object_GoodsByGoodsKind_View AS View_GoodsByGoodsKind ON View_GoodsByGoodsKind.GoodsId = Object_Goods.Id
                                                                           AND View_GoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id
       WHERE tmpMI.Amount <> 0 OR tmpMI.AmountSecond <> 0 OR tmpMI.AmountSend <> 0 OR tmpMI.AmountPartner <> 0 OR tmpMI.AmountPartnerPrior <> 0 OR tmpMI.AmountPartnerSecond <> 0 -- OR tmpMI.Amount_calc <> 0
          OR tmpMI.AmountRemains <> 0
          OR tmpMI.AmountSendOut <> 0
          --OR vbUserId = 5
       ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_OrderInternalBasis_Print (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternalBasis_Print (inMovementId := 388160, inSession:= zfCalc_UserAdmin())
