-- Function:  gpReport_CollationByPartner()

DROP FUNCTION IF EXISTS gpReport_CollationByPartner (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CollationByClient (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CollationByClient (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inClientId        Integer  ,  -- Покупатель
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Text_info             TVarChar
             , NumGroup              Integer
             , MovementId            Integer
             , Invnumber             TVarChar
             , MovementDescName      TVarChar
             , OperDate              TDateTime

             , PartionId          Integer

             , Amount_PartionMI     TFloat
             , OperDate_PartionMI   TDateTime
             , InsertDate_PartionMI TDateTime
             , InvNumber_PartionMI  TVarChar
             , isOffer              Boolean

             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , MeasureName        TVarChar
             , CompositionGroupName TVarChar
             , CompositionName    TVarChar
             , GoodsInfoName      TVarChar
             , LineFabricaName    TVarChar
             , LabelName          TVarChar
             , GoodsSizeId Integer, GoodsSizeName    TVarChar
             , CurrencyName       TVarChar
             , BrandName          TVarChar
             , FabrikaName        TVarChar
             , PeriodName         TVarChar
             , PeriodYear         Integer

             , AmountStart     TFloat
             , AmountIn        TFloat
             , AmountOut       TFloat
             , AmountEnd       TFloat
             , SummStart       TFloat
             , SummIn          TFloat
             , SummOut         TFloat
             , SummEnd         TFloat

             , TotalPay_Grn TFloat
             , TotalPay_USD TFloat
             , TotalPay_Eur TFloat
             , TotalPay_Card TFloat

             , SummChangePercent_Calc TFloat
             , TotalChangePercent     TFloat
             , SummChangePercent      TFloat
             , OperPriceList          TFloat
             , ChangePercent          TFloat
             , ChangePercentNext      TFloat
             , SummDebt               TFloat
  )
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbEndDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    vbEndDate := inEndDate + INTERVAL '1 DAY';


    -- проверка может ли смотреть любой магазин, или только свой
    PERFORM lpCheckUnit_byUser (inUnitId_by:= inUnitId, inUserId:= vbUserId);


    -- Результат
    RETURN QUERY
    WITH
    -- выбираю все контейнеры по покупателю и подразделению , если выбрано
    tmpContainer AS (SELECT Container.Id                    AS ContainerId
                          , Container.DescId                AS ContainerDescId
                          , CLO_Client.ObjectId             AS ClientId
                          , CASE WHEN Container.DescId = zc_Container_Count() THEN Container.ObjectId ELSE CLO_Goods.ObjectId END  AS GoodsId
                          , Container.PartionId             AS PartionId
                          , CLO_PartionMI.ObjectId          AS PartionId_MI
                          , Container.Amount
                     FROM Container
                          INNER JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                        AND CLO_Client.ObjectId    = inClientId                            --inClientId --Перцева Наталья 6343  --
                          INNER JOIN ContainerLinkObject AS CLO_Unit
                                                         ON CLO_Unit.ContainerId = Container.Id
                                                        AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                        AND (CLO_Unit.ObjectId    = inUnitId OR inUnitId = 0)
                          LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                        ON CLO_Goods.ContainerId = Container.Id
                                                       AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                          LEFT JOIN ContainerLinkObject AS CLO_PartionMI
                                                        ON CLO_PartionMI.ContainerId = Container.Id
                                                       AND CLO_PartionMI.DescId      = zc_ContainerLinkObject_PartionMI()
                      -- !!!кроме Покупатели + Прибыль будущих периодов!!!
                      WHERE Container.ObjectId <> zc_Enum_Account_20102()
                    )
  -- привязываем движение за выбранный период
  , tmpMIContainer_All AS (SELECT tmpContainer.ContainerId
                            , tmpContainer.GoodsId
                            , tmpContainer.PartionId
                            , tmpContainer.PartionId_MI
                            , tmpContainer.ContainerDescId
                            , tmpContainer.Amount
                            , MIContainer.OperDate
                            , MIContainer.MovementId
                            , MIContainer.MovementDescId
                            , MIContainer.DescId
                            , COALESCE (MIContainer.AnalyzerId, 0) AS AnalyzerId
                            , MIContainer.MovementItemId
                            , MIContainer.Amount AS Amount_MI
                       FROM tmpContainer
                            LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                          AND MIContainer.OperDate    >= inStartDate
                      )
  , tmpMIContainer AS (SELECT tmpContainer.ContainerId
                            , tmpContainer.GoodsId
                            , tmpContainer.PartionId
                            , tmpContainer.PartionId_MI
                            , tmpContainer.OperDate

                            , CASE WHEN tmpContainer.ContainerDescId = zc_Container_Count()
                                   THEN tmpContainer.Amount
                                   ELSE 0
                              END AS Amount
                            , CASE WHEN tmpContainer.ContainerDescId = zc_Container_Summ()
                                   THEN tmpContainer.Amount
                                   ELSE 0
                              END AS AmountSumm

                            , tmpContainer.MovementId     AS MovementId
                            , tmpContainer.MovementDescId AS MovementDescId
                            , tmpContainer.AnalyzerId

                              -- нужен Только для движения За период
                            , CASE WHEN (tmpContainer.OperDate BETWEEN inStartDate AND inEndDate)
                                      THEN tmpContainer.MovementItemId
                                   ELSE 0
                              END AS MovementItemId

                              -- Кол-во за ПЕРИОД
                            , CASE WHEN tmpContainer.OperDate BETWEEN inStartDate AND inEndDate AND tmpContainer.DescId = zc_MIContainer_Count()
                                        THEN tmpContainer.Amount_MI
                                   ELSE 0
                              END AS Amount_Period
                              -- Кол-во почти ИТОГО
                            , CASE WHEN tmpContainer.DescId = zc_MIContainer_Count()
                                      THEN tmpContainer.Amount_MI
                                   ELSE 0
                              END AS Amount_Total

                              -- сумма за ПЕРИОД
                            , CASE WHEN tmpContainer.OperDate BETWEEN inStartDate AND inEndDate AND tmpContainer.DescId = zc_MIContainer_Summ()
                                        THEN tmpContainer.Amount_MI
                                   ELSE 0
                              END AS Summ_Period
                              -- сумма почти ИТОГО
                            , CASE WHEN tmpContainer.DescId = zc_MIContainer_Summ()
                                        THEN tmpContainer.Amount_MI
                                   ELSE 0
                              END AS Summ_Total

                       FROM tmpMIContainer_All AS tmpContainer
                      )
  , tmpMotion AS (SELECT tmp.OperDate
                       , tmp.GoodsId
                       , tmp.PartionId
                       , tmp.PartionId_MI
                       , tmp.MovementId
                       , tmp.ContainerId
                       , SUM(tmp.AmountSumm) AS AmountSumm
                       , SUM (tmp.SummIn - tmp.SummOut) AS SummDebt
                  FROM (SELECT tmpMIContainer.ContainerId
                             , tmpMIContainer.MovementId
                             , tmpMIContainer.MovementItemId
                             , tmpMIContainer.GoodsId
                             , tmpMIContainer.PartionId
                             , tmpMIContainer.PartionId_MI
                             , tmpMIContainer.OperDate
                             , tmpMIContainer.AmountSumm
                             , CASE WHEN tmpMIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount(), zc_Movement_ReturnIn())
                                     AND tmpMIContainer.AnalyzerId     > 0
                                         THEN 1 * tmpMIContainer.Summ_Period
                                    WHEN tmpMIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount(), zc_Movement_ReturnIn())
                                         THEN 0
                                    WHEN tmpMIContainer.Summ_Period > 0
                                         THEN 1 * tmpMIContainer.Summ_Period
                                    ELSE 0
                               END AS SummIn
                             , CASE WHEN tmpMIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount(), zc_Movement_ReturnIn())
                                     AND tmpMIContainer.AnalyzerId     = 0
                                         THEN -1 * tmpMIContainer.Summ_Period
                                    WHEN tmpMIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount(), zc_Movement_ReturnIn())
                                         THEN 0
                                    WHEN tmpMIContainer.Summ_Period < 0
                                         THEN -1 * tmpMIContainer.Summ_Period
                                    ELSE 0
                               END AS SummOut
                        FROM tmpMIContainer
                        WHERE tmpMIContainer.Summ_Period <> 0
                        ) AS tmp
                  GROUP BY tmp.OperDate
                         , tmp.GoodsId
                         , tmp.PartionId
                         , tmp.PartionId_MI
                         , tmp.MovementId
                         , tmp.ContainerId
                 )

  , tmpDebt AS (SELECT tmp.OperDate
                     , tmp.GoodsId
                     , tmp.PartionId
                     , tmp.PartionId_MI
                     , tmp.MovementId
                     , SUM(tmp.SummDebt) AS SummDebt
                FROM (SELECT tmp.OperDate
                           , tmp.GoodsId
                           , tmp.PartionId
                           , tmp.PartionId_MI
                           , tmp.MovementId
                           , (tmp.SummDebt - SUM (CASE WHEN tmp2.OperDate >= tmp.OperDate THEN COALESCE (tmp2.SummDebt,0) ELSE 0 END) )  AS SummDebt
                      FROM tmpMotion AS tmp
                           LEFT JOIN tmpMotion AS tmp2 ON tmp2.ContainerId = tmp.ContainerId
                                                      --AND tmp2.OperDate <= tmp.OperDate
                      GROUP BY tmp.OperDate
                             , tmp.GoodsId
                             , tmp.PartionId
                             , tmp.PartionId_MI
                             , tmp.MovementId
                             , tmp.SummDebt 
                      ) AS tmp 
                GROUP BY tmp.OperDate
                       , tmp.GoodsId
                       , tmp.PartionId
                       , tmp.PartionId_MI
                       , tmp.MovementId
                )

    -- "собрали" данные нач / конечн. остатки и движение - в одну строку
  , tmpMIContainer_group AS (SELECT tmpMIContainer_all.Text_info
                                  , tmpMIContainer_all.NumGroup
                                  , tmpMIContainer_all.MovementId
                                  , tmpMIContainer_all.MovementItemId
                                  , tmpMIContainer_all.GoodsId
                                  , tmpMIContainer_all.PartionId
                                  , tmpMIContainer_all.PartionId_MI

                                  , SUM (tmpMIContainer_all.AmountStart)      AS AmountStart
                                  , SUM (tmpMIContainer_all.AmountEnd)        AS AmountEnd
                                  , SUM (tmpMIContainer_all.AmountIn)         AS AmountIn
                                  , SUM (tmpMIContainer_all.AmountOut)        AS AmountOut

                                  , SUM (tmpMIContainer_all.SummStart)        AS SummStart
                                  , SUM (tmpMIContainer_all.SummEnd)          AS SummEnd
                                  , SUM (tmpMIContainer_all.SummIn)           AS SummIn
                                  , SUM (tmpMIContainer_all.SummOut)          AS SummOut

                              FROM ( -- 1.1. Остатки начальные
                                    SELECT 'Долг начальный'  AS Text_info
                                         , 1 AS NumGroup
                                         , 0 AS MovementId
                                         , 0 AS MovementItemId
                                         , tmpMIContainer.GoodsId
                                         , tmpMIContainer.PartionId
                                         , tmpMIContainer.PartionId_MI

                                         , tmpMIContainer.Amount - SUM (tmpMIContainer.Amount_Total)   AS AmountStart
                                         , 0 AS AmountEnd
                                         , 0 AS AmountIn
                                         , 0 AS AmountOut
                                         , tmpMIContainer.AmountSumm - SUM (tmpMIContainer.Summ_Total) AS SummStart
                                         , 0 AS SummEnd
                                         , 0 AS SummIn
                                         , 0 AS SummOut
                                    FROM tmpMIContainer
                                    GROUP BY tmpMIContainer.ContainerId
                                           , tmpMIContainer.Amount
                                           , tmpMIContainer.AmountSumm
                                           , tmpMIContainer.GoodsId
                                           , tmpMIContainer.PartionId
                                           , tmpMIContainer.PartionId_MI
                                    HAVING (tmpMIContainer.Amount     - SUM (tmpMIContainer.Amount_Total)) <> 0
                                        OR (tmpMIContainer.AmountSumm - SUM (tmpMIContainer.Summ_Total))   <> 0

                                   UNION ALL
                                    -- 1.2. Остатки конечные
                                    SELECT 'Долг конечный'   AS Text_info
                                         , 3 AS NumGroup
                                         , 0 AS MovementId--, tmpMIContainer.MovementId
                                         , 0 AS MovementItemId
                                         , tmpMIContainer.GoodsId
                                         , tmpMIContainer.PartionId
                                         , tmpMIContainer.PartionId_MI

                                         , 0 AS AmountStart
                                         , tmpMIContainer.Amount - SUM (tmpMIContainer.Amount_Total) + SUM (tmpMIContainer.Amount_Period) AS AmountEnd
                                         , 0 AS AmountIn
                                         , 0 AS AmountOut
                                         , 0 AS SummStart
                                         , tmpMIContainer.AmountSumm - SUM (tmpMIContainer.Summ_Total) + SUM (tmpMIContainer.Summ_Period) AS SummEnd
                                         , 0 AS SummIn
                                         , 0 AS SummOut
                                    FROM tmpMIContainer
                                    GROUP BY tmpMIContainer.ContainerId
                                           , tmpMIContainer.Amount
                                           , tmpMIContainer.AmountSumm
                                           , tmpMIContainer.GoodsId
                                           , tmpMIContainer.PartionId
                                           , tmpMIContainer.PartionId_MI
                                    HAVING (tmpMIContainer.Amount     - SUM (tmpMIContainer.Amount_Total) + SUM (tmpMIContainer.Amount_Period)) <> 0
                                        OR (tmpMIContainer.AmountSumm - SUM (tmpMIContainer.Summ_Total)   + SUM (tmpMIContainer.Summ_Period))   <> 0

                                   UNION ALL
                                    -- 1.3. Движение за период
                                    SELECT 'Движение'        AS Text_info
                                         , 2 AS NumGroup
                                         , tmpMIContainer.MovementId
                                         , tmpMIContainer.MovementItemId
                                         , tmpMIContainer.GoodsId
                                         , tmpMIContainer.PartionId
                                         , tmpMIContainer.PartionId_MI

                                         , 0 AS AmountStart
                                         , 0 AS AmountEnd

                                         , CASE WHEN tmpMIContainer.Amount_Period > 0 THEN  1 * tmpMIContainer.Amount_Period ELSE 0 END AS AmountIn
                                         , CASE WHEN tmpMIContainer.Amount_Period < 0 THEN -1 * tmpMIContainer.Amount_Period ELSE 0 END AS AmountOut

                                         , 0 AS SummStart
                                         , 0 AS SummEnd
                                         , CASE WHEN tmpMIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount(), zc_Movement_ReturnIn())
                                                 AND tmpMIContainer.AnalyzerId     > 0
                                                     THEN 1 * tmpMIContainer.Summ_Period
                                                WHEN tmpMIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount(), zc_Movement_ReturnIn())
                                                     THEN 0
                                                WHEN tmpMIContainer.Summ_Period > 0
                                                     THEN 1 * tmpMIContainer.Summ_Period
                                                ELSE 0
                                           END AS SummIn
                                         , CASE WHEN tmpMIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount(), zc_Movement_ReturnIn())
                                                 AND tmpMIContainer.AnalyzerId     = 0
                                                     THEN -1 * tmpMIContainer.Summ_Period
                                                WHEN tmpMIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount(), zc_Movement_ReturnIn())
                                                     THEN 0
                                                WHEN tmpMIContainer.Summ_Period < 0
                                                     THEN -1 * tmpMIContainer.Summ_Period
                                                ELSE 0
                                           END AS SummOut

                                    FROM tmpMIContainer
                                    WHERE tmpMIContainer.Amount_Period <> 0
                                       OR tmpMIContainer.Summ_Period   <> 0
                                   ) AS tmpMIContainer_all

                              GROUP BY tmpMIContainer_all.Text_info
                                     , tmpMIContainer_all.NumGroup
                                     , tmpMIContainer_all.MovementId
                                     , tmpMIContainer_all.MovementItemId
                                     , tmpMIContainer_all.GoodsId
                                     , tmpMIContainer_all.PartionId
                                     , tmpMIContainer_all.PartionId_MI
                             )
    -- выбираем оплаты для документов движения
    , tmpMI_Child AS (SELECT tmpMovement.MovementId
                           , MovementItem.ParentId
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN MovementItem.Amount ELSE 0 END) AS Amount_GRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END) AS Amount_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END) AS Amount_EUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END) AS Amount_Bank

                      FROM (SELECT DISTINCT tmpMIContainer.MovementId
                            FROM tmpMIContainer
                            WHERE tmpMIContainer.Amount_Period <> 0
                               OR tmpMIContainer.Summ_Period <> 0
                            ) AS tmpMovement
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
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
                      GROUP BY tmpMovement.MovementId
                             , MovementItem.ParentId
                     )

   SELECT tmpData.Text_info :: TVarChar
        , tmpData.NumGroup
        , Movement.Id                    AS MovementId
        , Movement.InvNumber             AS InvNumber
        , MovementDesc.ItemName          AS MovementDescName
        , Movement.OperDate              AS OperDate

        , tmpData.PartionId              AS PartionId

        , MI_PartionMI.Amount            AS Amount_PartionMI
        , Movement_PartionMI.OperDate    AS OperDate_PartionMI
        , MovementDate_Insert.ValueData  AS InsertDate_PartionMI
        , Movement_PartionMI.InvNumber   AS InvNumber_PartionMI
        , COALESCE (MovementBoolean_Offer.ValueData, FALSE)  ::Boolean AS isOffer   -- примерка

        , Object_Goods.Id                AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , Object_Goods.ValueData         AS GoodsName
        , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , Object_Measure.ValueData       AS MeasureName
        , Object_CompositionGroup.ValueData   AS CompositionGroupName
        , Object_Composition.ValueData   AS CompositionName
        , Object_GoodsInfo.ValueData     AS GoodsInfoName
        , Object_LineFabrica.ValueData   AS LineFabricaName
        , Object_Label.ValueData         AS LabelName
        , Object_GoodsSize.Id            AS GoodsSizeId
        , COALESCE (Object_GoodsSize.ValueData, '') :: TVarChar     AS GoodsSizeName
        , Object_Currency.ValueData      AS CurrencyName
        , Object_Brand.ValueData         AS BrandName
        , Object_Fabrika.ValueData       AS FabrikaName
        , Object_Period.ValueData        AS PeriodName
        , Object_PartionGoods.PeriodYear ::Integer

        , CAST (tmpData.AmountStart AS TFloat) AS AmountStart
        , CAST (tmpData.AmountIn AS TFloat)    AS AmountIn
        , CAST (tmpData.AmountOut AS TFloat)   AS AmountOut
        , CAST (tmpData.AmountEnd AS TFloat)   AS AmountEnd

        , CAST (tmpData.SummStart AS TFloat)   AS SummStart
        , CAST (tmpData.SummIn AS TFloat)      AS SummIn
        , CAST (tmpData.SummOut AS TFloat)     AS SummOut
        , CAST (tmpData.SummEnd AS TFloat)     AS SummEnd

        -- оплаты
        , (tmpMI_Child.Amount_GRN  * CASE WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN -1 ELSE 1 END)       :: TFloat AS TotalPay_Grn
        , (tmpMI_Child.Amount_USD  * CASE WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN -1 ELSE 1 END)       :: TFloat AS TotalPay_USD
        , (tmpMI_Child.Amount_EUR  * CASE WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN -1 ELSE 1 END)       :: TFloat AS TotalPay_EUR
        , (tmpMI_Child.Amount_Bank * CASE WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN -1 ELSE 1 END)       :: TFloat AS TotalPay_Card

        --сумма скидки по % скидки док. продажи
        , ( (zfCalc_SummPriceList ((tmpData.AmountIn+tmpData.AmountOut), MIFloat_OperPriceList.ValueData) 
           - zfCalc_SummChangePercentNext(tmpData.AmountIn+tmpData.AmountOut
                                        , MIFloat_OperPriceList.ValueData
                                        , COALESCE (MIFloat_ChangePercent.ValueData, 0)
                                        , COALESCE (MIFloat_ChangePercentNext.ValueData, 0) ) 
             )
           * CASE WHEN MovementDesc.Id IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN 1
                  WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN (-1)
             END)                                                   :: TFloat   AS SummChangePercent_Calc
        --Итого сумма Скидки (в ГРН)
        , (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) * CASE WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN -1 ELSE 1 END)       :: TFloat   AS TotalChangePercent
        --Сумма дополнительной Скидки (в ГРН)
        , (CASE WHEN MovementDesc.Id IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN COALESCE (MIFloat_SummChangePercent.ValueData, 0)
                WHEN MovementDesc.Id = zc_Movement_ReturnIn() THEN (-1) * (COALESCE (MIFloat_SummChangePercent_Sale.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0))
           END)                                                     :: TFloat   AS SummChangePercent

        -- цена из партии док. продажи
        , COALESCE (MIFloat_OperPriceList.ValueData, 0)             :: TFloat   AS OperPriceList
        -- % скидки из партии док. продажи
        , COALESCE (MIFloat_ChangePercent.ValueData, 0)             :: TFloat   AS ChangePercent
        , COALESCE (MIFloat_ChangePercentNext.ValueData, 0)         :: TFloat   AS ChangePercentNext

        , (CASE WHEN tmpData.NumGroup = 2 
                  THEN tmpDebt.SummDebt
                  ELSE (tmpData.SummStart + tmpData.SummEnd)
             END)                                             :: TFloat   AS SummDebt

   FROM tmpMIContainer_group AS tmpData
        LEFT JOIN Movement ON Movement.Id = tmpData.MovementId
        LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

        LEFT JOIN Object_PartionGoods      ON Object_PartionGoods.MovementItemId  = tmpData.PartionId

        LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = Object_PartionGoods.GoodsId
        LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
        LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
        LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
        LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
        LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
        LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
        LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
        LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
        LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = Object_PartionGoods.CurrencyId
        LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
        LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId
        LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = Object_PartionGoods.FabrikaId

        LEFT JOIN Object AS Object_PartionMI     ON Object_PartionMI.Id     = tmpData.PartionId_MI
        LEFT JOIN MovementItem AS MI_PartionMI   ON MI_PartionMI.Id         = Object_PartionMI.ObjectCode
        LEFT JOIN Movement AS Movement_PartionMI ON Movement_PartionMI.Id   = MI_PartionMI.MovementId

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_PartionMI.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        --LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_PartionMI.DescId

        LEFT JOIN MovementBoolean AS MovementBoolean_Offer
                                  ON MovementBoolean_Offer.MovementId = Movement_PartionMI.Id
                                 AND MovementBoolean_Offer.DescId = zc_MovementBoolean_Offer()

        LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                               ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

        LEFT JOIN tmpMI_Child ON tmpMI_Child.MovementId = tmpData.MovementId
                             AND tmpMI_Child.ParentId   = tmpData.MovementItemId


        LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                    ON MIFloat_OperPriceList.MovementItemId = MI_PartionMI.Id
                                   AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
        LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                    ON MIFloat_ChangePercent.MovementItemId = MI_PartionMI.Id
                                   AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
        LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                    ON MIFloat_ChangePercentNext.MovementItemId = MI_PartionMI.Id
                                   AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()

        LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                    ON MIFloat_SummChangePercent.MovementItemId = tmpData.MovementItemId
                                   AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
        LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                    ON MIFloat_TotalChangePercent.MovementItemId = tmpData.MovementItemId
                                   AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
        -- Сумма дополнительной Скидки (в ГРН) в док. партии продажи
        LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_Sale
                                    ON MIFloat_SummChangePercent_Sale.MovementItemId = MI_PartionMI.Id
                                   AND MIFloat_SummChangePercent_Sale.DescId         = zc_MIFloat_SummChangePercent()
        -- Сумма дополнительной Скидки (в ГРН) в расчете док. партии продажи
        LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                    ON MIFloat_TotalChangePercentPay.MovementItemId = MI_PartionMI.Id
                                   AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()
        -- итого оплата грн
        LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                    ON MIFloat_TotalPay.MovementItemId = tmpData.MovementItemId
                                   AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

        LEFT JOIN tmpDebt ON tmpDebt.PartionId    = tmpData.PartionId
                         AND tmpDebt.PartionId_MI = tmpData.PartionId_MI
                         AND tmpDebt.MovementId   = tmpData.MovementId
                         AND tmpDebt.GoodsId      = Object_Goods.Id
                         AND tmpDebt.OperDate     = Movement.OperDate
       ;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 22.01.18         *
*/

-- тест
-- SELECT * FROM gpReport_CollationByClient (inStartDate:= '01.03.2017', inEndDate:= '31.03.2017', inUnitId:= 4195, inClientId:= 9765, inSession:= zfCalc_UserAdmin());
