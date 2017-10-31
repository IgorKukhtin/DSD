-- Function: gpSelect_MI_OrderInternalPackRemains()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPackRemains (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPackRemains(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF REFCURSOR
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE Cursor3 refcursor;

   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId   Integer;
   DECLARE vbToId     Integer;
   DECLARE vbDayCount Integer;
   DECLARE vbMonth    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется
     SELECT Movement.OperDate
          , 1 + EXTRACT (DAY FROM (MovementDate_OperDateEnd.ValueData - MovementDate_OperDateStart.ValueData))
          , EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
            INTO vbOperDate, vbDayCount, vbMonth, vbFromId, vbToId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
     WHERE Movement.Id = inMovementId;


     -- 
     CREATE TEMP TABLE _tmpMI_master (MovementItemId Integer, ContainerId Integer
                                    , ReceiptId Integer, GoodsId Integer, GoodsKindId Integer
                                    , GoodsId_complete Integer, GoodsKindId_complete Integer
                                    , ReceiptId_basis Integer, GoodsId_basis Integer
                                    , Amount TFloat, AmountSecond TFloat, AmountRemains TFloat
                                    , AmountPartnerPrior TFloat, AmountPartnerPriorPromo TFloat, AmountPartner TFloat, AmountPartnerPromo TFloat
                                    , AmountForecast TFloat, AmountForecastPromo TFloat, AmountForecastOrder TFloat, AmountForecastOrderPromo TFloat
                                    , CountForecast TFloat, CountForecastOrder TFloat
                                    , isErased Boolean) ON COMMIT DROP;
     INSERT INTO _tmpMI_master (MovementItemId, ContainerId
                              , ReceiptId, GoodsId, GoodsKindId
                              , GoodsId_complete, GoodsKindId_complete
                              , ReceiptId_basis, GoodsId_basis
                              , Amount, AmountSecond, AmountRemains
                              , AmountPartnerPrior, AmountPartnerPriorPromo, AmountPartner, AmountPartnerPromo
                              , AmountForecast, AmountForecastPromo, AmountForecastOrder, AmountForecastOrderPromo
                              , CountForecast, CountForecastOrder
                              , isErased
                               )
                              SELECT MovementItem.Id                                       AS MovementItemId
                                   , COALESCE (MIFloat_ContainerId.ValueData, 0)           AS ContainerId

                                   , COALESCE (MILinkObject_Receipt.ObjectId, 0)           AS ReceiptId
                                   , MovementItem.ObjectId                                 AS GoodsId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId

                                   , COALESCE (MILinkObject_GoodsComplete.ObjectId, 0)     AS GoodsId_complete
                                   , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_complete

                                   , COALESCE (MILinkObject_ReceiptBasis.ObjectId, 0)      AS ReceiptId_basis
                                   , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)        AS GoodsId_basis

                                   , MovementItem.Amount                                   AS Amount
                                   , COALESCE (MIFloat_AmountSecond.ValueData, 0)          AS AmountSecond

                                   , COALESCE (MIFloat_AmountRemains.ValueData, 0)         AS AmountRemains

                                   , COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0)         AS AmountPartnerPrior
                                   , COALESCE (MIFloat_AmountPartnerPriorPromo.ValueData, 0)    AS AmountPartnerPriorPromo
                                   , COALESCE (MIFloat_AmountPartner.ValueData, 0)              AS AmountPartner
                                   , COALESCE (MIFloat_AmountPartnerPromo.ValueData, 0)         AS AmountPartnerPromo

                                   , COALESCE (MIFloat_AmountForecast.ValueData, 0)             AS AmountForecast
                                   , COALESCE (MIFloat_AmountForecastPromo.ValueData, 0)        AS AmountForecastPromo
                                   , COALESCE (MIFloat_AmountForecastOrder.ValueData, 0)        AS AmountForecastOrder
                                   , COALESCE (MIFloat_AmountForecastOrderPromo.ValueData, 0)   AS AmountForecastOrderPromo
                                   
                                   , CASE WHEN vbDayCount <> 0 THEN COALESCE (MIFloat_AmountForecast.ValueData, 0)      / vbDayCount ELSE 0 END AS CountForecast
                                   , CASE WHEN vbDayCount <> 0 THEN COALESCE (MIFloat_AmountForecastOrder.ValueData, 0) / vbDayCount ELSE 0 END AS CountForecastOrder

                                   , MovementItem.isErased                                 AS isErased

                              FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                   INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = tmpIsErased.isErased
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                               ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                                   LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                               ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                              AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
--                                                       AND  = Object_InfoMoney_View.InfoMoneyId

                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                               ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()

                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                                               ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartnerPrior.DescId = zc_MIFloat_AmountPartnerPrior()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                                               ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                                               ON MIFloat_AmountForecastOrder.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecastOrder.DescId = zc_MIFloat_AmountForecastOrder()
                                   --
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPromo
                                                               ON MIFloat_AmountPartnerPromo.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartnerPromo.DescId = zc_MIFloat_AmountPartnerPromo()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPriorPromo
                                                               ON MIFloat_AmountPartnerPriorPromo.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartnerPriorPromo.DescId = zc_MIFloat_AmountPartnerPriorPromo()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastPromo
                                                               ON MIFloat_AmountForecastPromo.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecastPromo.DescId = zc_MIFloat_AmountForecastPromo()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrderPromo
                                                               ON MIFloat_AmountForecastOrderPromo.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecastOrderPromo.DescId = zc_MIFloat_AmountForecastOrderPromo()
                                   --                                                              
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                                    ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsBasis.DescId = zc_MILinkObject_GoodsBasis()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                                    ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsComplete.DescId = zc_MILinkObject_Goods()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                    ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                                    ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptBasis
                                                                    ON MILinkObject_ReceiptBasis.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
                             ;


       --
       OPEN Cursor1 FOR
       -- Результат
       SELECT
             tmpMI.MovementItemId   AS Id
           , (tmpMI.GoodsId :: TVarChar || '_' || tmpMI.GoodsKindId :: TVarChar) :: TVarChar AS KeyId
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_Goods_basis.Id               AS GoodsId_basis
           , Object_Goods_basis.ObjectCode       AS GoodsCode_basis
           , Object_Goods_basis.ValueData        AS GoodsName_basis

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_Measure.ValueData            AS MeasureName
           , Object_Measure_basis.ValueData      AS MeasureName_basis

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CASE WHEN tmpMI.GoodsId <> tmpMI.GoodsId_basis THEN TRUE ELSE FALSE END AS isCheck_basis

           , tmpMI.Amount           :: TFloat AS Amount           -- Заказ на УПАК
           , tmpMI.AmountSecond     :: TFloat AS AmountSecond     -- Дозаказ на УПАК

             -- Ост. начальн.
           , CASE WHEN ABS (tmpMI.AmountRemains) < 1 THEN tmpMI.AmountRemains ELSE CAST (tmpMI.AmountRemains AS NUMERIC (16, 1)) END :: TFloat AS AmountRemains

              -- неотгуж. заявка
           , CAST (tmpMI.AmountPartnerPrior       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
           , CAST (tmpMI.AmountPartnerPriorPromo  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorPromo
            -- сегодня заявка
           , CAST (tmpMI.AmountPartner            AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
           , CAST (tmpMI.AmountPartnerPromo       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromo

            -- Прогноз по прод.
           , CASE WHEN ABS (tmpMI.AmountForecast) < 1           THEN tmpMI.AmountForecast           ELSE CAST (tmpMI.AmountForecast           AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast     
           , CASE WHEN ABS (tmpMI.AmountForecastPromo) < 1      THEN tmpMI.AmountForecastPromo      ELSE CAST (tmpMI.AmountForecastPromo      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastPromo
             -- Прогноз по заяв. 
           , CASE WHEN ABS (tmpMI.AmountForecastOrder) < 1      THEN tmpMI.AmountForecastOrder      ELSE CAST (tmpMI.AmountForecastOrder      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder
           , CASE WHEN ABS (tmpMI.AmountForecastOrderPromo) < 1 THEN tmpMI.AmountForecastOrderPromo ELSE CAST (tmpMI.AmountForecastOrderPromo AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrderPromo

             -- Норм 1д (по пр.) без К
           , CAST (tmpMI.CountForecast AS NUMERIC (16, 1))      :: TFloat AS CountForecast
             -- Норм 1д (по зв.) без К
           , CAST (tmpMI.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- Ост. в днях (по зв.) - без К
           , CAST (CASE WHEN tmpMI.CountForecast > 0
                             THEN tmpMI.AmountRemains / tmpMI.CountForecast
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast      
             -- Ост. в днях (по пр.) - без К
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0
                             THEN tmpMI.AmountRemains / tmpMI.CountForecastOrder
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder

           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis
           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName


           , tmpMI.isErased

       FROM _tmpMI_master AS tmpMI

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
 
            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = tmpMI.GoodsId_basis
            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind   ON Object_GoodsKind.Id   = tmpMI.GoodsKindId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_basis
                                 ON ObjectLink_Goods_Measure_basis.ObjectId = Object_Goods_basis.Id
                                AND ObjectLink_Goods_Measure_basis.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_basis ON Object_Measure_basis.Id = ObjectLink_Goods_Measure_basis.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = Object_Goods_basis.Id
                                AND ObjectLink_OrderType_Goods.DescId        = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId   = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderType_Unit.ChildObjectId

       WHERE tmpMI.GoodsId_complete = 0
         AND tmpMI.ContainerId      = 0 -- отбросили остатки на ПР-ВЕ
         AND tmpMI.GoodsId_basis    > 0 -- отбросили Ирну (временно)
      ;

       RETURN NEXT Cursor1;

       OPEN Cursor2 FOR
       SELECT
             tmpMI.MovementItemId   AS Id
           , tmpMI.ContainerId      AS ContainerId
           , CASE WHEN tmpMI.GoodsId_complete = 0
                       THEN tmpMI.GoodsId :: TVarChar || '_' || tmpMI.GoodsKindId :: TVarChar
                  ELSE tmpMI.GoodsId_complete :: TVarChar || '_' || tmpMI.GoodsKindId_complete :: TVarChar
             END  :: TVarChar AS KeyId
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_Measure.ValueData            AS MeasureName

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.Amount           :: TFloat AS Amount           -- Заказ на УПАК
           , tmpMI.AmountSecond     :: TFloat AS AmountSecond     -- Дозаказ на УПАК

             -- Ост. начальн.
           , CASE WHEN ABS (tmpMI.AmountRemains) < 1 THEN tmpMI.AmountRemains ELSE CAST (tmpMI.AmountRemains AS NUMERIC (16, 1)) END :: TFloat AS AmountRemains

              -- неотгуж. заявка
           , CAST (tmpMI.AmountPartnerPrior       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
           , CAST (tmpMI.AmountPartnerPriorPromo  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorPromo
            -- сегодня заявка
           , CAST (tmpMI.AmountPartner            AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
           , CAST (tmpMI.AmountPartnerPromo       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromo

            -- Прогноз по прод.
           , CASE WHEN ABS (tmpMI.AmountForecast) < 1           THEN tmpMI.AmountForecast           ELSE CAST (tmpMI.AmountForecast           AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast     
           , CASE WHEN ABS (tmpMI.AmountForecastPromo) < 1      THEN tmpMI.AmountForecastPromo      ELSE CAST (tmpMI.AmountForecastPromo      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastPromo
             -- Прогноз по заяв. 
           , CASE WHEN ABS (tmpMI.AmountForecastOrder) < 1      THEN tmpMI.AmountForecastOrder      ELSE CAST (tmpMI.AmountForecastOrder      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder
           , CASE WHEN ABS (tmpMI.AmountForecastOrderPromo) < 1 THEN tmpMI.AmountForecastOrderPromo ELSE CAST (tmpMI.AmountForecastOrderPromo AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrderPromo

             -- Норм 1д (по пр.) без К
           , CAST (tmpMI.CountForecast AS NUMERIC (16, 1))      :: TFloat AS CountForecast
             -- Норм 1д (по зв.) без К
           , CAST (tmpMI.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- Ост. в днях (по зв.) - без К
           , CAST (CASE WHEN tmpMI.CountForecast > 0
                             THEN tmpMI.AmountRemains / tmpMI.CountForecast
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast      
             -- Ост. в днях (по пр.) - без К
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0
                             THEN tmpMI.AmountRemains / tmpMI.CountForecastOrder
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder

           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis

           , tmpMI.isErased

       FROM _tmpMI_master AS tmpMI

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
 
            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind   ON Object_GoodsKind.Id   = tmpMI.GoodsKindId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
       ;
       RETURN NEXT Cursor2;
       
       OPEN Cursor3 FOR
       SELECT
             tmpMI.MovementItemId   AS Id
           , tmpMI.ContainerId      AS ContainerId

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_Goods_complete.Id            AS GoodsId_complete
           , Object_Goods_complete.ObjectCode    AS GoodsCode_complete
           , Object_Goods_complete.ValueData     AS GoodsName_complete

           , Object_Goods_basis.Id               AS GoodsId_basis
           , Object_Goods_basis.ObjectCode       AS GoodsCode_basis
           , Object_Goods_basis.ValueData        AS GoodsName_basis

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_GoodsKind_complete.Id        AS GoodsKindId_complete
           , Object_GoodsKind_complete.ValueData AS GoodsKindName_complete

           , Object_Measure.ValueData            AS MeasureName
           , Object_Measure_complete.ValueData   AS MeasureName_complete
           , Object_Measure_basis.ValueData      AS MeasureName_basis

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CASE WHEN tmpMI.GoodsId_complete = 0
                       THEN tmpMI.GoodsId <> tmpMI.GoodsId_basis
                  ELSE tmpMI.GoodsId_complete <> tmpMI.GoodsId_basis
             END :: Boolean AS isCheck_basis

           , tmpMI.Amount           :: TFloat AS Amount           -- Заказ на УПАК
           , tmpMI.AmountSecond     :: TFloat AS AmountSecond     -- Дозаказ на УПАК

             -- Ост. начальн.
           , CASE WHEN ABS (tmpMI.AmountRemains) < 1 THEN tmpMI.AmountRemains ELSE CAST (tmpMI.AmountRemains AS NUMERIC (16, 1)) END :: TFloat AS AmountRemains

              -- неотгуж. заявка
           , CAST (tmpMI.AmountPartnerPrior       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
           , CAST (tmpMI.AmountPartnerPriorPromo  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorPromo
            -- сегодня заявка
           , CAST (tmpMI.AmountPartner            AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
           , CAST (tmpMI.AmountPartnerPromo       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromo

            -- Прогноз по прод.
           , CASE WHEN ABS (tmpMI.AmountForecast) < 1           THEN tmpMI.AmountForecast           ELSE CAST (tmpMI.AmountForecast           AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast     
           , CASE WHEN ABS (tmpMI.AmountForecastPromo) < 1      THEN tmpMI.AmountForecastPromo      ELSE CAST (tmpMI.AmountForecastPromo      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastPromo
             -- Прогноз по заяв. 
           , CASE WHEN ABS (tmpMI.AmountForecastOrder) < 1      THEN tmpMI.AmountForecastOrder      ELSE CAST (tmpMI.AmountForecastOrder      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder
           , CASE WHEN ABS (tmpMI.AmountForecastOrderPromo) < 1 THEN tmpMI.AmountForecastOrderPromo ELSE CAST (tmpMI.AmountForecastOrderPromo AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrderPromo

             -- Норм 1д (по пр.) без К
           , CAST (tmpMI.CountForecast AS NUMERIC (16, 1))      :: TFloat AS CountForecast
             -- Норм 1д (по зв.) без К
           , CAST (tmpMI.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- Ост. в днях (по зв.) - без К
           , CAST (CASE WHEN tmpMI.CountForecast > 0
                             THEN tmpMI.AmountRemains / tmpMI.CountForecast
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast      
             -- Ост. в днях (по пр.) - без К
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0
                             THEN tmpMI.AmountRemains / tmpMI.CountForecastOrder
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder

           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis
           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName

           , Object_GoodsKind_pf.ValueData             AS GoodsKindName_pf
           , Object_GoodsKindComplete_pf.ValueData     AS GoodsKindCompleteName_pf
           , ObjectDate_Value.ValueData                AS PartionDate_pf

           , tmpMI.isErased

       FROM _tmpMI_master AS tmpMI

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
 
            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods              ON Object_Goods.Id          = tmpMI.GoodsId
            LEFT JOIN Object AS Object_Goods_complete     ON Object_Goods_complete.Id = tmpMI.GoodsId_complete
            LEFT JOIN Object AS Object_Goods_basis        ON Object_Goods_basis.Id    = tmpMI.GoodsId_basis

            LEFT JOIN Object AS Object_GoodsKind          ON Object_GoodsKind.Id          = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = tmpMI.GoodsKindId_complete

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_complete
                                 ON ObjectLink_Goods_Measure_complete.ObjectId = Object_Goods_complete.Id
                                AND ObjectLink_Goods_Measure_complete.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_complete ON Object_Measure_complete.Id = ObjectLink_Goods_Measure_complete.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_basis
                                 ON ObjectLink_Goods_Measure_basis.ObjectId = Object_Goods_basis.Id
                                AND ObjectLink_Goods_Measure_basis.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_basis ON Object_Measure_basis.Id = ObjectLink_Goods_Measure_basis.ChildObjectId

            LEFT JOIN ContainerLinkObject AS CLO_Unit
                                          ON CLO_Unit.ContainerId = tmpMI.ContainerId
                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                          ON CLO_GoodsKind.ContainerId = tmpMI.ContainerId
                                         AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind_pf ON Object_GoodsKind_pf.Id = CLO_GoodsKind.ObjectId
            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                          ON CLO_PartionGoods.ContainerId = tmpMI.ContainerId
                                         AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
            LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                    AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                 ON ObjectLink_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                AND ObjectLink_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete_pf ON Object_GoodsKindComplete_pf.Id = ObjectLink_GoodsKindComplete.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = Object_Goods_basis.Id
                                AND ObjectLink_OrderType_Goods.DescId        = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId   = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = CASE WHEN tmpMI.ContainerId > 0 THEN CLO_Unit.ObjectId ELSE ObjectLink_OrderType_Unit.ChildObjectId END
           ;

       RETURN NEXT Cursor3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_OrderInternalPackRemains (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.10.17         * 
 19.06.15                                        * all
 31.03.15         * add GoodsGroupNameFull
 02.03.14         * add AmountRemains, AmountPartner, AmountForecast, AmountForecastOrder
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
