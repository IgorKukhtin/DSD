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
             , PriceSale     TFloat
             , SumSale       TFloat

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
                               
      , tmpSUN_Container AS (SELECT DISTINCT MIContainer.ContainerId
                             FROM tmpContainer_Check
                                  INNER JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.ContainerId = tmpContainer_Check.ContainerId
                                                                  AND MIContainer.DescId = zc_MIContainer_Count()
                                                                  AND MIContainer.MovementDescId = zc_Movement_Send()
                                  INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                             ON MovementBoolean_SUN.MovementId = MIContainer.MovementId
                                                            AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                            AND COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE
                             )

      , tmpCheckSUN AS (SELECT tmpContainer_Check.UnitId
                             , tmpContainer_Check.GoodsId
                             , tmpContainer_Check.MovementId
                             , SUM (tmpContainer_Check.Amount)  AS Amount
                             , SUM (tmpContainer_Check.SumSale) AS SumSale
                        FROM tmpSUN_Container
                             INNER JOIN tmpContainer_Check ON tmpContainer_Check.ContainerId = tmpSUN_Container.ContainerId
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

             , tmpData.Amount  ::TFloat AS Amount
             , CASE WHEN COALESCE (tmpData.Amount,0) <> 0 THEN tmpData.SumSale / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale
             , tmpData.SumSale ::TFloat
 
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
