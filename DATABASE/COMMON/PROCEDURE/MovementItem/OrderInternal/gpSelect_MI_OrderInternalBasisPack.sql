-- Function: gpSelect_MI_OrderInternalBasisPack()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalBasisPack (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalBasisPack(
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

   DECLARE vbOperDate TDateTime;
   DECLARE vbDayCount Integer;
   DECLARE vbFromId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется
     SELECT Movement.OperDate
          , 1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData)))
          , MovementLinkObject_From.ObjectId
            INTO vbOperDate, vbDayCount, vbFromId
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;


     -- 
     CREATE TEMP TABLE _tmpMI_master (MovementItemId Integer, GoodsId Integer
                                    , Amount TFloat, AmountSecond TFloat, AmountRemains TFloat, AmountPartner TFloat
                                    , AmountForecast TFloat
                                    , isErased Boolean) ON COMMIT DROP;
     INSERT INTO _tmpMI_master (MovementItemId, GoodsId
                              , Amount, AmountSecond, AmountRemains, AmountPartner
                              , AmountForecast
                              , isErased)
                              -- результат
                              SELECT MovementItem.Id AS MovementItemId
                                   , MovementItem.ObjectId AS GoodsId

                                   , MovementItem.Amount                                   AS Amount
                                   , COALESCE (MIFloat_AmountSecond.ValueData, 0)          AS AmountSecond

                                   , COALESCE (MIFloat_AmountRemains.ValueData, 0)         AS AmountRemains
                                   , COALESCE (MIFloat_AmountPartner.ValueData, 0)         AS AmountPartner

                                   , COALESCE (MIFloat_AmountForecast.ValueData, 0)        AS AmountForecast

                                   , MovementItem.isErased                                 AS isErased

                              FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                   INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = tmpIsErased.isErased
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                               ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                               ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                                               ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
                             ;

       --
       OPEN Cursor1 FOR
       WITH tmpMI_Send AS (-- группируется Перемещение
                           SELECT tmpMI.GoodsId                          AS GoodsId
                                , SUM (tmpMI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS Amount
                           FROM (SELECT MIContainer.ObjectId_Analyzer                  AS GoodsId
                                      , SUM (MIContainer.Amount)                       AS Amount
                                 FROM MovementItemContainer AS MIContainer
                                 WHERE MIContainer.OperDate   = vbOperDate
                                   AND MIContainer.DescId     = zc_MIContainer_Count()
                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                   AND MIContainer.WhereObjectId_Analyzer = vbFromId
                                   -- AND MIContainer.isActive = TRUE
                                 GROUP BY MIContainer.ObjectId_Analyzer
                                ) AS tmpMI
                                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                     ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                      ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                            GROUP BY tmpMI.GoodsId
                          )
       SELECT
             tmpMI.MovementItemId :: Integer      AS Id
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , ObjectString_Goods_Scale.ValueData   AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData             AS MeasureName

           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ObjectCode               AS UnitCode
           , Object_Unit.ValueData                AS UnitName

           , tmpMI.Amount           :: TFloat AS Amount           -- Заказ на склад
           , tmpMI.AmountSecond     :: TFloat AS AmountSecond     -- Дозаказ на склад
           , tmpMI_Send.Amount      :: TFloat AS AmountSend       -- Приход за "сегодня"

           , CASE WHEN tmpMI.AmountRemains + COALESCE (tmpMI_Send.Amount, 0) < tmpMI.AmountPartner THEN tmpMI.AmountPartner - tmpMI.AmountRemains - COALESCE (tmpMI_Send.Amount, 0) ELSE 0 END :: TFloat AS Amount_calc  -- Расчетный заказ

           , tmpMI.AmountRemains      :: TFloat  AS AmountRemains       -- Ост. начальн.
           , tmpMI.AmountPartner      :: TFloat  AS AmountPartner       -- расчет составляющих по заявке на производство (без производства ПФ)

           , (tmpMI.AmountPartner) :: TFloat AS AmountPartner_all       -- расчет составляющих по заявке на производство (итого)

           , CASE WHEN ABS (tmpMI.AmountForecast) < 1 THEN tmpMI.AmountForecast ELSE CAST (tmpMI.AmountForecast AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast -- Прогноз по факт. расходу на производство
           , CAST (CASE WHEN vbDayCount <> 0 THEN tmpMI.AmountForecast / vbDayCount ELSE 0 END AS NUMERIC (16, 1))                      :: TFloat AS CountForecast  -- Норм 1д (по пр.)
           , CAST (CASE WHEN (CASE WHEN vbDayCount <> 0 THEN tmpMI.AmountForecast / vbDayCount ELSE 0 END) > 0
                             THEN tmpMI.AmountRemains / CASE WHEN vbDayCount <> 0 THEN tmpMI.AmountForecast / vbDayCount ELSE 0 END
                        WHEN tmpMI.AmountRemains > 0
                             THEN 365
                        ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast -- Ост. в днях (по пр.)

           , CASE WHEN tmpMI.AmountRemains <= 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END :: Integer AS Color_remains
           , zc_Color_Cyan()   :: Integer AS ColorB_DayCountForecast -- $00E2C7C7
           , zc_Color_GreenL() :: Integer AS ColorB_AmountPartner    -- $00B6EAAA
           , zc_Color_Yelow()  :: Integer AS ColorB_AmountPrognoz    -- $008FF8F2 9435378

           , tmpMI.isErased

       FROM _tmpMI_master AS tmpMI
            LEFT JOIN tmpMI_Send ON tmpMI_Send.GoodsId     = tmpMI.GoodsId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = CASE WHEN Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                                                          THEN 8455 -- Склад специй
                                                                     ELSE 8439 -- Участок мясного сырья
                                                                END
          ;
       RETURN NEXT Cursor1;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.19         *
 27.06.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternalBasisPack (inMovementId:= 5609806, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_OrderInternalBasisPack (inMovementId:= 5609806, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
