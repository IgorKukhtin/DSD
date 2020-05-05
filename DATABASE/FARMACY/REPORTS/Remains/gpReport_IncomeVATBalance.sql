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
)
AS
$BODY$
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbPeriod    TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

  vbStartDate := DATE_TRUNC ('MONTH', inStartDate);
  vbEndDate := vbStartDate + INTERVAL '1 MONTH' - INTERVAL '1 day';

  IF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = 1 AND date_part('MONTH', vbEndDate) = 3
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

  RETURN QUERY
  WITH
    tmpMIContainer AS (
                      SELECT MIC.ContainerId                                          AS ContainerId
                           , SUM (CASE WHEN MIC.OperDate < vbEndDate + INTERVAL '1 day'
                                        AND MIC.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale()) THEN - 1.0 * MIC.Amount ELSE 0.0 END) AS AmountSale
                           , SUM (CASE WHEN MIC.OperDate >= vbEndDate + INTERVAL '1 day' THEN MIC.Amount ELSE 0.0 END)                            AS AmountOut
                      FROM MovementItemContainer AS MIC
                      WHERE MIC.DescId = zc_MIContainer_Count()
                        AND MIC.OperDate >= vbStartDate
                      GROUP BY MIC.ContainerId
                      ),

    tmpContainer AS (
                      SELECT Container.Id                                                          AS ID
                           , ObjectLink_Unit_Juridical.ChildObjectId                               AS JuridicalID
                           , Container.ObjectId                                                    AS GoodsId
                           , COALESCE (tmpMIContainer.AmountSale, 0.0)                             AS AmountSale
                           , Container.Amount - COALESCE (tmpMIContainer.AmountOut, 0.0)           AS Remains
                      FROM Container AS Container
                           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = Container.WhereObjectId
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           LEFT OUTER JOIN tmpMIContainer ON tmpMIContainer.ContainerId = Container.Id
                      WHERE Container.DescId = zc_Container_Count()
                        AND (COALESCE (tmpMIContainer.AmountSale, 0.0)  <> 0
                         OR Container.Amount - COALESCE (tmpMIContainer.AmountOut, 0.0) <> 0)
--                        AND Container.WhereObjectId = 183292
                      ),

    tmpContainerIncome AS (
                        SELECT Container.JuridicalID                                                          AS JuridicalID
                             , Container.GoodsId                                                              AS GoodsId
                             , Container.AmountSale                                                           AS AmountSale
                             , Container.Remains                                                              AS Remains
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
                        SELECT Container.JuridicalID                                                          AS JuridicalID
                             , Container.GoodsId                                                              AS GoodsId
                             , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                      OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                                    THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
                             , Container.AmountSale * MIFloat_PriceWithOutVAT.ValueData                       AS AmountSale
                             , Container.Remains * MIFloat_PriceWithOutVAT.ValueData                          AS Remains
                        FROM tmpContainerIncome AS Container

                             LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.GoodsId
                             LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

                             LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                             ON MovementBoolean_UseNDSKind.MovementId = Container.M_IncomeId
                                                            AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                          ON MovementLinkObject_NDSKind.MovementId = Container.M_IncomeId
                                                         AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()

                             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                         ON MIFloat_PriceWithOutVAT.MovementItemId = Container.MI_IncomeId
                                                        AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT())

    SELECT
           Object_Juridical.ValueData             AS JuridicalName
         , vbPeriod                               AS Period
         , Object_NDSKindId.ValueData             AS NDSKindName
         , Sum(Container.AmountSale)::TFloat      AS AmountSale
         , Sum(Container.Remains)::TFloat         AS Remains
    FROM tmpContainerSum as Container

         INNER JOIN Object AS Object_Juridical ON Object_Juridical.Id = Container.JuridicalID

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
-- select * from gpReport_IncomeVATBalance(inStartDate := ('01.04.2020')::TDateTime , inEndDate := ('30.04.2020')::TDateTime , inSession := '3');