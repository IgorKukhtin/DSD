-- Function: gpReport_NomenclaturePeriod()

DROP FUNCTION IF EXISTS gpReport_NomenclaturePeriod (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_NomenclaturePeriod(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,

              Coming TFloat,  ComingSum TFloat,
              Consumption TFloat,  ConsumptionSum TFloat,
              Send TFloat,  Inventory TFloat,  ReturnOut TFloat,  Loss TFloat,
              Remains TFloat,  RemainsSum TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- Результат
    RETURN QUERY
    WITH
       tmpMovement AS (SELECT Movement.Id
                        FROM Movement

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()

                             LEFT JOIN MovementDate AS MovementDate_Branch
                                                    ON MovementDate_Branch.MovementId = Movement.Id
                                                   AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                        WHERE (MovementDate_Branch.ValueData >= DATE_TRUNC ('DAY', inStartDate)
                          AND MovementDate_Branch.ValueData < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY')
                          AND Movement.DescId = zc_Movement_Income()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND MovementLinkObject_Unit.ObjectId = zc_DirectorPartner_UnitID()
                     )
     , tmpContener AS (SELECT Container.Id                                                                  AS Id
                            , Container.ObjectId                                                            AS GoodsId
                            , MovementItemContainer.Amount                                                  AS Coming
                            , Container.Amount                                                              AS Remains
                            , COALESCE (MIFloat_PriceWithVAT.ValueData, 0)                                  AS PriceIn
                       FROM tmpMovement
                            INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = tmpMovement.Id
                                                            AND MovementItemContainer.DescId = zc_MIContainer_Count()
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                        ON MIFloat_PriceWithVAT.MovementItemId = MovementItemContainer.MovementItemId
                                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                            INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                       )
     , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , Price_Goods.ChildObjectId               AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = zc_DirectorPartner_UnitID()
                        )
     , tmpData AS (SELECT tmpContener.GoodsId                                       AS GoodsId
                        , tmpContener.Coming                                        AS Coming
                        , tmpContener.Coming * tmpContener.PriceIn                  AS ComingSum
                        , tmpContener.Remains                                       AS Remains
                        , tmpContener.Remains * COALESCE(tmpObject_Price.Price,0)   AS RemainsSum
                   FROM tmpContener

                        INNER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = tmpContener.GoodsId
                   )
     , tmpCheck AS (SELECT Contener.GoodsId                                                                     AS GoodsId
                        , Sum(-1.0 * MovementItemContainer.Amount)                                              AS Consumption
                        , Sum(-1.0 * MovementItemContainer.Amount * COALESCE (MovementItemContainer.Price, 0))  AS ConsumptionSum
                    FROM (SELECT tmpContener.Id, tmpContener.GoodsId FROM  tmpContener GROUP BY tmpContener.Id, tmpContener.GoodsId) AS Contener

                         INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Contener.Id
                                                         AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                         AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                    GROUP BY Contener.GoodsId
                    )
     , tmpSend AS (SELECT Contener.GoodsId                                                                     AS GoodsId
                        , Sum(-1.0 * MovementItemContainer.Amount)                                             AS Send
                    FROM (SELECT tmpContener.Id, tmpContener.GoodsId FROM  tmpContener GROUP BY tmpContener.Id, tmpContener.GoodsId) AS Contener

                         INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Contener.Id
                                                         AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                         AND MovementItemContainer.MovementDescId = zc_Movement_Send()
                                                         AND  MovementItemContainer.Amount < 0
                    GROUP BY Contener.GoodsId
                    )
     , tmpInventory AS (SELECT Contener.GoodsId                                                                     AS GoodsId
                             , Sum(-1.0 * MovementItemContainer.Amount)                                              AS Inventory
                         FROM (SELECT tmpContener.Id, tmpContener.GoodsId FROM  tmpContener GROUP BY tmpContener.Id, tmpContener.GoodsId) AS Contener

                              INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Contener.Id
                                                              AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                              AND MovementItemContainer.MovementDescId = zc_Movement_Inventory()
                         GROUP BY Contener.GoodsId
                         )
     , tmpReturnOut AS (SELECT Contener.GoodsId                                                                     AS GoodsId
                             , Sum(-1.0 * MovementItemContainer.Amount)                                              AS ReturnOut
                         FROM (SELECT tmpContener.Id, tmpContener.GoodsId FROM  tmpContener GROUP BY tmpContener.Id, tmpContener.GoodsId) AS Contener

                              INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Contener.Id
                                                              AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                              AND MovementItemContainer.MovementDescId = zc_Movement_ReturnOut()
                         GROUP BY Contener.GoodsId
                         )
     , tmpLoss AS (SELECT Contener.GoodsId                                                                     AS GoodsId
                         , Sum(-1.0 * MovementItemContainer.Amount)                                              AS Loss
                    FROM (SELECT tmpContener.Id, tmpContener.GoodsId FROM  tmpContener GROUP BY tmpContener.Id, tmpContener.GoodsId) AS Contener

                          INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Contener.Id
                                                         AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                         AND MovementItemContainer.MovementDescId = zc_Movement_Loss()
                    GROUP BY Contener.GoodsId
                     )


     SELECT Object_Goods.Id
          , Object_Goods.ObjectCode
          , Object_Goods.ValueData

          , Sum(tmpData.Coming)::TFloat            AS Coming
          , Sum(tmpData.ComingSum)::TFloat         AS ComingSum
          , tmpCheck.Consumption::TFloat           AS Consumption
          , tmpCheck.ConsumptionSum::TFloat        AS ConsumptionSum
          , tmpSend.Send::TFloat                   AS Send
          , tmpInventory.Inventory::TFloat         AS Inventory
          , tmpReturnOut.ReturnOut::TFloat         AS ReturnOut
          , tmpLoss.Loss::TFloat                   AS Loss
          , Sum(tmpData.Remains)::TFloat           AS Remains
          , Sum(tmpData.RemainsSum)::TFloat        AS RemainsSum

     FROM tmpData
          INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
          LEFT JOIN tmpCheck ON tmpCheck.GoodsId = tmpData.GoodsId
          LEFT JOIN tmpSend ON tmpSend.GoodsId = tmpData.GoodsId
          LEFT JOIN tmpInventory ON tmpInventory.GoodsId = tmpData.GoodsId
          LEFT JOIN tmpReturnOut ON tmpReturnOut.GoodsId = tmpData.GoodsId
          LEFT JOIN tmpLoss ON tmpLoss.GoodsId = tmpData.GoodsId
     GROUP BY Object_Goods.Id
            , Object_Goods.ObjectCode
            , Object_Goods.ValueData
            , tmpCheck.Consumption
            , tmpCheck.ConsumptionSum
            , tmpSend.Send
            , tmpInventory.Inventory
            , tmpReturnOut.ReturnOut
            , tmpLoss.Loss
     ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.04.20                                                       *
*/

-- тест
-- select * from gpReport_NomenclaturePeriod(inStartDate := ('01.03.2020')::TDateTime , inEndDate := ('31.03.2020')::TDateTime ,  inSession := '3');
