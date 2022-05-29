-- Function: gpReport_Movement_Send_RemainsSun_Supplement

DROP FUNCTION IF EXISTS  gpReport_Movement_Send_RemainsSun_Supplement(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Send_RemainsSun_Supplement(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, isClose boolean
             , UnitId_From Integer, UnitName_From TVarChar

             , UnitId_To Integer, UnitName_To TVarChar
             , Amount TFloat
             , Summa_From TFloat
             , Summa_To TFloat
             , MinExpirationDate TDateTime

             , MCS TFloat
             , AmountRemains TFloat
             , AmountSalesDay TFloat
             , AverageSales TFloat
             , StockRatio TFloat

             , MCS_From TFloat
             , isCloseMCS_From boolean
             , Layout_From TFloat
             , PromoUnit_From TFloat
             , AmountRemains_From TFloat
             , AmountSalesDey_From TFloat
             , AmountSalesMonth_From TFloat
             , AverageSalesMonth_From TFloat
             , Need_From TFloat
             , Delt_From TFloat

             , MCS_To TFloat
             , isCloseMCS_To boolean
             , AmountRemains_To TFloat
             , AmountSalesDey_To TFloat
             , AmountSalesMonth_To TFloat
             , AverageSalesMonth_To TFloat
             , Need_To TFloat
             , Delta_To TFloat
             , InvNumberLayout TVarChar
             , LayoutName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;
     
    RETURN QUERY    
    SELECT
           Result.GoodsId
         , Result.GoodsCode
         , Result.GoodsName
         , Result.isClose
         , Result.UnitId_From 
         , Result.UnitName_From 

         , Result.UnitId_To 
         , Result.UnitName_To 
         , Result.Amount 
         , Round(Result.Amount * Result.Price_From, 2)::TFloat 
         , Round(Result.Amount * Result.Price_To, 2)::TFloat 
         , Result.MinExpirationDate


         , Result.MCS 
         , Result.AmountRemains 
         , Result.AmountSalesDay 
         , Result.AverageSales 
         , Result.StockRatio 

         , Result.MCS_From 
         , Result.isCloseMCS_From
         , Result.Layout_From
         , Result.PromoUnit_From
         , Result.AmountRemains_From 
         , Result.AmountSalesDey_From 
         , Result.AmountSalesMonth_From 
         , Result.AverageSalesMonth_From 
         , Result.Need_From 
         , Result.Delt_From 

         , Result.MCS_To 
         , Result.isCloseMCS_To
         , Result.AmountRemains_To 
         , Result.AmountSalesDey_To 
         , Result.AmountSalesMonth_To 
         , Result.AverageSalesMonth_To 
         , Result.Need_To 
         , Result.Delta_To  
         , Result.InvNumberLayout
         , Result.LayoutName
    FROM lpInsert_Movement_Send_RemainsSun_Supplement(inOperDate, 0, vbUserId) AS Result;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий 0.В.
 26.03.21                                                       *
 17.06.20                                                       *
*/

-- SELECT * FROM gpReport_Movement_Send_RemainsSun_Supplement (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inSession:= '3');

SELECT * FROM gpReport_Movement_Send_RemainsSun_Supplement (inOperDate:= ('11.04.2021')::TDateTime, inSession:= '3');