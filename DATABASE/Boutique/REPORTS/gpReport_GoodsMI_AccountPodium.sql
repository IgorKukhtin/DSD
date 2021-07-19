-- Function:  gpReport_GoodsMI_Account()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Account (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_GoodsMI_Account(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inIsShowAll        Boolean  ,  -- Показывать все документы / только проведенные
    IN inIsCurrency       Boolean  ,  -- Показать валюту (да/нет)
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (-- Документ
               MovementId            Integer
             , StatusCode            Integer
             , DescName              TVarChar
             , OperDate              TDateTime
             , InvNumber             TVarChar
               -- Партия ПРОДАЖИ
             , MovementId_Sale       Integer
             , DescName_Sale         TVarChar
             , OperDate_Sale         TDateTime
             , InvNumber_Sale        TVarChar
               --
             , UnitName              TVarChar
             , ClientName            TVarChar
             , PartionId             Integer
             , MI_Id                 Integer
             , MI_Id_Partion         Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, NameFull TVarChar, GoodsGroupName TVarChar
             , CompositionName  TVarChar
             , GoodsInfoName    TVarChar
             , LineFabricaName  TVarChar
             , LabelName        TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , BrandName        TVarChar
             , FabrikaName      TVarChar
             , PeriodName       TVarChar
             , PeriodYear       Integer
             , isOffer          Boolean
               -- % скидки
             , ChangePercent    TFloat
             , ChangePercentNext TFloat
               -- Цена по прайсу в продаже, ГРН
             , OperPriceList    TFloat
               -- Дополнительная скидка в документе, ГРН
             , SummChangePercent  TFloat
               -- Кол-во
             , Amount           TFloat
               -- Сумма без скидки
             , TotalSummPriceList TFloat
               -- Оплата
             , TotalPay_Grn     TFloat
             , TotalPay_USD     TFloat
             , TotalPay_EUR     TFloat
             , TotalPay_Card    TFloat
             , TotalPay         TFloat
               -- Долг
             , TotalDebt        TFloat

             , CurrencyValue    TFloat
             , CurrencyName     TVarChar
             
               -- Дата/вр. (созд.)
             , InsertDate       TDateTime
               -- Группа: 1 - по Товарам + 2 - Обмены
             , NumGroup         Integer
               -- Группировка в печати
             , ValueGroup       TVarChar
  )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- проверка может ли смотреть любой магазин, или только свой
    PERFORM lpCheckUnit_byUser (inUnitId_by:= inUnitId, inUserId:= vbUserId);


    -- Результат
    RETURN QUERY
    WITH
    tmpStatus AS (SELECT tmp.StatusId              AS StatusId
                       , Object_Status.ObjectCode  AS StatusCode
                  FROM (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId WHERE inIsShowAll = TRUE
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsShowAll = TRUE
                        ) AS tmp
                        LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmp.StatusId
                 )
     -- 1.1. Продажи за период Отчета
   , tmpSale AS (SELECT Movement_Sale.Id                    AS MovementId
                      , Movement_Sale.DescId                AS MovementDescId
                      , tmpStatus.StatusCode                AS StatusCode
                      , Movement_Sale.OperDate              AS OperDate
                      , Movement_Sale.InvNumber             AS InvNumber
                      , MovementLinkObject_From.ObjectId    AS UnitId
                      , MovementLinkObject_To.ObjectId      AS ClientId
                      , MI_Master.ObjectId                  AS GoodsId
                      , MI_Master.PartionId                 AS PartionId
                      , MI_Master.Id                        AS MI_Id
                      , COALESCE (MIFloat_ChangePercent.ValueData, 0)      AS ChangePercent
                      , COALESCE (MIFloat_ChangePercentNext.ValueData, 0)  AS ChangePercentNext
                      , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList
                      , COALESCE (MIFloat_SummChangePercent.ValueData, 0)  AS SummChangePercent
                      , MI_Master.Amount                                   AS Amount
                      , COALESCE (MIFloat_TotalPay.ValueData, 0)           AS TotalPay

                 FROM Movement AS Movement_Sale
                      INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_Sale.StatusId
                      INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                    ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                                   AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                   AND (MovementLinkObject_From.ObjectId  = inUnitId OR inUnitId = 0)
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                                  AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                      INNER JOIN MovementItem AS MI_Master
                                              ON MI_Master.MovementId = Movement_Sale.Id
                                             AND MI_Master.DescId     = zc_MI_Master()
                                             AND MI_Master.isErased   = FALSE
                      LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                  ON MIFloat_ChangePercent.MovementItemId = MI_Master.Id
                                                 AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                      LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                                  ON MIFloat_ChangePercentNext.MovementItemId = MI_Master.Id
                                                 AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()
                      LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                  ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                 AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                      LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                  ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                 AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                      LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                  ON MIFloat_SummChangePercent.MovementItemId = MI_Master.Id
                                                 AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()

                 WHERE Movement_Sale.DescId   = zc_Movement_Sale()
                   AND Movement_Sale.OperDate BETWEEN inStartDate AND inEndDate
               )
    -- 1.2. Возвраты за период Отчета
  , tmpReturnIn AS (SELECT Movement_ReturnIn.Id                AS MovementId
                         , Movement_ReturnIn.DescId            AS MovementDescId
                         , tmpStatus.StatusCode                AS StatusCode
                         , Movement_ReturnIn.OperDate          AS OperDate
                         , Movement_ReturnIn.InvNumber         AS InvNumber
                         , Movement_Sale.Id                    AS MovementId_Sale
                         , Movement_Sale.DescId                AS MovementDescId_Sale
                         , Movement_Sale.OperDate              AS OperDate_Sale
                         , Movement_Sale.InvNumber             AS InvNumber_Sale
                         , MovementLinkObject_To.ObjectId      AS UnitId
                         , MovementLinkObject_From.ObjectId    AS ClientId
                         , MI_Master.ObjectId                  AS GoodsId
                         , MI_Master.PartionId                 AS PartionId
                         , MI_Master.Id                        AS MI_Id
                         , COALESCE (MIFloat_ChangePercent.ValueData, 0)      AS ChangePercent
                         , COALESCE (MIFloat_ChangePercentNext.ValueData, 0)  AS ChangePercentNext
                         , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList
                         , 0                                                  AS SummChangePercent

                         , -1 * MI_Master.Amount                              AS Amount
                         , -1 * COALESCE (MIFloat_TotalPay.ValueData, 0)      AS TotalPay

                    FROM Movement AS Movement_ReturnIn
                         INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_ReturnIn.StatusId

                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = Movement_ReturnIn.Id
                                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                      AND (MovementLinkObject_To.ObjectId  = inUnitId OR inUnitId = 0)
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement_ReturnIn.Id
                                                     AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                         INNER JOIN MovementItem AS MI_Master
                                                 ON MI_Master.MovementId = Movement_ReturnIn.Id
                                                AND MI_Master.MovementId = Movement_ReturnIn.Id
                                                AND MI_Master.DescId     = zc_MI_Master()
                                                AND MI_Master.isErased   = FALSE

                         LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                     ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                    AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                     ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                          ON MILinkObject_PartionMI.MovementItemId = MI_Master.Id
                                                         AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                         LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                         LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode
                         LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MI_Sale.MovementId
                         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                     ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                                    AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                                     ON MIFloat_ChangePercentNext.MovementItemId = MI_Sale.Id
                                                    AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()
                    WHERE Movement_ReturnIn.DescId   = zc_Movement_ReturnIn()
                      AND Movement_ReturnIn.OperDate BETWEEN inStartDate AND inEndDate
                   )
    -- 1.3. Расчеты за период Отчета
  , tmpGoodsAccount AS (SELECT Movement_GoodsAccount.Id            AS MovementId
                             , Movement_GoodsAccount.DescId        AS MovementDescId
                             , tmpStatus.StatusCode                AS StatusCode
                             , Movement_GoodsAccount.OperDate      AS OperDate
                             , Movement_GoodsAccount.InvNumber     AS InvNumber
                             , Movement_Sale.Id                    AS MovementId_Sale
                             , Movement_Sale.DescId                AS MovementDescId_Sale
                             , Movement_Sale.OperDate              AS OperDate_Sale
                             , Movement_Sale.InvNumber             AS InvNumber_Sale
                             , MovementLinkObject_To.ObjectId      AS UnitId
                             , MovementLinkObject_From.ObjectId    AS ClientId
                             , MI_Master.ObjectId                  AS GoodsId
                             , MI_Sale.PartionId                   AS PartionId
                             , MI_Master.Id                        AS MI_Id
                             , COALESCE (MIFloat_ChangePercent.ValueData, 0)      AS ChangePercent
                             , COALESCE (MIFloat_ChangePercentNext.ValueData, 0)  AS ChangePercentNext
                             , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList
                             , COALESCE (MIFloat_SummChangePercent_master.ValueData, 0) AS SummChangePercent
                             , MI_Master.Amount                                   AS Amount
                             , COALESCE (MIFloat_TotalPay.ValueData, 0)           AS TotalPay

                        FROM Movement AS Movement_GoodsAccount
                             INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_GoodsAccount.StatusId

                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = Movement_GoodsAccount.Id
                                                          AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                          AND (MovementLinkObject_To.ObjectId  = inUnitId OR inUnitId = 0)
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement_GoodsAccount.Id
                                                         AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                             INNER JOIN MovementItem AS MI_Master
                                                     ON MI_Master.MovementId = Movement_GoodsAccount.Id
                                                    AND MI_Master.DescId     = zc_MI_Master()
                                                    AND MI_Master.isErased   = FALSE

                             LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_master
                                                         ON MIFloat_SummChangePercent_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_SummChangePercent_master.DescId         = zc_MIFloat_SummChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                         ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                              ON MILinkObject_PartionMI.MovementItemId = MI_Master.Id
                                                             AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                             LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                             LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode
                             LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MI_Sale.MovementId

                             LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                         ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                                        AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                                         ON MIFloat_ChangePercentNext.MovementItemId = MI_Sale.Id
                                                        AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()
                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                         ON MIFloat_OperPriceList.MovementItemId = MI_Sale.Id
                                                        AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                        WHERE Movement_GoodsAccount.DescId   = zc_Movement_GoodsAccount()
                          AND Movement_GoodsAccount.OperDate BETWEEN inStartDate AND inEndDate
                       )
       -- все документы
     , tmpData_MI  AS  (SELECT tmp.MovementId
                             , tmp.MovementDescId
                             , tmp.StatusCode
                             , tmp.OperDate
                             , tmp.InvNumber
                             , tmp.MovementId     AS MovementId_Sale
                             , tmp.MovementDescId AS MovementDescId_Sale
                             , tmp.OperDate       AS OperDate_Sale
                             , tmp.InvNumber      AS InvNumber_Sale
                             , tmp.UnitId
                             , tmp.ClientId
                             , tmp.GoodsId
                             , tmp.PartionId
                             , tmp.ChangePercent
                             , tmp.ChangePercentNext
                             , tmp.OperPriceList
                             , tmp.MI_Id
                             , SUM (tmp.SummChangePercent) AS SummChangePercent
                             , SUM (tmp.Amount)            AS Amount
                             , SUM (tmp.TotalPay)          AS TotalPay

                        FROM tmpSale AS tmp
                        GROUP BY tmp.MovementId
                               , tmp.MovementDescId
                               , tmp.StatusCode
                               , tmp.OperDate
                               , tmp.InvNumber
                               , tmp.UnitId
                               , tmp.ClientId
                               , tmp.GoodsId
                               , tmp.PartionId
                               , tmp.ChangePercent
                               , tmp.ChangePercentNext
                               , tmp.OperPriceList
                               , tmp.MI_Id
                         UNION ALL
                           SELECT tmp.MovementId
                                , tmp.MovementDescId
                                , tmp.StatusCode
                                , tmp.OperDate
                                , tmp.InvNumber
                                , tmp.MovementId_Sale
                                , tmp.MovementDescId_Sale
                                , tmp.OperDate_Sale
                                , tmp.InvNumber_Sale
                                , tmp.UnitId
                                , tmp.ClientId
                                , tmp.GoodsId
                                , tmp.PartionId
                                , tmp.ChangePercent
                                , tmp.ChangePercentNext
                                , tmp.OperPriceList
                                , tmp.MI_Id
                                , SUM (tmp.SummChangePercent) AS SummChangePercent
                                , SUM (tmp.Amount)            AS Amount
                                , SUM (tmp.TotalPay)          AS TotalPay

                           FROM tmpReturnIn AS tmp
                           GROUP BY tmp.MovementId
                                  , tmp.MovementDescId
                                  , tmp.StatusCode
                                  , tmp.OperDate
                                  , tmp.InvNumber
                                  , tmp.MovementId_Sale
                                  , tmp.MovementDescId_Sale
                                  , tmp.OperDate_Sale
                                  , tmp.InvNumber_Sale
                                  , tmp.UnitId
                                  , tmp.ClientId
                                  , tmp.GoodsId
                                  , tmp.PartionId
                                  , tmp.ChangePercent
                                  , tmp.ChangePercentNext
                                  , tmp.OperPriceList
                                  , tmp.MI_Id

                         UNION ALL
                           SELECT tmp.MovementId
                                , tmp.MovementDescId
                                , tmp.StatusCode
                                , tmp.OperDate
                                , tmp.InvNumber
                                , tmp.MovementId_Sale
                                , tmp.MovementDescId_Sale
                                , tmp.OperDate_Sale
                                , tmp.InvNumber_Sale
                                , tmp.UnitId
                                , tmp.ClientId
                                , tmp.GoodsId
                                , tmp.PartionId
                                , tmp.ChangePercent
                                , tmp.ChangePercentNext
                                , tmp.OperPriceList
                                , tmp.MI_Id
                                , SUM (tmp.SummChangePercent) AS SummChangePercent
                                , SUM (tmp.Amount)            AS Amount
                                , SUM (tmp.TotalPay)          AS TotalPay

                           FROM tmpGoodsAccount AS tmp
                           GROUP BY tmp.MovementId
                                  , tmp.MovementDescId
                                  , tmp.StatusCode
                                  , tmp.OperDate
                                  , tmp.InvNumber
                                  , tmp.MovementId_Sale
                                  , tmp.MovementDescId_Sale
                                  , tmp.OperDate_Sale
                                  , tmp.InvNumber_Sale
                                  , tmp.UnitId
                                  , tmp.ClientId
                                  , tmp.GoodsId
                                  , tmp.PartionId
                                  , tmp.ChangePercent
                                  , tmp.ChangePercentNext
                                  , tmp.OperPriceList
                                  , tmp.MI_Id
                    )
      -- оплаты в валюте / обмены
    , tmpMI_Child AS (SELECT MovementItem.MovementId
                           , COALESCE (MovementItem.ParentId, 0) AS ParentId
                           , CASE WHEN inIsCurrency = TRUE THEN MILinkObject_Currency.ObjectId ELSE 0 END AS CurrencyId
                           , SUM (CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_GRN() 
                                       THEN MovementItem.Amount
                                       ELSE zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                  END) AS Pay_Child
                           , SUM (CASE WHEN MovementItem.ParentId IS NULL
                                            -- Расчетная сумма в грн для обмен
                                            THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                       WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                            THEN MovementItem.Amount
                                       ELSE 0
                                  END) AS Amount_GRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END) AS Amount_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END) AS Amount_EUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END) AS Amount_Bank
                           , CASE WHEN MovementItem.ParentId IS NULL THEN MIFloat_CurrencyValue.ValueData ELSE 0 END AS CurrencyValue

                      FROM (SELECT DISTINCT tmpData_MI.MovementId FROM tmpData_MI) AS tmpData
                            JOIN MovementItem ON MovementItem.MovementId = tmpData.MovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = FALSE
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                      GROUP BY MovementItem.ParentId
                             , MovementItem.MovementId
                             , CASE WHEN MovementItem.ParentId IS NULL THEN MIFloat_CurrencyValue.ValueData ELSE 0 END
                             , CASE WHEN inIsCurrency = TRUE THEN MILinkObject_Currency.ObjectId ELSE 0 END
                     )
    -- выбираю все контейнеры по покупателю и подразделению , если выбрано
  , tmpContainer AS (SELECT Container.Id                    AS ContainerId
                          , CLO_Unit.ObjectId               AS UnitId
                          , CLO_Client.ObjectId             AS ClientId
                          , CLO_Goods.ObjectId              AS GoodsId
                          , Container.PartionId             AS PartionId
                          , Object_PartionMI.ObjectCode     AS MI_Id
                          , Container.Amount
                     FROM Container
                          INNER JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                          INNER JOIN ContainerLinkObject AS CLO_PartionMI
                                                         ON CLO_PartionMI.ContainerId = Container.Id
                                                        AND CLO_PartionMI.DescId      = zc_ContainerLinkObject_PartionMI()
                          INNER JOIN Object AS Object_PartionMI ON Object_PartionMI.Id         = CLO_PartionMI.ObjectId
                                                             --  AND Object_PartionMI.ObjectCode IN (SELECT DISTINCT tmpData_MI.MI_Id FROM tmpData_MI)
                          INNER JOIN ContainerLinkObject AS CLO_Unit
                                                         ON CLO_Unit.ContainerId = Container.Id
                                                        AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                        AND (CLO_Unit.ObjectId   = inUnitId OR inUnitId = 0)
                          LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                        ON CLO_Goods.ContainerId = Container.Id
                                                       AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                      -- !!!кроме Покупатели + Прибыль будущих периодов!!!
                      WHERE Container.ObjectId  <> zc_Enum_Account_20102()
                        AND Container.DescId    = zc_Container_Summ()
                    )
  , tmpDebt AS (SELECT tmpContainer.ClientId
                     , tmpContainer.UnitId
                     , tmpContainer.GoodsId
                     , tmpContainer.PartionId
                     , tmpContainer.MI_Id
                     , SUM (tmpContainer.Debt) AS Debt
                FROM (SELECT tmpContainer.ClientId
                           , tmpContainer.UnitId
                           , tmpContainer.GoodsId
                           , tmpContainer.PartionId
                           , tmpContainer.MI_Id
                           , tmpContainer.ContainerId
                           , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Debt
                      FROM tmpContainer
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                           AND MIContainer.OperDate    > inEndDate
                      GROUP BY tmpContainer.ClientId
                             , tmpContainer.UnitId
                             , tmpContainer.GoodsId
                             , tmpContainer.PartionId
                             , tmpContainer.MI_Id
                             , tmpContainer.ContainerId
                             , tmpContainer.Amount
                      HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0)
                     ) AS tmpContainer
                GROUP BY tmpContainer.ClientId
                       , tmpContainer.UnitId
                       , tmpContainer.GoodsId
                       , tmpContainer.PartionId
                       , tmpContainer.MI_Id
               )

       , tmpData AS (SELECT tmp.MovementId          AS MovementId
                          , tmp.MovementDescId      AS MovementDescId
                          , tmp.StatusCode          AS StatusCode
                          , tmp.OperDate            AS OperDate
                          , tmp.InvNumber           AS InvNumber
                          , tmp.MovementId_Sale     AS MovementId_Sale
                          , tmp.MovementDescId_Sale AS MovementDescId_Sale
                          , tmp.OperDate_Sale       AS OperDate_Sale
                          , tmp.InvNumber_Sale      AS InvNumber_Sale
                          , tmp.UnitId              AS UnitId
                          , tmp.ClientId            AS ClientId
                          , tmp.PartionId           AS PartionId
                          , tmp.MI_Id               AS MI_Id
                          , tmp.MI_Id_Partion       AS MI_Id_Partion
                          , tmp.Ord                 AS Ord
                          , tmp.ChangePercent       AS ChangePercent
                          , tmp.ChangePercentNext   AS ChangePercentNext
                          , tmp.OperPriceList       AS OperPriceList
                          , tmp.GoodsId
                          , tmp.CurrencyValue
                          , tmp.CurrencyId
                          , SUM (tmp.SummChangePercent) AS SummChangePercent
                          , SUM (tmp.Amount)            AS Amount
                          , SUM (tmp.TotalPay_Grn)      AS TotalPay_Grn
                          , SUM (tmp.TotalPay_USD)      AS TotalPay_USD
                          , SUM (tmp.TotalPay_EUR)      AS TotalPay_EUR
                          , SUM (tmp.TotalPay_Card)     AS TotalPay_Card
                          , SUM (tmp.TotalPay)          AS TotalPay
                          , SUM (tmp.Debt)              AS Debt
                     FROM (SELECT tmp.MovementId
                                , tmp.MovementDescId
                                , tmp.StatusCode
                                , tmp.OperDate
                                , tmp.InvNumber
                                , tmp.MovementId_Sale
                                , tmp.MovementDescId_Sale
                                , tmp.OperDate_Sale
                                , tmp.InvNumber_Sale
                                , tmp.UnitId
                                , tmp.ClientId
                                , tmp.GoodsId
                                , tmp.PartionId
                                , tmp.MI_Id
                                , tmpDebt.MI_Id AS MI_Id_Partion
                                , tmp.ChangePercent
                                , tmp.ChangePercentNext
                                , tmp.OperPriceList
                                , tmpMI_Child.CurrencyValue
                                , tmpMI_Child.CurrencyId
                                , (tmp.SummChangePercent) AS SummChangePercent
                                , (tmp.Amount)            AS Amount
                                --, (tmp.TotalPay)          AS TotalPay
                                , (tmpMI_Child.Pay_Child * (CASE WHEN tmp.MovementDescId = zc_Movement_ReturnIn() THEN -1 ELSE 1 END)) :: TFloat  AS TotalPay
                                , (tmpDebt.Debt)          AS Debt
                                , (tmpMI_Child.Amount_GRN * (CASE WHEN tmp.MovementDescId = zc_Movement_ReturnIn() THEN -1 ELSE 1 END)) :: TFloat AS TotalPay_Grn
                                , (tmpMI_Child.Amount_USD * (CASE WHEN tmp.MovementDescId = zc_Movement_ReturnIn() THEN -1 ELSE 1 END)) :: TFloat AS TotalPay_USD
                                , (tmpMI_Child.Amount_EUR * (CASE WHEN tmp.MovementDescId = zc_Movement_ReturnIn() THEN -1 ELSE 1 END)) :: TFloat AS TotalPay_EUR
                                , (tmpMI_Child.Amount_Bank* (CASE WHEN tmp.MovementDescId = zc_Movement_ReturnIn() THEN -1 ELSE 1 END)) :: TFloat AS TotalPay_Card
                                  -- № п/п
                                , ROW_NUMBER() OVER (PARTITION BY tmp.PartionId, tmp.ClientId, tmp.GoodsId, COALESCE (tmpDebt.MI_Id, 0)) AS Ord

                           FROM tmpData_MI AS tmp
                                LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmp.MI_Id
                                LEFT JOIN tmpDebt ON tmpDebt.PartionId = tmp.PartionId
                                                 AND tmpDebt.ClientId  = tmp.ClientId
                                                 AND tmpDebt.GoodsId   = tmp.GoodsId
                                                 --AND tmpDebt.MI_Id     = tmp.MI_Id
                           WHERE COALESCE (tmp.TotalPay, 0) <> 0 OR tmp.SummChangePercent <> 0
                       UNION ALL
                           SELECT tmp.MovementId
                                , tmp.MovementDescId
                                , tmp.StatusCode
                                , tmp.OperDate
                                , tmp.InvNumber
                                , 0 AS MovementId_Sale
                                , 0 AS MovementDescId_Sale
                                , NULL :: TDateTime AS OperDate_Sale
                                , ''   :: Tvarchar  AS InvNumber_Sale
                                , tmp.UnitId
                                , tmp.ClientId
                                , -1 AS GoodsId
                                , 0  AS PartionId
                                , 0  AS MI_Id
                                , 0  AS MI_Id_Partion
                                , 0    :: TFloat    AS ChangePercent
                                , 0    :: TFloat    AS ChangePercentNext
                                , 0    :: TFloat    AS OperPriceList
                                , tmpMI_Child_Exc.CurrencyValue
                                , tmpMI_Child_Exc.CurrencyId
                                , 0    :: TFloat    AS SummChangePercent
                                , 0    :: TFloat    AS Amount
                                , 0    :: TFloat    AS TotalPay
                                , 0    :: TFloat    AS Debt
                                , (tmpMI_Child_Exc.Amount_GRN * CASE WHEN tmp.MovementDescId = zc_Movement_ReturnIn() THEN -1 ELSE 1 END) :: TFloat AS TotalPay_Grn
                                , (tmpMI_Child_Exc.Amount_USD * CASE WHEN tmp.MovementDescId = zc_Movement_ReturnIn() THEN -1 ELSE 1 END) :: TFloat AS TotalPay_USD
                                , (tmpMI_Child_Exc.Amount_EUR * CASE WHEN tmp.MovementDescId = zc_Movement_ReturnIn() THEN -1 ELSE 1 END) :: TFloat AS TotalPay_EUR
                                , 0    :: TFloat    AS TotalPay_Card
                                  -- № п/п
                                , 0 AS Ord

                           FROM (SELECT DISTINCT tmp.MovementId
                                      , tmp.MovementDescId
                                      , tmp.StatusCode
                                      , tmp.OperDate
                                      , tmp.InvNumber
                                      , tmp.UnitId
                                      , tmp.ClientId
                                 FROM tmpData_MI AS tmp
                                ) AS tmp
                                INNER JOIN tmpMI_Child AS tmpMI_Child_Exc
                                                       ON tmpMI_Child_Exc.MovementId = tmp.MovementId
                                                      AND tmpMI_Child_Exc.ParentId   = 0
                                 ) AS tmp
                      GROUP BY tmp.MovementId
                             , tmp.MovementDescId
                             , tmp.StatusCode
                             , tmp.OperDate
                             , tmp.InvNumber
                             , tmp.MovementId_Sale
                             , tmp.MovementDescId_Sale
                             , tmp.OperDate_Sale
                             , tmp.InvNumber_Sale
                             , tmp.UnitId
                             , tmp.ClientId
                             , tmp.PartionId
                             , tmp.MI_Id
                             , tmp.MI_Id_Partion
                             , tmp.Ord
                             , tmp.ChangePercent
                             , tmp.ChangePercentNext
                             , tmp.OperPriceList
                             , tmp.GoodsId
                             , tmp.CurrencyValue
                             , tmp.CurrencyId
              )
    -- ???сворачиваем по продажам и возвратам???
  , tmp_All AS (SELECT CASE WHEN tmp.GoodsId <> -1 THEN 1 ELSE 2 END AS NumGroup
                     , tmp.MovementId
                     , tmp.MovementDescId
                     , tmp.StatusCode
                     , tmp.OperDate
                     , tmp.InvNumber
                     , tmp.MovementId_Sale       AS MovementId_Sale
                     , tmp.MovementDescId_Sale   AS MovementDescId_Sale
                     , tmp.OperDate_Sale         AS OperDate_Sale
                     , tmp.InvNumber_Sale        AS InvNumber_Sale
                     , tmp.UnitId                AS UnitId
                     , tmp.ClientId              AS ClientId
                     , tmp.PartionId             AS PartionId
                     , tmp.MI_Id                 AS MI_Id
                     , tmp.MI_Id_Partion         AS MI_Id_Partion
                     , tmp.ChangePercent         AS ChangePercent
                     , tmp.ChangePercentNext     AS ChangePercentNext
                     , tmp.OperPriceList         AS OperPriceList
                     , tmp.GoodsId
                     , tmp.CurrencyValue
                     , tmp.CurrencyId
                     , SUM (tmp.SummChangePercent) AS SummChangePercent
                     , SUM (tmp.Amount)            AS Amount
                     , SUM (tmp.TotalPay_Grn)      AS TotalPay_Grn
                     , SUM (tmp.TotalPay_USD)      AS TotalPay_USD
                     , SUM (tmp.TotalPay_EUR)      AS TotalPay_EUR
                     , SUM (tmp.TotalPay_Card)     AS TotalPay_Card
                     , SUM (tmp.TotalPay)          AS TotalPay
                     , SUM (CASE WHEN tmp.Ord = 1 THEN tmp.Debt ELSE 0 END) AS Debt
                     , ROW_NUMBER() OVER (PARTITION BY tmp.MovementId, tmp.MI_Id ORDER BY tmp.MovementId, tmp.MI_Id DESC) AS Ord
                FROM tmpData AS tmp
                GROUP BY CASE WHEN tmp.GoodsId <> -1 THEN 1 ELSE 2 END
                     , tmp.MovementId
                     , tmp.MovementDescId
                     , tmp.StatusCode
                     , tmp.OperDate
                     , tmp.InvNumber
                     , tmp.MovementId_Sale
                     , tmp.MovementDescId_Sale
                     , tmp.OperDate_Sale
                     , tmp.InvNumber_Sale
                     , tmp.UnitId 
                     , tmp.ClientId
                     , tmp.PartionId
                     , tmp.MI_Id
                     , tmp.MI_Id_Partion
                     , tmp.ChangePercent
                     , tmp.ChangePercentNext
                     , tmp.OperPriceList
                     , tmp.GoodsId
                     , tmp.CurrencyValue
                     , tmp.CurrencyId
             )

  ---
  SELECT tmpData.MovementId     ::Integer
             , tmpData.StatusCode     ::Integer         AS StatusCode
             , MovementDesc.ItemName  ::TVarChar        AS DescName
             , tmpData.OperDate       ::TDateTime       AS OperDate
             , tmpData.InvNumber      ::TVarChar        AS InvNumber
             , tmpData.MovementId_Sale ::Integer        AS MovementId_Sale
             , MovementDesc_Sale.ItemName   ::TVarChar  AS DescName_Sale
             , tmpData.OperDate_Sale  ::TDateTime       AS OperDate_Sale
             , tmpData.InvNumber_Sale ::TVarChar        AS InvNumber_Sale

             , Object_Unit.ValueData          AS UnitName
             , Object_Client.ValueData        AS ClientName
             , tmpData.PartionId              AS PartionId
             , tmpData.MI_Id                  AS MI_Id
             , tmpData.MI_Id_Partion          AS MI_Id_Partion
             , Object_Goods.Id                AS GoodsId
             , Object_Goods.ObjectCode        AS GoodsCode
             , CASE WHEN tmpData.GoodsId <> -1 THEN Object_Goods.ValueData ELSE 'Обмен' END ::TVarChar  AS GoodsName
             , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , (COALESCE (ObjectString_GoodsGroupFull.ValueData, '') || ' - ' || COALESCE (Object_GoodsInfo.ValueData, '')) :: TVarChar AS NameFull
             , Object_GoodsGroup.ValueData    AS GoodsGroupName
             , Object_Composition.ValueData   AS CompositionName
             , Object_GoodsInfo.ValueData     AS GoodsInfoName
             , Object_LineFabrica.ValueData   AS LineFabricaName
             , Object_Label.ValueData         AS LabelName
             , Object_GoodsSize.Id            AS GoodsSizeId
             , Object_GoodsSize.ValueData     AS GoodsSizeName
             , Object_Brand.ValueData         AS BrandName
             , Object_Fabrika.ValueData       AS FabrikaName
             , Object_Period.ValueData        AS PeriodName
             , Object_PartionGoods.PeriodYear ::Integer
             
             , COALESCE (MovementBoolean_Offer.ValueData, FALSE) ::Boolean AS isOffer   -- примерка

             , tmpData.ChangePercent       ::TFloat
             , tmpData.ChangePercentNext   ::TFloat
             , tmpData.OperPriceList       ::TFloat
             , CASE WHEN tmpData.Ord = 1 THEN COALESCE (tmpData.SummChangePercent, 0)  ELSE 0 END :: TFloat AS SummChangePercent
             , CASE WHEN tmpData.Ord = 1 THEN tmpData.Amount    ELSE 0 END                        :: TFloat AS Amount
             , CASE WHEN tmpData.Ord = 1 THEN zfCalc_SummPriceList (tmpData.Amount, tmpData.OperPriceList) ELSE 0 END :: TFloat AS TotalSummPriceList
             , tmpData.TotalPay_Grn        ::TFloat
             , tmpData.TotalPay_USD        ::TFloat
             , tmpData.TotalPay_EUR        ::TFloat
             , tmpData.TotalPay_Card       ::TFloat
             , COALESCE (tmpData.TotalPay, 0) ::TFloat  AS TotalPay
             , CASE WHEN tmpData.Ord = 1 THEN COALESCE (tmpData.Debt, 0) ELSE 0 END               :: TFloat  AS TotalDebt

             , tmpData.CurrencyValue           ::TFloat AS CurrencyValue

             , CASE WHEN tmpData.GoodsId <> -1 THEN Object_Currency.ValueData ELSE '' END :: TVarChar  AS CurrencyName
             
             , MovementDate_Insert.ValueData            AS InsertDate
               -- разные группы обмены и продажи
             , tmpData.NumGroup

             , CASE WHEN tmpData.NumGroup = 1
                         THEN tmpData.NumGroup   :: TVarChar
                    || '_' || tmpData.ClientId   :: TVarChar
                    || '_' || tmpData.PartionId  :: TVarChar
                    || '_' || zfConvert_FloatToString (tmpData.ChangePercent)
                    || '_' || zfConvert_FloatToString (tmpData.ChangePercentNext)
                    || '_' || zfConvert_FloatToString (tmpData.OperPriceList)
                    || '_' || CASE WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN MovementDesc.Id :: TVarChar ELSE '' END

                    ELSE zfConvert_FloatToString (tmpData.CurrencyValue)

               END :: TVarChar AS ValueGroup

        FROM tmp_All AS tmpData
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
            LEFT JOIN MovementDesc AS MovementDesc_Sale ON MovementDesc_Sale.Id = tmpData.MovementDescId_Sale

            LEFT JOIN Object AS Object_Unit   ON Object_Unit.Id   = tmpData.UnitId
            LEFT JOIN Object AS Object_Client ON Object_Client.Id = tmpData.ClientId
            LEFT JOIN Object AS Object_Goods  ON Object_Goods.Id  = tmpData.GoodsId

            LEFT JOIN Object AS Object_Currency  ON Object_Currency.Id  = tmpData.CurrencyId

            LEFT JOIN Object_PartionGoods      ON Object_PartionGoods.MovementItemId  = tmpData.PartionId

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId
            LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = Object_PartionGoods.FabrikaId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = tmpData.MovementId
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementBoolean AS MovementBoolean_Offer
                                      ON MovementBoolean_Offer.MovementId = tmpData.MovementId_Sale
                                     AND MovementBoolean_Offer.DescId = zc_MovementBoolean_Offer()
              ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.18         *               
 23.04.18         *
 12.02.18         *
 04.07.17         *
*/

-- тест
-- SELECT * FROM gpReport_GoodsMI_Account (inStartDate:= '01.04.2018', inEndDate:= '01.04.2018', inUnitId:= 506, inIsShowAll:= TRUE, inIsCurrency:= True, inSession:= zfCalc_UserAdmin()) -- WHERE ClientName like '%Шуваев%'
--select * from gpReport_GoodsMI_Account(inStartDate := ('25.10.2018')::TDateTime , inEndDate := ('01.11.2018')::TDateTime , inUnitId := 1531 , inIsShowAll := 'False' , inIsCurrency := 'False' ,  inSession := '8') as tt
--where tt.clientName like '%Капустин%'