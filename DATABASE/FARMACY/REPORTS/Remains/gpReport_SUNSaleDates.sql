-- Function: gpReport_SUNSaleDates()

DROP FUNCTION IF EXISTS gpReport_SUNSaleDates (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SUNSaleDates(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Двта конца
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer
             , UnitName TVarChar
             , GoodsCode Integer
             , GoodsName TVarChar

             , Amount TFloat
             , Summa TFloat

             , AmountSend TFloat
             , SummaSend TFloat

             , AmountCheck TFloat
             , SummaCheck TFloat

             , AmountSendTheir TFloat
             , SummaSendTheir TFloat

             , AmountLoss TFloat
             , SummaLoss TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH tmpMovement AS (SELECT Movement.id
                              , Movement.OperDate
                              , MovementLinkObject_To.ObjectId  AS UnitID
                         FROM Movement
                              INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                         ON MovementBoolean_SUN.MovementId = Movement.Id
                                                        AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                        AND MovementBoolean_SUN.ValueData = True

                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                           AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId = 0)

                              LEFT JOIN MovementBoolean AS MovementBoolean_SUN_V2
                                                        ON MovementBoolean_SUN_V2.MovementId = Movement.Id
                                                       AND MovementBoolean_SUN_V2.DescId = zc_MovementBoolean_SUN_V2()

                         WHERE Movement.DescId = zc_Movement_Send()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND COALESCE (MovementBoolean_SUN_V2.ValueData, False) = False
                           AND MovementLinkObject_To.ObjectId <> 11299914)

       , tmpMovementContainer  AS (SELECT Movement.UnitId
                                        , Movement.OperDate
                                        , Container.ObjectId                     AS GoodsId
                                        , MovementItemContainer.ContainerID
                                        , Sum(MovementItemContainer.Amount)  AS Amount
                                   FROM tmpMovement AS Movement

                                        INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.ID
                                                                        AND MovementItemContainer.isActive = True

                                        INNER JOIN MovementItem ON MovementItem.ID = MovementItemContainer.MovementItemID
                                                               AND MovementItem.DescId = zc_MI_Child()

                                        INNER JOIN Container ON  Container.DescId = zc_Container_Count()
                                                            AND  Container.ID = MovementItemContainer.ContainerID

                                        LEFT JOIN MovementItemContainer AS MIIncome
                                                                        ON MIIncome.ContainerID = MovementItemContainer.ContainerID
                                                                       AND MIIncome.MovementDescId = zc_Movement_Income()
                                   WHERE COALESCE (MIIncome.Id, 0) = 0
                                   GROUP BY Movement.UnitId
                                          , Movement.OperDate
                                          , Container.ObjectId
                                          , MovementItemContainer.ContainerID)

       , tmpContainerIn  AS (SELECT tmpMovementContainer.UnitId
                                  , tmpMovementContainer.GoodsId
                                  , Sum(tmpMovementContainer.Amount)::TFloat     AS Amount
                                  , Sum(tmpMovementContainer.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0))::TFloat AS Summa

                             FROM tmpMovementContainer

                                  INNER JOIN ObjectLink AS ObjectLink_Goods
                                                        ON ObjectLink_Goods.ChildObjectId = tmpMovementContainer.GoodsId
                                                       AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                  INNER JOIN ObjectLink AS ObjectLink_Unit
                                                       ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                      AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                      AND ObjectLink_Unit.ChildObjectId = tmpMovementContainer.UnitId

                                  -- получаем значения цены и НТЗ из истории значений на начало дня
                                  LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                          ON ObjectHistory_Price.ObjectId = ObjectLink_Goods.ObjectId
                                                         AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                         AND tmpMovementContainer.OperDate >= ObjectHistory_Price.StartDate
                                                         AND tmpMovementContainer.OperDate < ObjectHistory_Price.EndDate
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                               ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                              AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                             WHERE tmpMovementContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                               AND tmpMovementContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'

                             GROUP BY tmpMovementContainer.UnitId
                                  , tmpMovementContainer.GoodsId)

       , tmpContainerSend  AS (SELECT Container.UnitId
                                     , Container.GoodsId
                                     , Sum(-1 * MovementItemContainer.Amount)::TFloat                                 AS AmountSend
                                     , Sum(-1 * MovementItemContainer.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0))::TFloat   AS SummaSend

                                FROM (SELECT DISTINCT tmpMovementContainer.UnitId, tmpMovementContainer.GoodsId, tmpMovementContainer.ContainerID FROM tmpMovementContainer) AS Container

                                     INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ContainerID
                                                                     AND MovementItemContainer.MovementDescId = zc_Movement_Send()
                                                                     AND MovementItemContainer.Amount < 0
                                                                     AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                                                     AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'

                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = MovementItemContainer.MovementId
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                     INNER JOIN ObjectLink AS ObjectLink_Goods
                                                           ON ObjectLink_Goods.ChildObjectId = Container.GoodsId
                                                          AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                     INNER JOIN ObjectLink AS ObjectLink_Unit
                                                          ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                         AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                         AND ObjectLink_Unit.ChildObjectId = Container.UnitId

                                            -- получаем значения цены и НТЗ из истории значений на начало дня
                                     LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                             ON ObjectHistory_Price.ObjectId = ObjectLink_Goods.ObjectId
                                                            AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                            AND MovementItemContainer.OperDate >= ObjectHistory_Price.StartDate
                                                            AND MovementItemContainer.OperDate < ObjectHistory_Price.EndDate
                                     LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                                  ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                                 AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()

                                WHERE MovementLinkObject_To.ObjectId <> 11299914
                                GROUP BY Container.UnitId
                                       , Container.GoodsId)

       , tmpContainerCheck  AS (SELECT Container.UnitId
                                     , Container.GoodsId
                                     , Sum(-1 * MovementItemContainer.Amount)::TFloat                                 AS AmountCheck
                                     , Sum(-1 * MovementItemContainer.Amount * MovementItemContainer.Price)::TFloat   AS SummaCheck

                                FROM (SELECT DISTINCT tmpMovementContainer.UnitId, tmpMovementContainer.GoodsId, tmpMovementContainer.ContainerID FROM tmpMovementContainer) AS Container

                                     INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ContainerID
                                                                     AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                                                                     AND MovementItemContainer.Amount <> 0
                                                                     AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                                                     AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'

                                GROUP BY Container.UnitId
                                       , Container.GoodsId)
       , tmpMovementTheir AS (SELECT Movement.id
                                   , Movement.OperDate
                                   , MovementLinkObject_From.ObjectId  AS UnitID
                              FROM Movement
                                   INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                              ON MovementBoolean_SUN.MovementId = Movement.Id
                                                             AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                             AND MovementBoolean_SUN.ValueData = True

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0)

                                   LEFT JOIN MovementBoolean AS MovementBoolean_SUN_V2
                                                             ON MovementBoolean_SUN_V2.MovementId = Movement.Id
                                                            AND MovementBoolean_SUN_V2.DescId = zc_MovementBoolean_SUN_V2()

                              WHERE Movement.DescId = zc_Movement_Send()
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND COALESCE (MovementBoolean_SUN_V2.ValueData, False) = False
                                AND Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                                AND MovementLinkObject_From.ObjectId <> 11299914
                                )

       , tmpMovementItemTheir  AS (SELECT Movement.UnitId
                                        , Container.ObjectId                      AS GoodsId
                                        , Sum(-1 * MovementItemContainer.Amount)  AS AmountSendTheir
                                        , Sum(-1 * MovementItemContainer.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0))::TFloat   AS SummaSendTheir
                                   FROM tmpMovementTheir AS Movement

                                        INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.ID
                                                                        AND MovementItemContainer.Amount < 0

                                        INNER JOIN MovementItem ON MovementItem.ID = MovementItemContainer.MovementItemID
                                                               AND MovementItem.DescId = zc_MI_Child()

                                        INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                            AND Container.ID = MovementItemContainer.ContainerID
                                                            AND Container.ID NOT IN (SELECT DISTINCT tmpMovementContainer.ContainerID FROM tmpMovementContainer)

                                        INNER JOIN ObjectLink AS ObjectLink_Goods
                                                              ON ObjectLink_Goods.ChildObjectId = Container.ObjectId
                                                             AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                        INNER JOIN ObjectLink AS ObjectLink_Unit
                                                             ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                            AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                            AND ObjectLink_Unit.ChildObjectId = Movement.UnitId

                                               -- получаем значения цены и НТЗ из истории значений на начало дня
                                        LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                                ON ObjectHistory_Price.ObjectId = ObjectLink_Goods.ObjectId
                                                               AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                               AND Movement.OperDate >= ObjectHistory_Price.StartDate
                                                               AND Movement.OperDate < ObjectHistory_Price.EndDate
                                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                                     ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                                    AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                                   GROUP BY Movement.UnitId
                                          , Container.ObjectId)
       , tmpSendDelay  AS (SELECT Container.UnitId
                                , Container.GoodsId
                                , Sum(-1 * MovementItemContainer.Amount)::TFloat                                 AS AmountSend
                                , Sum(-1 * MovementItemContainer.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0))::TFloat   AS SummaSend

                           FROM (SELECT DISTINCT tmpMovementContainer.UnitId, tmpMovementContainer.GoodsId, tmpMovementContainer.ContainerID FROM tmpMovementContainer) AS Container

                                INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ContainerID
                                                                AND MovementItemContainer.MovementDescId = zc_Movement_Send()
                                                                AND MovementItemContainer.Amount < 0
                                                                AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                                                AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'

                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = MovementItemContainer.MovementId
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                INNER JOIN ObjectLink AS ObjectLink_Goods
                                                      ON ObjectLink_Goods.ChildObjectId = Container.GoodsId
                                                     AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_Unit
                                                     ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                     AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                    AND ObjectLink_Unit.ChildObjectId = Container.UnitId

                                       -- получаем значения цены и НТЗ из истории значений на начало дня
                                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                        ON ObjectHistory_Price.ObjectId = ObjectLink_Goods.ObjectId
                                                       AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                       AND MovementItemContainer.OperDate >= ObjectHistory_Price.StartDate
                                                       AND MovementItemContainer.OperDate < ObjectHistory_Price.EndDate
                                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                             ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                            AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                           WHERE MovementLinkObject_To.ObjectId = 11299914
                           GROUP BY Container.UnitId
                                  , Container.GoodsId)
       , tmpLoss  AS (SELECT Container.UnitId
                           , Container.GoodsId
                           , Sum(-1 * MovementItemContainer.Amount)::TFloat                                 AS AmountLoss
                           , Sum(-1 * MovementItemContainer.Amount * COALESCE (ObjectHistoryFloat_Price.ValueData, 0))::TFloat   AS SummaLoss

                      FROM (SELECT DISTINCT tmpMovementContainer.UnitId, tmpMovementContainer.GoodsId, tmpMovementContainer.ContainerID FROM tmpMovementContainer) AS Container

                           INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.ContainerID
                                                           AND MovementItemContainer.MovementDescId = zc_Movement_Loss()
                                                           AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                                           AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'

                           INNER JOIN ObjectLink AS ObjectLink_Goods
                                                 ON ObjectLink_Goods.ChildObjectId = Container.GoodsId
                                                AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                           INNER JOIN ObjectLink AS ObjectLink_Unit
                                                ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                               AND ObjectLink_Unit.ChildObjectId = Container.UnitId

                                  -- получаем значения цены и НТЗ из истории значений на начало дня
                           LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                   ON ObjectHistory_Price.ObjectId = ObjectLink_Goods.ObjectId
                                                  AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                  AND MovementItemContainer.OperDate >= ObjectHistory_Price.StartDate
                                                  AND MovementItemContainer.OperDate < ObjectHistory_Price.EndDate
                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                        ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                       AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                      GROUP BY Container.UnitId
                             , Container.GoodsId)



    SELECT Object_Unit.Id                                                      AS Id
         , Object_Unit.ValueData                                               AS UnitName
         , Object_Goods.ObjectCode
         , Object_Goods.ValueData

         , tmpContainerIn.Amount::TFloat                                       AS Amount
         , tmpContainerIn.Summa::TFloat                                        AS Summa

         , tmpContainerSend.AmountSend::TFloat                                 AS AmountSend
         , tmpContainerSend.SummaSend::TFloat                                  AS SummaSend

         , tmpContainerCheck.AmountCheck::TFloat                               AS AmountCheck
         , tmpContainerCheck.SummaCheck::TFloat                                AS SummaCheck

         , tmpMovementItemTheir.AmountSendTheir::TFloat                        AS AmountSendTheir
         , tmpMovementItemTheir.SummaSendTheir::TFloat                         AS SummaSendTheir

         , (COALESCE(tmpSendDelay.AmountSend, 0) +
           COALESCE(tmpLoss.AmountLoss, 0))::TFloat                            AS AmountSendTheir
         , (COALESCE(tmpSendDelay.SummaSend, 0) +
           COALESCE(tmpLoss.SummaLoss, 0))::TFloat                             AS SummaSendTheir

    FROM (SELECT DISTINCT T1.UnitId, T1.GoodsId FROM (
           SELECT DISTINCT tmpMovementContainer.UnitId, tmpMovementContainer.GoodsId FROM tmpMovementContainer
           UNION ALL
           SELECT DISTINCT tmpMovementItemTheir.UnitId, tmpMovementItemTheir.GoodsId FROM tmpMovementItemTheir) AS T1) AS Container

         LEFT JOIN tmpContainerIn ON tmpContainerIn.UnitId = Container.UnitId
                                 AND tmpContainerIn.GoodsId = Container.GoodsId

         LEFT JOIN tmpContainerSend ON tmpContainerSend.UnitId = Container.UnitId
                                    AND tmpContainerSend.GoodsId = Container.GoodsId

         LEFT JOIN tmpContainerCheck ON tmpContainerCheck.UnitId = Container.UnitId
                                    AND tmpContainerCheck.GoodsId = Container.GoodsId

         LEFT JOIN tmpMovementItemTheir ON tmpMovementItemTheir.UnitId = Container.UnitId
                                       AND tmpMovementItemTheir.GoodsId = Container.GoodsId

         LEFT JOIN tmpSendDelay ON tmpSendDelay.UnitId = Container.UnitId
                               AND tmpSendDelay.GoodsId = Container.GoodsId

         LEFT JOIN tmpLoss ON tmpLoss.UnitId = Container.UnitId
                          AND tmpLoss.GoodsId = Container.GoodsId

         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Container.GoodsId
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Container.UnitId

    WHERE COALESCE(tmpContainerIn.Amount, 0) <> 0 OR COALESCE(tmpContainerSend.AmountSend, 0) <> 0
       OR COALESCE(tmpContainerCheck.AmountCheck, 0) <> 0 OR COALESCE(tmpMovementItemTheir.AmountSendTheir, 0) <> 0
    ORDER BY Object_Unit.ValueData, Object_Goods.objectcode
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.02.20                                                       *
*/

-- тест select * from gpReport_SUNSaleDates(inStartDate := ('01.01.2016')::TDateTime , inEndDate := ('13.02.2020')::TDateTime , inUnitId := 375627 ,  inSession := '3');