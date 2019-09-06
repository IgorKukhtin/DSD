-- Function: gpReport_CheckSUN()

DROP FUNCTION IF EXISTS gpReport_CheckSUN (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckSUN (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckSUN(
    IN inUnitId              Integer  ,  -- Подразделение
    IN inRetailId            Integer  ,  -- ссылка на торг.сеть
    IN inJuridicalId         Integer  ,  -- юр.лицо
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inisUnitList          Boolean,    --
    IN inisMovement          Boolean,    --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId    Integer
             , OperDate      TDateTime
             , Invnumber     TVarChar
             , UnitId        Integer
             , UnitName      TVarChar
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , Amount        TFloat
             , AmountSend_In  TFloat
             , AmountSend_Out TFloat
             , PriceSale     TFloat
             , PriceSend_In  TFloat
             , PriceSend_Out TFloat
             , SumSale       TFloat
             , SumSend_In    TFloat
             , SumSend_Out   TFloat

             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH 
        -- список подразделений
        tmpUnit AS (SELECT inUnitId                                  AS UnitId
                    WHERE COALESCE (inUnitId, 0) <> 0 
                      AND inisUnitList = FALSE
                   UNION 
                    SELECT ObjectLink_Unit_Juridical.ObjectId        AS UnitId
                    FROM ObjectLink AS ObjectLink_Unit_Juridical
                         INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                              AND ((ObjectLink_Juridical_Retail.ChildObjectId = inRetailId AND inUnitId = 0)
                                                   OR (inRetailId = 0 AND inUnitId = 0))
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                      AND inisUnitList = FALSE
                   UNION
                    SELECT ObjectBoolean_Report.ObjectId             AS UnitId
                    FROM ObjectBoolean AS ObjectBoolean_Report
                         LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                              ON ObjectLink_Unit_Juridical.ObjectId = ObjectBoolean_Report.ObjectId
                                             AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                      AND ObjectBoolean_Report.ValueData = TRUE
                      AND inisUnitList = TRUE
                   )
        -- все продажи за период
      , tmpContainer_Check AS (SELECT MIContainer.ContainerId                     AS ContainerId
                                    , MIContainer.WhereObjectId_analyzer          AS UnitId
                                    , MIContainer.ObjectId_analyzer               AS GoodsId
                                    , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId
                                    , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                                    , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SumSale 
                               FROM MovementItemContainer AS MIContainer
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                               WHERE MIContainer.DescId = zc_MIContainer_Count()
                                 AND MIContainer.MovementDescId = zc_Movement_Check()
                                 AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                                 --AND MIContainer.OperDate >= '01.08.2019' AND MIContainer.OperDate <  '03.09.2019'
                               GROUP BY MIContainer.ObjectId_analyzer 
                                      , MIContainer.WhereObjectId_analyzer
                                      , MIContainer.ContainerId
                                      , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END
                               HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                               )
        -- берем только ContainerId - для товара по перемещ. СУН
      , tmpSUN_Container AS (SELECT MIContainer.ContainerId
                                  , tmpContainer_Check.GoodsId
                                  , tmpContainer_Check.UnitId
                                  , SUM (CASE WHEN COALESCE (MIContainer.Amount,0) > 0 THEN MIContainer.Amount ELSE 0 END) AS AmountIn    -- пришло по перемещению
                                  , SUM (CASE WHEN COALESCE (MIContainer.Amount,0) < 0 THEN MIContainer.Amount ELSE 0 END) AS AmountOut   -- ушло по перемещению
                             FROM tmpContainer_Check
                                  INNER JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.ContainerId = tmpContainer_Check.ContainerId
                                                                  AND MIContainer.DescId = zc_MIContainer_Count()
                                                                  AND MIContainer.MovementDescId = zc_Movement_Send()
                                  INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                             ON MovementBoolean_SUN.MovementId = MIContainer.MovementId
                                                            AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                            AND MovementBoolean_SUN.ValueData = TRUE
                             GROUP BY MIContainer.ContainerId
                                    , tmpContainer_Check.GoodsId
                                    , tmpContainer_Check.UnitId
                             )
        -- текущие цены
      , tmpPrice AS (SELECT tmpGoods.GoodsId               AS GoodsId
                          , ObjectLink_Unit.ChildObjectId  AS UnitId
                          , ROUND (ObjectFloat_Price_Value.ValueData, 2)  AS Price
                     FROM (SELECT DISTINCT tmpSUN_Container.GoodsId
                           FROM tmpSUN_Container) AS tmpGoods
                           INNER JOIN ObjectLink AS ObjectLink_Goods
                                                 ON ObjectLink_Goods.ChildObjectId = tmpGoods.GoodsId
                                                AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                           INNER JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                           INNER JOIN tmpUnit ON tmpUnit.UnitId = ObjectLink_Unit.ChildObjectId
                           LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                 ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                AND ObjectFloat_Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                    )

      --
      , tmpCheckSUN AS (SELECT tmpContainer_Check.UnitId
                             , tmpContainer_Check.GoodsId
                             , tmpContainer_Check.MovementId
                             , SUM (tmpContainer_Check.Amount)  AS Amount
                             , SUM (COALESCE (tmpSUN_Container.AmountIn,0) )        AS AmountSend_In
                             , SUM (COALESCE (tmpSUN_Container.AmountOut,0)* (-1))  AS AmountSend_Out
                             , SUM (tmpContainer_Check.SumSale) AS SumSale
                             , SUM (COALESCE(Object_Price.Price,0) * COALESCE (tmpSUN_Container.AmountIn,0) )        AS SumSend_In
                             , SUM (COALESCE(Object_Price.Price,0) * COALESCE (tmpSUN_Container.AmountOut,0) * (-1)) AS SumSend_Out
                        FROM tmpSUN_Container
                             INNER JOIN tmpContainer_Check ON tmpContainer_Check.ContainerId = tmpSUN_Container.ContainerId

                             LEFT JOIN tmpPrice AS Object_Price
                                                ON Object_Price.GoodsId = tmpSUN_Container.GoodsId
                                               AND Object_Price.UnitId  = tmpSUN_Container.UnitId
                        GROUP BY tmpContainer_Check.UnitId
                               , tmpContainer_Check.GoodsId
                               , tmpContainer_Check.MovementId
                       )
                 
        -- результат
        SELECT Movement.Id              AS MovementId
             , Movement.OperDate        AS OperDate
             , Movement.Invnumber       AS Invnumber
             , Object_Unit.Id           AS UnitId
             , Object_Unit.ValueData    AS UnitName
             , Object_Goods.Id          AS GoodsId
             , Object_Goods.ObjectCode  AS GoodsCode
             , Object_Goods.ValueData   AS GoodsName

             , tmpData.Amount          ::TFloat AS Amount
             , tmpData.AmountSend_In   ::TFloat AS AmountSend_In
             , tmpData.AmountSend_Out  ::TFloat AS AmountSend_Out
             , CASE WHEN COALESCE (tmpData.Amount,0) <> 0         THEN tmpData.SumSale / tmpData.Amount ELSE 0 END             :: TFloat AS PriceSale
             , CASE WHEN COALESCE (tmpData.AmountSend_In,0) <> 0  THEN tmpData.SumSend_In / tmpData.AmountSend_In ELSE 0 END   :: TFloat AS PriceSend_In
             , CASE WHEN COALESCE (tmpData.AmountSend_Out,0) <> 0 THEN tmpData.SumSend_Out / tmpData.AmountSend_Out ELSE 0 END :: TFloat AS PriceSend_Out
             , tmpData.SumSale     ::TFloat
             , tmpData.SumSend_In  ::TFloat
             , tmpData.SumSend_Out ::TFloat
 
        FROM tmpCheckSUN AS tmpData 
             LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = tmpData.UnitId
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
             LEFT JOIN Movement ON Movement.Id = tmpData.MovementId
        ORDER BY Object_Unit.ValueData
               , Movement.OperDate
               , Movement.Invnumber
               , Object_Goods.ValueData               
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 04.09.19         * 
*/

-- тест
-- SELECT * FROM gpReport_CheckSUN (inUnitId :=7117700, inRetailId:= 0, inJuridicalId:=0, inStartDate := '01.09.2019' ::TDateTime, inEndDate := '10.09.2019' ::TDateTime, inisUnitList := false, inisMovement:=true, inSession := '3' :: TVarChar);
