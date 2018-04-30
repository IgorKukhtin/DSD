-- Function:  gpReport_SaleReturnIn()

DROP FUNCTION IF EXISTS gpReport_SaleReturnIn_BarCode (TDateTime,TDateTime,Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_SaleReturnIn_BarCode (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (PartionId             Integer
             , BrandName             VarChar (100)
             , PeriodName            VarChar (25)
             , PeriodYear            Integer
             , PartnerId             Integer
             , PartnerName           VarChar (100)

             , GoodsGroupNameFull    TVarChar
             , GoodsGroupName        TVarChar
             , LabelName             VarChar (100)
             , GoodsId               Integer
             , GoodsCode             Integer
             , GoodsName           TVarChar
             , BarCode_item          TVarChar
             , GoodsInfoName         TVarChar
             , LineFabricaName       TVarChar
             , GoodsSizeId           Integer
             , GoodsSizeName         VarChar (25)
             , MeasureName           TVarChar

             , UnitName              VarChar (100)
             , ClientName            VarChar (100)
             , DiscountSaleKindName  VarChar (15)
             , ChangePercent         TFloat

             , OperPriceList         TFloat

             , Debt_Amount           TFloat -- ост. долг
             , Sale_Amount           TFloat -- Кол-во прод.
             , Sale_Summ             TFloat -- сумма продажи
             , Sale_Summ_prof        TFloat -- Сумма прибыль
             , Sale_Summ_10100       TFloat -- Сумма без скидки
             , Sale_Summ_10201       TFloat -- Сезонная скидка
             , Sale_Summ_10202       TFloat -- Скидка outlet
             , Sale_Summ_10203       TFloat -- Скидка клиента
             , Sale_Summ_10204       TFloat -- Доп. скидка
             , Sale_Summ_10200       TFloat -- итого сумма скидки
             
             , Return_Amount         TFloat
             , Return_Summ           TFloat
             , Return_Summ_10200     TFloat

  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- проверка может ли смотреть любой магазин, или только свой
    PERFORM lpCheckUnit_byUser (inUnitId_by:= inUnitId, inUserId:= vbUserId);


    -- Результат
    RETURN QUERY

        -- результат
        SELECT tmpData.PartionId
             , tmpData.BrandName
             , tmpData.PeriodName
             , tmpData.PeriodYear
             , tmpData.PartnerId
             , tmpData.PartnerName

             , tmpData.GoodsGroupNameFull
             , tmpData.GoodsGroupName
             , tmpData.LabelName

             , tmpData.GoodsId       
             , tmpData.GoodsCode     
             , tmpData.GoodsName
             , tmpData.BarCode_item  
             , tmpData.GoodsInfoName 
             , tmpData.LineFabricaName       
             , tmpData.GoodsSizeId   
             , tmpData.GoodsSizeName 
             , tmpData.MeasureName   

             , tmpData.UnitName      
             , tmpData.ClientName    
             , tmpData.DiscountSaleKindName
             , tmpData.ChangePercent

             , tmpData.OperPriceList

             , tmpData.Debt_Amount         
             , tmpData.Sale_Amount
             , tmpData.Sale_Summ
             , tmpData.Sale_Summ_prof       
             , tmpData.Sale_Summ_10100      
             , tmpData.Sale_Summ_10201      
             , tmpData.Sale_Summ_10202      
             , tmpData.Sale_Summ_10203      
             , tmpData.Sale_Summ_10204      
             , tmpData.Sale_Summ_10200      

             , 0 :: TFloat AS Return_Amount
             , 0 :: TFloat AS Return_Summ
             , 0 :: TFloat AS Return_Summ_10200
             

        FROM gpReport_Sale (inStartDate := inStartDate, inEndDate := inEndDate, inUnitId := inUnitId
                          , inClientId := 0, inPartnerId := 0, inBrandId := 0, inPeriodId := 0
                          , inStartYear := 0, inEndYear := 0, inisPartion := FALSE 
                          , inisSize := TRUE, inisSizeStr := False, inisPartner := TRUE , inisMovement := FALSE
                          , inIsClient := FALSE, inSession := inSession
                          ) AS tmpData
      UNION 
        SELECT tmpData.PartionId
             , tmpData.BrandName
             , tmpData.PeriodName
             , tmpData.PeriodYear
             , tmpData.PartnerId
             , tmpData.PartnerName

             , tmpData.GoodsGroupNameFull
             , tmpData.GoodsGroupName
             , tmpData.LabelName

             , tmpData.GoodsId       
             , tmpData.GoodsCode     
             , tmpData.GoodsName
             , tmpData.BarCode_item  
             , tmpData.GoodsInfoName 
             , tmpData.LineFabricaName       
             , tmpData.GoodsSizeId   
             , tmpData.GoodsSizeName 
             , tmpData.MeasureName   

             , tmpData.UnitName      
             , tmpData.ClientName    
             , tmpData.DiscountSaleKindName
             , tmpData.ChangePercent

             , tmpData.OperPriceList

             , tmpData.Debt_Amount         
             , 0 :: TFloat AS Sale_Amount
             , 0 :: TFloat AS Sale_Summ
             , 0 :: TFloat AS Sale_Summ_prof       
             , 0 :: TFloat AS Sale_Summ_10100      
             , 0 :: TFloat AS Sale_Summ_10201      
             , 0 :: TFloat AS Sale_Summ_10202      
             , 0 :: TFloat AS Sale_Summ_10203      
             , 0 :: TFloat AS Sale_Summ_10204      
             , 0 :: TFloat AS Sale_Summ_10200      

             , tmpData.Return_Amount        :: TFloat
             , tmpData.Return_Summ          :: TFloat
             , tmpData.Return_Summ_10200    :: TFloat

        FROM gpReport_ReturnIn (inStartDate := inStartDate, inEndDate := inEndDate, inUnitId := inUnitId
                              , inClientId := 0, inPartnerId := 0, inBrandId := 0, inPeriodId := 0
                              , inStartYear := 0, inEndYear := 0, inisPartion := FALSE 
                              , inisSize := TRUE, inisPartner := TRUE , inisMovement := FALSE
                              , inIsClient := FALSE,  inSession := inSession
                              ) AS tmpData

           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 27.04.18         *
*/

-- тест
-- SELECT * FROM gpReport_SaleReturnIn_BarCode (inStartDate:= '01.04.2018', inEndDate:= '30.04.2018', inUnitId:= 1601, inSession:= '6');
