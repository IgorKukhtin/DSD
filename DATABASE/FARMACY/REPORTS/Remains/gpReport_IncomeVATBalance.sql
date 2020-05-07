-- Function: gpReport_IncomeVATBalance()

DROP FUNCTION IF EXISTS gpReport_IncomeVATBalance (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IncomeVATBalance(
    IN inStartDate     TDateTime , -- ������ �������
    IN inEndDate       TDateTime , -- ����� �������
    IN inSession       TVarChar    -- ������ ������������
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
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

  vbStartDate := DATE_TRUNC ('MONTH', inStartDate);
  vbEndDate := vbStartDate + INTERVAL '1 MONTH' - INTERVAL '1 day';

  IF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = 1 AND date_part('MONTH', vbEndDate) = 3
  THEN
   vbPeriod := '�� 1 ��. ' || EXTRACT (YEAR FROM vbStartDate) || '�.';
  ELSEIF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = 4 AND date_part('MONTH', vbEndDate) = 6
  THEN
   vbPeriod := '�� 2 ��. ' || EXTRACT (YEAR FROM vbStartDate) || '�.';
  ELSEIF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = 7 AND date_part('MONTH', vbEndDate) = 9
  THEN
   vbPeriod := '�� 3 ��. ' || EXTRACT (YEAR FROM vbStartDate) || '�.';
  ELSEIF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = 10 AND date_part('MONTH', vbEndDate) = 12
  THEN
   vbPeriod := '�� 4 ��. ' || EXTRACT (YEAR FROM vbStartDate) || '�.';
  ELSEIF DATE_TRUNC ('YEAR', inStartDate) = DATE_TRUNC ('YEAR', vbEndDate) AND date_part('MONTH', vbStartDate) = date_part('MONTH', vbEndDate)
  THEN
   vbPeriod := '�� ' || zfCalc_MonthYearName (vbStartDate) || '�.';
  ELSE
    vbPeriod := 'C '||zfCalc_MonthYearName (vbStartDate)||' �� ' ||zfCalc_MonthYearName (vbEndDate);
  END IF;

  vbEndDate := vbEndDate + INTERVAL '1 day';

  RETURN QUERY
  WITH
        -- ���� ������
    tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                      , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                      , COALESCE (ObjectHistoryFloat_Price.ValueData, 0) :: TFloat  AS Price
                 FROM ObjectLink AS ObjectLink_Price_Unit
                      INNER JOIN ObjectLink AS Price_Goods
                                            ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                           AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                      -- �������� �������� ���� � ��� �� ������� �������� �� ������ ���
                      LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                              ON ObjectHistory_Price.ObjectId = Price_Goods.ObjectId
                                             AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                             AND vbEndDate >= ObjectHistory_Price.StartDate AND vbEndDate < ObjectHistory_Price.EndDate
                      LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                   ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                  AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                 WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                ),
    tmpMIContainer AS (
                      SELECT MIC.ContainerId                                          AS ContainerId
                           , SUM (CASE WHEN MIC.OperDate < vbEndDate
                                        AND MIC.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale()) THEN - 1.0 * MIC.Amount ELSE 0.0 END) AS AmountSale
                           , SUM (CASE WHEN MIC.OperDate >= vbEndDate THEN MIC.Amount ELSE 0.0 END)                            AS AmountOut
                      FROM MovementItemContainer AS MIC
                      WHERE MIC.DescId = zc_MIContainer_Count()
                        AND MIC.OperDate >= vbStartDate
                      GROUP BY MIC.ContainerId
                      ),

    tmpContainer AS (
                      SELECT Container.Id                                                          AS ID
                           , Container.ObjectId                                                    AS GoodsId
                           , Container.WhereObjectId                                               AS UnitId
                           , COALESCE (tmpMIContainer.AmountSale, 0.0)                             AS AmountSale
                           , Container.Amount - COALESCE (tmpMIContainer.AmountOut, 0.0)           AS Remains
                      FROM Container AS Container
                           LEFT OUTER JOIN tmpMIContainer ON tmpMIContainer.ContainerId = Container.Id
                      WHERE Container.DescId = zc_Container_Count()
                        AND (COALESCE (tmpMIContainer.AmountSale, 0.0)  <> 0
                         OR Container.Amount - COALESCE (tmpMIContainer.AmountOut, 0.0) <> 0)
--                        AND Container.WhereObjectId = 183292
                      ),

    tmpContainerIncome AS (
                        SELECT Container.GoodsId                                                              AS GoodsId
                             , Container.UnitId                                                               AS UnitId
                             , Container.AmountSale                                                           AS AmountSale
                             , Container.Remains                                                              AS Remains
                             , COALESCE (MI_Income_find.Id, MI_Income.Id)                                     AS MI_IncomeId
                             , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)                      AS M_IncomeId
                        FROM tmpContainer AS Container
                             LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                           ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                          AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                             LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                             -- ������� �������
                             LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                             -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                             LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                         ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                        AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                             -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                             LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                            ),

    tmpContainerSum AS (
                        SELECT Container.UnitId                                                               AS UnitId
                             , Container.GoodsId                                                              AS GoodsId
                             , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                                      OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
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
 ������� ����������: ����, �����
             ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 05.05.20                                                      *
*/

-- ����
-- select * from gpReport_IncomeVATBalance(inStartDate := ('01.04.2020')::TDateTime , inEndDate := ('30.04.2020')::TDateTime , inSession := '3');