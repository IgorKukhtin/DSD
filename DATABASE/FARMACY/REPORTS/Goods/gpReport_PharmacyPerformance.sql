-- Function: gpReport_PharmacyPerformance()

DROP FUNCTION IF EXISTS gpReport_PharmacyPerformance (TDateTime, TDateTime, TDateTime, TDateTime, BOOLEAN, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PharmacyPerformance(
    IN inStartDate                TDateTime , --
    IN inEndDate                  TDateTime , --
    IN inStartDateSecond          TDateTime , --
    IN inEndDateSecond            TDateTime , --
    IN inisSeasonalityCoefficient BOOLEAN,
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar,

               CountCheck Integer,
               TotalSumm TFloat,
               AverageCheck TFloat,
               PercMarkup TFloat,

               CountCheckSecond Integer,
               TotalSummSecond TFloat,
               AverageCheckSecond TFloat,
               PercMarkupSecond TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbSeasonalityCoefficientId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    vbSeasonalityCoefficientId := (SELECT Min(Object.Id) FROM Object WHERE Object.DescId = zc_Object_SeasonalityCoefficient());

     -- Результат
     RETURN QUERY
    WITH
       tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                             AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                   WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   )
     , tmpSeasonalityCoefficient AS (SELECT 1 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff1()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 2 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff2()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 3 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff3()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 4 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff4()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 5 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff5()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 6 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff6()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 7 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff7()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 8 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff8()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 9 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff9()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 10 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff10()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 11 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff11()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     UNION ALL
                                     SELECT 12 AS Month, COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat
                                     WHERE ObjectFloat.ObjectId = vbSeasonalityCoefficientId
                                       AND ObjectFloat.DescId = zc_ObjectFloat_SeasonalityCoefficient_Koeff12()
                                       AND inisSeasonalityCoefficient = TRUE), 1) AS Koeff
                                     )
     , tmpMovement AS (SELECT Movement.*
                            , MovementLinkObject_Unit.ObjectId  AS UnitID
                        FROM Movement

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                        WHERE (Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                          AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY')
                          AND Movement.DescId = zc_Movement_Check()
                          AND  Movement.StatusId = zc_Enum_Status_Complete()
                     )
     , tmpMovementUnit AS (SELECT Movement.UnitID                   AS UnitID
                                , Sum(tmpSeasonalityCoefficient.Koeff)::Integer                                    AS CountCheck
                                , Sum(MovementFloat_TotalSumm.ValueData * tmpSeasonalityCoefficient.Koeff)::TFloat AS TotalSumm
                           FROM tmpMovement AS Movement

                                LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                        ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                       AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                LEFT JOIN tmpSeasonalityCoefficient ON tmpSeasonalityCoefficient.Month = date_part('MONTH',  Movement.OperDate)

                           GROUP BY Movement.UnitID
                     )
     , tmpContainer AS (SELECT Movement.UnitID                                                 AS UnitID
                             , MIContainer.Amount                                              AS Amount
                             , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)       AS M_IncomeId
                             , COALESCE (MI_Income_find.Id,MI_Income.Id)                       AS MI_IncomeId
                        FROM tmpMovement AS Movement

                             INNER JOIN tmpUnit ON tmpUnit.UnitId = Movement.UnitID

                             INNER JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.MovementId = Movement.Id
                                                              AND MIContainer.DescId = zc_MIContainer_Count()

                             LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                           ON ContainerLinkObject_MovementItem.Containerid = MIContainer.ContainerId
                                                          AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                             LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                             -- элемент прихода
                             LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                             -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                             LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                         ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                        AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                             -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                             LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                        WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                          AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                          AND Movement.DescId = zc_Movement_Check()
                          AND  Movement.StatusId = zc_Enum_Status_Complete()
                     )
     , tmpIncome AS (SELECT tmpContainer.UnitID
                          , SUM( -1.0 * tmpContainer.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0) * tmpSeasonalityCoefficient.Koeff)::TFloat AS SummaWithVAT
                     FROM tmpContainer
                          -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                      ON MIFloat_PriceWithVAT.MovementItemId = tmpContainer.MI_IncomeId
                                                     AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                            -- цена без учета НДС, для элемента прихода от поставщика (или NULL)
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                      ON MIFloat_PriceWithOutVAT.MovementItemId = tmpContainer.MI_IncomeId
                                                     AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                          LEFT JOIN Movement ON Movement.Id =  tmpContainer.M_IncomeId
                          LEFT JOIN tmpSeasonalityCoefficient ON tmpSeasonalityCoefficient.Month = date_part('MONTH',  Movement.OperDate)
                     GROUP BY tmpContainer.UnitID)
     , tmpMovementSecond AS (SELECT Movement.*
                                   , MovementLinkObject_Unit.ObjectId  AS UnitID
                             FROM Movement

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                             WHERE (Movement.OperDate >= DATE_TRUNC ('DAY', inStartDateSecond)
                               AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDateSecond) + INTERVAL '1 DAY')
                               AND Movement.DescId = zc_Movement_Check()
                               AND  Movement.StatusId = zc_Enum_Status_Complete()
                           )
     , tmpMovementUnitSecond AS (SELECT Movement.UnitID                   AS UnitID
                                      , Sum(tmpSeasonalityCoefficient.Koeff)::Integer                                           AS CountCheck
                                      , Sum(MovementFloat_TotalSumm.ValueData * tmpSeasonalityCoefficient.Koeff)::TFloat        AS TotalSumm
                                 FROM tmpMovementSecond AS Movement

                                      LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                              ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                             AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                      LEFT JOIN tmpSeasonalityCoefficient ON tmpSeasonalityCoefficient.Month = date_part('MONTH',  Movement.OperDate)

                                 GROUP BY Movement.UnitID
                           )
     , tmpContainerSecond AS (SELECT Movement.UnitID                                                 AS UnitID
                                   , MIContainer.Amount                                              AS Amount
                                   , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)       AS M_IncomeId
                                   , COALESCE (MI_Income_find.Id,MI_Income.Id)                       AS MI_IncomeId
                              FROM tmpMovementSecond AS Movement

                                   INNER JOIN tmpUnit ON tmpUnit.UnitId = Movement.UnitID

                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.MovementId = Movement.Id
                                                                    AND MIContainer.DescId = zc_MIContainer_Count()

                                   LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                 ON ContainerLinkObject_MovementItem.Containerid = MIContainer.ContainerId
                                                                AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                   LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                   -- элемент прихода
                                   LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                   -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                               ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                   -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                   LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDateSecond)
                                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDateSecond) + INTERVAL '1 DAY'
                                AND Movement.DescId = zc_Movement_Check()
                                AND  Movement.StatusId = zc_Enum_Status_Complete()
                     )
     , tmpIncomeSecond AS (SELECT tmpContainer.UnitID
                                , SUM( -1.0 * tmpContainer.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0) * tmpSeasonalityCoefficient.Koeff)::TFloat AS SummaWithVAT
                           FROM tmpContainerSecond AS tmpContainer
                                -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                                LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                            ON MIFloat_PriceWithVAT.MovementItemId = tmpContainer.MI_IncomeId
                                                           AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                                LEFT JOIN Movement ON Movement.Id =  tmpContainer.M_IncomeId
                                LEFT JOIN tmpSeasonalityCoefficient ON tmpSeasonalityCoefficient.Month = date_part('MONTH',  Movement.OperDate)
                           GROUP BY tmpContainer.UnitID)

     SELECT Object_Unit.Id
          , Object_Unit.ObjectCode
          , Object_Unit.ValueData

          , tmpMovementUnit.CountCheck
          , tmpMovementUnit.TotalSumm
          , (tmpMovementUnit.TotalSumm / tmpMovementUnit.CountCheck) ::TFloat AS AverageCheck
          , ((tmpMovementUnit.TotalSumm / tmpIncome.SummaWithVAT - 1) * 100.0) ::TFloat AS PercMarkup

          , tmpMovementUnitSecond.CountCheck
          , tmpMovementUnitSecond.TotalSumm
          , (tmpMovementUnitSecond.TotalSumm / tmpMovementUnitSecond.CountCheck) ::TFloat AS AverageCheckSecond
          , ((tmpMovementUnitSecond.TotalSumm / tmpIncomeSecond.SummaWithVAT - 1) * 100.0) ::TFloat AS PercMarkupSecond
     FROM tmpUnit
          INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitId

          LEFT JOIN tmpMovementUnit ON tmpMovementUnit.UnitId = tmpUnit.UnitId
          LEFT JOIN tmpIncome ON tmpIncome.UnitId = tmpUnit.UnitId

          LEFT JOIN tmpMovementUnitSecond ON tmpMovementUnitSecond.UnitId = tmpUnit.UnitId
          LEFT JOIN tmpIncomeSecond ON tmpIncomeSecond.UnitId = tmpUnit.UnitId

     WHERE COALESCE(tmpMovementUnit.CountCheck, 0) > 0;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.04.20                                                       *
*/

-- тест
-- select * from gpReport_PharmacyPerformance(inStartDate := ('01.03.2020')::TDateTime , inEndDate := ('31.03.2020')::TDateTime , inStartDateSecond := ('01.03.2019')::TDateTime , inEndDateSecond := ('31.03.2019')::TDateTime , inisSeasonalityCoefficient := FALSE,  inSession := '3');