-- Function:  gpReport_Profitability()

DROP FUNCTION IF EXISTS gpReport_Profitability (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Profitability(
    IN inDateStart              TDateTime,  -- Дата начала
    IN inDateFinal              TDateTime,  -- Двта конца
    IN inUnitID                 Integer,    -- Подразделение
    IN inisNoStaticSalaryAmount Boolean,    -- Без статической суммы ЗП
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitID          Integer
             , UnitCode        Integer   --
             , UnitName        TVarChar  --
             , SummaComing     TFloat    -- Сумма прихода сНДС
             , SummaSelling    TFloat    -- Сумма реализации
             , SummChange      TFloat    -- Сумма компенсации
             , SummaIncome     TFloat    -- Сумма дохода

             , Remains         TFloat    -- Остатки количество
             , RemainsSum      TFloat    -- Остатки сумма

             , WagesAmount     TFloat    -- Зарплата
             , ExpensesAmount  TFloat    -- Дополнительные затраты

             , Profit          TFloat    -- Прибыль

              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbObjectId   Integer;
   DECLARE vbDateWStart TDateTime;
   DECLARE vbDateWEnd   TDateTime;
   DECLARE vbWStart     Float;
   DECLARE vbWEnd       Float;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
      vbUserId:= lpGetUserBySession (inSession);

      -- Ограничение на просмотр товарного справочника
      vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    IF vbUserId <> 948223 AND inSession <> '3'
    THEN
        RAISE EXCEPTION 'Ошибка. Запуск отчета разрешен только директору.';
    END IF;


     vbDateWStart := DATE_TRUNC ('month', inDateStart);
     vbDateWEnd   := DATE_TRUNC ('month', inDateFinal);

     IF date_part('DAY',  inDateStart)::Integer > 1 OR
        DATE_TRUNC ('month', inDateStart) = DATE_TRUNC ('month', inDateFinal)
        AND date_part('DAY',  inDateFinal)::Integer < date_part('DAY', DATE_TRUNC ('MONTH', inDateFinal) + interval '1 month' - interval '1 day')::Integer
     THEN
       vbWStart := (CASE WHEN DATE_TRUNC ('month', inDateStart) = DATE_TRUNC ('month', inDateFinal)
                        THEN date_part('DAY', inDateFinal)::Float
                        ELSE date_part('DAY', DATE_TRUNC ('MONTH', inDateStart) + interval '1 month' - interval '1 day')::Float END -
                    date_part('DAY',  inDateStart)::Float + 1.0) /
                    date_part('DAY', DATE_TRUNC ('MONTH', inDateStart) + interval '1 month' - interval '1 day')::Float;
     ELSE
       vbWStart := 1;
     END IF;

     IF DATE_TRUNC ('month', inDateStart) < DATE_TRUNC ('month', inDateFinal)
        AND date_part('DAY', inDateFinal)::Integer < date_part('DAY', DATE_TRUNC ('MONTH', inDateFinal) + interval '1 month' - interval '1 day')::Integer
     THEN
       vbWEnd := date_part ('day', inDateFinal)::Float /  date_part('DAY', DATE_TRUNC ('MONTH', inDateFinal) + interval '1 month' - interval '1 day')::Float;
     ELSE
       vbWEnd := 1;
     END IF;

     inDateStart := DATE_TRUNC ('day', inDateStart);
     inDateFinal   := DATE_TRUNC ('day', inDateFinal) + interval '1 day';

      -- Результат
      RETURN QUERY
        WITH tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                         FROM ObjectLink AS ObjectLink_Unit_Juridical

                              INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                    ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                   AND (ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId OR vbObjectId = 0)

                          WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            AND (inUnitID = 0 OR inUnitID = ObjectLink_Unit_Juridical.ObjectId)
                         )
             -- Остатки
           , tmpContainerAll AS (SELECT Container.UnitID                        AS UnitID
                                      , Container.GoodsId                       AS GoodsId
                                      , SUM (Container.Saldo)                   AS Saldo
                                 FROM AnalysisContainer as Container
                                 WHERE (inUnitID = 0 OR inUnitID = Container.UnitID)
                                 GROUP BY Container.UnitID
                                        , Container.GoodsId
                              )
             -- Остатки на конец
           , tmpContainerEnd AS (SELECT Container.UnitID                                              AS UnitID
                                      , Container.GoodsId                                             AS GoodsId
                                      , Max(Container.Saldo) - COALESCE (SUM (ContainerItem.Saldo),0) AS Saldo
                                 FROM tmpContainerAll as Container
                                      LEFT OUTER JOIN AnalysisContainerItem AS ContainerItem
                                                                            ON ContainerItem.UnitID = Container.UnitID
                                                                           AND ContainerItem.GoodsId = Container.GoodsId
                                                                           AND ContainerItem.Operdate >= inDateFinal
                                 GROUP BY Container.UnitID
                                        , Container.GoodsId
                                 HAVING (Max(Container.Saldo) - SUM (COALESCE (ContainerItem.Saldo,0))) <> 0
                              )
           , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                              AND ObjectFloat_Goods_Price.ValueData > 0
                                             THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                             ELSE ROUND (Price_Value.ValueData, 2)
                                             END :: TFloat                           AS Price
                                       , Price_Goods.ChildObjectId                   AS GoodsId
                                       , ObjectLink_Price_Unit.ChildObjectId         AS UnitId
                                 FROM ObjectLink AS ObjectLink_Price_Unit
                                      LEFT JOIN ObjectLink AS Price_Goods
                                                           ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                          AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                      LEFT JOIN ObjectFloat AS Price_Value
                                                            ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                           AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                      LEFT JOIN ObjectFloat AS MCS_Value
                                                            ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                           AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                                      -- Фикс цена для всей Сети
                                      LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                             ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                            AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                                      LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                              ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                             AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                                  WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                    AND (inUnitID = 0 OR inUnitID = ObjectLink_Price_Unit.ChildObjectId)
                                  )
             -- Остаток по одразделениям
           , tmpRemains AS (SELECT tmpContainerEnd.UnitID
                                     , Sum(tmpContainerEnd.Saldo) AS Saldo
                                     , Sum(tmpContainerEnd.Saldo * tmpObject_Price.Price) AS SaldoSum
                                FROM tmpContainerEnd
                                     LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitID  = tmpContainerEnd.UnitID
                                                              AND tmpObject_Price.GoodsId = tmpContainerEnd.GoodsId
                                GROUP BY tmpContainerEnd.UnitID)
             -- Реализация за период
           , tmpRealization AS (SELECT AnalysisContainerItem.UnitID
                                     , Sum(COALESCE(AnalysisContainerItem.AmountCheckSumJuridical, 0) + COALESCE(AnalysisContainerItem.AmountSaleSumJuridical, 0)) AS AmountSumJuridical
                                     , Sum(COALESCE(AnalysisContainerItem.AmountCheckSum, 0) + COALESCE(AnalysisContainerItem.AmountSaleSum, 0))          AS AmountSum
                                FROM AnalysisContainerItem
                                WHERE AnalysisContainerItem.OperDate >= inDateStart
                                  AND AnalysisContainerItem.OperDate < inDateFinal
                                  AND (inUnitID = 0 OR inUnitID = AnalysisContainerItem.UnitID)
                                GROUP BY AnalysisContainerItem.UnitID)
             -- Статические суммы ЗП за реализацию единицы товара
           , tmpGoodsSummaWages AS (SELECT MovementItemContainer.WhereObjectId_analyzer                                                 AS UnitId
                                         , SUM(ROUND(-1 * MovementItemContainer.Amount * MovementItemContainer.Price * 0.03 +
                                                     MovementItemContainer.Amount * Object_Goods_Retail.SummaWages, 2))                 AS Summa
                                    FROM MovementItemContainer

                                          LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItemContainer.ObjectId_analyzer

                                     WHERE MovementItemContainer.OperDate >= inDateStart
                                       AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                                       AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                                       AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                       AND MovementItemContainer.ObjectId_analyzer IN (SELECT Object_Goods_Retail.ID
                                                                                       FROM Object_Goods_Retail
                                                                                       WHERE COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0)
                                       AND inisNoStaticSalaryAmount = TRUE
                                     GROUP BY MovementItemContainer.WhereObjectId_analyzer)
             -- Статические суммы ЗП % от продажи
           , tmpGoodsPercentWages AS (SELECT MovementItemContainer.WhereObjectId_analyzer                                              AS UnitId
                                           , SUM(ROUND(-1 * MovementItemContainer.Amount * MovementItemContainer.Price * 0.03 +
                                                       MovementItemContainer.Amount * MovementItemContainer.Price *
                                                       Object_Goods_Retail.PercentWages / 100.0, 2))                                   AS Summa
                                      FROM MovementItemContainer

                                           LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItemContainer.ObjectId_analyzer

                                      WHERE MovementItemContainer.OperDate >= inDateStart
                                        AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                                        AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                        AND MovementItemContainer.ObjectId_analyzer IN (SELECT Object_Goods_Retail.ID
                                                                                        FROM Object_Goods_Retail
                                                                                        WHERE COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0)
                                        AND inisNoStaticSalaryAmount = TRUE
                                      GROUP BY MovementItemContainer.WhereObjectId_analyzer)
             -- Зврплата за период
           , tmpWages AS (SELECT Object_Unit.ID                     AS UnitID
                               , SUM(MI_Child.Amount) AS Amount

                          FROM  Movement

                                INNER JOIN MovementItem AS MI_Master
                                                        ON MI_Master.MovementId = Movement.Id
                                                       AND MI_Master.DescId = zc_MI_Master()
                                                       AND MI_Master.isErased = FALSE

                                INNER JOIN MovementItem AS MI_Child
                                                        ON MI_Child.MovementId = Movement.Id
                                                       AND MI_Child.ParentId = MI_Master.Id
                                                       AND MI_Child.DescId = zc_MI_Child()
                                                       AND MI_Child.isErased = FALSE

                                INNER JOIN MovementItemDate AS MIDate_Calculation
                                                            ON MIDate_Calculation.MovementItemId = MI_Child.Id
                                                           AND MIDate_Calculation.DescId = zc_MIDate_Calculation()
                                                           AND MIDate_Calculation.ValueData >= inDateStart
                                                           AND MIDate_Calculation.ValueData < inDateFinal

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                 ON MILinkObject_Unit.MovementItemId = MI_Master.Id
                                                                AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                     ON ObjectLink_User_Member.ObjectId = MI_Master.ObjectId
                                                    AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

                                LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                                     ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                    AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

                                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MI_Child.ObjectId, MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId)


                          WHERE Movement.DescId = zc_Movement_Wages()
                            AND Movement.ID <> 15774527
                            AND Movement.OperDate >= vbDateWStart
                            AND Movement.OperDate <= vbDateWEnd
                          GROUP BY Object_Unit.ID
                          )
             -- Зврплата за период остальная
           , tmpWagesRest AS (SELECT Object_Unit.ID                     AS UnitID
                                   , SUM(CASE Movement.OperDate
                                              WHEN vbDateWStart THEN vbWStart
                                              WHEN vbDateWEnd THEN vbWEnd ELSE 1.0 END *
                                         (COALESCE (MIFloat_HolidaysHospital.ValueData, 0) +
                                          COALESCE (MIFloat_Marketing.ValueData, 0) +
                                          COALESCE (MIFloat_Director.ValueData, 0))) AS Amount

                              FROM  Movement
                                    LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId = zc_MI_Master()

                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                     ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                    LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                         ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                                        AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                    LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

                                    LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                                         ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                        AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

                                    LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId)

                                    LEFT JOIN MovementItemFloat AS MIFloat_HolidaysHospital
                                                                ON MIFloat_HolidaysHospital.MovementItemId = MovementItem.Id
                                                               AND MIFloat_HolidaysHospital.DescId = zc_MIFloat_HolidaysHospital()

                                    LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                                                ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                                               AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()

                                    LEFT JOIN MovementItemFloat AS MIFloat_Director
                                                                ON MIFloat_Director.MovementItemId = MovementItem.Id
                                                               AND MIFloat_Director.DescId = zc_MIFloat_Director()

                              WHERE Movement.DescId = zc_Movement_Wages()
                                AND Movement.ID <> 15774527
                                AND Movement.OperDate >= vbDateWStart
                                AND Movement.OperDate <= vbDateWEnd
                                AND MovementItem.isErased = FALSE
                              GROUP BY Object_Unit.ID
                              )
             -- Дополнительные расходы
           , tmpAdditionalExpenses AS (SELECT MovementItem.ObjectId              AS UnitID
                                            , SUM(CASE Movement.OperDate
                                                       WHEN vbDateWStart THEN vbWStart
                                                       WHEN vbDateWEnd THEN vbWEnd ELSE 1.0 END * MovementItem.Amount) AS Amount
                                       FROM  Movement
                                             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId = zc_MI_Sign()

                                       WHERE Movement.DescId = zc_Movement_Wages()
                                         AND Movement.ID <> 15774527
                                         AND Movement.OperDate >= vbDateWStart
                                         AND Movement.OperDate <= vbDateWEnd
                                         AND MovementItem.isErased = FALSE
                                       GROUP BY MovementItem.ObjectId
                                       )
           , tmpSPKind AS (SELECT MovementLinkObject_Unit.ObjectId                     AS UnitID
                                , sum(CASE WHEN Movement.DescId = zc_Movement_Check() THEN MovementFloat_TotalSummChangePercent.ValueData
                                  ELSE COALESCE(MovementFloat_TotalSummSale.ValueData, 0) - COALESCE(MovementFloat_TotalSumm.ValueData, 0) END)  AS SummChange
                           FROM Movement

                                INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                              ON MovementLinkObject_SPKind.MovementID = Movement.ID
                                                             AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                             AND MovementLinkObject_SPKind.ObjectId in (zc_Enum_SPKind_1303(), zc_Enum_SPKind_SP())

                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementID = Movement.ID
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                         ON MovementFloat_TotalSummChangePercent.MovementID = Movement.ID
                                                        AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

                                LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                        ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                       AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                                        ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                                                       AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

                           WHERE Movement.OperDate >= inDateStart
                             AND Movement.OperDate < inDateFinal
                             AND Movement.DescId in (zc_Movement_Check(), zc_Movement_Sale())
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                           GROUP BY  MovementLinkObject_Unit.ObjectId )

        SELECT tmpUnit.UnitId
             , Object_Unit.ObjectCode
             , Object_Unit.ValueData
             , ROUND(tmpRealization.AmountSumJuridical, 2) ::TFloat
             , ROUND(tmpRealization.AmountSum, 2) ::TFloat
             , ROUND(tmpSPKind.SummChange, 2) ::TFloat
             , ROUND(COALESCE(tmpRealization.AmountSum, 0)::TFloat + COALESCE(tmpSPKind.SummChange, 0)::TFloat - COALESCE(tmpRealization.AmountSumJuridical, 0), 2)::TFloat

             , ROUND(tmpRemains.Saldo, 2)::TFloat
             , ROUND(tmpRemains.SaldoSum, 2)::TFloat

             , ROUND(tmpWages.Amount + COALESCE (tmpGoodsSummaWages.Summa, 0) + COALESCE (tmpGoodsPercentWages.Summa, 0), 2)::TFloat
             , ROUND(COALESCE(tmpAdditionalExpenses.Amount, 0)::TFloat + COALESCE(tmpWagesRest.Amount, 0)::TFloat, 2)::TFloat

             , ROUND(COALESCE(tmpRealization.AmountSum, 0)::TFloat + COALESCE(tmpSPKind.SummChange, 0)::TFloat - COALESCE(tmpRealization.AmountSumJuridical, 0)::TFloat -
                COALESCE(tmpWages.Amount, 0)::TFloat - COALESCE (tmpGoodsSummaWages.Summa, 0) - COALESCE (tmpGoodsPercentWages.Summa, 0) - 
                COALESCE(tmpAdditionalExpenses.Amount, 0)::TFloat - COALESCE(tmpWagesRest.Amount, 0)::TFloat, 2) ::TFloat
        FROM tmpUnit

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitId

             LEFT JOIN tmpRealization ON tmpRealization.UnitID = Object_Unit.Id

             LEFT JOIN tmpRemains ON tmpRemains.UnitID = Object_Unit.Id

             LEFT JOIN tmpWages ON tmpWages.UnitID = Object_Unit.Id
             LEFT JOIN tmpGoodsSummaWages ON tmpGoodsSummaWages.UnitID = Object_Unit.Id
             LEFT JOIN tmpGoodsPercentWages ON tmpGoodsPercentWages.UnitID = Object_Unit.Id
             LEFT JOIN tmpWagesRest ON tmpWagesRest.UnitID = Object_Unit.Id

             LEFT JOIN tmpAdditionalExpenses ON tmpAdditionalExpenses.UnitID = Object_Unit.Id

             LEFT JOIN tmpSPKind ON tmpSPKind.UnitID = Object_Unit.Id
        WHERE tmpRealization.AmountSumJuridical <> 0
           OR tmpRealization.AmountSum <> 0
           OR tmpWages.Amount <> 0
           OR tmpAdditionalExpenses.Amount <> 0
        ORDER BY tmpUnit.UnitId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.11.19                                                       *

*/

-- тест
--
select * from gpReport_Profitability(inDateStart := ('01.04.2020')::TDateTime , inDateFinal := ('30.06.2020')::TDateTime , inUnitId := 3457773 , inisNoStaticSalaryAmount := False,  inSession := '3');