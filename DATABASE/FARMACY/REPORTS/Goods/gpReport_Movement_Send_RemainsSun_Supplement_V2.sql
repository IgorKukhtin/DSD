-- Function: gpReport_Movement_Send_RemainsSun_Supplement_V2

DROP FUNCTION IF EXISTS  gpReport_Movement_Send_RemainsSun_Supplement_V2(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Send_RemainsSun_Supplement_V2(
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

             , MCS_From TFloat
             , isCloseMCS_From boolean
             , Layout_From TFloat
             , PromoUnit_From TFloat
             , AmountRemains_From TFloat
             , AmountSalesDey_From TFloat
             , Give_From TFloat

             , MCS_To TFloat
             , isCloseMCS_To boolean
             , AmountRemains_To TFloat
             , AmountSalesDey_To TFloat
             , Need_To TFloat
             , InvNumberLayout TVarChar
             , LayoutName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
     
    IF EXISTS (SELECT Object_Goods_Retail.ID
                    , Object_Goods_Retail.KoeffSUN_V2
               FROM Object_Goods_Retail
                    INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                AND Object_Goods_Main.isSupplementSUN2 = TRUE
               WHERE Object_Goods_Retail.RetailID = vbObjectId)     
    THEN
    
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

           , Result.MCS_From 
           , Result.isCloseMCS_From
           , Result.Layout_From
           , Result.PromoUnit_From
           , Result.AmountRemains_From 
           , Null::TFloat                AS AmountSalesDey_From 
           , Result.Give_From 

           , Result.MCS_To 
           , Result.isCloseMCS_To
           , Result.AmountRemains_To 
           , Null::TFloat                AS AmountSalesDey_To 
           , Result.Need_To 
           , Result.InvNumberLayout
           , Result.LayoutName
      FROM lpInsert_Movement_Send_RemainsSun_Supplement_V2_Sum(inOperDate, 0, vbUserId) AS Result;
    ELSE
     
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

           , Result.MCS_From 
           , Result.isCloseMCS_From
           , Result.Layout_From
           , Result.PromoUnit_From
           , Result.AmountRemains_From 
           , Result.AmountSalesDey_From 
           , Result.Give_From 

           , Result.MCS_To 
           , Result.isCloseMCS_To
           , Result.AmountRemains_To 
           , Result.AmountSalesDey_To 
           , Result.Need_To 
           , Result.InvNumberLayout
           , Result.LayoutName
      FROM lpInsert_Movement_Send_RemainsSun_Supplement_V2(inOperDate, 0, vbUserId) AS Result;
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий 0.В.
 26.03.21                                                       *
 17.06.20                                                       *
*/

-- SELECT * FROM gpReport_Movement_Send_RemainsSun_Supplement_V2 (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inSession:= '3');

SELECT * FROM gpReport_Movement_Send_RemainsSun_Supplement_V2 (inOperDate:= ('21.03.2022')::TDateTime, inSession:= '3');