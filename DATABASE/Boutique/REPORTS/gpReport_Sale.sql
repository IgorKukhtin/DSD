-- Function:  gpReport_Sale()

DROP FUNCTION IF EXISTS gpReport_Sale (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Sale (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Sale (
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
    IN inisSale           Boolean  , -- по каким данным форморовать отчет Да - продажа, нет - возвраты
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS TABLE (PartionId             Integer
             , BrandName             VarChar (100)
             , PeriodName            VarChar (25)
             , PeriodYear            Integer
             , PartnerId             Integer
             , PartnerName           VarChar (100)

             , GoodsGroupName_all    TVarChar
             , GoodsGroupName        TVarChar
             , LabelName             VarChar (100)
             , CompositionGroupName  TVarChar
             , CompositionName       TVarChar

             , GoodsId               Integer
             , GoodsCode             Integer
             , GoodsName             VarChar (100)
             , GoodsInfoName         TVarChar
             , LineFabricaName       TVarChar
             , GoodsSizeId           Integer
             , GoodsSizeName         VarChar (25)

             , UnitName              VarChar (100)
             , ClientName            VarChar (100)
             , DiscountSaleKindName  VarChar (15)
             , ChangePercent         TFloat

             , UnitName_In           VarChar (100)
             , CurrencyName          VarChar (10)

             , OperPrice             TFloat
             , Income_Amount         TFloat

             , Debt_Amount           TFloat
             , Sale_Amount           TFloat
             , Sale_Summ             TFloat
             , Sale_SummCost         TFloat
             , Sale_SummCost_diff    TFloat
             , Sale_Summ_prof        TFloat
             , Sale_Summ_10100       TFloat
             , Sale_Summ_10201       TFloat
             , Sale_Summ_10202       TFloat
             , Sale_Summ_10203       TFloat
             , Sale_Summ_10204       TFloat
             , Sale_Summ_10200       TFloat

             , Return_Amount         TFloat
             , Return_Summ           TFloat
             , Return_SummCost       TFloat
             , Return_SummCost_diff  TFloat
             , Return_Summ_prof      TFloat
             , Return_Summ_10200     TFloat

             , Result_Amount         TFloat
             , Result_Summ           TFloat
             , Result_SummCost       TFloat
             , Result_SummCost_diff  TFloat
             , Result_Summ_prof      TFloat
             , Result_Summ_10200     TFloat

             , GroupsName4           VarChar (50)
             , GroupsName3           VarChar (50)
             , GroupsName2           VarChar (50)
             , GroupsName1           VarChar (50)

             , DescName_Partion     TVarChar
             , OperDate_Partion     TDateTime
             , Invnumber_Partion    TVarChar

             , DescName_doc         TVarChar
             , OperDate_doc         TDateTime
             , InvNumber_doc        TVarChar
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
         , tmpContainer AS (SELECT Container.Id         AS ContainerId
                                 , CLO_Client.ObjectId  AS ClientId
                            FROM Container
                                 INNER JOIN ContainerLinkObject AS CLO_Client
                                                                ON CLO_Client.ContainerId = Container.Id
                                                               AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                               AND (CLO_Client.ObjectId = inClientId OR inClientId = 0)
                            WHERE Container.DescId   = zc_Container_Count()
                              AND Container.WhereObjectId = inUnitId
                           UNION ALL
                            SELECT Container.Id         AS ContainerId
                                 , 0                    AS ClientId
                            FROM Container
                            WHERE Container.DescId   = zc_Container_Summ()
                              AND Container.WhereObjectId = inUnitId
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

                                , COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) :: Integer AS UnitId
                                , CASE WHEN inisMovement = TRUE THEN MIConatiner.OperDate ELSE NULL :: TDateTime END AS OperDate_doc
                                , CASE WHEN inisMovement = TRUE THEN MIConatiner.MovementId ELSE 0 END               AS MovementId_doc
                                , CASE WHEN inIsClient   = TRUE THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() THEN MIConatiner.WhereObjectId_Analyzer ELSE tmpContainer.ClientId END ELSE NULL :: Integer END AS ClientId

                                , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                                , COALESCE (MILinkObject_DiscountSaleKind.ObjectId, 0)  AS DiscountSaleKindId

                                , Object_PartionGoods.UnitId     AS UnitId_in
                                , Object_PartionGoods.CurrencyId AS CurrencyId
                                , Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END :: TFloat  AS OperPrice
                                  -- Кол-во Приход от поставщика - только для UnitId
                                , Object_PartionGoods.Amount AS Income_Amount

                                  -- Кол-во: Долг
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() THEN MIConatiner.Amount ELSE 0 END) AS Debt_Amount

                                  -- Кол-во: Только Продажа
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Amount
                                  -- С\с продажа - calc
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount
                                     * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                     * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                     / CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                       ELSE 0 END) :: TFloat AS Sale_SummCost_calc
                                  -- Сумма продажа
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Summ

                                  -- С\с продажа
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_SummCost
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
                                , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN 1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10200

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
                                -- , 0 :: TFloat AS Result_Summ
                                -- , 0 :: TFloat AS Result_SummCost
                                -- , 0 :: TFloat AS Result_Summ_10200
                                  --  № п/п
                                , ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId ORDER BY CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC) AS Ord

                                , COALESCE (MIBoolean_Checked.ValueData, FALSE)         AS isChecked
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
                                LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                           AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                                 ON MILinkObject_DiscountSaleKind.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                                AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()

                                LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                              ON MIBoolean_Checked.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                             AND MIBoolean_Checked.DescId         = zc_MIBoolean_Checked()

                           WHERE (Object_PartionGoods.PartnerId  = inPartnerId        OR inPartnerId   = 0)
                             AND (Object_PartionGoods.BrandId    = inBrandId          OR inBrandId     = 0)
                             AND (Object_PartionGoods.PeriodId   = inPeriodId         OR inPeriodId    = 0)
                             AND (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                             AND (MIConatiner.ContainerId        > 0                  )
                             AND (tmpContainer.ContainerId       > 0                  OR MIConatiner.PartionId IS NULL)
                             AND (   (MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) AND inisSale = TRUE)
                                  OR (MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) AND inisSale = FALSE)
                                  )
                             AND inUnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId)
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

                                  , MIConatiner.ObjectExtId_Analyzer
                                  , CASE WHEN inisMovement = TRUE THEN MIConatiner.OperDate ELSE NULL :: TDateTime END 
                                  , CASE WHEN inisMovement = TRUE THEN MIConatiner.MovementId ELSE 0 END
                                  , CASE WHEN inIsClient   = TRUE THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() THEN MIConatiner.WhereObjectId_Analyzer ELSE tmpContainer.ClientId END ELSE NULL :: Integer END

                                  , MIFloat_ChangePercent.ValueData
                                  , MILinkObject_DiscountSaleKind.ObjectId

                                  , Object_PartionGoods.UnitId
                                  , Object_PartionGoods.CurrencyId
                                  , Object_PartionGoods.Amount
                                  , Object_PartionGoods.OperPrice
                                  , Object_PartionGoods.CountForPrice
                                  , COALESCE (MIBoolean_Checked.ValueData, FALSE)
                            HAVING SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) <> 0
                               OR (SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END) <> 0
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
                          , CASE WHEN inIsSize  = TRUE THEN tmpData_all.GoodsSizeId ELSE 0 END AS GoodsSizeId

                          , tmpData_all.OperDate_doc
                          , tmpData_all.MovementId_doc
                          , tmpData_all.UnitId
                          , tmpData_all.ClientId
                          , tmpData_all.ChangePercent
                          , tmpData_all.DiscountSaleKindId

                          , tmpData_all.UnitId_in
                          , tmpData_all.CurrencyId

                          , tmpData_all.OperPrice
                          , tmpData_all.isChecked
                          , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.Income_Amount ELSE 0 END) AS Income_Amount

                          , SUM (tmpData_all.Debt_Amount)           AS Debt_Amount
                          , SUM (tmpData_all.Sale_Amount)           AS Sale_Amount
                          , SUM (tmpData_all.Sale_Summ)             AS Sale_Summ
                          , SUM (tmpData_all.Sale_SummCost)         AS Sale_SummCost
                          , SUM (tmpData_all.Sale_SummCost_calc)    AS Sale_SummCost_calc
                          , SUM (tmpData_all.Sale_Summ_10100)       AS Sale_Summ_10100
                          , SUM (tmpData_all.Sale_Summ_10201)       AS Sale_Summ_10201
                          , SUM (tmpData_all.Sale_Summ_10202)       AS Sale_Summ_10202
                          , SUM (tmpData_all.Sale_Summ_10203)       AS Sale_Summ_10203
                          , SUM (tmpData_all.Sale_Summ_10204)       AS Sale_Summ_10204
                          , SUM (tmpData_all.Sale_Summ_10200)       AS Sale_Summ_10200
                          , SUM (tmpData_all.Return_Amount)         AS Return_Amount
                          , SUM (tmpData_all.Return_Summ)           AS Return_Summ
                          , SUM (tmpData_all.Return_SummCost)       AS Return_SummCost
                          , SUM (tmpData_all.Return_SummCost_calc)  AS Return_SummCost_calc
                          , SUM (tmpData_all.Return_Summ_10200)     AS Return_Summ_10200
                          , SUM (tmpData_all.Result_Amount)         AS Result_Amount
                          -- , SUM (tmpData_all.Result_Summ)         AS Result_Summ
                          -- , SUM (tmpData_all.Result_SummCost)     AS Result_SummCost
                          -- , SUM (tmpData_all.Result_Summ_10200)   AS Result_Summ_10200

                          , ObjectLink_Parent0.ChildObjectId AS GroupId1
                          , ObjectLink_Parent1.ChildObjectId AS GroupId1_parent

                          , ObjectLink_Parent1.ChildObjectId AS GroupId2
                          , ObjectLink_Parent2.ChildObjectId AS GroupId2_parent

                          , ObjectLink_Parent2.ChildObjectId AS GroupId3
                          , ObjectLink_Parent3.ChildObjectId AS GroupId3_parent

                          , ObjectLink_Parent3.ChildObjectId AS GroupId4
                          , ObjectLink_Parent4.ChildObjectId AS GroupId4_parent

                          , ObjectLink_Parent4.ChildObjectId AS GroupId5
                          , ObjectLink_Parent5.ChildObjectId AS GroupId5_parent

                          , ObjectLink_Parent5.ChildObjectId AS GroupId6
                          , ObjectLink_Parent6.ChildObjectId AS GroupId6_parent

                          , ObjectLink_Parent6.ChildObjectId AS GroupId7
                          , ObjectLink_Parent7.ChildObjectId AS GroupId7_parent

                          , ObjectLink_Parent7.ChildObjectId AS GroupId8
                          , ObjectLink_Parent8.ChildObjectId AS GroupId8_parent

                     FROM tmpData_all AS tmpData_all
                          LEFT JOIN ObjectLink AS ObjectLink_Parent0
                                               ON ObjectLink_Parent0.ObjectId = tmpData_all.GoodsId
                                              AND ObjectLink_Parent0.DescId   = zc_ObjectLink_Goods_GoodsGroup()

                          LEFT JOIN ObjectLink AS ObjectLink_Parent1
                                               ON ObjectLink_Parent1.ObjectId = ObjectLink_Parent0.ChildObjectId
                                              AND ObjectLink_Parent1.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent2
                                               ON ObjectLink_Parent2.ObjectId = ObjectLink_Parent1.ChildObjectId
                                              AND ObjectLink_Parent2.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent3
                                               ON ObjectLink_Parent3.ObjectId = ObjectLink_Parent2.ChildObjectId
                                              AND ObjectLink_Parent3.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent4
                                               ON ObjectLink_Parent4.ObjectId = ObjectLink_Parent3.ChildObjectId
                                              AND ObjectLink_Parent4.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent5
                                               ON ObjectLink_Parent5.ObjectId = ObjectLink_Parent4.ChildObjectId
                                              AND ObjectLink_Parent5.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent6
                                               ON ObjectLink_Parent6.ObjectId = ObjectLink_Parent5.ChildObjectId
                                              AND ObjectLink_Parent6.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent7
                                               ON ObjectLink_Parent7.ObjectId = ObjectLink_Parent6.ChildObjectId
                                              AND ObjectLink_Parent7.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                          LEFT JOIN ObjectLink AS ObjectLink_Parent8
                                               ON ObjectLink_Parent8.ObjectId = ObjectLink_Parent7.ChildObjectId
                                              AND ObjectLink_Parent8.DescId   = zc_ObjectLink_GoodsGroup_Parent()
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

                            , tmpData_all.OperDate_doc
                            , tmpData_all.MovementId_doc
                            , tmpData_all.UnitId
                            , tmpData_all.ClientId
                            , tmpData_all.ChangePercent
                            , tmpData_all.DiscountSaleKindId

                            , tmpData_all.UnitId_in
                            , tmpData_all.CurrencyId
                            , tmpData_all.OperPrice
                            , tmpData_all.isChecked

                            , ObjectLink_Parent0.ChildObjectId
                            , ObjectLink_Parent1.ChildObjectId
                            , ObjectLink_Parent1.ChildObjectId
                            , ObjectLink_Parent2.ChildObjectId
                            , ObjectLink_Parent2.ChildObjectId
                            , ObjectLink_Parent3.ChildObjectId
                            , ObjectLink_Parent3.ChildObjectId
                            , ObjectLink_Parent4.ChildObjectId
                            , ObjectLink_Parent4.ChildObjectId
                            , ObjectLink_Parent5.ChildObjectId
                            , ObjectLink_Parent5.ChildObjectId
                            , ObjectLink_Parent6.ChildObjectId
                            , ObjectLink_Parent6.ChildObjectId
                            , ObjectLink_Parent7.ChildObjectId
                            , ObjectLink_Parent7.ChildObjectId
                            , ObjectLink_Parent8.ChildObjectId
                    )
   /*, tmpDayOfWeek AS (SELECT zfCalc.Ord_dow, zfCalc.DayOfWeekName
                      FROM (SELECT GENERATE_SERIES (CURRENT_DATE, CURRENT_DATE + INTERVAL '6 DAY', '1 DAY' :: INTERVAL) AS OperDate) AS tmp
                           CROSS JOIN zfCalc_DayOfWeekName_cross (tmp.OperDate) AS zfCalc
                     )*/

        -- Результат
        SELECT tmpData.PartionId
             , Object_Brand.ValueData    :: VarChar (100) AS BrandName
             , Object_Period.ValueData   :: VarChar (25)  AS PeriodName
             , tmpData.PeriodYear        :: Integer       AS PeriodYear
             , Object_Partner.Id                          AS PartnerId
             , Object_Partner.ValueData  :: VarChar (100) AS PartnerName

             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupName_all
             , Object_GoodsGroup.ValueData                AS GoodsGroupName
             , Object_Label.ValueData    :: VarChar (100) AS LabelName
             , Object_CompositionGroup.ValueData  AS CompositionGroupName
             , Object_Composition.ValueData       AS CompositionName

             , Object_Goods.Id                            AS GoodsId
             , Object_Goods.ObjectCode                    AS GoodsCode
             , Object_Goods.ValueData    :: VarChar (100) AS GoodsName
             , Object_GoodsInfo.ValueData                 AS GoodsInfoName
             , Object_LineFabrica.ValueData               AS LineFabricaName
             , Object_GoodsSize.Id                        AS GoodsSizeId
             , Object_GoodsSize.ValueData :: VarChar (25) AS GoodsSizeName

             , Object_Unit.ValueData        :: VarChar (100) AS UnitName
             , Object_Client.ValueData      :: VarChar (100) AS ClientName
             , Object_DiscountSaleKind.ValueData :: VarChar (15) AS DiscountSaleKindName
             , tmpData.ChangePercent        :: TFloat        AS ChangePercent
                                            
             , Object_Unit_In.ValueData     :: VarChar (100) AS UnitName_In
             , Object_Currency.ValueData    :: VarChar (10)  AS CurrencyName

             , tmpData.OperPrice            :: TFloat
             , tmpData.Income_Amount        :: TFloat
                                            
             , tmpData.Debt_Amount          :: TFloat
             , tmpData.Sale_Amount          :: TFloat
             , tmpData.Sale_Summ            :: TFloat
                                            
             , tmpData.Sale_SummCost_calc   :: TFloat AS Sale_SummCost
             , (tmpData.Sale_SummCost - tmpData.Sale_SummCost_calc) :: TFloat AS Sale_SummCost_diff
             , (tmpData.Sale_Summ     - tmpData.Sale_SummCost_calc) :: TFloat AS Sale_Summ_prof
             , tmpData.Sale_Summ_10100      :: TFloat
             , tmpData.Sale_Summ_10201      :: TFloat
             , tmpData.Sale_Summ_10202      :: TFloat
             , tmpData.Sale_Summ_10203      :: TFloat
             , tmpData.Sale_Summ_10204      :: TFloat
             , tmpData.Sale_Summ_10200      :: TFloat
                                            
             , tmpData.Return_Amount        :: TFloat
             , tmpData.Return_Summ          :: TFloat
             , tmpData.Return_SummCost_calc :: TFloat AS Return_SummCost_calc
             , (tmpData.Return_SummCost - tmpData.Return_SummCost_calc) :: TFloat AS Return_SummCost_diff
             , (tmpData.Return_Summ     - tmpData.Return_SummCost_calc) :: TFloat AS Return_Summ_prof
             , tmpData.Return_Summ_10200    :: TFloat

             , tmpData.Result_Amount        :: TFloat
             , (tmpData.Sale_Summ          - tmpData.Return_Summ)           :: TFloat AS Result_Summ
             , (tmpData.Sale_SummCost_calc - tmpData.Return_SummCost_calc)  :: TFloat AS Result_SummCost
             , (tmpData.Sale_SummCost - tmpData.Sale_SummCost_calc - tmpData.Return_SummCost + tmpData.Return_SummCost_calc) :: TFloat AS Result_SummCost_diff
             , (tmpData.Sale_Summ - tmpData.Sale_SummCost_calc - tmpData.Return_Summ + tmpData.Return_SummCost_calc)         :: TFloat AS Result_Summ_prof
             , (tmpData.Sale_Summ_10200 - tmpData.Return_Summ_10200)        :: TFloat AS Result_Summ_10200
    
               -- 0 - Первая Группа СНИЗУ
             , Object_GoodsGroup1.ValueData :: VarChar (50) AS GroupsName4 -- а было AnalyticaName1, а в GroupsName4 - сейчас LabelName

               -- 1 - Самый Верхней уровень
             , CASE WHEN tmpData.GroupId1_parent IS NULL
                         THEN Object_GoodsGroup1.ValueData
                    WHEN tmpData.GroupId2_parent IS NULL
                         THEN Object_GoodsGroup2.ValueData
                    WHEN tmpData.GroupId3_parent IS NULL
                         THEN Object_GoodsGroup3.ValueData
                    WHEN tmpData.GroupId4_parent IS NULL
                         THEN Object_GoodsGroup4.ValueData
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN Object_GoodsGroup5.ValueData
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN Object_GoodsGroup6.ValueData
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN Object_GoodsGroup7.ValueData
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN Object_GoodsGroup8.ValueData
               END :: VarChar (50) AS GroupsName3

               -- 2 - Следующий ПОСЛЕ П.1. + !!!для "Детское" - еще Следующий!!!
             , CASE WHEN tmpData.GroupId2_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup1.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_Label.ValueData
                                   ELSE Object_GoodsGroup1.ValueData
                              END
                    WHEN tmpData.GroupId3_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup2.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup2.ValueData
                              END
                    WHEN tmpData.GroupId4_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup3.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup2.ValueData
                                   ELSE Object_GoodsGroup3.ValueData
                              END
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup4.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup3.ValueData
                                   ELSE Object_GoodsGroup4.ValueData
                              END
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup5.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup4.ValueData
                                   ELSE Object_GoodsGroup5.ValueData
                              END
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup6.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup5.ValueData
                                   ELSE Object_GoodsGroup6.ValueData
                              END
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup7.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup6.ValueData
                                   ELSE Object_GoodsGroup7.ValueData
                              END
               END :: VarChar (50) AS GroupsName2

               -- 3 - Следующий ПОСЛЕ П.2. + !!!для "Детское" - еще Следующий!!!
             , CASE WHEN tmpData.GroupId2_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup2.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_Label.ValueData
                                   ELSE Object_Label.ValueData
                              END
                    WHEN tmpData.GroupId3_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup2.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup1.ValueData
                              END
                    WHEN tmpData.GroupId4_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup3.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup2.ValueData
                              END
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup4.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup2.ValueData
                                   ELSE Object_GoodsGroup3.ValueData
                              END
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup5.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup3.ValueData
                                   ELSE Object_GoodsGroup4.ValueData
                              END
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup6.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup4.ValueData
                                   ELSE Object_GoodsGroup5.ValueData
                              END
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup7.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup5.ValueData
                                   ELSE Object_GoodsGroup6.ValueData
                              END
               END :: VarChar (50) AS GroupsName1

             , MovementDesc.ItemName          AS DescName_Partion
             , Movement.OperDate              AS OperDate_Partion
             , Movement.InvNumber             AS InvNumber_Partion

             , MovementDesc_Doc.ItemName          AS DescName_doc
             , Movement_Doc.OperDate              AS OperDate_doc
             , Movement_Doc.InvNumber             AS InvNumber_doc
             
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
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpData.GoodsSizeId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = tmpData.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = tmpData.PeriodId

            LEFT JOIN Object AS Object_GoodsGroup1 ON Object_GoodsGroup1.Id = tmpData.GroupId1
            LEFT JOIN Object AS Object_GoodsGroup2 ON Object_GoodsGroup2.Id = tmpData.GroupId2
            LEFT JOIN Object AS Object_GoodsGroup3 ON Object_GoodsGroup3.Id = tmpData.GroupId3
            LEFT JOIN Object AS Object_GoodsGroup4 ON Object_GoodsGroup4.Id = tmpData.GroupId4
            LEFT JOIN Object AS Object_GoodsGroup5 ON Object_GoodsGroup5.Id = tmpData.GroupId5
            LEFT JOIN Object AS Object_GoodsGroup6 ON Object_GoodsGroup6.Id = tmpData.GroupId6
            LEFT JOIN Object AS Object_GoodsGroup7 ON Object_GoodsGroup7.Id = tmpData.GroupId7
            LEFT JOIN Object AS Object_GoodsGroup8 ON Object_GoodsGroup8.Id = tmpData.GroupId8
          ;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 21.02.18         *
*/

-- тест
--select * from gpReport_Sale(inStartDate := ('01.01.2017')::TDateTime , inEndDate := ('01.01.2017')::TDateTime , inUnitId := 1157 , inClientId := 0 , inPartnerId := 0 , inBrandId := 0 , inPeriodId := 0 , inStartYear := 0 , inEndYear := 0 , inisPartion := 'False' , inisSize := 'False' , inisPartner := 'False' , inisMovement := 'False' , inIsClient := 'False' , inisSale:= 'TRUE',  inSession := '2');