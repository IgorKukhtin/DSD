-- Function: gpInsert_RemainsOLAPTable (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsert_RemainsOLAPTable (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_RemainsOLAPTable(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer,    --
    IN inSession            TVarChar 
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_RemainsOLAPTable());
   
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('_tmpReport'))
   THEN
        DELETE FROM _tmpReport;
   ELSE
        -- выбираем данные из отчета
        CREATE TEMP TABLE _tmpReport (OperDate            TDateTime
                                    , UnitId              Integer
                                    , GoodsId             Integer
                                    , GoodsKindId         Integer
                                    , AmountStart         TFloat
                                    , AmountEnd           TFloat
                                    , AmountIncome    TFloat
                                    , AmountReturnOut TFloat
                                    , AmountSendIn  TFloat
                                    , AmountSendOut TFloat
                                    , AmountSendOnPriceIn        TFloat
                                    , AmountSendOnPriceOut       TFloat
                                    , AmountSendOnPriceOut_10900 TFloat
                                    , AmountSendOnPrice_10500   TFloat
                                    , AmountSendOnPrice_40200   TFloat
                                    , AmountSale           TFloat
                                    , AmountSale_10500     TFloat
                                    , AmountSale_40208     TFloat
                                    , AmountSaleReal       TFloat
                                    , AmountSaleReal_10500 TFloat
                                    , AmountSaleReal_40208 TFloat
                                    , AmountReturnIn           TFloat
                                    , AmountReturnIn_40208     TFloat
                                    , AmountReturnInReal       TFloat
                                    , AmountReturnInReal_40208 TFloat
                                    , AmountLoss      TFloat
                                    , AmountInventory TFloat
                                    , AmountProductionIn  TFloat
                                    , AmountProductionOut TFloat) ON COMMIT DROP;
   END IF;


          INSERT INTO _tmpReport (OperDate, UnitId, GoodsId, GoodsKindId, AmountStart, AmountEnd, AmountIncome, AmountReturnOut, AmountSendIn, AmountSendOut
                                , AmountSendOnPriceIn, AmountSendOnPriceOut, AmountSendOnPriceOut_10900, AmountSendOnPrice_10500, AmountSendOnPrice_40200
                                , AmountSale, AmountSale_10500, AmountSale_40208, AmountSaleReal, AmountSaleReal_10500, AmountSaleReal_40208
                                , AmountReturnIn, AmountReturnIn_40208, AmountReturnInReal, AmountReturnInReal_40208
                                , AmountLoss, AmountInventory, AmountProductionIn, AmountProductionOut)
          WITH 
          tmpReport AS (SELECT *, MAX (tmp.CountStart) OVER (PARTITION BY tmp.GoodsId, tmp.GoodsKindId) AS CountStart_Calc
                        FROM lpReport_MotionGoodsCount_light (inStartDate:= inStartDate, inEndDate:= inEndDate, inLocationId := inUnitId , inUserId := vbUserId) as tmp
                       )
                       
        , tmpData AS (SELECT tmp.OperDate
                           , tmp.LocationId AS UnitId
                           , tmp.GoodsId
                           , tmp.GoodsKindId
                           , tmp.CountStart_Calc
                           , tmp.CountStart_Calc - SUM ( t1.Remains_Mov) AS CountEnd
                           , tmp.CountIncome
                           , tmp.CountReturnOut
                           , tmp.CountSendIn
                           , tmp.CountSendOut
                           , tmp.CountSendOnPriceIn
                           , tmp.CountSendOnPriceOut
                           , tmp.CountSendOnPriceOut_10900
                           , tmp.CountSendOnPrice_10500
                           , tmp.CountSendOnPrice_40200
                           , tmp.CountSale
                           , tmp.CountSale_10500
                           , tmp.CountSale_40208
                           , tmp.CountSaleReal
                           , tmp.CountSaleReal_10500
                           , tmp.CountSaleReal_40208
                           , tmp.CountReturnIn
                           , tmp.CountReturnIn_40208
                           , tmp.CountReturnInReal
                           , tmp.CountReturnInReal_40208
                           , tmp.CountLoss
                           , tmp.CountInventory
                           , tmp.CountProductionIn
                           , tmp.CountProductionOut                           
                      FROM tmpReport AS tmp
                           LEFT JOIN tmpReport AS t1 ON t1.GoodsId = tmp.GoodsId
                                              AND t1.GoodsKindId = tmp.GoodsKindId
                                              AND t1.OperDate <= tmp.OperDate
                      GROUP BY tmp.OperDate
                             , tmp.GoodsId
                             , tmp.GoodsKindId
                             , tmp.CountStart_Calc
                             , tmp.CountIncome
                             , tmp.CountReturnOut
                             , tmp.CountSendIn
                             , tmp.CountSendOut
                             , tmp.CountSendOnPriceIn
                             , tmp.CountSendOnPriceOut
                             , tmp.CountSendOnPriceOut_10900
                             , tmp.CountSendOnPrice_10500
                             , tmp.CountSendOnPrice_40200
                             , tmp.CountSale
                             , tmp.CountSale_10500
                             , tmp.CountSale_40208
                             , tmp.CountSaleReal
                             , tmp.CountSaleReal_10500
                             , tmp.CountSaleReal_40208
                             , tmp.CountReturnIn
                             , tmp.CountReturnIn_40208
                             , tmp.CountReturnInReal
                             , tmp.CountReturnInReal_40208
                             , tmp.CountLoss
                             , tmp.CountInventory
                             , tmp.CountProductionIn
                             , tmp.CountProductionOut
                             , tmp.LocationId
                             )

          SELECT tmp.OperDate                                      AS OperDate                  
               , tmp.UnitId                                        AS UnitId                    
               , tmp.GoodsId                                       AS GoodsId                   
               , tmp.GoodsKindId                                   AS GoodsKindId               
               , COALESCE (tmp2.CountEnd, tmp.CountStart_Calc ,0)  AS AmountStart               
               , tmp.CountEnd                                      AS AmountEnd                 
               , tmp.CountIncome                                   AS AmountIncome              
               , tmp.CountReturnOut                                AS AmountReturnOut           
               , tmp.CountSendIn                                   AS AmountSendIn              
               , tmp.CountSendOut                                  AS AmountSendOut             
               , tmp.CountSendOnPriceIn                            AS AmountSendOnPriceIn       
               , tmp.CountSendOnPriceOut                           AS AmountSendOnPriceOut      
               , tmp.CountSendOnPriceOut_10900                     AS AmountSendOnPriceOut_10900
               , tmp.CountSendOnPrice_10500                        AS AmountSendOnPrice_10500   
               , tmp.CountSendOnPrice_40200                        AS AmountSendOnPrice_40200   
               , tmp.CountSale                                     AS AmountSale                
               , tmp.CountSale_10500                               AS AmountSale_10500          
               , tmp.CountSale_40208                               AS AmountSale_40208          
               , tmp.CountSaleReal                                 AS AmountSaleReal            
               , tmp.CountSaleReal_10500                           AS AmountSaleReal_10500      
               , tmp.CountSaleReal_40208                           AS AmountSaleReal_40208      
               , tmp.CountReturnIn                                 AS AmountReturnIn            
               , tmp.CountReturnIn_40208                           AS AmountReturnIn_40208      
               , tmp.CountReturnInReal                             AS AmountReturnInReal        
               , tmp.CountReturnInReal_40208                       AS AmountReturnInReal_40208  
               , tmp.CountLoss                                     AS AmountLoss                
               , tmp.CountInventory                                AS AmountInventory           
               , tmp.CountProductionIn                             AS AmountProductionIn        
               , tmp.CountProductionOut                            AS AmountProductionOut       
          FROM tmpData AS tmp
               LEFT JOIN tmpData AS tmp2 ON tmp2.GoodsId = tmp.GoodsId
                                    AND tmp2.GoodsKindId = tmp.GoodsKindId
                                    AND tmp2.OperDate = tmp.OperDate - interval '1 Day'
          ORDER BY 1, 2, 3, 4;


          -- Обновляем те записи которые уже есть в таблице
          UPDATE RemainsOLAPTable
           SET OperDate                  = tmp.OperDate
             , UnitId                    = tmp.UnitId
             , GoodsId                   = tmp.GoodsId
             , GoodsKindId               = tmp.GoodsKindId
             , AmountStart               = tmp.AmountStart
             , AmountEnd                 = tmp.AmountEnd
             , AmountIncome              = tmp.AmountIncome
             , AmountReturnOut           = tmp.AmountReturnOut           
             , AmountSendIn              = tmp.AmountSendIn              
             , AmountSendOut             = tmp.AmountSendOut             
             , AmountSendOnPriceIn       = tmp.AmountSendOnPriceIn       
             , AmountSendOnPriceOut      = tmp.AmountSendOnPriceOut      
             , AmountSendOnPriceOut_10900= tmp.AmountSendOnPriceOut_10900
             , AmountSendOnPrice_10500   = tmp.AmountSendOnPrice_10500   
             , AmountSendOnPrice_40200   = tmp.AmountSendOnPrice_40200   
             , AmountSale                = tmp.AmountSale                
             , AmountSale_10500          = tmp.AmountSale_10500          
             , AmountSale_40208          = tmp.AmountSale_40208          
             , AmountSaleReal            = tmp.AmountSaleReal            
             , AmountSaleReal_10500      = tmp.AmountSaleReal_10500      
             , AmountSaleReal_40208      = tmp.AmountSaleReal_40208      
             , AmountReturnIn            = tmp.AmountReturnIn            
             , AmountReturnIn_40208      = tmp.AmountReturnIn_40208      
             , AmountReturnInReal        = tmp.AmountReturnInReal        
             , AmountReturnInReal_40208  = tmp.AmountReturnInReal_40208  
             , AmountLoss                = tmp.AmountLoss                
             , AmountInventory           = tmp.AmountInventory           
             , AmountProductionIn        = tmp.AmountProductionIn        
             , AmountProductionOut       = tmp.AmountProductionOut       
          FROM _tmpReport AS tmp
          WHERE tmp.GoodsId     = RemainsOLAPTable.GoodsId
            AND tmp.GoodsKindId = RemainsOLAPTable.GoodsKindId
            AND tmp.UnitId      = RemainsOLAPTable.UnitId
            AND tmp.OperDate    = RemainsOLAPTable.OperDate;
     
     -- добавляем новые строки
     INSERT INTO RemainsOLAPTable (OperDate, UnitId, GoodsId, GoodsKindId, AmountStart, AmountEnd, AmountIncome, AmountReturnOut, AmountSendIn, AmountSendOut
                                , AmountSendOnPriceIn, AmountSendOnPriceOut, AmountSendOnPriceOut_10900, AmountSendOnPrice_10500, AmountSendOnPrice_40200
                                , AmountSale, AmountSale_10500, AmountSale_40208, AmountSaleReal, AmountSaleReal_10500, AmountSaleReal_40208
                                , AmountReturnIn, AmountReturnIn_40208, AmountReturnInReal, AmountReturnInReal_40208
                                , AmountLoss, AmountInventory, AmountProductionIn, AmountProductionOut)
      SELECT tmp.OperDate
           , tmp.UnitId
           , tmp.GoodsId
           , tmp.GoodsKindId
           , tmp.AmountStart
           , tmp.AmountEnd
           , tmp.AmountIncome
           , tmp.AmountReturnOut           
           , tmp.AmountSendIn              
           , tmp.AmountSendOut             
           , tmp.AmountSendOnPriceIn       
           , tmp.AmountSendOnPriceOut
           , tmp.AmountSendOnPriceOut_10900
           , tmp.AmountSendOnPrice_10500
           , tmp.AmountSendOnPrice_40200
           , tmp.AmountSale
           , tmp.AmountSale_10500
           , tmp.AmountSale_40208
           , tmp.AmountSaleReal
           , tmp.AmountSaleReal_10500
           , tmp.AmountSaleReal_40208      
           , tmp.AmountReturnIn
           , tmp.AmountReturnIn_40208      
           , tmp.AmountReturnInReal        
           , tmp.AmountReturnInReal_40208  
           , tmp.AmountLoss                
           , tmp.AmountInventory           
           , tmp.AmountProductionIn        
           , tmp.AmountProductionOut
      FROM _tmpReport AS tmp
           LEFT JOIN RemainsOLAPTable ON tmp.GoodsId     = RemainsOLAPTable.GoodsId
                                     AND tmp.GoodsKindId = RemainsOLAPTable.GoodsKindId
                                     AND tmp.UnitId      = RemainsOLAPTable.UnitId
                                     AND tmp.OperDate    = RemainsOLAPTable.OperDate
      WHERE RemainsOLAPTable.GoodsId IS NULL
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.08.19         *
*/

-- тест
-- select * from RemainsOLAPTable where RemainsOLAPTable.OperDate = '02.08.2019'

--select * from gpInsert_RemainsOLAPTable('01.08.2019',  '03.08.2019', 8459, '3')