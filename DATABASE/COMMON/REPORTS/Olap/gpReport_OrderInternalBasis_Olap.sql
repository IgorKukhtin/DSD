-- Function: gpReport_OrderInternalBasis_Olap ()

DROP FUNCTION IF EXISTS gpReport_OrderInternalBasis_Olap (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderInternalBasis_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderInternalBasis_Olap (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inFromId             Integer   ,    -- от кого
    IN inToId               Integer   ,    -- кому 
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate            TDateTime
             , InvNumber           TVarChar
             , DayOfWeekName_Full  TVarChar
             , DayOfWeekName       TVarChar
             , DayOfWeekNumber     Integer
             , MonthName           TVarChar
             , FromCode            Integer
             , FromName            TVarChar
             , ToCode              Integer
             , ToName              TVarChar
             , GoodsGroupNameFull  TVarChar
             , GoodsGroupName      TVarChar
             , GoodsId             Integer
             , GoodsCode           Integer
             , GoodsName           TVarChar
             , GoodsKindId         Integer
             , GoodsKindName       TVarChar
             , Amount              TFloat -- Заказ на склад
             , AmountSecond        TFloat -- Дозаказ на склад
             , AmountSend          TFloat -- Приход за "сегодня"
             , Amount_calc         TFloat -- Расчетный заказ
             , AmountRemains       TFloat -- Ост. начальн.
             , AmountPartner       TFloat -- расчет составляющих по заявке на производство (без производства ПФ)
             , AmountPartnerPrior  TFloat -- расчет составляющих по заявке на производство (для производства ПФ)
             , AmountPartner_all   TFloat -- расчет составляющих по заявке на производство (итого)
             , AmountPartnerSecond TFloat -- расчет ....
             , AmountForecast      TFloat -- Прогноз по факт. расходу на производство
             , CountForecast       TFloat -- Норм 1д (по пр.)
             , DayCountForecast    TFloat -- Ост. в днях (по пр.)  
             , AmountSendIn_or     TFloat -- расход по заявке
             , AmountSendOut_or    TFloat -- возврат по заявке
             , AmountSend_or       TFloat -- итого расход по заявке
             , AmountSend_diff     TFloat -- осталось выдать
             )   
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- Ограничения по товару
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
 
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
          SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inGoodsId <> 0
         THEN
             INSERT INTO _tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE
             INSERT INTO _tmpGoods (GoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;

    -- ограничения по подразделениям
    CREATE TEMP TABLE _tmpUnitFrom (UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpUnitTo (UnitId Integer) ON COMMIT DROP;
    -- от кого
    IF inFromId <> 0
    THEN
        INSERT INTO _tmpUnitFrom (UnitId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpUnitFrom (UnitId)
          SELECT Id FROM Object_Unit_View;
    END IF;
    -- кому
    IF inToId <> 0
    THEN
        INSERT INTO _tmpUnitTo (UnitId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpUnitTo (UnitId)
          SELECT Id FROM Object_Unit_View;
    END IF;
    -------

    
    -- Результат
    RETURN QUERY
    WITH
     tmpMovement AS (SELECT Movement.Id        AS Id
                          , Movement.OperDate  AS OperDate
                          , Movement.InvNumber
                          , 1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData))) AS DayCount
                          , MovementLinkObject_From.ObjectId AS FromId
                     FROM Movement 
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                        INNER JOIN _tmpUnitFrom ON _tmpUnitFrom.UnitId = MovementLinkObject_From.ObjectId

                        LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                                  ON MovementBoolean_Remains.MovementId = Movement.Id
                                                 AND MovementBoolean_Remains.DescId = zc_MovementBoolean_Remains()

                        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                               ON MovementDate_OperDateStart.MovementId = Movement.Id
                                              AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
                        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                               ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                              AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                       AND Movement.DescId = zc_Movement_OrderInternal()
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                       AND (COALESCE (MovementBoolean_Remains.ValueData, FALSE) = FALSE)
                     )
     
     , tmpMI AS (SELECT Movement.Id           AS MovementId
                      , Movement.FromId       AS FromId
                      , Movement.OperDate     AS OperDate
                      , Movement.InvNumber    AS InvNumber
                      , Movement.DayCount     AS DayCount
                      , MovementItem.Id       AS MovementItemId
                      , MovementItem.ObjectId AS GoodsId
                      , MovementItem.Amount   AS Amount
                 FROM tmpMovement AS Movement
                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = FALSE
                      INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                 )
     
     , tmpMIFloat AS (SELECT MovementItemFloat.*
                      FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                        AND MovementItemFloat.DescId IN (zc_MIFloat_AmountSecond()
                                                       , zc_MIFloat_AmountRemains()
                                                       , zc_MIFloat_AmountPartner()
                                                       , zc_MIFloat_AmountPartnerPrior()
                                                       , zc_MIFloat_AmountPartnerSecond()
                                                       , zc_MIFloat_AmountForecast()
                                                       )
                      )

     , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                               AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                             )

     , tmpMILO_Receipt AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                               AND MovementItemLinkObject.DescId = zc_MILinkObject_Receipt()
                             )

     , tmpData AS (SELECT tmpMI.OperDate
                        , STRING_AGG (tmpMI.InvNumber :: TVarChar, ';') :: TVarChar AS InvNumber
                        , tmpMI.DayCount
                        , tmpMI.FromId
                        , tmpMI.GoodsId
                        , COALESCE (MILinkObject_Receipt.ObjectId, 0)   AS ReceiptId
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                        , SUM (tmpMI.Amount)                                          AS Amount
                        , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0))          AS AmountSecond
                        , SUM (COALESCE (MIFloat_AmountRemains.ValueData, 0))         AS AmountRemains
                        , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))         AS AmountPartner
                        , SUM (COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0))    AS AmountPartnerPrior
                        , SUM (COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0))   AS AmountPartnerSecond
                        , SUM (COALESCE (MIFloat_AmountForecast.ValueData, 0))        AS AmountForecast
                   FROM tmpMI
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountSecond
                                             ON MIFloat_AmountSecond.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountRemains
                                             ON MIFloat_AmountRemains.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                             ON MIFloat_AmountPartner.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountPartnerPrior
                                             ON MIFloat_AmountPartnerPrior.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountPartnerPrior.DescId = zc_MIFloat_AmountPartnerPrior()
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountPartnerSecond
                                             ON MIFloat_AmountPartnerSecond.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountForecast
                                             ON MIFloat_AmountForecast.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()

                        LEFT JOIN tmpMILO_Receipt AS MILinkObject_Receipt
                                                  ON MILinkObject_Receipt.MovementItemId = tmpMI.MovementItemId

                        LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = tmpMI.MovementItemId
                   GROUP BY tmpMI.OperDate
                          , tmpMI.DayCount
                          , tmpMI.FromId
                          , tmpMI.GoodsId
                          , COALESCE (MILinkObject_Receipt.ObjectId, 0)
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
              )

     , tmpMI_Send AS (-- группируется Перемещение
                       SELECT tmpMI.OperDate     AS OperDate
                            , tmpMI.UnitId       AS UnitId
                            , tmpMI.GoodsId      AS GoodsId
                            , tmpMI.GoodsKindId  AS GoodsKindId
                            , SUM (tmpMI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS Amount
                       FROM (SELECT MIContainer.OperDate
                                  , MIContainer.WhereObjectId_Analyzer     AS UnitId
                                  , MIContainer.ObjectId_Analyzer          AS GoodsId
                                  , CASE -- !!!временно захардкодил!!!
                                         WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- Склад МИНУСОВКА
                                              THEN 8338 -- морож.
                                         ELSE 0
                                    END                                    AS GoodsKindId
                                  , SUM (MIContainer.Amount)               AS Amount
                             FROM MovementItemContainer AS MIContainer
                                  INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                             WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                               AND MIContainer.DescId     = zc_MIContainer_Count()
                               AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                               --AND MIContainer.WhereObjectId_Analyzer = inFromId
                             GROUP BY MIContainer.ObjectId_Analyzer, MIContainer.OperDate
                                    , MIContainer.WhereObjectId_Analyzer
                                    , CASE -- !!!временно захардкодил!!!
                                           WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- Склад МИНУСОВКА
                                                THEN 8338 -- морож.
                                           ELSE 0
                                      END
                            ) AS tmpMI
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        GROUP BY tmpMI.OperDate
                               , tmpMI.UnitId
                               , tmpMI.GoodsId
                               , tmpMI.GoodsKindId
                      )
       , tmpListDate AS (SELECT tmp.OperDate
                              , tmpWeekDay.Number
                              , ROW_NUMBER()OVER (ORDER BY tmp.OperDate) AS Num_day
                         FROM (SELECT generate_series(inStartDate, inStartDate +interval '6 Day', '1 day' ::interval) AS OperDate) AS tmp
                               LEFT JOIN zfCalc_DayOfWeekName (tmp.OperDate) AS tmpWeekDay ON 1=1
                        )

       -- факт перемещения (расход / возврат / итого выдали)
       , tmpMovementSend AS (SELECT tmp.MovementId                  AS MovementId
                                  , MovementLinkMovement.MovementId AS MovementId_Send
                                  , tmp.OperDate                    AS OperDate
                             FROM (SELECT DISTINCT tmpMovement.Id AS MovementId, tmpMovement.OperDate FROM tmpMovement) AS tmp
                                  INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementChildId = tmp.MovementId
                                                                 AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Order()
                                  INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementId
                                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                                     AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                            )

       , tmpSend AS (SELECT tmpMovementSend.OperDate
                          , MIContainer.WhereObjectId_Analyzer     AS UnitId
                          , MIContainer.ObjectId_Analyzer          AS GoodsId
                          , CASE -- !!!временно захардкодил!!!
                                 WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- Склад МИНУСОВКА
                                      THEN 8338 -- морож.
                                 ELSE 0
                            END                                    AS GoodsKindId
                          , SUM (CASE WHEN MIContainer.isActive = FALSE THEN -1 * COALESCE (MIContainer.Amount,0) ELSE 0 END) AS AmountSendIn
                          , SUM (CASE WHEN MIContainer.isActive = TRUE  THEN      COALESCE (MIContainer.Amount,0) ELSE 0 END) AS AmountSendOut
                          , SUM (COALESCE (MIContainer.Amount,0))  AS AmountSend
                     FROM tmpMovementSend
                          INNER JOIN MovementItemContainer AS MIContainer
                                                           ON MIContainer.MovementId = tmpMovementSend.MovementId_Send
                                                          AND MIContainer.DescId     = zc_MIContainer_Count()
                                                          AND MIContainer.MovementDescId IN (zc_Movement_Send(), zc_Movement_SendAsset())
                          INNER JOIN _tmpUnitFrom ON _tmpUnitFrom.UnitId = MIContainer.WhereObjectId_Analyzer
                          INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer
                     GROUP BY tmpMovementSend.OperDate
                            , MIContainer.WhereObjectId_Analyzer
                            , MIContainer.ObjectId_Analyzer
                            , CASE WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- Склад МИНУСОВКА
                                        THEN 8338 -- морож.
                                   ELSE 0
                              END
                     )


       , tmpData_full AS (-- данные завки
                          SELECT tmp.OperDate
                               , tmp.InvNumber
                               , tmp.DayCount
                               , tmp.FromId
                               , tmp.GoodsId
                               , tmp.GoodsKindId
                               , tmp.ReceiptId
                               , tmp.Amount
                               , tmp.AmountSecond
                               , tmp.AmountRemains
                               , tmp.AmountPartner
                               , tmp.AmountPartnerPrior
                               , tmp.AmountPartnerSecond
                               , tmp.AmountForecast

                               , tmpMI_Send.Amount          :: TFloat AS AmountSend       -- Приход за "сегодня"

                               , tmpSend.AmountSendIn  :: TFloat AS AmountSendIn_or
                               , tmpSend.AmountSendOut :: TFloat AS AmountSendOut_or
                               , tmpSend.AmountSend    :: TFloat AS AmountSend_or

                          FROM tmpData AS tmp
                               -- приход сегодня
                               LEFT JOIN tmpMI_Send ON tmpMI_Send.GoodsId     = tmp.GoodsId
                                                   AND tmpMI_Send.GoodsKindId = tmp.GoodsKindId
                                                   AND tmpMI_Send.OperDate    = tmp.OperDate
                                                   AND tmpMI_Send.UnitId      = tmp.FromId
                               LEFT JOIN tmpSend ON tmpSend.GoodsId     = tmp.GoodsId
                                                   AND tmpSend.GoodsKindId = tmp.GoodsKindId
                                                   AND tmpSend.OperDate    = tmp.OperDate
                                                   AND tmpSend.UnitId      = tmp.FromId
                        UNION
                          -- если есть перемещения без заявки их тоже показываем
                          SELECT tmp.OperDate
                               , '' :: TVarChar AS InvNumber
                               , 0 AS DayCount
                               , tmp.UnitId
                               , tmp.GoodsId
                               , tmp.GoodsKindId
                               , 0 AS ReceiptId
                               , 0 AS Amount
                               , 0 AS AmountSecond
                               , 0 AS AmountRemains
                               , 0 AS AmountPartner
                               , 0 AS AmountPartnerPrior
                               , 0 AS AmountPartnerSecond
                               , 0 AS AmountForecast

                               , 0 AS AmountSend
                               
                               , tmp.AmountSendIn  AS AmountSendIn_or
                               , tmp.AmountSendOut AS AmountSendOut_or
                               , tmp.AmountSend    AS AmountSend_or
                               
                          FROM tmpSend AS tmp
                               INNER JOIN _tmpUnitFrom ON _tmpUnitFrom.UnitId = tmp.UnitId
                               LEFT JOIN tmpData ON tmpData.GoodsId     = tmp.GoodsId
                                                AND tmpData.GoodsKindId = tmp.GoodsKindId
                                                AND tmpData.OperDate    = tmp.OperDate
                                                AND tmpData.FromId      = tmp.UnitId
                          WHERE tmpData.GoodsId IS NULL
                        UNION
                          SELECT tmp.OperDate
                               , '' :: TVarChar AS InvNumber
                               , 0 AS DayCount
                               , tmp.UnitId
                               , tmp.GoodsId
                               , tmp.GoodsKindId
                               , 0 AS ReceiptId
                               , 0 AS Amount
                               , 0 AS AmountSecond
                               , 0 AS AmountRemains
                               , 0 AS AmountPartner
                               , 0 AS AmountPartnerPrior
                               , 0 AS AmountPartnerSecond
                               , 0 AS AmountForecast

                               , tmp.Amount AS AmountSend

                               , 0 AS AmountSendIn_or
                               , 0 AS AmountSendOut_or
                               , 0 AS AmountSend_or
                               
                          FROM tmpMI_Send AS tmp
                               INNER JOIN _tmpUnitFrom ON _tmpUnitFrom.UnitId = tmp.UnitId
                               LEFT JOIN tmpData ON tmpData.GoodsId     = tmp.GoodsId
                                                AND tmpData.GoodsKindId = tmp.GoodsKindId
                                                AND tmpData.OperDate    = tmp.OperDate
                                                AND tmpData.FromId      = tmp.UnitId
                          WHERE tmpData.GoodsId IS NULL
                          )

      --Результат
      SELECT tmpData.OperDate
           , tmpData.InvNumber ::TVarChar
           , (tmpListDate.Num_day::TVarChar ||' '||tmpWeekDay.DayOfWeekName_Full)    ::TVarChar AS DayOfWeekName_Full
           , (tmpListDate.Num_day::TVarChar ||' '||tmpWeekDay.DayOfWeekName)         ::TVarChar AS DayOfWeekName
           , (tmpListDate.Num_day)                                                   ::Integer  AS DayOfWeekNumber
           , zfCalc_MonthName (DATE_TRUNC ('Month', tmpData.OperDate)) ::TVarChar AS MonthName
           , Object_From.ObjectCode               AS FromCode
           , Object_From.ValueData                AS FromName
           , Object_To.ObjectCode                 AS ToCode
           , Object_To.ValueData                  AS ToName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , Object_GoodsKind.Id                  AS GoodsKindId
           , Object_GoodsKind.ValueData           AS GoodsKindName


           , tmpData.Amount             :: TFloat AS Amount           -- Заказ на склад
           , tmpData.AmountSecond       :: TFloat AS AmountSecond     -- Дозаказ на склад
           , tmpData.AmountSend          :: TFloat AS AmountSend       -- Приход за "сегодня"

           , CASE WHEN COALESCE (tmpData.AmountRemains,0) + COALESCE (tmpData.AmountSend, 0) < COALESCE (tmpData.AmountPartner,0) + COALESCE (tmpData.AmountPartnerPrior,0) + COALESCE (tmpData.AmountPartnerSecond,0)
                      THEN COALESCE (tmpData.AmountPartner,0) + COALESCE (tmpData.AmountPartnerPrior,0) + COALESCE (tmpData.AmountPartnerSecond,0) - COALESCE (tmpData.AmountRemains,0) - COALESCE (tmpData.AmountSend, 0) 
                  ELSE 0
             END                        :: TFloat AS Amount_calc  -- Расчетный заказ

           , tmpData.AmountRemains      :: TFloat  AS AmountRemains       -- Ост. начальн.
           , tmpData.AmountPartner      :: TFloat  AS AmountPartner       -- расчет составляющих по заявке на производство (без производства ПФ)
           , tmpData.AmountPartnerPrior :: TFloat  AS AmountPartnerPrior  -- расчет составляющих по заявке на производство (для производства ПФ)
           , (tmpData.AmountPartner + tmpData.AmountPartnerPrior + tmpData.AmountPartnerSecond) :: TFloat AS AmountPartner_all -- расчет составляющих по заявке на производство (итого)
           , tmpData.AmountPartnerSecond :: TFloat AS AmountPartnerSecond -- расчет ....

           , CASE WHEN ABS (tmpData.AmountForecast) < 1 THEN tmpData.AmountForecast ELSE CAST (tmpData.AmountForecast AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast -- Прогноз по факт. расходу на производство
           , CAST (CASE WHEN DayCount <> 0 THEN tmpData.AmountForecast / DayCount ELSE 0 END AS NUMERIC (16, 1))                      :: TFloat AS CountForecast  -- Норм 1д (по пр.)
           , CAST (CASE WHEN (CASE WHEN DayCount <> 0 THEN tmpData.AmountForecast / DayCount ELSE 0 END) > 0
                             THEN tmpData.AmountRemains / CASE WHEN DayCount <> 0 THEN tmpData.AmountForecast / DayCount ELSE 0 END
                        WHEN tmpData.AmountRemains > 0
                             THEN 365
                        ELSE 0
                   END
             AS NUMERIC (16, 1))        :: TFloat AS DayCountForecast -- Ост. в днях (по пр.)

           , tmpData.AmountSendIn_or  :: TFloat AS AmountSendIn_or
           , tmpData.AmountSendOut_or :: TFloat AS AmountSendOut_or
           , tmpData.AmountSend_or    :: TFloat AS AmountSend_or
           , (COALESCE (tmpData.Amount,0) - COALESCE (tmpData.AmountSend_or, 0)) :: TFloat AS AmountSend_diff
           
      FROM tmpData_full AS tmpData
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpData.GoodsId
                              AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup_parent
                               ON ObjectLink_Goods_GoodsGroup_parent.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                              AND ObjectLink_Goods_GoodsGroup_parent.DescId   = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = tmpData.GoodsId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN tmpData.ReceiptId > 0
                                                                AND (ObjectLink_Goods_GoodsGroup.ChildObjectId        IN (1942, 5064881) -- СО-ЭМУЛЬСИИ + СО-ПОСОЛ
                                                                  OR ObjectLink_Goods_GoodsGroup_parent.ChildObjectId IN (1942, 5064881) -- СО-ЭМУЛЬСИИ + СО-ПОСОЛ
                                                                    )
                                                                    THEN tmpData.FromId
                                                                WHEN Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                                                                                                     , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные  + Прочие материалы
                                                                                                                      )
                                                                    THEN 8455 -- Склад специй
                                                                ELSE 8439 -- Участок мясного сырья
                                                          END
          --ограничения по подразделению кому
          INNER JOIN _tmpUnitTo ON _tmpUnitTo.UnitId = Object_To.Id

       /*   -- приход сегодня
          LEFT JOIN tmpMI_Send ON tmpMI_Send.GoodsId     = tmpData.GoodsId
                              AND tmpMI_Send.GoodsKindId = tmpData.GoodsKindId
                              AND tmpMI_Send.OperDate    = tmpData.OperDate
                              AND tmpMI_Send.UnitId      = tmpData.FromId
          -- факт перемещение 
          LEFT JOIN tmpSend ON tmpSend.GoodsId     = tmpData.GoodsId
                           AND tmpSend.GoodsKindId = tmpData.GoodsKindId
                           AND tmpSend.OperDate    = tmpData.OperDate
                           AND tmpSend.UnitId      = tmpData.FromId
*/
          LEFT JOIN zfCalc_DayOfWeekName (tmpData.OperDate) AS tmpWeekDay ON 1=1
          LEFT JOIN tmpListDate ON tmpListDate.Number = tmpWeekDay.Number
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.03.20         *
*/

-- тест
-- SELECT * FROM gpReport_OrderInternalBasis_Olap (inStartDate:= '26.02.2020'::TDateTime, inEndDate:= '28.02.2020'::TDateTime, inGoodsGroupId:= 0, inGoodsId:= 0, inFromId:= 8447, inToId:= 8447 , inSession:= zfCalc_UserAdmin())
