-- Function: gpReport_PositionsUKTVEDonSUN()

DROP FUNCTION IF EXISTS gpReport_PositionsUKTVEDonSUN (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PositionsUKTVEDonSUN(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumbr TVarChar, OperDate TDateTime
             , UnitCode Integer, UnitName TVarChar
             , UnitCodeTo Integer, UnitNameTo TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, PriceFrom TFloat, SummaFrom TFloat, PriceTo TFloat, SummaTo TFloat
              )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE curMovement refcursor;
  DECLARE vbId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);

  -- 1. Результат работы
  CREATE TEMP TABLE _tmpResult  (Id Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;


  OPEN curMovement FOR
    SELECT Movement.ID
    FROM Movement
         INNER JOIN MovementBoolean AS MovementBoolean_SUN
                 ON MovementBoolean_SUN.MovementId = Movement.Id
                AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                AND MovementBoolean_SUN.ValueData = TRUE
    WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
      AND Movement.DescId = zc_Movement_Send()
      AND Movement.StatusId <> zc_Enum_Status_Complete();


   -- начало цикла по курсору1
   LOOP
      -- данные по курсору1
      FETCH curMovement INTO vbId;
      -- если данные закончились, тогда выход
      IF NOT FOUND THEN EXIT; END IF;

      INSERT INTO _tmpResult (Id, GoodsId, Amount)
      SELECT vbId, MI.GoodsId, MI.Amount
      FROM gpSelect_MovementItem_Send_Child (inMovementId:= vbId, inSession:= inSession) AS MI
      WHERE MI.Amount > 0 AND MI.Color_calc = zc_Color_Red();


  END LOOP; -- финиш цикла по курсору1
  CLOSE curMovement; -- закрыли курсор1

  -- Результат
  RETURN QUERY
    WITH
           tmpResult AS ( SELECT Movement.Id
                               , Movement.InvNumber
                               , Movement.OperDate
                               , MovementLinkObject_From.ObjectId                                               AS UnitId
                               , MovementLinkObject_To.ObjectId                                                 AS UnitIdTo
                               , tmpResult.GoodsId                                                              AS GoodsId
                               , tmpResult.Amount                                                               AS Amount

                          FROM _tmpResult AS tmpResult

                               LEFT JOIN Movement ON Movement.ID = tmpResult.Id

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = tmpResult.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = tmpResult.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                        )
         , tmpPrice AS (SELECT OL_Price_Goods.ChildObjectId      AS GoodsId
                             , OL_Price_Unit.ChildObjectId       AS UnitID
                             , ROUND (Price_Value.ValueData, 2)  AS Price
                        FROM ObjectLink AS OL_Price_Unit
                             -- !!!только для таких Аптек!!!
                             LEFT JOIN ObjectLink AS OL_Price_Goods
                                                  ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                 AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                             INNER JOIN (SELECT DISTINCT tmpResult.GoodsId FROM tmpResult) AS Goods
                                                                                           ON Goods.GoodsId       = OL_Price_Goods.ChildObjectId
                             LEFT JOIN ObjecTFloat AS Price_Value
                                                   ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                  AND Price_Value.DescId = zc_ObjecTFloat_Price_Value()
                        WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          AND OL_Price_Unit.ChildObjectId in (SELECT DISTINCT UnitId FROM tmpResult
                                                              UNION ALL
                                                              SELECT DISTINCT UnitIdTo FROM tmpResult)
                       )

  SELECT Movement.Id
       , Movement.InvNumber
       , Movement.OperDate
       , Object_From.ObjectCode                                                         AS UnitCode
       , Object_From.ValueData                                                          AS UnitName
       , Object_To.ObjectCode                                                           AS UnitCodeTo
       , Object_To.ValueData                                                            AS UnitNameTo
       , Movement.GoodsId                                                               AS GoodsId
       , Object_Goods.ObjectCode                                                        AS GoodsCode
       , Object_Goods.ValueData                                                         AS GoodsName
       , Movement.Amount                                                                AS Amount
       , PriceFrom.Price::TFloat                                                        AS PriceFrom
       , Round(PriceFrom.Price * Movement.Amount  , 2)::TFloat                          AS SummaFrom
       , PriceTo.Price::TFloat                                                          AS PriceTo
       , Round(PriceTo.Price * Movement.Amount  , 2)::TFloat                            AS SummaTo

  FROM tmpResult AS Movement


       LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.UnitId

       LEFT JOIN Object AS Object_To ON Object_To.Id = Movement.UnitIdTo

       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Movement.GoodsId

       LEFT JOIN tmpPrice AS PriceFrom
                          ON PriceFrom.UnitId = Movement.UnitId
                         AND PriceFrom.GoodsId = Movement.GoodsId

       LEFT JOIN tmpPrice AS PriceTo
                          ON PriceTo.UnitId = Movement.UnitIdTo
                         AND PriceTo.GoodsId = Movement.GoodsId

  ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_PercentageOverdueSUN (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.12.19                                                       *
*/

-- тест
-- SELECT * FROM gpReport_PositionsUKTVEDonSUN (inStartDate:= '01.07.2020', inEndDate:= '30.07.2020', inSession:= '3')