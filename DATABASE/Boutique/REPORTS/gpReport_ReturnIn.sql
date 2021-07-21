-- Function:  gpReport_ReturnIn()

DROP FUNCTION IF EXISTS gpReport_ReturnIn(TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ReturnIn (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inClientId         Integer  ,  -- Покупатель
    IN inPartnerId        Integer  ,  -- Поставщик
    IN inBrandId          Integer  ,  --
    IN inPeriodId         Integer  ,  --
    IN inStartYear        Integer  ,
    IN inEndYear          Integer  ,
    IN inisPartion        Boolean  , -- показывать партии
    IN inIsSize           Boolean  , -- показать Размеры (Да/Нет)
    IN inisPartner        Boolean  , -- показать по поставщикам
    IN inisMovement       Boolean  , -- показать по документам    
    IN inIsClient         Boolean  , -- показать Покупателя (Да/Нет)
    IN inSession          TVarChar   -- сессия пользователя
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
             , CompositionGroupName  TVarChar
             , CompositionName       TVarChar

             , GoodsId               Integer
             , GoodsCode             Integer
             , GoodsName             TVarChar
             , BarCode_item          TVarChar
             , GoodsInfoName         TVarChar
             , LineFabricaName       TVarChar
             , GoodsSizeId           Integer
             , GoodsSizeName         VarChar (25)
             , GoodsSizeName_real    TVarChar
             , MeasureName           TVarChar

             , UnitName              VarChar (100)
             , ClientName            VarChar (100)
             , DiscountSaleKindName  VarChar (15)
             , ChangePercent         TFloat
             , ChangePercentNext     TFloat

             , UnitName_In           VarChar (100)
             , CurrencyName          VarChar (10)

             , OperPrice             TFloat
             , OperPriceList         TFloat
             , Income_Amount         TFloat

             , Debt_Amount           TFloat

             , Return_Amount         TFloat
             , Return_Summ           TFloat
             , Return_SummCost       TFloat
             , Return_SummCost_diff  TFloat
             , Return_Summ_prof      TFloat
             , Return_Summ_10200     TFloat

             , DescName_Partion     TVarChar
             , OperDate_Partion     TDateTime
             , Invnumber_Partion    TVarChar

             , DescName_doc         TVarChar
             , OperDate_doc         TDateTime
             , InvNumber_doc        TVarChar

             , OperDate_Sale        TDateTime
             , Invnumber_Sale       TVarChar

             , OperDate_pay         TDateTime
             , Days_pay             TFloat

             , isChecked            Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!замена!!!
    IF inIsPartion = TRUE THEN
       inIsPartner:= TRUE;
       inIsSize   := TRUE;
    END IF;
    -- !!!замена!!!
    IF COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;

    -- Результат
    RETURN QUERY
      WITH tmpCurrency_all AS (SELECT Movement.Id                    AS MovementId
                                    , Movement.OperDate              AS OperDate
                                    , MovementItem.Id                AS MovementItemId
                                    , MovementItem.ObjectId          AS CurrencyFromId
                                    , MovementItem.Amount            AS Amount
                                    , CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END AS ParValue
                                    , MILinkObject_Currency.ObjectId AS CurrencyToId
                                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Currency.ObjectId ORDER BY Movement.OperDate, Movement.Id) AS Ord
                               FROM Movement
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                    INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                      ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                    LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                                ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                               AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                               WHERE Movement.DescId   = zc_Movement_Currency()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              )
         , tmpCurrency AS (SELECT tmpCurrency_all.OperDate                           AS StartDate
                                , COALESCE (tmpCurrency_next.OperDate, zc_DateEnd()) AS EndDate
                                , tmpCurrency_all.Amount
                                , tmpCurrency_all.ParValue
                                , tmpCurrency_all.CurrencyFromId
                                , tmpCurrency_all.CurrencyToId
                           FROM tmpCurrency_all
                                LEFT JOIN tmpCurrency_all AS tmpCurrency_next
                                                          ON tmpCurrency_next.CurrencyFromId = tmpCurrency_all.CurrencyFromId
                                                         AND tmpCurrency_next.CurrencyToId   = tmpCurrency_all.CurrencyToId
                                                         AND tmpCurrency_next.Ord            = tmpCurrency_all.Ord + 1
                          )

         , tmpDiscountPeriod AS (SELECT ObjectLink_DiscountPeriod_Period.ChildObjectId AS PeriodId
                                      , ObjectDate_StartDate.ValueData                 AS StartDate
                                      , ObjectDate_EndDate.ValueData                   AS EndDate
                                 FROM Object as Object_DiscountPeriod
                                      LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriod_Period
                                                           ON ObjectLink_DiscountPeriod_Period.ObjectId = Object_DiscountPeriod.Id
                                                          AND ObjectLink_DiscountPeriod_Period.DescId = zc_ObjectLink_DiscountPeriod_Period()
   
                                      LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                           ON ObjectDate_StartDate.ObjectId = Object_DiscountPeriod.Id
                                                          AND ObjectDate_StartDate.DescId = zc_ObjectDate_DiscountPeriod_StartDate()
                          
                                      LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                                           ON ObjectDate_EndDate.ObjectId = Object_DiscountPeriod.Id
                                                          AND ObjectDate_EndDate.DescId = zc_ObjectDate_DiscountPeriod_EndDate()
   
                                 WHERE Object_DiscountPeriod.DescId = zc_Object_DiscountPeriod()
                                   AND Object_DiscountPeriod.isErased = FALSE
                                 )

         , tmpContainer AS (SELECT Container.Id         AS ContainerId
                                 , CLO_Client.ObjectId  AS ClientId
                            FROM Container
                                 INNER JOIN ContainerLinkObject AS CLO_Client
                                                                ON CLO_Client.ContainerId = Container.Id
                                                               AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                               AND (CLO_Client.ObjectId = inClientId OR inClientId = 0)
                            WHERE Container.DescId   = zc_Container_Count()
                              AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                           UNION ALL
                            SELECT Container.Id         AS ContainerId
                                 , 0                    AS ClientId
                            FROM Container
                            WHERE Container.DescId   = zc_Container_Summ()
                              AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                              AND Container.ObjectId = zc_Enum_Account_100301 () -- прибыль текущего периода
                           )
         , tmpData_all AS (SELECT Object_PartionGoods.MovementItemId AS PartionId
                                , Object_PartionGoods.MovementId     AS MovementId_Partion
                                , Object_PartionGoods.BrandId
                                , Object_PartionGoods.PeriodId
                                , Object_PartionGoods.PeriodYear
                                , Object_PartionGoods.PartnerId

                                , Object_PartionGoods.GoodsGroupId
                                , Object_PartionGoods.LabelId
                                , Object_PartionGoods.CompositionGroupId
                                , Object_PartionGoods.CompositionId

                                , Object_PartionGoods.GoodsId
                                , Object_PartionGoods.GoodsInfoId
                                , Object_PartionGoods.LineFabricaId
                                , Object_PartionGoods.GoodsSizeId
                                , Object_PartionGoods.MeasureId

                                , MIConatiner.ObjectExtId_Analyzer                                                   AS UnitId
                                , CASE WHEN inisMovement = TRUE THEN MIConatiner.OperDate ELSE NULL :: TDateTime END AS OperDate_doc
                                , CASE WHEN inisMovement = TRUE THEN MIConatiner.MovementId ELSE 0 END               AS MovementId_doc
                                , CASE WHEN inIsClient   = TRUE THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() THEN MIConatiner.WhereObjectId_Analyzer ELSE tmpContainer.ClientId END ELSE NULL :: Integer END AS ClientId

                                , CASE WHEN inisMovement = TRUE THEN Movement_Sale.OperDate ELSE NULL :: TDateTime END       AS OperDate_Sale
                                , CASE WHEN inisMovement = TRUE THEN Movement_Sale.Invnumber ELSE '' END                     AS Invnumber_Sale

                                , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                                , COALESCE (MIFloat_ChangePercentNext.ValueData, 0)     AS ChangePercentNext
                                , COALESCE (MILinkObject_DiscountSaleKind.ObjectId, 0)  AS DiscountSaleKindId

                                , Object_PartionGoods.UnitId     AS UnitId_in
                                , Object_PartionGoods.CurrencyId AS CurrencyId
                                , Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END                   :: TFloat  AS OperPrice
                                , (COALESCE (MIFloat_OperPriceList.ValueData, 0) / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END) :: TFloat  AS OperPriceList
                                  -- Кол-во Приход от поставщика - только для UnitId
                                , Object_PartionGoods.Amount AS Income_Amount

                                  -- Кол-во: Долг
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() THEN MIConatiner.Amount ELSE 0 END) AS Debt_Amount

                                  -- Кол-во: Только Возврат
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Return_Amount
                                  -- С\с возврат - calc
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount
                                     * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                     * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                     / CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                       ELSE 0 END) :: TFloat AS Return_SummCost_calc
                                  -- Сумма возврат
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_ReturnSumm_10501(), zc_Enum_AnalyzerId_ReturnSumm_10502()) AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Return_Summ
                                  -- С\с возврат
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10600() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN -1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Return_SummCost
                                  -- Скидка возврат
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10502() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN -1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Return_Summ_10200

                                  -- Кол-во: Продажа - Возврат
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END
                                     - CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END
                                      ) :: TFloat AS Result_Amount

                                  --  № п/п
                                , ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId ORDER BY CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC) AS Ord

                                , COALESCE (MIBoolean_Checked.ValueData, FALSE)         AS isChecked
                                , MIString_BarCode.ValueData                            AS BarCode_item
                                
                                , MAX (CASE WHEN MIContainer_PartionMI.OperDate IS NOT NULL
                                            THEN MIContainer_PartionMI.OperDate
                                       ELSE zc_DateStart()
                                       END ) :: TDateTime AS OperDate_pay
                                 
                           FROM Object_PartionGoods

                                LEFT JOIN MovementItemContainer AS MIConatiner
                                                                ON MIConatiner.PartionId = Object_PartionGoods.MovementItemId
                                                               AND (MIConatiner.OperDate BETWEEN inStartDate AND inEndDate)

                                LEFT JOIN tmpContainer ON tmpContainer.ContainerId = MIConatiner.ContainerId
                                LEFT JOIN tmpCurrency  ON tmpCurrency.CurrencyFromId = zc_Currency_Basis()
                                                      AND tmpCurrency.CurrencyToId   = Object_PartionGoods.CurrencyId
                                                      AND MIConatiner.OperDate       >= tmpCurrency.StartDate
                                                      AND MIConatiner.OperDate       <  tmpCurrency.EndDate

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                                 ON MILinkObject_PartionMI.MovementItemId = MIConatiner.MovementItemId
                                                                AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                                LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId

                                LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode
                                LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MI_Sale.MovementId

                                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                           AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                                            ON MIFloat_ChangePercentNext.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                           AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                                 ON MILinkObject_DiscountSaleKind.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                                AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()

                                LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                              ON MIBoolean_Checked.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                             AND MIBoolean_Checked.DescId         = zc_MIBoolean_Checked()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                           AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                                LEFT JOIN tmpDiscountPeriod ON tmpDiscountPeriod.PeriodId = Object_PartionGoods.PeriodId
                                                           AND MIConatiner.OperDate BETWEEN tmpDiscountPeriod.StartDate AND tmpDiscountPeriod.EndDate

                                LEFT JOIN MovementItemString AS MIString_BarCode
                                                             ON MIString_BarCode.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                            AND MIString_BarCode.DescId         = zc_MIString_BarCode()

                                LEFT JOIN ContainerLinkObject AS CLO_PartionMI
                                                              ON CLO_PartionMI.ObjectId = MILinkObject_PartionMI.ObjectId
                                                             AND CLO_PartionMI.DescId   = zc_ContainerLinkObject_PartionMI()
                                                             AND inisMovement = TRUE
                                LEFT JOIN MovementItemContainer AS MIContainer_PartionMI
                                                                ON MIContainer_PartionMI.ContainerId  = CLO_PartionMI.ContainerId
                                                               AND MIContainer_PartionMI.AnalyzerId   = zc_Enum_AnalyzerId_SaleCount_10100() -- Кол-во, реализация - Типы аналитик (проводки)
                                                               AND MIContainer_PartionMI.Amount       < 0
                                                               AND inisMovement = TRUE

                           WHERE (Object_PartionGoods.PartnerId  = inPartnerId        OR inPartnerId   = 0)
                             AND (Object_PartionGoods.BrandId    = inBrandId          OR inBrandId     = 0)
                             AND (Object_PartionGoods.PeriodId   = inPeriodId         OR inPeriodId    = 0)
                             AND (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                             AND (MIConatiner.ContainerId        > 0                  )
                             AND (tmpContainer.ContainerId       > 0                  OR MIConatiner.PartionId IS NULL)
                             AND MIConatiner.MovementDescId = zc_Movement_ReturnIn()
                             AND (inUnitId = MIConatiner.ObjectExtId_Analyzer OR inUnitId = 0)
                             AND (inClientId = 0 OR inClientId = CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() THEN MIConatiner.WhereObjectId_Analyzer ELSE tmpContainer.ClientId END )
                      
                           GROUP BY Object_PartionGoods.MovementItemId
                                  , Object_PartionGoods.MovementId
                                  , Object_PartionGoods.BrandId
                                  , Object_PartionGoods.PeriodId
                                  , Object_PartionGoods.PeriodYear
                                  , Object_PartionGoods.PartnerId

                                  , Object_PartionGoods.GoodsGroupId
                                  , Object_PartionGoods.LabelId
                                  , Object_PartionGoods.CompositionGroupId
                                  , Object_PartionGoods.CompositionId

                                  , Object_PartionGoods.GoodsId
                                  , Object_PartionGoods.GoodsInfoId
                                  , Object_PartionGoods.LineFabricaId
                                  , Object_PartionGoods.GoodsSizeId
                                  , Object_PartionGoods.MeasureId

                                  , MIConatiner.ObjectExtId_Analyzer
                                  , CASE WHEN inisMovement = TRUE THEN MIConatiner.OperDate ELSE NULL :: TDateTime END 
                                  , CASE WHEN inisMovement = TRUE THEN MIConatiner.MovementId ELSE 0 END
                                  , CASE WHEN inIsClient   = TRUE THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() THEN MIConatiner.WhereObjectId_Analyzer ELSE tmpContainer.ClientId END ELSE NULL :: Integer END
                                  , CASE WHEN inisMovement = TRUE THEN Movement_Sale.OperDate ELSE NULL :: TDateTime END
                                  , CASE WHEN inisMovement = TRUE THEN Movement_Sale.Invnumber ELSE '' END

                                  , MIFloat_ChangePercent.ValueData
                                  , MIFloat_ChangePercentNext.ValueData
                                  , MILinkObject_DiscountSaleKind.ObjectId

                                  , Object_PartionGoods.UnitId
                                  , Object_PartionGoods.CurrencyId
                                  , Object_PartionGoods.Amount
                                  , Object_PartionGoods.OperPrice
                                  , Object_PartionGoods.CountForPrice
                                  , COALESCE (MIBoolean_Checked.ValueData, FALSE)
                                  , COALESCE (MIFloat_OperPriceList.ValueData, 0)
                                  , MIString_BarCode.ValueData
                            HAVING (SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END) <> 0
                                  -- С\с возврат - calc
                                OR SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount
                                     * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                     * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                     / CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                       ELSE 0 END) <> 0
                                  -- Сумма возврат
                                OR SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_ReturnSumm_10501(), zc_Enum_AnalyzerId_ReturnSumm_10502()) AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END) <> 0
                                  -- С\с возврат
                                OR SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10600() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN -1 * MIConatiner.Amount ELSE 0 END) <> 0
                                  -- Скидка возврат
                                OR SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10502() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN -1 * MIConatiner.Amount ELSE 0 END) <> 0
                                    )
                          )

       , tmpData AS (SELECT CASE WHEN inisPartion = TRUE THEN tmpData_all.PartionId ELSE 0 END  AS PartionId
                          , CASE WHEN inisPartion = TRUE THEN tmpData_all.MovementId_Partion ELSE 0 END  AS MovementId_Partion
                          , tmpData_all.BrandId
                          , tmpData_all.PeriodId
                          , tmpData_all.PeriodYear
                          , tmpData_all.PartnerId

                          , tmpData_all.GoodsGroupId
                          , tmpData_all.LabelId
                          , tmpData_all.CompositionGroupId
                          , tmpData_all.CompositionId

                          , tmpData_all.GoodsId
                          , tmpData_all.GoodsInfoId
                          , tmpData_all.LineFabricaId
                          , CASE WHEN inIsSize  = TRUE THEN tmpData_all.GoodsSizeId ELSE 0 END     AS GoodsSizeId
                          , CASE WHEN inIsSize  = TRUE THEN Object_GoodsSize.ValueData ELSE '' END AS GoodsSizeName_real
                          , STRING_AGG (Object_GoodsSize.ValueData, ', ' ORDER BY CASE WHEN LENGTH (Object_GoodsSize.ValueData) = 1 THEN '0' ELSE '' END || Object_GoodsSize.ValueData)  AS GoodsSizeName

                          , tmpData_all.MeasureId

                          , tmpData_all.OperDate_doc
                          , tmpData_all.MovementId_doc
                          , tmpData_all.UnitId
                          , tmpData_all.ClientId
                          , tmpData_all.ChangePercent
                          , tmpData_all.ChangePercentNext
                          , tmpData_all.DiscountSaleKindId

                          , tmpData_all.OperDate_Sale
                          , tmpData_all.Invnumber_Sale
                          , tmpData_all.OperDate_pay

                          , tmpData_all.UnitId_in
                          , tmpData_all.CurrencyId

                          , tmpData_all.OperPrice
                          , tmpData_all.OperPriceList
                          , tmpData_all.isChecked
                          , tmpData_all.BarCode_item
                          , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.Income_Amount ELSE 0 END) AS Income_Amount

                          , SUM (tmpData_all.Debt_Amount)           AS Debt_Amount
                          , SUM (tmpData_all.Return_Amount)         AS Return_Amount
                          , SUM (tmpData_all.Return_Summ)           AS Return_Summ
                          , SUM (tmpData_all.Return_SummCost)       AS Return_SummCost
                          , SUM (tmpData_all.Return_SummCost_calc)  AS Return_SummCost_calc
                          , SUM (tmpData_all.Return_Summ_10200)     AS Return_Summ_10200
                          , SUM (tmpData_all.Result_Amount)         AS Result_Amount

                     FROM tmpData_all
                          LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = tmpData_all.GoodsSizeId
                     GROUP BY CASE WHEN inisPartion = TRUE THEN tmpData_all.PartionId ELSE 0 END
                            , CASE WHEN inisPartion = TRUE THEN tmpData_all.MovementId_Partion ELSE 0 END
                            , tmpData_all.BrandId
                            , tmpData_all.PeriodId
                            , tmpData_all.PeriodYear
                            , tmpData_all.PartnerId

                            , tmpData_all.GoodsGroupId
                            , tmpData_all.LabelId
                            , tmpData_all.CompositionGroupId
                            , tmpData_all.CompositionId

                            , tmpData_all.GoodsId
                            , tmpData_all.GoodsInfoId
                            , tmpData_all.LineFabricaId
                            , CASE WHEN inIsSize  = TRUE THEN tmpData_all.GoodsSizeId ELSE 0 END
                            , CASE WHEN inIsSize  = TRUE THEN Object_GoodsSize.ValueData ELSE '' END
                            , tmpData_all.MeasureId

                            , tmpData_all.OperDate_doc
                            , tmpData_all.MovementId_doc
                            , tmpData_all.UnitId
                            , tmpData_all.ClientId
                            , tmpData_all.ChangePercent
                            , tmpData_all.ChangePercentNext
                            , tmpData_all.DiscountSaleKindId
                            , tmpData_all.OperDate_Sale
                            , tmpData_all.Invnumber_Sale
                            , tmpData_all.OperDate_pay
                            , tmpData_all.UnitId_in
                            , tmpData_all.CurrencyId
                            , tmpData_all.OperPrice
                            , tmpData_all.OperPriceList
                            , tmpData_all.isChecked
                            , tmpData_all.BarCode_item
                    )


        -- Результат
        SELECT tmpData.PartionId
             , Object_Brand.ValueData    :: VarChar (100) AS BrandName
             , Object_Period.ValueData   :: VarChar (25)  AS PeriodName
             , tmpData.PeriodYear        :: Integer       AS PeriodYear
             , Object_Partner.Id                          AS PartnerId
             , Object_Partner.ValueData  :: VarChar (100) AS PartnerName

             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , Object_GoodsGroup.ValueData                AS GoodsGroupName
             , Object_Label.ValueData    :: VarChar (100) AS LabelName
             , Object_CompositionGroup.ValueData  AS CompositionGroupName
             , Object_Composition.ValueData       AS CompositionName

             , Object_Goods.Id                            AS GoodsId
             , Object_Goods.ObjectCode                    AS GoodsCode
             , Object_Goods.ValueData    :: TVarChar      AS GoodsName
             , tmpData.BarCode_item      :: TVarChar      AS BarCode_item
             , Object_GoodsInfo.ValueData                 AS GoodsInfoName
             , Object_LineFabrica.ValueData               AS LineFabricaName
             , tmpData.GoodsSizeId            AS GoodsSizeId
             , tmpData.GoodsSizeName       ::VarChar (25) AS GoodsSizeName
             , tmpData.GoodsSizeName_real  ::TVarChar     AS GoodsSizeName_real
             , Object_Measure.ValueData                   AS MeasureName

             , Object_Unit.ValueData        :: VarChar (100) AS UnitName
             , Object_Client.ValueData      :: VarChar (100) AS ClientName
             , Object_DiscountSaleKind.ValueData :: VarChar (15) AS DiscountSaleKindName
             , tmpData.ChangePercent        :: TFloat        AS ChangePercent
             , tmpData.ChangePercentNext    :: TFloat        AS ChangePercentNext
                                            
             , Object_Unit_In.ValueData     :: VarChar (100) AS UnitName_In
             , Object_Currency.ValueData    :: VarChar (10)  AS CurrencyName

             , tmpData.OperPrice            :: TFloat
             , tmpData.OperPriceList        :: TFloat
             , tmpData.Income_Amount        :: TFloat
                                            
             , tmpData.Debt_Amount          :: TFloat
                                            
             , tmpData.Return_Amount        :: TFloat
             , tmpData.Return_Summ          :: TFloat
             , tmpData.Return_SummCost_calc :: TFloat AS Return_SummCost_calc
             , (tmpData.Return_SummCost - tmpData.Return_SummCost_calc) :: TFloat AS Return_SummCost_diff
             , (tmpData.Return_Summ     - tmpData.Return_SummCost_calc) :: TFloat AS Return_Summ_prof
             , tmpData.Return_Summ_10200    :: TFloat
    
             , MovementDesc.ItemName          AS DescName_Partion
             , Movement.OperDate              AS OperDate_Partion
             , Movement.InvNumber             AS InvNumber_Partion

             , MovementDesc_Doc.ItemName          AS DescName_doc
             , Movement_Doc.OperDate              AS OperDate_doc
             , Movement_Doc.InvNumber             AS InvNumber_doc

             , tmpData.OperDate_Sale  :: TDateTime
             , tmpData.Invnumber_Sale :: TVarChar
             , CASE WHEN tmpData.OperDate_pay = zc_DateStart() THEN NULL ELSE tmpData.OperDate_pay END  :: TDateTime AS OperDate_pay
             
             , CASE WHEN tmpData.OperDate_pay = zc_DateStart() THEN 0 ELSE date_part('day', Movement_Doc.OperDate - tmpData.OperDate_pay) END :: TFloat AS Days_pay

             , tmpData.isChecked
        FROM tmpData
            --LEFT JOIN tmpDayOfWeek ON tmpDayOfWeek.Ord_dow = tmpData.OrdDay_doc

            LEFT JOIN Movement ON Movement.Id = tmpData.MovementId_Partion
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

            LEFT JOIN Movement AS Movement_doc ON Movement_doc.Id = tmpData.MovementId_doc
            LEFT JOIN MovementDesc AS MovementDesc_doc ON MovementDesc_doc.Id = Movement_doc.DescId

            LEFT JOIN Object AS Object_Client           ON Object_Client.Id           = tmpData.ClientId
            LEFT JOIN Object AS Object_Partner          ON Object_Partner.Id          = tmpData.PartnerId
            LEFT JOIN Object AS Object_Unit             ON Object_Unit.Id             = tmpData.UnitId
            LEFT JOIN Object AS Object_Unit_In          ON Object_Unit_In.Id          = tmpData.UnitId_in
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = tmpData.CurrencyId
            LEFT JOIN Object AS Object_DiscountSaleKind ON Object_DiscountSaleKind.Id = tmpData.DiscountSaleKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpData.LabelId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = tmpData.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpData.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = tmpData.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpData.LineFabricaId
            --LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpData.GoodsSizeId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = tmpData.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = tmpData.PeriodId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = tmpData.MeasureId

          ;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 22.01.19         *
 27.04.18         *
*/

-- тест
--select * from gpReport_ReturnIn(inStartDate := ('01.01.2017')::TDateTime , inEndDate := ('01.01.2017')::TDateTime , inUnitId := 1157 , inClientId := 0 , inPartnerId := 0 , inBrandId := 0 , inPeriodId := 0 , inStartYear := 0 , inEndYear := 0 , inisPartion := 'False' , inisSize := 'False' , inisPartner := 'False' , inisMovement := 'False' , inIsClient := 'False',  inSession := '2');