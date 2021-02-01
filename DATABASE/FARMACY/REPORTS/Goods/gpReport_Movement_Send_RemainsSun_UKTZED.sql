-- Function: gpReport_Movement_Send_RemainsSun_UKTZED

DROP FUNCTION IF EXISTS  gpReport_Movement_Send_RemainsSun_UKTZED(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Send_RemainsSun_UKTZED(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitId_From Integer, UnitName_From TVarChar

             , UnitId_To Integer, UnitName_To TVarChar
             , Amount TFloat
             , Summa_From TFloat
             , Summa_To TFloat

             , MCS TFloat
             , AmountRemains TFloat
             , AmountSalesDay TFloat
             , AverageSales TFloat
             , StockRatio TFloat

             , MCS_From TFloat
             , AmountRemains_From TFloat
             , AmountSalesDey_From TFloat
             , AmountSalesMonth_From TFloat
             , AverageSalesMonth_From TFloat
             , Need_From TFloat
             , Delt_From TFloat

             , MCS_To TFloat
             , AmountRemains_To TFloat
             , AmountSalesDey_To TFloat
             , AmountSalesMonth_To TFloat
             , AverageSalesMonth_To TFloat
             , Need_To TFloat
             , Delta_To TFloat
              )
AS
$BODY$
  DECLARE vbUserId     Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;
     
    RETURN QUERY    
    SELECT
           Result.GoodsId
         , Result.GoodsCode
         , Result.GoodsName
         , Result.UnitId_From 
         , Result.UnitName_From 

         , Result.UnitId_To 
         , Result.UnitName_To 
         , Result.Amount 
         , Round(Result.Amount * Result.Price_From, 2)::TFloat 
         , Round(Result.Amount * Result.Price_To, 2)::TFloat 


         , Result.MCS 
         , Result.AmountRemains 
         , Result.AmountSalesDay 
         , Result.AverageSales 
         , Result.StockRatio 

         , Result.MCS_From 
         , Result.AmountRemains_From 
         , Result.AmountSalesDey_From 
         , Result.AmountSalesMonth_From 
         , Result.AverageSalesMonth_From 
         , Result.Need_From 
         , Result.Delt_From 

         , Result.MCS_To 
         , Result.AmountRemains_To 
         , Result.AmountSalesDey_To 
         , Result.AmountSalesMonth_To 
         , Result.AverageSalesMonth_To 
         , Result.Need_To 
         , Result.Delta_To  
    FROM lpInsert_Movement_Send_RemainsSun_UKTZED(inOperDate, 0, vbUserId) AS Result;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ 0.�.
 17.06.20                                                     *
*/

-- SELECT * FROM gpReport_Movement_Send_RemainsSun_UKTZED (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inSession:= '3');

SELECT * FROM gpReport_Movement_Send_RemainsSun_UKTZED (inOperDate:= CURRENT_DATE + INTERVAL '2 DAY', inSession:= '3');
