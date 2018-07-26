
-- Function:  gpReport_Sale()
DROP FUNCTION IF EXISTS gpReport_Sale_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Sale_Analysis (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inPartnerId        Integer  ,  -- Поставщик
    IN inBrandId          Integer  ,  --
    IN inPeriodId         Integer  ,  --
    IN inStartYear        Integer  ,
    IN inEndYear          Integer  ,
    IN inIsPeriodAll      Boolean  , -- ограничение за Весь период (Да/Нет) (движение по Документам)
    IN inisPartion        Boolean  , -- показывать партии
    IN inIsGoods          Boolean  , -- показать Товары (Да/Нет)
    IN inIsSize           Boolean  , -- показать Размеры детально(Да/Нет)
    IN inIsDiscount       Boolean  , -- показать % скидки (Да/Нет)
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE Cursor1       refcursor;
   DECLARE Cursor2       refcursor;
   DECLARE Cursor3       refcursor;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!замена!!!
    IF COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;


 CREATE TEMP TABLE _tmpData (PartionId             Integer
                           , BrandName             TVarChar
                           , PeriodName            TVarChar
                           , PeriodYear            Integer
                           , PartnerId             Integer
                           , PartnerName           TVarChar
              
                     /*      , GoodsGroupNameFull    TVarChar
                           , GoodsGroupName        TVarChar
                           , LabelName             TVarChar
                           , CompositionGroupName  TVarChar
                           , CompositionName       TVarChar
              
                           , GoodsId               Integer
                           , GoodsCode             Integer
                           , GoodsName             TVarChar
                           , BarCode_item          TVarChar
                           , GoodsInfoName         TVarChar
                           , LineFabricaName       TVarChar
                           , GoodsSizeId           Integer
                           , GoodsSizeName         TVarChar
                           , GoodsSizeName_real    TVarChar
                           , MeasureName           TVarChar
              */
                           , UnitName              TVarChar

                           , UnitName_In           TVarChar
                           , CurrencyName          TVarChar
              
                          -- , OperPrice             TFloat
                          -- , OperPriceList         TFloat
                           , Income_Amount         TFloat
              
                           , Debt_Amount           TFloat
                           , Sale_Amount           TFloat
                           , Sale_Summ             TFloat
                           , Sale_Summ_curr        TFloat
                           , Sale_SummCost         TFloat
                           , Sale_SummCost_curr    TFloat
                           , Sale_SummCost_diff    TFloat
                           , Sale_Summ_prof        TFloat
                           , Sale_Summ_prof_curr   TFloat
                           , Sale_Summ_10100       TFloat
                           , Sale_Summ_10201       TFloat
                           , Sale_Summ_10202       TFloat
                           , Sale_Summ_10203       TFloat
                           , Sale_Summ_10204       TFloat
                           , Sale_Summ_10200       TFloat
                           , Sale_Summ_10200_curr  TFloat
                           , Tax_Amount            TFloat
                           , Tax_Summ_curr         TFloat
                           , Tax_Summ_prof         TFloat               
              
                           , DescName_Partion     TVarChar
                           , OperDate_Partion     TDateTime
                           , Invnumber_Partion    TVarChar
                         ) ON COMMIT DROP;
                           
        INSERT INTO _tmpData (PartionId
                            , BrandName
                            , PeriodName
                            , PeriodYear
                            , PartnerId
                            , PartnerName
                          /*  , GoodsGroupNameFull
                            , GoodsGroupName
                            , LabelName
                            , CompositionGroupName
                            , CompositionName
                            , GoodsId
                            , GoodsCode
                            , GoodsName
                            , BarCode_item
                            , GoodsInfoName 
                            , LineFabricaName
                            , GoodsSizeId
                            , GoodsSizeName
                            , GoodsSizeName_real
                            , MeasureName
                            */
                            , UnitName
                            , UnitName_In
                            , CurrencyName
                            --, OperPrice
                            --, OperPriceList
                            , Income_Amount
                            , Debt_Amount
                            , Sale_Amount
                            , Sale_Summ
                            , Sale_Summ_curr
                            , Sale_SummCost
                            , Sale_SummCost_curr
                            , Sale_SummCost_diff
                            , Sale_Summ_prof
                            , Sale_Summ_prof_curr
                            , Sale_Summ_10100
                            , Sale_Summ_10201
                            , Sale_Summ_10202
                            , Sale_Summ_10203
                            , Sale_Summ_10204
                            , Sale_Summ_10200
                            , Sale_Summ_10200_curr
                            , Tax_Amount
                            , Tax_Summ_curr
                            , Tax_Summ_prof
                            , DescName_Partion
                            , OperDate_Partion
                            , Invnumber_Partion)
      WITH 
           tmpCurrency_all AS (SELECT Movement.Id                    AS MovementId
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
                            FROM Container
                            WHERE Container.DescId   = zc_Container_Count()
                              AND Container.WhereObjectId = inUnitId
                           UNION ALL
                            SELECT Container.Id         AS ContainerId
                            FROM Container
                            WHERE Container.DescId        = zc_Container_Summ()
                              AND Container.WhereObjectId = inUnitId
                              AND Container.ObjectId      = zc_Enum_Account_100301() -- прибыль текущего периода
                           )
         , tmpData_all AS (SELECT Object_PartionGoods.MovementItemId AS PartionId
                                , Object_PartionGoods.MovementId     AS MovementId_Partion
                                , Object_PartionGoods.BrandId
                                , Object_PartionGoods.PeriodId
                                , Object_PartionGoods.PeriodYear
                                , Object_PartionGoods.PartnerId

                               /* , Object_PartionGoods.GoodsGroupId
                                , Object_PartionGoods.LabelId
                                , Object_PartionGoods.CompositionGroupId
                                , Object_PartionGoods.CompositionId

                                , Object_PartionGoods.GoodsId
                                , Object_PartionGoods.GoodsInfoId
                                , Object_PartionGoods.LineFabricaId
                                , Object_PartionGoods.GoodsSizeId
                                , Object_PartionGoods.MeasureId
*/
                                , COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) :: Integer AS UnitId

                                , Object_PartionGoods.UnitId     AS UnitId_in
                                , Object_PartionGoods.CurrencyId AS CurrencyId
                                --, Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END                   :: TFloat  AS OperPrice
                                --, (COALESCE (MIFloat_OperPriceList.ValueData, 0) / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END) :: TFloat  AS OperPriceList
                                  -- Кол-во Приход от поставщика - только для UnitId
                                , Object_PartionGoods.Amount AS Income_Amount
                                , Object_PartionGoods.Amount * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS Income_Summ

                                  -- Кол-во: Долг
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() THEN MIConatiner.Amount ELSE 0 END) AS Debt_Amount

                                  -- Кол-во: Только Продажа
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Amount
                                  -- С\с продажа - calc из валюты в Грн
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN -1 * MIConatiner.Amount
                                                     * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                     * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                     / CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_SummCost_calc

                                  -- Сумма продажа
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN -1 * MIConatiner.Amount
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ
                                   -- переводим в валюту 
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN -1 * MIConatiner.Amount
                                                    / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                    * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                    -- !!!обнулили если нет КУРСА!!!
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ_curr

                                  -- С\с продажа - ГРН
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN  1 * MIConatiner.Amount
                                            ELSE 0
                                       END) :: TFloat AS Sale_SummCost
                                  -- С\с продажа - валюта
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN -1 * MIConatiner.Amount
                                                    * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_SummCost_curr

                                  -- Сумма Прайс
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10100
                                  -- Сезонная скидка
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10201() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10201
                                  -- Скидка outlet
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10202() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10202
                                  -- Скидка клиента
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10203() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10203
                                  -- скидка дополнительная
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10204() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10204

                                  -- Скидка ИТОГО
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN 1 * MIConatiner.Amount
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ_10200
                                   -- переводим в валюту 
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN 1 * MIConatiner.Amount
                                                    / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                    * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                    -- !!!обнулили если нет КУРСА!!!
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ_10200_curr

                                  --  № п/п
                                , ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId
                                                     ORDER BY /*CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() THEN 0 ELSE 1 END ASC
                                                            , */CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC
                                                    ) AS Ord

                                --, MIString_BarCode.ValueData                            AS BarCode_item
                           FROM Object_PartionGoods
                                LEFT JOIN MovementItemContainer AS MIConatiner
                                                                ON MIConatiner.PartionId = Object_PartionGoods.MovementItemId
                                                               AND (MIConatiner.OperDate BETWEEN inStartDate AND inEndDate
                                                                 OR inIsPeriodAll = TRUE)
                                                               
                                LEFT JOIN tmpContainer ON tmpContainer.ContainerId = MIConatiner.ContainerId
                                LEFT JOIN tmpCurrency  ON tmpCurrency.CurrencyFromId = zc_Currency_Basis()
                                                      AND tmpCurrency.CurrencyToId   = Object_PartionGoods.CurrencyId
                                                      AND MIConatiner.OperDate       >= tmpCurrency.StartDate
                                                      AND MIConatiner.OperDate       <  tmpCurrency.EndDate

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                                 ON MILinkObject_PartionMI.MovementItemId = MIConatiner.MovementItemId
                                                                AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                                LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                               /* LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                           AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                                           AND inIsDiscount                         = TRUE
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                                 ON MILinkObject_DiscountSaleKind.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                                AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()
                                                                AND inIsDiscount                                 = TRUE

                                LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                              ON MIBoolean_Checked.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                             AND MIBoolean_Checked.DescId         = zc_MIBoolean_Checked()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                           AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
*/
                                LEFT JOIN Movement ON Movement.Id = MIConatiner.MovementId

                           WHERE (Object_PartionGoods.PartnerId  = inPartnerId        OR inPartnerId   = 0)
                             AND (Object_PartionGoods.BrandId    = inBrandId          OR inBrandId     = 0)
                             AND (Object_PartionGoods.PeriodId   = inPeriodId         OR inPeriodId    = 0)
                             AND (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                             AND (MIConatiner.ContainerId        > 0                  )
                             AND (tmpContainer.ContainerId       > 0                  OR MIConatiner.PartionId IS NULL)
                             AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                             AND inUnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId)
                             --AND (inClientId = 0 OR inClientId = CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() THEN MIConatiner.WhereObjectId_Analyzer ELSE tmpContainer.ClientId END )
                      
                           GROUP BY Object_PartionGoods.MovementItemId
                                  , Object_PartionGoods.MovementId
                                  , Object_PartionGoods.BrandId
                                  , Object_PartionGoods.PeriodId
                                  , Object_PartionGoods.PeriodYear
                                  , Object_PartionGoods.PartnerId

                                /*  , Object_PartionGoods.GoodsGroupId
                                  , Object_PartionGoods.LabelId
                                  , Object_PartionGoods.CompositionGroupId
                                  , Object_PartionGoods.CompositionId

                                  , Object_PartionGoods.GoodsId
                                  , Object_PartionGoods.GoodsInfoId
                                  , Object_PartionGoods.LineFabricaId
                                  , Object_PartionGoods.GoodsSizeId
                                  , Object_PartionGoods.MeasureId
*/
                                  , MIConatiner.ObjectExtId_Analyzer

                               --   , MIFloat_ChangePercent.ValueData
                               --   , MILinkObject_DiscountSaleKind.ObjectId

                                  , Object_PartionGoods.UnitId
                                  , Object_PartionGoods.CurrencyId
                                  , Object_PartionGoods.Amount
                                 -- , Object_PartionGoods.OperPrice
                                 -- , Object_PartionGoods.CountForPrice
                                 -- , COALESCE (MIBoolean_Checked.ValueData, FALSE)
                                 -- , COALESCE (MIFloat_OperPriceList.ValueData, 0)
                                 -- , MIString_BarCode.ValueData

                            HAVING SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) =  zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) <> 0
                                OR SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) <> 0
                                  -- Кол-во: Долг
                                OR SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() THEN MIConatiner.Amount ELSE 0 END) <> 0
                                  -- Кол-во: Только Продажа
                                OR SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) <> 0
                          )
       , tmpData AS (SELECT CASE WHEN inisPartion = TRUE AND inIsSize = TRUE THEN tmpData_all.PartionId ELSE 0 END  AS PartionId
                          , CASE WHEN inisPartion = TRUE THEN tmpData_all.MovementId_Partion ELSE 0 END  AS MovementId_Partion
                          , tmpData_all.BrandId
                          , tmpData_all.PeriodId
                          , tmpData_all.PeriodYear
                          , tmpData_all.PartnerId

                       /*   , tmpData_all.GoodsGroupId
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
*/
                          , tmpData_all.UnitId
                        --  , tmpData_all.ChangePercent
                         -- , tmpData_all.DiscountSaleKindId

                          , tmpData_all.UnitId_in
                          , tmpData_all.CurrencyId

                        --  , tmpData_all.OperPrice
                       --   , tmpData_all.OperPriceList
                         -- , tmpData_all.isChecked
                         -- , tmpData_all.BarCode_item

                          , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.Income_Amount ELSE 0 END) AS Income_Amount
                          , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.Income_Summ   ELSE 0 END) AS Income_Summ
 
                          , SUM (tmpData_all.Debt_Amount)             AS Debt_Amount
                          , SUM (tmpData_all.Sale_Amount)             AS Sale_Amount
 
                            -- Сумма продажа
                          , SUM (tmpData_all.Sale_Summ)             AS Sale_Summ
                          , SUM (tmpData_all.Sale_Summ_curr)        AS Sale_Summ_curr
 
                            -- С\с продажа
                          , SUM (tmpData_all.Sale_SummCost_calc)    AS Sale_SummCost_calc -- calc из валюты в Грн
                          , SUM (tmpData_all.Sale_SummCost)         AS Sale_SummCost      -- ГРН
                          , SUM (tmpData_all.Sale_SummCost_curr)    AS Sale_SummCost_curr -- валюта
 
                          , SUM (tmpData_all.Sale_Summ_10100)       AS Sale_Summ_10100
                          , SUM (tmpData_all.Sale_Summ_10201)       AS Sale_Summ_10201
                          , SUM (tmpData_all.Sale_Summ_10202)       AS Sale_Summ_10202
                          , SUM (tmpData_all.Sale_Summ_10203)       AS Sale_Summ_10203
                          , SUM (tmpData_all.Sale_Summ_10204)       AS Sale_Summ_10204
 
                            -- Скидка ИТОГО
                          , SUM (tmpData_all.Sale_Summ_10200)       AS Sale_Summ_10200
                          , SUM (tmpData_all.Sale_Summ_10200_curr)  AS Sale_Summ_10200_curr

                     FROM tmpData_all
                         -- LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = tmpData_All.GoodsSizeId

                     GROUP BY CASE WHEN inisPartion = TRUE AND inIsSize = TRUE THEN tmpData_all.PartionId ELSE 0 END
                            , CASE WHEN inisPartion = TRUE THEN tmpData_all.MovementId_Partion ELSE 0 END
                            , tmpData_all.BrandId
                            , tmpData_all.PeriodId
                            , tmpData_all.PeriodYear
                            , tmpData_all.PartnerId

                          /*  , tmpData_all.GoodsGroupId
                            , tmpData_all.LabelId
                            , tmpData_all.CompositionGroupId
                            , tmpData_all.CompositionId

                            , tmpData_all.GoodsId
                            , tmpData_all.GoodsInfoId
                            , tmpData_all.LineFabricaId
                            , CASE WHEN inIsSize  = TRUE THEN tmpData_all.GoodsSizeId ELSE 0 END
                            , CASE WHEN inIsSize  = TRUE THEN Object_GoodsSize.ValueData ELSE '' END
                            , tmpData_all.MeasureId
*/
                            , tmpData_all.UnitId
                           -- , tmpData_all.ChangePercent
                            --, tmpData_all.DiscountSaleKindId

                            , tmpData_all.UnitId_in
                            , tmpData_all.CurrencyId
                            --, tmpData_all.OperPrice
                           -- , tmpData_all.OperPriceList
                            --, tmpData_all.isChecked
                           -- , tmpData_all.BarCode_item
                    )


        -- Результат
        SELECT tmpData.PartionId
             , Object_Brand.ValueData    :: TVarChar      AS BrandName
             , Object_Period.ValueData   :: TVarChar      AS PeriodName
             , tmpData.PeriodYear        :: Integer       AS PeriodYear
             , Object_Partner.Id                          AS PartnerId
             , Object_Partner.ValueData  :: TVarChar      AS PartnerName

             /*, ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , Object_GoodsGroup.ValueData                 AS GoodsGroupName
             , Object_Label.ValueData    :: TVarChar       AS LabelName
             , Object_CompositionGroup.ValueData           AS CompositionGroupName
             , Object_Composition.ValueData                AS CompositionName

             , Object_Goods.Id                             AS GoodsId
             , Object_Goods.ObjectCode                     AS GoodsCode
             , Object_Goods.ValueData    :: TVarChar       AS GoodsName
             , tmpData.BarCode_item      :: TVarChar       AS BarCode_item
             , Object_GoodsInfo.ValueData                  AS GoodsInfoName
             , Object_LineFabrica.ValueData                AS LineFabricaName
             , tmpData.GoodsSizeId                         AS GoodsSizeId
             , tmpData.GoodsSizeName      :: TVarChar      AS GoodsSizeName
             , tmpData.GoodsSizeName_real :: TVarChar      AS GoodsSizeName_real
             , Object_Measure.ValueData                    AS MeasureName
*/
             , Object_Unit.ValueData        :: TVarChar    AS UnitName
           --  , Object_DiscountSaleKind.ValueData :: TVarChar AS DiscountSaleKindName
           --  , tmpData.ChangePercent        :: TFloat        AS ChangePercent
                                            
             , Object_Unit_In.ValueData     :: TVarChar AS UnitName_In
             , Object_Currency.ValueData    :: TVarChar  AS CurrencyName

            -- , tmpData.OperPrice            :: TFloat
            -- , tmpData.OperPriceList        :: TFloat
             
             , tmpData.Income_Amount        :: TFloat
                                            
             , tmpData.Debt_Amount          :: TFloat
             , tmpData.Sale_Amount          :: TFloat

               -- Сумма продажа
             , tmpData.Sale_Summ            :: TFloat
             , tmpData.Sale_Summ_curr       :: TFloat
                                            
               -- С\с продажа
             , tmpData.Sale_SummCost_calc   :: TFloat AS Sale_SummCost      -- calc из валюты в Грн
             , tmpData.Sale_SummCost_curr   :: TFloat AS Sale_SummCost_curr -- валюта

             , (tmpData.Sale_SummCost - tmpData.Sale_SummCost_calc) :: TFloat AS Sale_SummCost_diff
             , (tmpData.Sale_Summ     - tmpData.Sale_SummCost_calc) :: TFloat AS Sale_Summ_prof
             , (tmpData.Sale_Summ_curr- tmpData.Sale_SummCost_curr) :: TFloat AS Sale_Summ_prof_curr

             , tmpData.Sale_Summ_10100      :: TFloat
             , tmpData.Sale_Summ_10201      :: TFloat
             , tmpData.Sale_Summ_10202      :: TFloat
             , tmpData.Sale_Summ_10203      :: TFloat
             , tmpData.Sale_Summ_10204      :: TFloat

               -- Скидка ИТОГО
             , tmpData.Sale_Summ_10200      :: TFloat
             , tmpData.Sale_Summ_10200_curr :: TFloat

               -- % кол-во продали    / кол-во приход
             , CASE WHEN tmpData.Sale_Amount > 0 AND tmpData.Income_Amount > 0
                         THEN tmpData.Sale_Amount / tmpData.Income_Amount * 100
                    ELSE 0
               END :: TFloat AS Tax_Amount

               -- % сумма с/с продали / сумма с/с приход
             , CASE WHEN tmpData.Sale_SummCost_curr > 0 AND tmpData.Income_Summ > 0
                         THEN tmpData.Sale_SummCost_curr / tmpData.Income_Summ * 100
                    ELSE 0
               END :: TFloat AS Tax_Summ_curr

               -- % сумма продажа     / сумма с/с
             , CASE WHEN tmpData.Sale_Summ_curr > 0 AND tmpData.Sale_SummCost_curr > 0
                         THEN tmpData.Sale_Summ_curr / tmpData.Sale_SummCost_curr * 100 - 100
                    ELSE 0
               END :: TFloat AS Tax_Summ_prof             

             , MovementDesc.ItemName          AS DescName_Partion
             , Movement.OperDate              AS OperDate_Partion
             , Movement.InvNumber             AS InvNumber_Partion

             --, tmpData.isChecked
        FROM tmpData
            LEFT JOIN Movement ON Movement.Id = tmpData.MovementId_Partion
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

           -- LEFT JOIN MovementDesc AS MovementDesc_doc ON MovementDesc_doc.Id = Movement_doc.DescId

            LEFT JOIN Object AS Object_Partner          ON Object_Partner.Id          = tmpData.PartnerId
            LEFT JOIN Object AS Object_Unit             ON Object_Unit.Id             = tmpData.UnitId
            LEFT JOIN Object AS Object_Unit_In          ON Object_Unit_In.Id          = tmpData.UnitId_in
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = tmpData.CurrencyId
          /*  LEFT JOIN Object AS Object_DiscountSaleKind ON Object_DiscountSaleKind.Id = tmpData.DiscountSaleKindId

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
          */  LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = tmpData.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = tmpData.PeriodId
         /*   LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = tmpData.MeasureId
*/
          ;
     --продажи больше 50% от прихода
     OPEN Cursor1 FOR
     SELECT *
     FROM _tmpData
     WHERE Tax_Amount >= 50 ;
     
     RETURN NEXT Cursor1;


     --продажи больше 20% меньше 50% от прихода
     OPEN Cursor2 FOR
     SELECT *
     FROM _tmpData
     WHERE Tax_Amount >= 20 AND Tax_Amount < 50;
     RETURN NEXT Cursor2;

     --продажи меньше 20% от прихода
     OPEN Cursor3 FOR
     SELECT *
     FROM _tmpData
     WHERE Tax_Amount < 20;
     RETURN NEXT Cursor3;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 26.07.18         *
*/

-- тест
-- SELECT * FROM gpReport_Sale_Analysis