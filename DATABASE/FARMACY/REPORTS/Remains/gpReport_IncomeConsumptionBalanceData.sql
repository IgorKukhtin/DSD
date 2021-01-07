-- Function: gpReport_IncomeConsumptionBalanceData()

DROP FUNCTION IF EXISTS gpReport_IncomeConsumptionBalanceData (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IncomeConsumptionBalanceData(
    IN inStartDate     TDateTime , -- ������ �������
    IN inEndDate       TDateTime , -- ����� �������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (ParentName TVarChar
             , UnitName TVarChar

             , GoodsId Integer
             , GoodsName TVarChar

             , SaldoIn TFloat
             , SummaIn TFloat

             , AmountIncome TFloat       -- ������
             , AmountIncomeSumWith TFloat
             , AmountIncomeSum TFloat

             , AmountReturnOut TFloat   -- ������� ����������
             , AmountReturnOutSum TFloat

             , AmountCheck TFloat       -- �������� ���
             , AmountCheckSumJuridical TFloat
             , AmountCheckSum TFloat

             , AmountSale TFloat        -- �������
             , AmountSaleSumJuridical TFloat
             , AmountSaleSum TFloat

             , AmountReturnIn TFloat        -- ������� �����������
             , AmountReturnInSum TFloat

             , AmountInventory TFloat   -- ��������
             , AmountInventorySum TFloat

             , AmountLoss TFloat        -- ��������
             , AmountLossSum TFloat

             , AmountSend TFloat        -- �����������
             , AmountSendSum TFloat

             , SaldoOut TFloat
             , SummaOut TFloat

             , isChecked Boolean
             , isReport Boolean
             )
AS
$BODY$
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

  vbStartDate := DATE_TRUNC ('DAY', inStartDate);
  vbEndDate := DATE_TRUNC ('DAY', inEndDate);

  RETURN QUERY
  WITH
    tmpContainer AS (
                        SELECT AnalysisContainer.UnitID                                                      AS UnitID
                             , AnalysisContainer.GoodsId                                                     AS GoodsId
                             , SUM(AnalysisContainer.Saldo)::TFloat                                          AS Saldo
                             , SUM((AnalysisContainer.Saldo  *
                                 AnalysisContainer.Price)::NUMERIC (16, 2))::TFloat                          AS Summa
                        FROM AnalysisContainer AS AnalysisContainer
                        GROUP BY AnalysisContainer.UnitID
                               , AnalysisContainer.GoodsId
                        ),

    tmpSaldoOut AS (
                        SELECT MovementItem.UnitID                                                       AS UnitID
                             , MovementItem.GoodsId                                                      AS GoodsId
                             , SUM(MovementItem.Saldo)                                                   AS Saldo
                             , SUM(MovementItem.SaldoSum)                                                AS Summa
                        FROM AnalysisContainerItem AS MovementItem
                        WHERE MovementItem.Operdate > vbEndDate
                        GROUP BY MovementItem.UnitID
                               , MovementItem.GoodsId ),

    tmContainerItem AS (SELECT
                            AnalysisContainerItem.UnitID                       AS UnitID
                          , AnalysisContainerItem.GoodsId                      AS GoodsId

                          , SUM(AnalysisContainerItem.AmountIncome)            AS AmountIncome             -- ������
                          , SUM(AnalysisContainerItem.AmountIncomeSumWith)     AS AmountIncomeSumWith
                          , SUM(AnalysisContainerItem.AmountIncomeSum)         AS AmountIncomeSum

                          , SUM(AnalysisContainerItem.AmountReturnOut)         AS AmountReturnOut          -- ������� ����������
                          , SUM(AnalysisContainerItem.AmountReturnOutSum)      AS AmountReturnOutSum

                          , SUM(AnalysisContainerItem.AmountCheck)             AS AmountCheck              -- �������� ���
                          , SUM(AnalysisContainerItem.AmountCheckSumJuridical) AS AmountCheckSumJuridical
                          , SUM(AnalysisContainerItem.AmountCheckSum)          AS AmountCheckSum

                          , SUM(AnalysisContainerItem.AmountSale)              AS AmountSale               -- �������
                          , SUM(AnalysisContainerItem.AmountSaleSumJuridical)  AS AmountSaleSumJuridical
                          , SUM(AnalysisContainerItem.AmountSaleSum)           AS AmountSaleSum

                          , SUM(AnalysisContainerItem.AmountReturnIn)          AS AmountReturnIn           -- ������� �����������
                          , SUM(AnalysisContainerItem.AmountReturnInSum)       AS AmountReturnInSum

                          , SUM(AnalysisContainerItem.AmountInventory)         AS AmountInventory          -- ��������
                          , SUM(AnalysisContainerItem.AmountInventorySum)      AS AmountInventorySum

                          , SUM(AnalysisContainerItem.AmountLoss)              AS AmountLoss               -- ��������
                          , SUM(AnalysisContainerItem.AmountLossSum)           AS AmountLossSum

                          , SUM(AnalysisContainerItem.AmountSend)              AS AmountSend               -- �����������
                          , SUM(AnalysisContainerItem.AmountSendSum)           AS AmountSendSum

                          , SUM(AnalysisContainerItem.Saldo)                   AS Saldo
                          , SUM(AnalysisContainerItem.SaldoSum)                AS Summa

                          , Count(*)                                           AS CountItem
                        FROM AnalysisContainerItem AS AnalysisContainerItem
                        WHERE AnalysisContainerItem.Operdate >= vbStartDate
                          AND AnalysisContainerItem.Operdate <= vbEndDate
                        GROUP BY AnalysisContainerItem.UnitID, AnalysisContainerItem.GoodsId
                        )

  , tmpGoodsChecked AS (SELECT DISTINCT Object_Goods_Main.ObjectCode  AS GoodsId
                        FROM Movement
                          INNER JOIN MovementItem AS MI_Goods
                                                  ON MI_Goods.MovementId = Movement.Id
                                                 AND MI_Goods.DescId = zc_MI_Master()
                                                 AND MI_Goods.isErased = FALSE
                          INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                         ON MIBoolean_Checked.MovementItemId = MI_Goods.Id
                                                        AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                        AND MIBoolean_Checked.ValueData = TRUE
                          INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MI_Goods.ObjectId
                          INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                        WHERE Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.DescId = zc_Movement_Promo()
                        )


    SELECT
        Object_Parent.ValueData              AS ParentName
      , Object_Unit.ValueData                AS UnitName

      , Object_Goods_Main.ObjectCode         AS GoodsId
      , Object_Goods_Main.Name               AS GoodsName

      , (tmpContainer.Saldo - COALESCE(tmpSaldoOut.Saldo, 0) -
           COALESCE(tmpMovement.Saldo, 0))::TFloat    AS SaldoIn
      , (tmpContainer.Summa - COALESCE(tmpSaldoOut.Summa, 0) -
           COALESCE(tmpMovement.Summa, 0))::TFloat    AS SummaIn

      , tmpMovement.AmountIncome::TFloat             AS AmountIncome       -- ������
      , tmpMovement.AmountIncomeSumWith::TFloat      AS AmountIncomeSumWith
      , tmpMovement.AmountIncomeSum::TFloat          AS AmountIncomeSum

      , tmpMovement.AmountReturnOut::TFloat          AS AmountReturnOut   -- ������� ����������
      , tmpMovement.AmountReturnOutSum::TFloat       AS AmountReturnOutSum

      , tmpMovement.AmountCheck::TFloat              AS AmountCheck       -- �������� ���
      , tmpMovement.AmountCheckSumJuridical::TFloat  AS AmountCheckSumJuridical
      , tmpMovement.AmountCheckSum::TFloat           AS AmountCheckSum

      , tmpMovement.AmountSale::TFloat               AS AmountSale        -- �������
      , tmpMovement.AmountSaleSumJuridical::TFloat   AS AmountSaleSumJuridical
      , tmpMovement.AmountSaleSum::TFloat            AS AmountSaleSum

      , tmpMovement.AmountReturnIn::TFloat           AS AmountReturnIn        -- ������� �����������
      , tmpMovement.AmountReturnInSum::TFloat        AS AmountReturnInSum

      , tmpMovement.AmountInventory::TFloat          AS AmountInventory   -- ��������
      , tmpMovement.AmountInventorySum::TFloat       AS AmountInventorySum

      , tmpMovement.AmountLoss::TFloat               AS AmountLoss        -- ��������
      , tmpMovement.AmountLossSum::TFloat            AS AmountLossSum

      , tmpMovement.AmountSend::TFloat               AS AmountSend        -- �����������
      , tmpMovement.AmountSendSum::TFloat            AS AmountSendSum

      , (tmpContainer.Saldo - COALESCE(tmpSaldoOut.Saldo, 0))::TFloat    AS SaldoOut
      , (tmpContainer.Summa - COALESCE(tmpSaldoOut.Summa, 0))::TFloat    AS SummaOut

      , CASE WHEN tmpGoodsChecked.GoodsId IS NOT NULL THEN TRUE ELSE FALSE END  ::Boolean  AS isChecked
      , CASE WHEN tmpGoodsChecked.GoodsId IS NULL     THEN TRUE ELSE FALSE END  ::Boolean  AS isReport
    FROM tmpContainer as tmpContainer

        LEFT JOIN tmpSaldoOut AS tmpSaldoOut
                              ON tmpSaldoOut.UnitID = tmpContainer.UnitID
                             AND tmpSaldoOut.GoodsId = tmpContainer.GoodsId

        LEFT JOIN tmContainerItem AS tmpMovement
                                  ON tmpMovement.UnitID = tmpContainer.UnitID
                                 AND tmpMovement.GoodsId = tmpContainer.GoodsId

        INNER JOIN Object AS Object_Unit  ON Object_Unit.Id  = tmpContainer.UnitID

        INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpContainer.GoodsId
        INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent
                         ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

        LEFT JOIN tmpGoodsChecked ON tmpGoodsChecked.GoodsId = Object_Goods_Main.ObjectCode

    WHERE COALESCE(tmpMovement.CountItem, tmpContainer.Saldo - COALESCE(tmpSaldoOut.Saldo, 0)) <> 0
    ORDER BY Object_Goods_Main.ObjectCode, Object_Goods_Main.Name, Object_Unit.ValueData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
             ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 07.01.20                                                      *
 12.11.18       *
 24.05.18                                                      *
*/

-- ����
--
select * from gpReport_IncomeConsumptionBalanceData(inStartDate := ('01.01.2021')::TDateTime , inEndDate := ('30.01.2021')::TDateTime , inSession := '3');