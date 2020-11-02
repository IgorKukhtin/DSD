-- Function: gpReport_IncomeVATBalance()

DROP FUNCTION IF EXISTS gpReport_IncomeVATBalance (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IncomeVATBalance(
    IN inStartDate     TDateTime , -- Начало периода
    IN inEndDate       TDateTime , -- Конец периода
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalName       TVarChar
             , Period              TVarChar
             , NDSKindName         TVarChar
             , AmountSale          TFloat
             , Remains             TFloat
             , RemainsNDS          TFloat
             , RemainsSale         TFloat
)
AS
$BODY$
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbPeriod    TVarChar;
   DECLARE vbUserId Integer;
   DECLARE vbRetailId  Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
  vbUserId:= lpGetUserBySession (inSession);

  -- определяется <Торговая сеть>
  vbRetailId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

  vbStartDate := DATE_TRUNC ('DAY', inStartDate);
  vbEndDate := DATE_TRUNC ('DAY', inEndDate);

  IF date_part('DAY', vbStartDate)::Integer <> 1 OR date_part('DAY', vbEndDate + INTERVAL '1 day')::Integer <> 1
  THEN
   vbPeriod := 'C '||zfConvert_DateToString (vbStartDate)||' по ' ||zfConvert_DateToString (vbEndDate);
  ELSEIF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = 1 AND date_part('MONTH', vbEndDate) = 3
  THEN
   vbPeriod := 'За 1 кв. ' || EXTRACT (YEAR FROM vbStartDate) || 'г.';
  ELSEIF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = 4 AND date_part('MONTH', vbEndDate) = 6
  THEN
   vbPeriod := 'За 2 кв. ' || EXTRACT (YEAR FROM vbStartDate) || 'г.';
  ELSEIF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = 7 AND date_part('MONTH', vbEndDate) = 9
  THEN
   vbPeriod := 'За 3 кв. ' || EXTRACT (YEAR FROM vbStartDate) || 'г.';
  ELSEIF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = 10 AND date_part('MONTH', vbEndDate) = 12
  THEN
   vbPeriod := 'За 4 кв. ' || EXTRACT (YEAR FROM vbStartDate) || 'г.';
  ELSEIF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = date_part('MONTH', vbEndDate)
  THEN
   vbPeriod := 'За ' || zfCalc_MonthYearName (vbStartDate) || 'г.';
  ELSE
    vbPeriod := 'C '||zfCalc_MonthYearName (vbStartDate)||' по ' ||zfCalc_MonthYearName (vbEndDate);
  END IF;

  vbEndDate := vbEndDate + INTERVAL '1 day';

  RETURN QUERY
  WITH
        -- Подразделения
    tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                 WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   AND (ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId OR vbRetailId = 4)
                  -- AND ObjectLink_Unit_Juridical.ChildObjectId = 393038
                  -- AND ObjectLink_Unit_Juridical.ObjectId = 183292
              ),
        -- цены аптеки
    tmpObjectHistory AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                              , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                              , Price_Goods.ObjectId
                         FROM ObjectLink AS ObjectLink_Price_Unit
                              INNER JOIN ObjectLink AS Price_Goods
                                                    ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                         WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                           AND ObjectLink_Price_Unit.ChildObjectId in (SELECT tmpUnit.UnitId FROM tmpUnit)
                         --  AND ObjectLink_Price_Unit.ChildObjectId in (10126729, 10128935)
                         ),
    tmpPrice AS (SELECT ObjectLink_Price_Unit.GoodsId                               AS GoodsId
                      , ObjectLink_Price_Unit.UnitId                                AS UnitId
                      , COALESCE (ObjectHistoryFloat_Price.ValueData, 0) :: TFloat  AS Price
                 FROM tmpObjectHistory AS ObjectLink_Price_Unit

                      -- получаем значения цены и НТЗ из истории значений на начало дня
                      LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                              ON ObjectHistory_Price.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                             AND vbEndDate >= ObjectHistory_Price.StartDate AND vbEndDate < ObjectHistory_Price.EndDate
                      LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                   ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                  AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                 ),
    tmpMIC AS (
                      SELECT MIC.ContainerId
                           , COALESCE (SUM(CASE WHEN MIC.OperDate < vbEndDate + INTERVAL '1 day'
                                        AND MIC.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale()) THEN - 1.0 * MIC.Amount ELSE 0.0 END), 0.0)  AS AmountSale
                           , COALESCE (SUM(CASE WHEN MIC.OperDate >= vbEndDate + INTERVAL '1 day' THEN - 1.0 * MIC.Amount ELSE 0.0 END), 0.0)                       AS Amount
                      FROM MovementItemContainer AS MIC
                      WHERE MIC.DescId = zc_MIContainer_Count()
                        AND MIC.OperDate >= vbStartDate

                      GROUP BY MIC.ContainerId
                      ),
    tmpMIContainer AS (
                      SELECT Container.Id
                           , Container.ObjectId
                           , Container.WhereObjectId
                           , MIC.AmountSale
                           , MIC.Amount
                      FROM tmpMIC AS MIC

                           INNER JOIN Container ON Container.ID = MIC.ContainerID
                                               AND Container.WhereObjectId in (SELECT tmpUnit.UnitId FROM tmpUnit)

                      ),
    tmpContainerAll AS (
                      SELECT Container.Id
                           , Container.ObjectId
                           , Container.WhereObjectId
                           , Null::TFloat               AS AmountSale
                           , Container.Amount
                      FROM Container AS Container
                      WHERE Container.DescId = zc_Container_Count()
                        AND Container.WhereObjectId in (SELECT tmpUnit.UnitId FROM tmpUnit)
                        AND Container.Amount <> 0
                      UNION ALL
                      SELECT tmpMIContainer.Id
                           , tmpMIContainer.ObjectId
                           , tmpMIContainer.WhereObjectId
                           , tmpMIContainer.AmountSale
                           , tmpMIContainer.Amount
                      FROM tmpMIContainer
                      ),
    tmpContainer AS (
                      SELECT Container.Id
                           , Container.ObjectId              AS GoodsId
                           , Container.WhereObjectId         AS UnitId
                           , Sum(Container.AmountSale)       AS AmountSale
                           , Sum(Container.Amount)           AS Amount
                      FROM tmpContainerAll AS Container
                      GROUP BY Container.Id
                             , Container.ObjectId
                             , Container.WhereObjectId
                      ),
    tmpContainerIncome AS (
                        SELECT Container.GoodsId                                                              AS GoodsId
                             , Container.UnitId                                                               AS UnitId
                             , Container.AmountSale                                                           AS AmountSale
                             , Container.Amount                                                               AS Remains
                             , COALESCE (MI_Income_find.Id, MI_Income.Id)                                     AS MI_IncomeId
                             , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)                      AS M_IncomeId
                        FROM tmpContainer AS Container
                             LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                           ON ContainerLinkObject_MovementItem.Containerid = Container.Id
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
                            ),

    tmpContainerSum AS (
                        SELECT Container.UnitId                                                               AS UnitId
                             , Container.GoodsId                                                              AS GoodsId
                             , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                      OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                      OR Container.M_IncomeId = 19763747
                                    THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                             , Container.AmountSale * MIFloat_PriceWithOutVAT.ValueData                       AS AmountSale
                             , Container.Remains * MIFloat_PriceWithOutVAT.ValueData                          AS Remains
                             , Container.Remains * MIFloat_PriceWithVAT.ValueData                             AS RemainsNDS
                             , Container.Remains * tmpPrice.Price                                             AS RemainsSale
                        FROM tmpContainerIncome AS Container

                             LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.GoodsId
                             LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                             LEFT OUTER JOIN tmpPrice ON tmpPrice.GoodsId = Container.GoodsId
                                                     AND tmpPrice.UnitId = Container.UnitId

                             LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                             ON MovementBoolean_UseNDSKind.MovementId = Container.M_IncomeId
                                                            AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                          ON MovementLinkObject_NDSKind.MovementId = Container.M_IncomeId
                                                         AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()

                             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                         ON MIFloat_PriceWithOutVAT.MovementItemId = Container.MI_IncomeId
                                                        AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                         ON MIFloat_PriceWithVAT.MovementItemId = Container.MI_IncomeId
                                                        AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT())

    SELECT
           Object_Juridical.ValueData             AS JuridicalName
         , vbPeriod                               AS Period
         , Object_NDSKindId.ValueData             AS NDSKindName
         , Sum(Container.AmountSale)::TFloat      AS AmountSale
         , Sum(Container.Remains)::TFloat         AS Remains
         , Sum(Container.RemainsNDS)::TFloat      AS RemainsNDS
         , Sum(Container.RemainsSale)::TFloat     AS RemainsSale

    FROM tmpContainerSum as Container

         INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                               ON ObjectLink_Unit_Juridical.ObjectId = Container.UnitId
                              AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

         INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

         INNER JOIN Object AS Object_NDSKindId ON Object_NDSKindId.Id = Container.NDSKindId

    GROUP BY Object_Juridical.ValueData
           , Object_NDSKindId.ValueData
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
             Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 05.05.20                                                      *
*/

-- тест
-- select * from gpReport_IncomeVATBalance(inStartDate := ('01.01.2020')::TDateTime , inEndDate := ('31.01.2020')::TDateTime , inSession := '3');

select * from gpReport_IncomeVATBalance(inStartDate := ('01.01.2020')::TDateTime , inEndDate := ('10.09.2020')::TDateTime ,  inSession := '15009580');