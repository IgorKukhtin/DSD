 -- Function: gpReport_BalanceGoodsSUN()

DROP FUNCTION IF EXISTS gpReport_BalanceGoodsSUN (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_BalanceGoodsSUN(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsID  Integer
             , GoodsCode  Integer
             , GoodsName  TVarChar
             , Price TFloat
             , AmountIn TFloat
             , SummaIn TFloat
             , AmountOut TFloat
             , SummaOut TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    inStartDate := date_trunc('day', inStartDate);
    inDateFinal := date_trunc('day', inDateFinal) + interval '1  day';

    -- Результат
    RETURN QUERY
    WITH
         -- Все перемещения по СУН
         tmpSendAll AS (SELECT DISTINCT Movement.Id AS Id
                        FROM Movement

                             INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                        ON MovementBoolean_SUN.MovementId = Movement.Id
                                                       AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()


                        WHERE Movement.DescId = zc_Movement_Send()
                          AND COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.OperDate >= inStartDate AND Movement.OperDate < inDateFinal

                        )
           -- Перемещения по СУН содержимое
         , tmpSUNAll AS (SELECT MIMaster.ObjectId
                                       , MovementLinkObject_To.ObjectId = inUnitId  AS isActive
                                       , MIChild.Amount
                                  FROM tmpSendAll AS Movement

                                       INNER JOIN MovementItem AS MIMaster
                                                               ON MIMaster.MovementId =  Movement.Id
                                                              AND MIMaster.DescId = zc_MI_Master()
                                                              AND MIMaster.isErased = False

                                       INNER JOIN MovementItem AS MIChild
                                                               ON MIChild.MovementId =  Movement.Id
                                                              AND MIChild.ParentId = MIMaster.ID
                                                              AND MIChild.DescId = zc_MI_Child()
                                                              AND MIChild.isErased = False
                                                              AND MIChild.Amount <> 0

                                       LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()


                                       LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()


                                  WHERE MovementLinkObject_From.ObjectID = inUnitId
                                     OR MovementLinkObject_To.ObjectId = inUnitId

                                  )
         , tmpSUNGroup AS (SELECT tmpSUNAll.ObjectId
                                       , tmpSUNAll.isActive
                                       , Sum(tmpSUNAll.Amount) as Amount
                                  FROM tmpSUNAll
                                  GROUP BY tmpSUNAll.ObjectId, tmpSUNAll.isActive)
         , tmpSUN AS (SELECT tmpSUNGroup.ObjectId
                           , Sum(CASE WHEN tmpSUNGroup.isActive = TRUE THEN tmpSUNGroup.Amount END) as AmountIn
                           , Sum(CASE WHEN tmpSUNGroup.isActive = FALSE THEN tmpSUNGroup.Amount END) as AmountOut
                      FROM tmpSUNGroup
                      GROUP BY tmpSUNGroup.ObjectId)
         , tmpPrice AS (SELECT OL_Price_Goods.ChildObjectId      AS GoodsId
                             , ROUND (Price_Value.ValueData, 2)  AS Price
                        FROM ObjectLink AS OL_Price_Unit
                             -- !!!только для таких Аптек!!!
                             LEFT JOIN ObjectBoolean AS MCS_isClose
                                                     ON MCS_isClose.ObjectId = OL_Price_Unit.ObjectId
                                                    AND MCS_isClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                             LEFT JOIN ObjectLink AS OL_Price_Goods
                                                  ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                 AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                             INNER JOIN Object AS Object_Goods
                                               ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                              AND Object_Goods.isErased = FALSE
                             LEFT JOIN ObjecTFloat AS Price_Value
                                                   ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                  AND Price_Value.DescId = zc_ObjecTFloat_Price_Value()
                        WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          AND OL_Price_Unit.ChildObjectId = inUnitId
                          AND COALESCE (MCS_isClose.ValueData, FALSE) = FALSE
                       )


    SELECT tmpSUN.ObjectId
         , Object_Goods.ObjectCode                                AS GoodsCode
         , Object_Goods.ValueData                                 AS GoodsName
         , tmpPrice.Price::TFloat                                 AS Price
         , tmpSUN.AmountIn::TFloat
         , ROUND (tmpSUN.AmountIn * tmpPrice.Price, 2)::TFloat    AS SummaIn
         , tmpSUN.AmountOut::TFloat
         , ROUND (tmpSUN.AmountOut * tmpPrice.Price, 2)::TFloat   AS SummaOut
    FROM tmpSUN

         INNER JOIN Object AS Object_Goods ON Object_Goods.ID = tmpSUN.ObjectId

         LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpSUN.ObjectId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.08.19                                                       *
*/

-- тест
-- select * from gpReport_BalanceGoodsSUN(inStartDate := ('12.08.2019')::TDateTime , inDateFinal := ('17.08.2019')::TDateTime , inUnitId := 375626 ,  inSession := '3');