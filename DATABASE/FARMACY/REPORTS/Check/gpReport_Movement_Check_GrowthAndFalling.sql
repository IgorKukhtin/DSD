-- Function: gpReport_Movement_Check_GrowthAndFalling

DROP FUNCTION IF EXISTS gpReport_Movement_Check_GrowthAndFalling (Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Check_GrowthAndFalling (Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Check_GrowthAndFalling (
    IN inUnitId           Integer   , -- Подразделение
    IN inRetailId         Integer   , -- ссылка на торг.сеть
    IN inJuridicalId      Integer   , -- юр.лицо
    IN inDateStart        TDateTime , -- Дата начала
    IN inDateFinal        TDateTime , -- Дата окончания
    IN inDateStartBefore  TDateTime , -- Дата начала до
    IN inDateFinalBefore  TDateTime , -- Дата окончания до
    IN inisUnitList       Boolean   , --
    IN inisUnitSplit      Boolean   , --
    IN inisJuridicalSplit Boolean   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId                Integer
             , GoodsCode              Integer
             , GoodsName              TVarChar
             , AmountBefore           TFloat
             , Amount                 TFloat
             , SummaBefore            TFloat
             , Summa                  TFloat
             , AmountGrowthInPercent  TFloat
             , AmountFallingInPercent TFloat
             , SummaGrowthInPercent   TFloat
             , SummaFallingInPercent  TFloat
              )
AS $BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...);
      vbUserId:= lpGetUserBySession (inSession);
    
      -- Результат
      RETURN QUERY
        WITH tmpUnit AS (SELECT inUnitId AS UnitId
                         WHERE inisUnitList = FALSE
                         UNION
                         SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                         FROM ObjectLink AS ObjectLink_Unit_Juridical
                              JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                             AND ((ObjectLink_Juridical_Retail.ChildObjectId = inRetailId AND inUnitId = 0)
                                               OR (inRetailId = 0 AND inUnitId = 0))
                         WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                           AND inisUnitList = FALSE
                         UNION
                         SELECT ObjectBoolean_Report.ObjectId AS UnitId
                         FROM ObjectBoolean AS ObjectBoolean_Report
                         WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                           AND ObjectBoolean_Report.ValueData = TRUE
                           AND inisUnitList = TRUE
                        )
           , tmpMIContainer AS (SELECT MIContainer.ObjectId_analyzer AS GoodsId
                                     , SUM (-1.0 * COALESCE (MIContainer.Amount, 0.0))::TFloat AS Amount
                                     , SUM (-1.0 * COALESCE (MIContainer.Amount, 0.0) * COALESCE (MIContainer.Price, 0.0))::TFloat AS Summa
                                FROM MovementItemContainer AS MIContainer
                                     JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                WHERE MIContainer.DescId = zc_MIContainer_Count()
                                  AND MIContainer.MovementDescId = zc_Movement_Check()
                                  AND MIContainer.OperDate >= inDateStart
                                  AND MIContainer.OperDate < (inDateFinal + INTERVAL '1 DAY')
                                  AND ABS (COALESCE (MIContainer.Amount, 0.0)) <> 0
                                  AND ABS (COALESCE (MIContainer.Price, 0.0)) <> 0
                                GROUP BY MIContainer.ObjectId_analyzer
                               )
           , tmpMIContainerBefore AS (SELECT MIContainer.ObjectId_analyzer AS GoodsId
                                           , SUM (-1.0 * COALESCE (MIContainer.Amount, 0.0))::TFloat AS Amount
                                           , SUM (-1.0 * COALESCE (MIContainer.Amount, 0.0) * COALESCE (MIContainer.Price, 0.0))::TFloat AS Summa
                                      FROM MovementItemContainer AS MIContainer
                                           JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                                      WHERE MIContainer.DescId = zc_MIContainer_Count()
                                        AND MIContainer.MovementDescId = zc_Movement_Check()
                                        AND MIContainer.OperDate >= inDateStartBefore 
                                        AND MIContainer.OperDate < (inDateFinalBefore + INTERVAL '1 DAY')
                                        AND ABS (COALESCE (MIContainer.Amount, 0.0)) <> 0
                                        AND ABS (COALESCE (MIContainer.Price, 0.0)) <> 0
                                      GROUP BY MIContainer.ObjectId_analyzer
                                     )
           , tmpDataAll AS (SELECT tmpMIContainer.GoodsId
                                 , Object_Goods.ObjectCode AS GoodsCode
                                 , Object_Goods.ValueData AS GoodsName
                                 , COALESCE (tmpMIContainerBefore.Amount, 0.0)::TFloat AS AmountBefore
                                 , tmpMIContainer.Amount
                                 , COALESCE (tmpMIContainerBefore.Summa, 0.0)::TFloat AS SummaBefore
                                 , tmpMIContainer.Summa 
                                 , CASE
                                        WHEN ((tmpMIContainer.Amount - COALESCE (tmpMIContainerBefore.Amount, 0.0)) > 0) AND (COALESCE (tmpMIContainerBefore.Amount, 0.0) <> 0) THEN
                                          ((tmpMIContainer.Amount - COALESCE (tmpMIContainerBefore.Amount, 0.0)) / COALESCE (tmpMIContainerBefore.Amount, 0.0) * 100.0)::TFloat
                                        WHEN (tmpMIContainer.Amount > 0) AND (COALESCE (tmpMIContainerBefore.Amount, 0.0) = 0) THEN
                                          100::TFloat
                                        ELSE  
                                          0::TFloat
                                   END AS AmountGrowthInPercent
                                 , CASE
                                        WHEN ((tmpMIContainer.Amount - COALESCE (tmpMIContainerBefore.Amount, 0.0)) < 0) AND (COALESCE (tmpMIContainer.Amount, 0.0) <> 0) THEN
                                          ((COALESCE (tmpMIContainerBefore.Amount, 0.0) - tmpMIContainer.Amount) / COALESCE (tmpMIContainer.Amount, 0.0) * 100.0)::TFloat
                                        ELSE  
                                          0::TFloat
                                   END AS AmountFallingInPercent
                                 , CASE
                                        WHEN ((tmpMIContainer.Summa - COALESCE (tmpMIContainerBefore.Summa, 0.0)) > 0) AND (COALESCE (tmpMIContainerBefore.Summa, 0.0) <> 0) THEN
                                          ((tmpMIContainer.Summa - COALESCE (tmpMIContainerBefore.Summa, 0.0)) / COALESCE (tmpMIContainerBefore.Summa, 0.0) * 100.0)::TFloat
                                        WHEN (tmpMIContainer.Summa > 0) AND (COALESCE (tmpMIContainerBefore.Summa, 0.0) = 0) THEN
                                          100::TFloat
                                        ELSE  
                                          0::TFloat
                                   END AS SummaGrowthInPercent
                                 , CASE
                                        WHEN ((tmpMIContainer.Summa - COALESCE (tmpMIContainerBefore.Summa, 0.0)) < 0) AND (COALESCE (tmpMIContainer.Summa, 0.0) <> 0) THEN
                                          ((COALESCE (tmpMIContainerBefore.Summa, 0.0) - tmpMIContainer.Summa) / COALESCE (tmpMIContainer.Summa, 0.0) * 100.0)::TFloat
                                        ELSE  
                                          0::TFloat
                                   END AS SummaFallingInPercent
                            FROM tmpMIContainer
                                 LEFT JOIN Object AS Object_Goods
                                                  ON Object_Goods.Id = tmpMIContainer.GoodsId
                                                 AND Object_Goods.DescId = zc_Object_Goods() 
                                 LEFT JOIN tmpMIContainerBefore ON tmpMIContainerBefore.GoodsId = tmpMIContainer.GoodsId
                            )
        SELECT tmpDataAll.GoodsId
             , tmpDataAll.GoodsCode
             , tmpDataAll.GoodsName
             , tmpDataAll.AmountBefore
             , tmpDataAll.Amount
             , tmpDataAll.SummaBefore
             , tmpDataAll.Summa
             , tmpDataAll.AmountGrowthInPercent
             , tmpDataAll.AmountFallingInPercent
             , tmpDataAll.SummaGrowthInPercent
             , tmpDataAll.SummaFallingInPercent
        FROM tmpDataAll
        ;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 07.09.17                                                       *
*/

-- тест
/*
SELECT * FROM gpReport_Movement_Check_GrowthAndFalling (inUnitId          := 183292
                                                      , inRetailId        := 4 
                                                      , inJuridicalId     := 0 
                                                      , inDateStart       := '01.11.2016' 
                                                      , inDateFinal       := '15.11.2016'
                                                      , inDateStartBefore := '15.10.2016'
                                                      , inDateFinalBefore := '30.10.2016'
                                                      , inisUnitList      := FALSE
                                                      , inisUnitSplit     := TRUE
                                                      , inisJuridicalSplit:= FALSE
                                                      , inSession         := zfCalc_UserAdmin()
                                                       );
*/