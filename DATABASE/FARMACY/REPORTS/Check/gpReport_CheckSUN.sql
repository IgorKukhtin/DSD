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
             , PriceSale      TFloat
             , PriceSend_In   TFloat
             , PriceSend_Out  TFloat
             , SumSale        TFloat
             , SumSend_In     TFloat
             , SumSend_Out    TFloat
             , ExpirationDate TDateTime
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
        -- Все контейнера сун
      , tmpSUN_Container_All AS (SELECT DISTINCT MIContainer.ContainerId
                                 FROM MovementItemContainer AS MIContainer
                                      INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                                ON MovementBoolean_SUN.MovementId = MIContainer.MovementId
                                                               AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                               AND MovementBoolean_SUN.ValueData = TRUE
                                WHERE MIContainer.DescId = zc_MIContainer_Count()
                                  AND MIContainer.MovementDescId = zc_Movement_Send()
                                  AND MIContainer.isActive = TRUE
                                  AND MIContainer.Amount > 0
                                )
        -- все продажи за период
      , tmpContainer_Check AS (SELECT MIContainer.ContainerId                     AS ContainerId
                                    , MIContainer.WhereObjectId_analyzer          AS UnitId
                                    , MIContainer.ObjectId_analyzer               AS GoodsId
                                    , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId
                                    , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                                    , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SumSale 
                               FROM tmpSUN_Container_All
                                    INNER JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.ContainerId = tmpSUN_Container_All.ContainerId
                                                                    AND MIContainer.DescId = zc_MIContainer_Count()
                                                                    AND MIContainer.MovementDescId = zc_Movement_Check()
                                                                    AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY' 
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                               GROUP BY MIContainer.ObjectId_analyzer 
                                      , MIContainer.WhereObjectId_analyzer
                                      , MIContainer.ContainerId
                                      , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END
                               HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                               )
        -- берем только ContainerId - для товара по перемещ. СУН поступление
      , tmpSUN_Container_in AS (SELECT MIContainer.ContainerId
                                     , Container.ObjectId        AS GoodsId
                                     , Container.WhereObjectId   AS UnitId
                                     , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END AS MovementId
                                     , MIFloat_PriceTo.ValueData                                            AS Price 
                                     , SUM (MIContainer.Amount)                                             AS AmountIn    -- пришло по перемещению
                                FROM MovementItemContainer AS MIContainer
                                      INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                                ON MovementBoolean_SUN.MovementId = MIContainer.MovementId
                                                               AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                               AND MovementBoolean_SUN.ValueData = TRUE
                                      INNER JOIN Container ON Container.Id = MIContainer.ContainerId
                                      INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                      LEFT JOIN MovementItemFloat AS MIFloat_PriceTo
                                                                  ON MIFloat_PriceTo.MovementItemId = MIContainer.MovementItemId
                                                                 AND MIFloat_PriceTo.DescId =zc_MIFloat_PriceTo()
                                WHERE MIContainer.DescId = zc_MIContainer_Count()
                                  AND MIContainer.MovementDescId = zc_Movement_Send()
                                  AND MIContainer.isActive = TRUE
                                  AND MIContainer.Amount > 0
                                  AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                                GROUP BY MIContainer.ContainerId
                                       , Container.ObjectId 
                                       , Container.WhereObjectId
                                       , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END
                                       , MIFloat_PriceTo.ValueData
                                )
      , tmpSUN_Container AS (SELECT tmpSUN_Container_in.ContainerId
                                  , tmpSUN_Container_in.GoodsId
                                  , tmpSUN_Container_in.UnitId
                                  , tmpSUN_Container_in.MovementId
                                  , tmpSUN_Container_in.AmountIn
                                  , tmpSUN_Container_in.Price
                                  , SUM (CASE WHEN COALESCE (MIContainer.Amount,0) < 0 AND
                                                   COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE THEN MIContainer.Amount ELSE 0 END) AS AmountOut   -- ушло по перемещению
                             FROM tmpSUN_Container_in
                                  LEFT JOIN MovementItemContainer AS MIContainer
                                                                  ON MIContainer.ContainerId = tmpSUN_Container_in.ContainerId
                                                                 AND MIContainer.DescId = zc_MIContainer_Count()
                                                                 AND MIContainer.MovementDescId = zc_Movement_Send()
                                                                 AND MIContainer.isActive = FALSE
                                                                 AND COALESCE (MIContainer.Amount, 0) < 0
                                  LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                                            ON MovementBoolean_SUN.MovementId = MIContainer.MovementId
                                                           AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                             GROUP BY tmpSUN_Container_in.ContainerId
                                    , tmpSUN_Container_in.GoodsId
                                    , tmpSUN_Container_in.UnitId
                                    , tmpSUN_Container_in.MovementId
                                    , tmpSUN_Container_in.AmountIn
                                    , tmpSUN_Container_in.Price
                             )
      , tmpCLOPartionMovementItem AS (SELECT ContainerlinkObject.ContainerId
                                           , ContainerlinkObject.ObjectId ::Integer
                                      FROM ContainerlinkObject
                                      WHERE ContainerlinkObject.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                        AND ContainerlinkObject.ContainerId IN (SELECT DISTINCT tmpSUN_Container.ContainerId FROM tmpSUN_Container)
                                      )
      --

      , tmpExpirationDate AS (SELECT tmp.ContainerId
                                   , (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())) ::TDateTime AS ExpirationDate
                              FROM (SELECT DISTINCT tmp.ContainerId FROM 
                                      (SELECT DISTINCT tmpContainer_Check.ContainerId FROM tmpContainer_Check
                                       UNION ALL
                                       SELECT DISTINCT tmpSUN_Container.ContainerId FROM tmpSUN_Container) AS tmp) AS tmp
                              
                                   LEFT JOIN tmpCLOPartionMovementItem AS ContainerLinkObject_MovementItem
                                                                       ON ContainerLinkObject_MovementItem.ContainerId = tmp.ContainerId
                                                                      --AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                   LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId-- ::Integer
                                   -- элемент прихода
                                   LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode ::Integer
                                   -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                               ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                   -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                   LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                              
                                   LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                              ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                              )

      , tmpCheckSUN AS (SELECT tmp.UnitId
                             , tmp.GoodsId
                             , tmp.MovementId
                             , SUM (COALESCE( tmp.Amount,0))         AS Amount
                             , SUM (COALESCE (tmp.AmountSend_In,0))  AS AmountSend_In
                             , SUM (COALESCE (tmp.AmountSend_Out,0)) AS AmountSend_Out
                             , SUM (COALESCE( tmp.SumSale,0))        AS SumSale
                             , SUM (COALESCE(tmp.SumSend_In,0))      AS SumSend_In
                             , SUM (COALESCE(tmp.SumSend_Out,0))     AS SumSend_Out
                             , (tmp.ExpirationDate)  ::TDateTime AS ExpirationDate
                        FROM
                             (SELECT tmpSUN_Container.UnitId
                                   , tmpSUN_Container.GoodsId
                                   , tmpSUN_Container.MovementId
                                   , 0                                                    AS Amount
                                   , SUM (COALESCE (tmpSUN_Container.AmountIn,0))         AS AmountSend_In
                                   , SUM (COALESCE (tmpSUN_Container.AmountOut,0)* (-1))  AS AmountSend_Out
                                   , 0                                                    AS SumSale
                                   , SUM (COALESCE(tmpSUN_Container.Price,0) * COALESCE (tmpSUN_Container.AmountIn,0))         AS SumSend_In
                                   , SUM (COALESCE(tmpSUN_Container.Price,0) * COALESCE (tmpSUN_Container.AmountOut,0) * (-1)) AS SumSend_Out
                                   , (tmpExpirationDate.ExpirationDate) ::TDateTime AS ExpirationDate
                              FROM tmpSUN_Container
      
                                  LEFT JOIN tmpExpirationDate ON tmpExpirationDate.ContainerId = tmpSUN_Container.ContainerId
      
                              GROUP BY tmpSUN_Container.UnitId
                                     , tmpSUN_Container.GoodsId
                                     , tmpSUN_Container.MovementId
                                     , (tmpExpirationDate.ExpirationDate)
                           UNION ALL
                              SELECT tmpContainer_Check.UnitId
                                   , tmpContainer_Check.GoodsId
                                   , tmpContainer_Check.MovementId
                                   , SUM (tmpContainer_Check.Amount)  AS Amount
                                   , 0                                AS AmountSend_In
                                   , 0                                AS AmountSend_Out
                                   , SUM (tmpContainer_Check.SumSale) AS SumSale
                                   , 0                                AS SumSend_In
                                   , 0                                AS SumSend_Out
                                   , (tmpExpirationDate.ExpirationDate) ::TDateTime AS ExpirationDate
                              FROM tmpContainer_Check
                                   LEFT JOIN tmpExpirationDate ON tmpExpirationDate.ContainerId = tmpContainer_Check.ContainerId
                              GROUP BY tmpContainer_Check.UnitId
                                     , tmpContainer_Check.GoodsId
                                     , tmpContainer_Check.MovementId
                                     , (tmpExpirationDate.ExpirationDate)
                              ) AS tmp
                        GROUP BY tmp.UnitId
                               , tmp.GoodsId
                               , tmp.MovementId
                               , (tmp.ExpirationDate)
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
             , tmpData.ExpirationDate ::TDateTime
 
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
 SELECT * FROM gpReport_CheckSUN (inUnitId :=7117700, inRetailId:= 0, inJuridicalId:=0, inStartDate := '01.01.2019' ::TDateTime, inEndDate := '10.08.2021' ::TDateTime, inisUnitList := false, inisMovement:=false, inSession := '3' :: TVarChar);