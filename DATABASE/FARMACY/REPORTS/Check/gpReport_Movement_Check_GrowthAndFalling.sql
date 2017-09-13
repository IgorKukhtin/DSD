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
RETURNS TABLE (UnitId                 Integer
             , UnitName               TVarChar
             , JuridicalId            Integer
             , JuridicalName          TVarChar
             , GoodsId                Integer
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

      CREATE TEMP TABLE tmpUnit ON COMMIT DROP
      AS (SELECT UnitIds.UnitId
               , COALESCE (ObjectLink_Juridical.ChildObjectId, 0) AS JuridicalId
          FROM (SELECT inUnitId AS UnitId
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
               ) AS UnitIds
               LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                    ON ObjectLink_Juridical.ObjectId = UnitIds.UnitId
                                   AND ObjectLink_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
         );

      CREATE TEMP TABLE tmpData ON COMMIT DROP
      AS (SELECT tmpUnit.UnitId
               , tmpUnit.JuridicalId
               , MIContainer.ObjectId_analyzer AS GoodsId
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
          GROUP BY tmpUnit.UnitId
                 , tmpUnit.JuridicalId
                 , MIContainer.ObjectId_analyzer
         );

      CREATE TEMP TABLE tmpDataBefore ON COMMIT DROP
      AS (SELECT tmpUnit.UnitId
               , tmpUnit.JuridicalId
               , MIContainer.ObjectId_analyzer AS GoodsId
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
          GROUP BY tmpUnit.UnitId
                 , tmpUnit.JuridicalId
                 , MIContainer.ObjectId_analyzer
         );

      CREATE TEMP TABLE tmpDataAll (
        UnitId       Integer,
        JuridicalId  Integer, 
        GoodsId      Integer,
        AmountBefore TFloat,  
        Amount       TFloat,
        SummaBefore  TFloat,
        Summa        TFloat
      ) ON COMMIT DROP;

      IF inisUnitSplit = TRUE AND inisJuridicalSplit = TRUE
      THEN
           INSERT INTO tmpDataAll 
                  SELECT tmpData.UnitId
                       , tmpData.JuridicalId 
                       , tmpData.GoodsId
                       , COALESCE (tmpDataBefore.Amount, 0.0)::TFloat AS AmountBefore
                       , tmpData.Amount
                       , COALESCE (tmpDataBefore.Summa, 0.0)::TFloat AS SummaBefore
                       , tmpData.Summa 
                  FROM tmpData
                       LEFT JOIN tmpDataBefore ON tmpDataBefore.UnitId = tmpData.UnitId
                                              AND tmpDataBefore.JuridicalId = tmpData.JuridicalId
                                              AND tmpDataBefore.GoodsId = tmpData.GoodsId
                  ;
      ELSIF inisUnitSplit = TRUE AND inisJuridicalSplit = FALSE
      THEN
           INSERT INTO tmpDataAll
                  SELECT tmpData.UnitId
                       , 0::Integer AS JuridicalId 
                       , tmpData.GoodsId
                       , SUM (COALESCE (tmpDataBefore.Amount, 0.0))::TFloat AS AmountBefore
                       , SUM (tmpData.Amount)::TFloat                       AS Amount
                       , SUM (COALESCE (tmpDataBefore.Summa, 0.0))::TFloat  AS SummaBefore
                       , SUM (tmpData.Summa)::TFloat                        AS Summa
                  FROM tmpData
                       LEFT JOIN tmpDataBefore ON tmpDataBefore.UnitId = tmpData.UnitId
                                              AND tmpDataBefore.JuridicalId = tmpData.JuridicalId
                                              AND tmpDataBefore.GoodsId = tmpData.GoodsId
                  GROUP BY tmpData.UnitId
                         , tmpData.GoodsId
                  ;
      ELSIF inisUnitSplit = FALSE AND inisJuridicalSplit = TRUE
      THEN
           INSERT INTO tmpDataAll
                  SELECT 0::Integer AS UnitId
                       , tmpData.JuridicalId 
                       , tmpData.GoodsId
                       , SUM (COALESCE (tmpDataBefore.Amount, 0.0))::TFloat AS AmountBefore
                       , SUM (tmpData.Amount)::TFloat                       AS Amount
                       , SUM (COALESCE (tmpDataBefore.Summa, 0.0))::TFloat  AS SummaBefore
                       , SUM (tmpData.Summa)::TFloat                        AS Summa
                  FROM tmpData
                       LEFT JOIN tmpDataBefore ON tmpDataBefore.UnitId = tmpData.UnitId
                                              AND tmpDataBefore.JuridicalId = tmpData.JuridicalId
                                              AND tmpDataBefore.GoodsId = tmpData.GoodsId
                  GROUP BY tmpData.JuridicalId
                         , tmpData.GoodsId
                  ;
      ELSE
           INSERT INTO tmpDataAll
                  SELECT 0::Integer AS UnitId
                       , 0::Integer AS JuridicalId 
                       , tmpData.GoodsId
                       , SUM (COALESCE (tmpDataBefore.Amount, 0.0))::TFloat AS AmountBefore
                       , SUM (tmpData.Amount)::TFloat                       AS Amount
                       , SUM (COALESCE (tmpDataBefore.Summa, 0.0))::TFloat  AS SummaBefore
                       , SUM (tmpData.Summa)::TFloat                        AS Summa
                  FROM tmpData
                       LEFT JOIN tmpDataBefore ON tmpDataBefore.UnitId = tmpData.UnitId
                                              AND tmpDataBefore.JuridicalId = tmpData.JuridicalId
                                              AND tmpDataBefore.GoodsId = tmpData.GoodsId
                  GROUP BY tmpData.GoodsId
                  ;
      END IF;
    
      -- Результат
      RETURN QUERY
        SELECT tmpDataAll.UnitId
             , COALESCE (Object_Unit.ValueData, '')::TVarChar AS UnitName
             , tmpDataAll.JuridicalId
             , COALESCE (Object_Juridical.ValueData, '')::TVarChar AS JuridicalName 
             , tmpDataAll.GoodsId
             , Object_Goods.ObjectCode AS GoodsCode
             , Object_Goods.ValueData AS GoodsName
             , tmpDataAll.AmountBefore
             , tmpDataAll.Amount
             , tmpDataAll.SummaBefore
             , tmpDataAll.Summa 
             , CASE
                    WHEN (tmpDataAll.Amount - tmpDataAll.AmountBefore) > 0 AND tmpDataAll.AmountBefore <> 0 THEN
                      ((tmpDataAll.Amount - tmpDataAll.AmountBefore) / tmpDataAll.AmountBefore * 100.0)::TFloat
                    WHEN tmpDataAll.Amount > 0 AND tmpDataAll.AmountBefore = 0 THEN
                      100::TFloat
                    ELSE  
                      0::TFloat
               END AS AmountGrowthInPercent
             , CASE
                    WHEN (tmpDataAll.Amount - tmpDataAll.AmountBefore) < 0 AND tmpDataAll.AmountBefore <> 0 THEN
                      ((tmpDataAll.AmountBefore - tmpDataAll.Amount) / tmpDataAll.AmountBefore * 100.0)::TFloat
                    ELSE  
                      0::TFloat
               END AS AmountFallingInPercent
             , CASE
                    WHEN (tmpDataAll.Summa - tmpDataAll.SummaBefore) > 0 AND tmpDataAll.SummaBefore <> 0 THEN
                      ((tmpDataAll.Summa - tmpDataAll.SummaBefore) / tmpDataAll.SummaBefore * 100.0)::TFloat
                    WHEN tmpDataAll.Summa > 0 AND tmpDataAll.SummaBefore = 0 THEN
                      100::TFloat
                    ELSE  
                      0::TFloat
               END AS SummaGrowthInPercent
             , CASE
                    WHEN (tmpDataAll.Summa - tmpDataAll.SummaBefore) < 0 AND tmpDataAll.SummaBefore <> 0 THEN
                      ((tmpDataAll.SummaBefore - tmpDataAll.Summa) / tmpDataAll.SummaBefore * 100.0)::TFloat
                    ELSE  
                      0::TFloat
               END AS SummaFallingInPercent
        FROM tmpDataAll
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpDataAll.UnitId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpDataAll.JuridicalId
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpDataAll.GoodsId
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