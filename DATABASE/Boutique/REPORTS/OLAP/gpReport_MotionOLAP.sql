-- Function:  gpReport_MotionOLAP()

DROP FUNCTION IF EXISTS gpReport_MotionOLAP (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_MotionOLAP (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_MotionOLAP (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inPartnerId        Integer  ,  -- Покупатель
    IN inBrandId          Integer  ,  --
    IN inPeriodId         Integer  ,  --
    IN inGoodsId          Integer  ,  --
    IN inStartYear        Integer  ,
    IN inEndYear          Integer  ,
    IN inIsYear           Boolean  , -- ограничение Год ТМ (Да/Нет) (выбор партий)
    IN inIsPeriodAll      Boolean  , -- ограничение за Весь период (Да/Нет) (движение по Документам)
    IN inIsGoods          Boolean  , -- показать Товары (Да/Нет)
    IN inIsSize           Boolean  , -- показать Размеры (Да/Нет)
    IN inIsClient_doc     Boolean  , -- показать Покупателя (Да/Нет)
    IN inIsOperDate_doc   Boolean  , -- показать Год / Месяц (Да/Нет) (движение по Документам)
    IN inIsDay_doc        Boolean  , -- показать День недели (Да/Нет) (движение по Документам)
    IN inIsOperPrice      Boolean  , -- показать Цена вх. в вал. (Да/Нет)
    IN inIsDiscount       Boolean  , -- показать % скидки (Да/Нет)
    IN inIsMark           Boolean  , -- показать только отмеченные товары(Да/Нет)
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS TABLE (BrandName             VarChar (100)
             , PeriodName            VarChar (25)
             , PeriodYear            Integer
             , PartnerId             Integer
             , PartnerName           VarChar (100)

             , GoodsGroupName        TVarChar
             , LabelName             VarChar (100)
             , CompositionName       VarChar (50) -- TVarChar -- +

             , GoodsId               Integer
             , GoodsCode             Integer
             , GoodsName             VarChar (100)
             , GoodsInfoName         VarChar (100) -- TVarChar -- +
             , LineFabricaName       VarChar (50)  -- TVarChar -- +
             , GoodsSizeId           Integer
             , GoodsSizeName         VarChar (50)

             , PeriodName_doc        VarChar (25)
             , PeriodYear_doc        Integer
             , MonthName_doc         VarChar (25)
             , DayName_doc           VarChar (3)
             , UnitName              VarChar (100)
             , ClientName            VarChar (100)
             , DiscountSaleKindName  VarChar (15)
             , ChangePercent         TFloat
             , ChangePercentNext     TFloat

             , UnitName_In           VarChar (100)
             , CurrencyName          VarChar (10)
             , OperPrice             TFloat

               -- Приход - только для UnitId, и здесь вычитаем если было Списание или Возврат Поставщику - только для UnitId
             , Income_Amount         TFloat
             , Income_Summ           TFloat
               -- Приход - РЕАЛЬНЫЙ - только для UnitId, и здесь НЕ вычитаем если было Списание или Возврат Поставщику - только для UnitId
             , IncomeReal_Amount     TFloat
             , IncomeReal_Summ       TFloat

               -- Остаток - без учета "долга"
             , Remains_Amount        TFloat
             , Remains_Summ          TFloat
               -- Остаток - с учетом "долга"
             , Remains_Amount_real   TFloat

             , RemainsStart      TFloat
             , RemainsEnd        TFloat
             , RemainsStart_Summ TFloat
             , RemainsEnd_Summ TFloat
             , RemainsStart_Summ_curr TFloat
             , RemainsEnd_Summ_curr TFloat
             , RemainsStart_PriceListSumm TFloat
             , RemainsEnd_PriceListSumm TFloat
             , RemainsStart_PriceListSumm_curr TFloat
             , RemainsEnd_PriceListSumm_curr TFloat

               -- Перемещение
             , SendIn_Amount         TFloat
             , SendOut_Amount        TFloat
             , SendIn_Summ           TFloat
             , SendOut_Summ          TFloat

               -- Списание + Возврат поставщ.
             , Loss_Amount           TFloat
             , Loss_Summ             TFloat

               -- Кол-во Остаток - "долг"
             , Debt_Amount           TFloat
               -- Сумма Остаток - "долг"
             , Debt_Summ             TFloat

               -- Кол-во продажа - с учетом "долга"
             , Sale_Amount           TFloat
               -- Кол-во продажа - без учета "долга"
             , Sale_Amount_real      TFloat

               -- Кол-во продажа - ПО Сезонным скидкам
             , Result_InDiscount       TFloat
               -- Кол-во продажа - ДО Сезонных скидок
             , Result_OutDiscount      TFloat

             , Result_SummCost_curr_InD   TFloat
             , Result_SummCost_curr_OutD  TFloat
             , Result_Summ_InD            TFloat
             , Result_Summ_OutD           TFloat
             , Result_Summ_10200_InD      TFloat
             , Result_Summ_10200_OutD     TFloat

               -- Сумма продажа - без учета "долга"
             , Sale_Summ             TFloat
             , Sale_Summ_curr        TFloat

               -- С\с продажа - без учета "долга"
             , Sale_SummCost         TFloat -- calc из валюты в Грн
             , Sale_SummCost_curr    TFloat -- валюта

               -- Курс. разн продажа
             , Sale_SummCost_diff    TFloat
               -- Прибыль продажа с учетом курсовой разницы - без учета "долга"
             , Sale_Summ_prof        TFloat

             , Sale_Summ_10100       TFloat
             , Sale_Summ_10201       TFloat
             , Sale_Summ_10202       TFloat
             , Sale_Summ_10203       TFloat
             , Sale_Summ_10204       TFloat

               -- Скидка ИТОГО
             , Sale_Summ_10200       TFloat
             , Sale_Summ_10200_curr  TFloat

             , Return_Amount         TFloat

               -- Сумма возврат
             , Return_Summ           TFloat
             , Return_Summ_curr      TFloat

               -- С\с возврат
             , Return_SummCost        TFloat -- calc из валюты в Грн
             , Return_SummCost_curr   TFloat -- валюта

               -- Курс. разн возврат
             , Return_SummCost_diff   TFloat
               -- Убыток возврат
             , Return_Summ_prof       TFloat

               -- Скидка возврат
             , Return_Summ_10200      TFloat
             , Return_Summ_10200_curr TFloat

               -- Кол. Итог - с учетом "долга"
             , Result_Amount         TFloat
               -- Кол. Итог - без учета "долга"
             , Result_Amount_real    TFloat

               -- Сумма Итог - без учета "долга"
             , Result_Summ           TFloat
             , Result_Summ_curr      TFloat
               -- С\с Итог - без учета "долга"
             , Result_SummCost       TFloat -- calc из валюты в Грн
             , Result_SummCost_curr  TFloat -- валюта
               -- Курс. разн. Итог
             , Result_SummCost_diff  TFloat
               -- Прибыль Итог с учетом курсовой разницы - без учета "долга"
             , Result_Summ_prof      TFloat
             , Result_Summ_prof_curr TFloat

               -- Скидка Итог
             , Result_Summ_10200      TFloat
             , Result_Summ_10200_curr TFloat


               -- 1. % Продаж: кол-во продажи    / кол-во приход
             , Tax_Amount_calc1      TFloat
             , Tax_Amount_calc2      TFloat
             , Tax_Amount            TFloat

               -- 2.
             , Tax_Amount_real_calc1 TFloat
             , Tax_Amount_real_calc2 TFloat
             , Tax_Amount_real       TFloat

               -- 3. % Продаж: сумма с/с продажи / сумма с/с приход
             , Tax_Summ_curr_calc1   TFloat
             , Tax_Summ_curr_calc2   TFloat
             , Tax_Summ_curr         TFloat

               -- 4. % Рентабельности: сумма продажи / сумма с/с
             , Tax_Summ_prof_calc1   TFloat
             , Tax_Summ_prof_calc2   TFloat
             , Tax_Summ_prof         TFloat

             , GroupsName1           VarChar (50)
             , GroupsName2           VarChar (50)
             , GroupsName3           VarChar (50)
             , GroupsName4           VarChar (50)

             , isOLAP_Goods          VarChar (3)
             , isOLAP_Partion        VarChar (3)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!замена!!!
    IF inIsYear = TRUE AND COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;

    -- !!!замена!!!
    IF COALESCE (inBrandId, 0) = 0
       AND COALESCE (inPartnerId, 0) = 0
       -- ЕСТЬ - СПИСОК Brand - отмеченные для OLAP
       AND EXISTS (SELECT 1
                   FROM Object
                        INNER JOIN ObjectLink AS ObjectLink_Object
                                              ON ObjectLink_Object.ObjectId      = Object.Id
                                             AND ObjectLink_Object.DescId        = zc_ObjectLink_ReportOLAP_Object()
                        INNER JOIN ObjectLink AS ObjectLink_User
                                              ON ObjectLink_User.ObjectId      = Object.Id
                                             AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                             AND ObjectLink_User.ChildObjectId = vbUserId
                   WHERE Object.DescId      = zc_Object_ReportOLAP()
                     AND Object.ObjectCode  = zc_ReportOLAP_Brand()
                     AND Object.isErased    = FALSE
                  )
       -- НЕТ - СПИСОК Партий/Товаров - отмеченные для OLAP
       AND inIsMark = FALSE
    THEN
         inBrandId:= -1;
    END IF;


    -- таблица подразделений
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    IF COALESCE (inUnitId, 0) <> 0
    THEN
        --
        INSERT INTO _tmpUnit (UnitId)
          SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect
         ;
    ELSE
        --
        INSERT INTO _tmpUnit (UnitId)
          SELECT Object_Unit.Id FROM Object AS Object_Unit WHERE Object_Unit.DescId = zc_Object_Unit()
         ;
    END IF;


    -- Результат
    RETURN QUERY
      WITH 
           -- СПИСОК Партий/Товаров - отмеченные для OLAP
           tmpOLAP AS (SELECT ObjectLink_Object.ChildObjectId                                                AS ObjectId
                            , CASE WHEN Object.ObjectCode = zc_ReportOLAP_Goods()   THEN TRUE ELSE FALSE END AS isOlap_Goods
                            , CASE WHEN Object.ObjectCode = zc_ReportOLAP_Partion() THEN TRUE ELSE FALSE END AS isOlap_Partion
                       FROM Object
                            INNER JOIN ObjectLink AS ObjectLink_User
                                                  ON ObjectLink_User.ObjectId      = Object.Id
                                                 AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                 AND ObjectLink_User.ChildObjectId = vbUserId
                            INNER JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ObjectId = Object.Id
                                                 AND ObjectLink_Object.DescId   = zc_ObjectLink_ReportOLAP_Object()
                       WHERE Object.DescId     = zc_Object_ReportOLAP()
                         AND Object.ObjectCode IN (zc_ReportOLAP_Goods(), zc_ReportOLAP_Partion())
                         AND Object.isErased   = FALSE
                      )
            -- Товары отмеченные для OLAP -> получаем Партии
          , tmpOLAP_goods AS (SELECT DISTINCT Object_PartionGoods.MovementItemId AS PartionId
                              FROM tmpOLAP
                                   INNER JOIN Object_PartionGoods ON Object_PartionGoods.GoodsId = tmpOLAP.ObjectId
                              WHERE tmpOLAP.isOlap_Goods = TRUE
                             )
          -- Партии отмеченные для OLAP
        , tmpOLAP_partion AS (SELECT DISTINCT tmpOLAP.ObjectId AS PartionId
                              FROM tmpOLAP
                              WHERE tmpOLAP.isOlap_Partion = TRUE
                             )
              -- Партии для OLAP
            , tmpOLAP_all AS (SELECT tmpOLAP_goods.PartionId    AS PartionId
                                  , 1                           AS Olap_Goods
                                  , 0                           AS Olap_Partion
                              FROM tmpOLAP_goods
                             UNION
                              SELECT tmpOLAP_partion.PartionId AS PartionId
                                  , 0                          AS Olap_Goods
                                  , 1                          AS Olap_Partion
                              FROM tmpOLAP_partion
                                   LEFT JOIN tmpOLAP_goods ON tmpOLAP_goods.PartionId = tmpOLAP_partion.PartionId
                              WHERE tmpOLAP_goods.PartionId IS NULL
                             )
          -- Курсы
        , tmpCurrency_all AS (SELECT Movement.Id                    AS MovementId
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
                               -- , ROW_NUMBER() OVER (PARTITION BY tmpCurrency_all.OperDate, tmpCurrency_all.CurrencyFromId, tmpCurrency_all.CurrencyToId) AS Ord
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
                                     /*LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriod_Unit
                                                          ON ObjectLink_DiscountPeriod_Unit.ObjectId = Object_DiscountPeriod.Id
                                                         AND ObjectLink_DiscountPeriod_Unit.DescId = zc_ObjectLink_DiscountPeriod_Unit()
                                     */
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
         -- Долги покупателя
        , tmpContainerDebt AS (SELECT Container.Id         AS ContainerId
                                    , CLO_Client.ObjectId  AS ClientId
                               FROM Container
                                    INNER JOIN ContainerLinkObject AS CLO_Client
                                                                   ON CLO_Client.ContainerId = Container.Id
                                                                  AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                               WHERE Container.DescId   = zc_Container_Count()
                              UNION ALL
                               SELECT Container.Id         AS ContainerId
                                    , 0                    AS ClientId
                               FROM Container
                               WHERE Container.DescId   = zc_Container_Summ()
                                 AND Container.ObjectId = zc_Enum_Account_100301 () -- прибыль текущего периода
                              )
          -- СПИСОК Brand - отмеченные для OLAP
        , tmpBrand AS (SELECT ObjectLink_Object.ChildObjectId AS BrandId
                       FROM Object
                            INNER JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ObjectId      = Object.Id
                                                 AND ObjectLink_Object.DescId        = zc_ObjectLink_ReportOLAP_Object()
                            INNER JOIN ObjectLink AS ObjectLink_User
                                                  ON ObjectLink_User.ObjectId      = Object.Id
                                                 AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                 AND ObjectLink_User.ChildObjectId = vbUserId
                       WHERE Object.DescId      = zc_Object_ReportOLAP()
                         AND Object.ObjectCode  = zc_ReportOLAP_Brand()
                         AND Object.isErased    = FALSE
                         AND inBrandId          = -1
                      UNION ALL
                       SELECT inBrandId AS BrandId WHERE inBrandId > 0
                      )
                          
           -- список Партий
        , tmpPartionGoods AS (SELECT Object_PartionGoods.*
                                   , tmpOLAP_all.Olap_Goods
                                   , tmpOLAP_all.Olap_Partion
                              FROM Object_PartionGoods
                                   LEFT JOIN tmpBrand ON tmpBrand.BrandId = Object_PartionGoods.BrandId
                                   LEFT JOIN tmpOLAP_all ON tmpOLAP_all.PartionId = Object_PartionGoods.MovementItemId
                              WHERE (Object_PartionGoods.PartnerId  = inPartnerId OR inPartnerId = 0)
                                AND (Object_PartionGoods.GoodsId    = inGoodsId   OR inGoodsId   = 0)
                                AND (tmpBrand.BrandId               > 0           OR inBrandId   = 0)
                                AND (tmpOLAP_all.PartionId          > 0           OR inIsMark    = FALSE)
                                AND (Object_PartionGoods.PeriodId   = inPeriodId  OR inPeriodId  = 0)
                                AND ((Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear) OR inIsYear = FALSE)
                                AND Object_PartionGoods.isErased    = FALSE

                             )
          -- список Возврат Поставщику + Брак
        , tmpReturnOut AS (SELECT tmpPartionGoods.MovementItemId AS PartionId
                                , SUM (-1 * MIConatiner.Amount)  AS Amount
                           FROM tmpPartionGoods
                                INNER JOIN MovementItemContainer AS MIConatiner
                                                                ON MIConatiner.PartionId      = tmpPartionGoods.MovementItemId
                                                               AND MIConatiner.MovementDescId IN (zc_Movement_ReturnOut(), zc_Movement_Loss())
                                                               AND MIConatiner.DescId         = zc_MIContainer_Count()
                                -- НЕ важно с какго подразделения, ГЛАВНОЕ - партия
                                INNER JOIN _tmpUnit ON _tmpUnit.UnitId = tmpPartionGoods.UnitId
                           GROUP BY tmpPartionGoods.MovementItemId
                          )
          -- список Перемещение
        , tmpSend AS (SELECT tmpPartionGoods.MovementItemId     AS PartionId
                           , MIConatiner.WhereObjectId_Analyzer AS UnitId
                           , SUM (MIConatiner.Amount)           AS Amount
                      FROM tmpPartionGoods
                           INNER JOIN MovementItemContainer AS MIConatiner
                                                            ON MIConatiner.PartionId      = tmpPartionGoods.MovementItemId
                                                           AND MIConatiner.MovementDescId = zc_Movement_Send()
                                                           AND MIConatiner.DescId         = zc_MIContainer_Count()
                           INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MIConatiner.WhereObjectId_Analyzer
                      GROUP BY tmpPartionGoods.MovementItemId
                             , MIConatiner.WhereObjectId_Analyzer
                     )
            -- список Остаток
        , tmpRemains AS (SELECT tmp.PartionId
                              , tmp.UnitId
                              , SUM (tmp.Amount)          AS Amount
                              , SUM (tmp.Amount_real)     AS Amount_real
                              , SUM (tmp.RemainsStart)    AS RemainsStart
                              , SUM (tmp.RemainsEnd)      AS RemainsEnd
                         FROM (SELECT tmpPartionGoods.MovementItemId                                          AS PartionId
                                    , Container.WhereObjectId                                                 AS UnitId
                                    , SUM (CASE WHEN CLO_Client.ContainerId > 0 THEN 0 ELSE COALESCE (Container.Amount,0) END) AS Amount  -- текущий остаток
                                    , COALESCE (Container.Amount ,0)                                                       AS Amount_real -- текущий остаток
                                    , COALESCE (Container.Amount,0) - SUM (COALESCE (MIContainer.Amount, 0))               AS RemainsStart
                                    , COALESCE (Container.Amount,0) - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS RemainsEnd
                               FROM tmpPartionGoods
                                    INNER JOIN Container ON Container.PartionId = tmpPartionGoods.MovementItemId
                                                        AND Container.DescId    = zc_Container_Count()
                                                        AND Container.Amount    <> 0
                                    INNER JOIN _tmpUnit ON _tmpUnit.UnitId = Container.WhereObjectId
                                    LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                  ON CLO_Client.ContainerId = Container.Id
                                                                 AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
      
                                    LEFT JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.Containerid = Container.Id
                                                                   AND MIContainer.OperDate >= inStartDate

                               GROUP BY tmpPartionGoods.MovementItemId
                                      , Container.WhereObjectId
                                      , Container.Amount
                               ) AS tmp
                         GROUP BY tmp.PartionId
                                , tmp.UnitId
                        )

          -- Продажа / Возврат от Покупателя
        , tmpSale_all AS (SELECT Object_PartionGoods.MovementItemId AS PartionId
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

                               , MIConatiner.ObjectExtId_Analyzer AS UnitId
                               , CASE WHEN inIsOperDate_doc = TRUE THEN DATE_TRUNC ('MONTH', MIConatiner.OperDate) ELSE NULL :: TDateTime END AS OperDate_doc
                               , CASE WHEN inIsDay_doc      = TRUE THEN EXTRACT (DOW FROM MIConatiner.OperDate)    ELSE NULL :: Integer   END AS OrdDay_doc
                               , CASE WHEN inIsClient_doc   = TRUE THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() THEN MIConatiner.WhereObjectId_Analyzer ELSE tmpContainerDebt.ClientId END ELSE 0 :: Integer END AS ClientId

                               , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                               , COALESCE (MIFloat_ChangePercentNext.ValueData, 0)     AS ChangePercentNext
                               , COALESCE (MILinkObject_DiscountSaleKind.ObjectId, 0)  AS DiscountSaleKindId

                               , Object_PartionGoods.UnitId     AS UnitId_in
                               , Object_PartionGoods.CurrencyId AS CurrencyId
                               , CASE WHEN inIsOperPrice    = TRUE THEN Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 :: TFloat END AS OperPrice

                                 -- Приход от поставщика - только для UnitId
                               , 0 AS Income_Amount
                               , 0 AS Income_Summ
                                 -- Приход от поставщика - только для UnitId
                               , 0 AS IncomeReal_Amount
                               , 0 AS IncomeReal_Summ

                                 -- Остаток - без учета "долга"
                               , 0 AS Remains_Amount
                               , 0 AS Remains_Summ
                                 -- Остаток - с учетом "долга"
                               , 0 AS Remains_Amount_real

                                 -- Перемещение
                               , 0 AS SendIn_Amount
                               , 0 AS SendOut_Amount
                               , 0 AS SendIn_Summ
                               , 0 AS SendOut_Summ

                                 -- Списание + Возврат поставщ.
                               , 0 AS Loss_Amount
                               , 0 AS Loss_Summ

                                 -- Кол-во: Долг
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() THEN 1 * MIConatiner.Amount ELSE 0 END) AS Debt_Amount
                                 -- Сумма: Долг
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() THEN 1 * MIConatiner.Amount * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 END) AS Debt_Summ

                                 -- Кол-во: Только Продажа
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND COALESCE (MIConatiner.Amount,0) < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * COALESCE (MIConatiner.Amount,0) ELSE 0 END) :: TFloat AS Sale_Amount
                                 -- С\с продажа - calc из валюты в Грн
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN -1 * MIConatiner.Amount
                                                    * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                    / CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                           ELSE 0
                                      END) AS Sale_SummCost_calc

                                 -- Сумма продажа
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN -1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Sale_Summ
                                  -- переводим в валюту 
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN -1 * MIConatiner.Amount
                                                   / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                   * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                   -- !!!обнулили если нет КУРСА!!!
                                                   * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                           ELSE 0
                                      END) AS Sale_Summ_curr

                                 -- С\с продажа - ГРН
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN  1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Sale_SummCost
                                 -- С\с продажа - валюта
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN -1 * MIConatiner.Amount
                                                   * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                           ELSE 0
                                      END) AS Sale_SummCost_curr

                                 -- Сумма Прайс
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) AS Sale_Summ_10100
                                 -- Сезонная скидка
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10201() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) AS Sale_Summ_10201
                                 -- Скидка outlet
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10202() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) AS Sale_Summ_10202
                                 -- Скидка клиента
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10203() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) AS Sale_Summ_10203
                                 -- скидка дополнительная
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10204() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) AS Sale_Summ_10204

                                 -- Скидка ИТОГО
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN 1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Sale_Summ_10200
                                  -- переводим в валюту 
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN 1 * MIConatiner.Amount
                                                   / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                   * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                   -- !!!обнулили если нет КУРСА!!!
                                                   * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                           ELSE 0
                                      END) AS Sale_Summ_10200_curr

                                 -- Кол-во: Только Возврат
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END) AS Return_Amount
                                 -- С\с возврат - calc из валюты в Грн
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN 1 * MIConatiner.Amount
                                                   * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                   * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                   / CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                           ELSE 0
                                      END) AS Return_SummCost_calc

                                 -- Сумма возврат
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_ReturnSumm_10501(), zc_Enum_AnalyzerId_ReturnSumm_10502()) AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN 1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Return_Summ
                                  -- переводим в валюту 
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_ReturnSumm_10501(), zc_Enum_AnalyzerId_ReturnSumm_10502()) AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN 1 * MIConatiner.Amount
                                                   / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                   * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                   -- !!!обнулили если нет КУРСА!!!
                                                   * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                           ELSE 0
                                      END) AS Return_Summ_curr

                                 -- С\с возврат - ГРН
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10600() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN -1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Return_SummCost
                                 -- С\с возврат - валюта
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN 1 * MIConatiner.Amount
                                                   * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                           ELSE 0
                                      END
                                     ) AS Return_SummCost_curr

                                 -- Скидка возврат
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10502() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN -1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Return_Summ_10200
                                 -- переводим в валюту 
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10502() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN -1 * MIConatiner.Amount
                                                   / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                   * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                   -- !!!обнулили если нет КУРСА!!!
                                                   * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                           ELSE 0
                                      END) AS Return_Summ_10200_curr

                                 -- Кол-во: Продажа - Возврат
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * COALESCE (MIConatiner.Amount,0) ELSE 0 END
                                    - CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * COALESCE (MIConatiner.Amount,0) ELSE 0 END
                                     ) AS Result_Amount
                               -- , 0 AS Result_Summ
                               -- , 0 AS Result_SummCost
                               -- , 0 AS Result_Summ_10200

                                 --  № п/п
                               -- , ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId ORDER BY CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC) AS Ord
                               , 0 AS Ord

                                 -- Кол-во продажа (ПО Сезонным скидкам)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) <> 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END
                                           ELSE 0
                                      END)
                                      --  долг
                                      + SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) <> 0 AND MIConatiner.DescId = zc_MIContainer_Count() THEN -1 * MIConatiner.Amount ELSE 0 END) AS Sale_Amount_InDiscount
                                      
                                 -- Кол-во продажа (ДО Сезонных скидок)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) = 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) 
                                                     THEN -1 * MIConatiner.Amount
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END)
                                      --  долг
                                      + SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) = 0 AND MIConatiner.DescId = zc_MIContainer_Count() THEN -1 * MIConatiner.Amount ELSE 0 END) AS Sale_Amount_OutDiscount

                                 -- Кол-во: Только Возврат (ПО Сезонным скидкам)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod_Ret.PeriodId, 0) <> 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END
                                           ELSE 0
                                      END) AS Return_Amount_InDiscount
                                 -- Кол-во: Только Возврат (ДО Сезонных скидок)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod_Ret.PeriodId, 0) = 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END
                                           ELSE 0
                                      END) AS Return_Amount_OutDiscount

                                  -- С\с продажа - валюта (ПО Сезонным скидкам)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) <> 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                          THEN -1 * MIConatiner.Amount
                                                             * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Sale_SummCost_curr_InDiscount
                                  -- С\с продажа - валюта (ДО Сезонных скидок)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) = 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                          THEN -1 * MIConatiner.Amount
                                                             * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Sale_SummCost_curr_OutDiscount

                                 -- Сумма продажа (ПО Сезонным скидкам)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) <> 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                          THEN -1 * MIConatiner.Amount
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Sale_Summ_InDiscount

                                 -- Сумма продажа (ДО Сезонных скидок)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) = 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                          THEN -1 * MIConatiner.Amount
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Sale_Summ_OutDiscount

                                 -- Скидка ИТОГО (ПО Сезонным скидкам)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) <> 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                          THEN 1 * MIConatiner.Amount
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Sale_Summ_10200_InDiscount
                                 -- Скидка ИТОГО (ДО Сезонных скидок)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) = 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                          THEN 1 * MIConatiner.Amount
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Sale_Summ_10200_OutDiscount

                                 -- С\с возврат - валюта (ПО Сезонным скидкам)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod_Ret.PeriodId, 0) <> 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                          THEN 1 * MIConatiner.Amount
                                                             * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Return_SummCost_curr_InDiscount
                                 -- С\с возврат - валюта (ДО Сезонных скидок)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod_Ret.PeriodId, 0) = 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                          THEN 1 * MIConatiner.Amount
                                                             * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Return_SummCost_curr_OutDiscount

                                 -- Сумма возврат (ПО Сезонным скидкам)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod_Ret.PeriodId, 0) <> 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_ReturnSumm_10501(), zc_Enum_AnalyzerId_ReturnSumm_10502()) AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                          THEN 1 * MIConatiner.Amount
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Return_Summ_InDiscount
                                 -- Сумма возврат (ДО Сезонных скидок)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod_Ret.PeriodId, 0) = 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_ReturnSumm_10501(), zc_Enum_AnalyzerId_ReturnSumm_10502()) AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                          THEN 1 * MIConatiner.Amount
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Return_Summ_OutDiscount

                                 -- Скидка возврат (ПО Сезонным скидкам)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod_Ret.PeriodId, 0) <> 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10502() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                          THEN -1 * MIConatiner.Amount
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Return_Summ_10200_InDiscount
                                 -- Скидка возврат (ДО Сезонных скидок)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod_Ret.PeriodId, 0) = 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10502() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                          THEN -1 * MIConatiner.Amount
                                                     ELSE 0
                                                END
                                           ELSE 0
                                      END) AS Return_Summ_10200_OutDiscount

                               , Object_PartionGoods.Olap_Goods
                               , Object_PartionGoods.Olap_Partion

                          FROM tmpPartionGoods AS Object_PartionGoods
                               -- !!!для теста!!!
                               -- INNER JOIN Object ON Object.Id = Object_PartionGoods.GoodsId AND Object.ObjectCode = 89373
                               INNER JOIN MovementItemContainer AS MIConatiner
                                                                ON MIConatiner.PartionId = Object_PartionGoods.MovementItemId
                                                               AND (MIConatiner.OperDate BETWEEN inStartDate AND inEndDate
                                                                OR inIsPeriodAll = TRUE
                                                                   )
                               INNER JOIN tmpContainerDebt ON tmpContainerDebt.ContainerId   = MIConatiner.ContainerId
                               INNER JOIN _tmpUnit         ON _tmpUnit.UnitId                = MIConatiner.ObjectExtId_Analyzer

                               LEFT JOIN tmpCurrency      ON tmpCurrency.CurrencyFromId = zc_Currency_Basis()
                                                         AND tmpCurrency.CurrencyToId   = Object_PartionGoods.CurrencyId
                                                         -- AND tmpCurrency.Ord            = 1
                                                         AND MIConatiner.OperDate       >= tmpCurrency.StartDate
                                                         AND MIConatiner.OperDate       <  tmpCurrency.EndDate

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                                ON MILinkObject_PartionMI.MovementItemId = MIConatiner.MovementItemId
                                                               AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                                                               --AND inIsDiscount                          = TRUE
                               LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                           ON MIFloat_ChangePercent.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                          AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                                          AND inIsDiscount                         = TRUE
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                                           ON MIFloat_ChangePercentNext.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                          AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()
                                                          AND inIsDiscount                         = TRUE

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                                ON MILinkObject_DiscountSaleKind.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                               AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()
                                                               AND inIsDiscount                                 = TRUE

                               LEFT JOIN Movement ON Movement.Id = MIConatiner.MovementId
                               LEFT JOIN tmpDiscountPeriod ON tmpDiscountPeriod.PeriodId = Object_PartionGoods.PeriodId
                                                          --AND MIConatiner.OperDate BETWEEN tmpDiscountPeriod.StartDate AND tmpDiscountPeriod.EndDate
                                                          AND Movement.OperDate BETWEEN tmpDiscountPeriod.StartDate AND tmpDiscountPeriod.EndDate

                               -- док. продажи для док.возврата
                               LEFT JOIN MovementItem AS MovementItem_Sale ON MovementItem_Sale.Id = Object_PartionMI.ObjectCode
                               LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementItem_Sale.MovementId
                               -- период скидок для возврата по дате продажи
                               LEFT JOIN tmpDiscountPeriod AS tmpDiscountPeriod_Ret 
                                                           ON tmpDiscountPeriod_Ret.PeriodId = Object_PartionGoods.PeriodId
                                                          AND Movement_Sale.OperDate BETWEEN tmpDiscountPeriod_Ret.StartDate AND tmpDiscountPeriod_Ret.EndDate

                          -- WHERE (MIConatiner.ContainerId      > 0 OR inIsPeriodAll = TRUE)
                          --   AND (tmpContainerDebt.ContainerId > 0 OR MIConatiner.PartionId IS NULL)

                          GROUP BY Object_PartionGoods.MovementItemId
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
                                 , CASE WHEN inIsOperDate_doc = TRUE THEN DATE_TRUNC ('MONTH', MIConatiner.OperDate) ELSE NULL :: TDateTime END
                                 , CASE WHEN inIsDay_doc      = TRUE THEN EXTRACT (DOW FROM MIConatiner.OperDate)    ELSE NULL :: Integer   END
                                 , CASE WHEN inIsClient_doc   = TRUE THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() THEN MIConatiner.WhereObjectId_Analyzer ELSE tmpContainerDebt.ClientId END ELSE 0 END

                                 , MIFloat_ChangePercent.ValueData
                                 , MIFloat_ChangePercentNext.ValueData
                                 , MILinkObject_DiscountSaleKind.ObjectId

                                 , Object_PartionGoods.UnitId
                                 , Object_PartionGoods.CurrencyId
                                 -- , Object_PartionGoods.Amount
                                 , CASE WHEN inIsOperPrice    = TRUE THEN Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 :: TFloat END

                                 , Object_PartionGoods.Olap_Goods
                                 , Object_PartionGoods.Olap_Partion
                         )
          -- Данные: Продажа + Приход + Остаток + Пемещения
        , tmpData_all AS (-- 1. Продажа / Возврат от Покупателя
                          SELECT tmpSale_all.PartionId
                               , tmpSale_all.BrandId
                               , tmpSale_all.PeriodId
                               , tmpSale_all.PeriodYear
                               , tmpSale_all.PartnerId

                               , tmpSale_all.GoodsGroupId
                               , tmpSale_all.LabelId
                               , tmpSale_all.CompositionGroupId
                               , tmpSale_all.CompositionId

                               , tmpSale_all.GoodsId
                               , tmpSale_all.GoodsInfoId
                               , tmpSale_all.LineFabricaId
                               , tmpSale_all.GoodsSizeId

                               , tmpSale_all.UnitId
                               , tmpSale_all.OperDate_doc
                               , tmpSale_all.OrdDay_doc
                               , tmpSale_all.ClientId

                               , tmpSale_all.ChangePercent
                               , tmpSale_all.ChangePercentNext
                               , tmpSale_all.DiscountSaleKindId

                               , tmpSale_all.UnitId_in
                               , tmpSale_all.CurrencyId
                               , tmpSale_all.OperPrice

                                 -- Приход от поставщика - только для UnitId
                               , tmpSale_all.Income_Amount
                               , tmpSale_all.Income_Summ
                                 -- Приход от поставщика - только для UnitId
                               , tmpSale_all.IncomeReal_Amount
                               , tmpSale_all.IncomeReal_Summ

                                 -- Остаток - без учета "долга"
                               , tmpSale_all.Remains_Amount
                               , tmpSale_all.Remains_Summ
                                 -- Остаток - с учетом "долга"
                               , tmpSale_all.Remains_Amount_real

                               , 0 AS RemainsStart
                               , 0 AS RemainsEnd
                               , 0 AS RemainsStart_Summ
                               , 0 AS RemainsEnd_Summ
                               , 0 AS RemainsStart_Summ_curr
                               , 0 AS RemainsEnd_Summ_curr
                               , 0 AS RemainsStart_PriceListSumm
                               , 0 AS RemainsEnd_PriceListSumm
                               , 0 AS RemainsStart_PriceListSumm_curr
                               , 0 AS RemainsEnd_PriceListSumm_curr

                                 -- Перемещение
                               , tmpSale_all.SendIn_Amount
                               , tmpSale_all.SendOut_Amount
                               , tmpSale_all.SendIn_Summ
                               , tmpSale_all.SendOut_Summ

                                 -- Списание + Возврат поставщ.
                               , tmpSale_all.Loss_Amount
                               , tmpSale_all.Loss_Summ

                                 -- Кол-во: Долг
                               , tmpSale_all.Debt_Amount
                                 -- Сумма: Долг
                               , tmpSale_all.Debt_Summ

                                 -- Кол-во: Только Продажа
                               , tmpSale_all.Sale_Amount
                                 -- С\с продажа - calc из валюты в Грн
                               , tmpSale_all.Sale_SummCost_calc

                                 -- Сумма продажа
                               , tmpSale_all.Sale_Summ
                                  -- переводим в валюту 
                               , tmpSale_all.Sale_Summ_curr

                                 -- С\с продажа - ГРН
                               , tmpSale_all.Sale_SummCost
                                 -- С\с продажа - валюта
                               , tmpSale_all.Sale_SummCost_curr

                                 -- Сумма Прайс
                               , tmpSale_all.Sale_Summ_10100
                                 -- Сезонная скидка
                               , tmpSale_all.Sale_Summ_10201
                                 -- Скидка outlet
                               , tmpSale_all.Sale_Summ_10202
                                 -- Скидка клиента
                               , tmpSale_all.Sale_Summ_10203
                                 -- скидка дополнительная
                               , tmpSale_all.Sale_Summ_10204

                                 -- Скидка ИТОГО
                               , tmpSale_all.Sale_Summ_10200
                                  -- переводим в валюту 
                               , tmpSale_all.Sale_Summ_10200_curr

                                 -- Кол-во: Только Возврат
                               , tmpSale_all.Return_Amount
                                 -- С\с возврат - calc из валюты в Грн
                               , tmpSale_all.Return_SummCost_calc

                                 -- Сумма возврат
                               , tmpSale_all.Return_Summ
                                  -- переводим в валюту 
                               , tmpSale_all.Return_Summ_curr

                                 -- С\с возврат - ГРН
                               , tmpSale_all.Return_SummCost
                                 -- С\с возврат - валюта
                               , tmpSale_all.Return_SummCost_curr

                                 -- Скидка возврат
                               , tmpSale_all.Return_Summ_10200
                                 -- переводим в валюту 
                               , tmpSale_all.Return_Summ_10200_curr

                                 -- Кол-во: Продажа - Возврат
                               , tmpSale_all.Result_Amount

                                 --  № п/п
                               , tmpSale_all.Ord

                                 -- Кол-во продажа (ПО Сезонным скидкам)
                               , tmpSale_all.Sale_Amount_InDiscount
                                      
                                 -- Кол-во продажа (ДО Сезонных скидок)
                               , tmpSale_all.Sale_Amount_OutDiscount

                                 -- Кол-во: Только Возврат (ПО Сезонным скидкам)
                               , tmpSale_all.Return_Amount_InDiscount
                                 -- Кол-во: Только Возврат (ДО Сезонных скидок)
                               , tmpSale_all.Return_Amount_OutDiscount

                                  -- С\с продажа - валюта (ПО Сезонным скидкам)
                               , tmpSale_all.Sale_SummCost_curr_InDiscount
                                 -- С\с продажа - валюта (ДО Сезонных скидок)
                               , tmpSale_all.Sale_SummCost_curr_OutDiscount

                                 -- Сумма продажа (ПО Сезонным скидкам)
                               , tmpSale_all.Sale_Summ_InDiscount

                                 -- Сумма продажа (ДО Сезонных скидок)
                               , tmpSale_all.Sale_Summ_OutDiscount

                                 -- Скидка ИТОГО (ПО Сезонным скидкам)
                               , tmpSale_all.Sale_Summ_10200_InDiscount
                                 -- Скидка ИТОГО (ДО Сезонных скидок)
                               , tmpSale_all.Sale_Summ_10200_OutDiscount

                                 -- С\с возврат - валюта (ПО Сезонным скидкам)
                               , tmpSale_all.Return_SummCost_curr_InDiscount
                                 -- С\с возврат - валюта (ДО Сезонных скидок)
                               , tmpSale_all.Return_SummCost_curr_OutDiscount

                                 -- Сумма возврат (ПО Сезонным скидкам)
                               , tmpSale_all.Return_Summ_InDiscount
                                 -- Сумма возврат (ДО Сезонных скидок)
                               , tmpSale_all.Return_Summ_OutDiscount

                                 -- Скидка возврат (ПО Сезонным скидкам)
                               , tmpSale_all.Return_Summ_10200_InDiscount
                                 -- Скидка возврат (ДО Сезонных скидок)
                               , tmpSale_all.Return_Summ_10200_OutDiscount

                               , tmpSale_all.Olap_Goods
                               , tmpSale_all.Olap_Partion

                          FROM tmpSale_all

                         UNION ALL
                          -- 2. Приход от Поставщика
                          SELECT Object_PartionGoods.MovementItemId AS PartionId
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

                               , Object_PartionGoods.UnitId AS UnitId
                               , CASE WHEN inIsOperDate_doc = TRUE THEN DATE_TRUNC ('MONTH', Object_PartionGoods.OperDate) ELSE NULL :: TDateTime END AS OperDate_doc
                               , CASE WHEN inIsDay_doc      = TRUE THEN EXTRACT (DOW FROM Object_PartionGoods.OperDate)    ELSE NULL :: Integer   END AS OrdDay_doc
                               , 0 AS ClientId

                               , 0 AS ChangePercent
                               , 0 AS ChangePercentNext
                               , 0 AS DiscountSaleKindId

                               , Object_PartionGoods.UnitId     AS UnitId_in
                               , Object_PartionGoods.CurrencyId AS CurrencyId
                               , CASE WHEN inIsOperPrice    = TRUE THEN Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 :: TFloat END AS OperPrice

                                 -- Приход от поставщика - только для UnitId
                               , CASE WHEN _tmpUnit.UnitId > 0 THEN (Object_PartionGoods.Amount - COALESCE (tmpReturnOut.Amount, 0)) ELSE 0 END AS Income_Amount --AND (Object_PartionGoods.OperDate BETWEEN inStartDate AND inEndDate OR inIsPeriodAll = TRUE)
                               , CASE WHEN _tmpUnit.UnitId > 0 THEN (Object_PartionGoods.Amount - COALESCE (tmpReturnOut.Amount, 0)) * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 END AS Income_Summ
                                 -- Приход от поставщика - только для UnitId
                               , CASE WHEN _tmpUnit.UnitId > 0 THEN (Object_PartionGoods.Amount - 0) ELSE 0 END AS IncomeReal_Amount
                               , CASE WHEN _tmpUnit.UnitId > 0 THEN (Object_PartionGoods.Amount - 0) * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 END AS IncomeReal_Summ

                                 -- Остаток - без учета "долга"
                               , 0 AS Remains_Amount
                               , 0 AS Remains_Summ
                                 -- Остаток - с учетом "долга"
                               , 0 AS Remains_Amount_real

                               , 0 AS RemainsStart
                               , 0 AS RemainsEnd
                               
                               , 0 AS RemainsStart_Summ
                               , 0 AS RemainsEnd_Summ
                               , 0 AS RemainsStart_Summ_curr
                               , 0 AS RemainsEnd_Summ_curr
                               , 0 AS RemainsStart_PriceListSumm
                               , 0 AS RemainsEnd_PriceListSumm
                               , 0 AS RemainsStart_PriceListSumm_curr
                               , 0 AS RemainsEnd_PriceListSumm_curr
                               
                               
                                 -- Перемещение
                               , 0 AS SendIn_Amount
                               , 0 AS SendOut_Amount
                               , 0 AS SendIn_Summ
                               , 0 AS SendOut_Summ

                                 -- Списание + Возврат поставщ.
                               , COALESCE (tmpReturnOut.Amount, 0) AS Loss_Amount
                               , COALESCE (tmpReturnOut.Amount, 0) * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS Loss_Summ

                                 -- Кол-во: Долг
                               , 0 AS Debt_Amount
                                 -- Сумма: Долг
                               , 0 AS Debt_Summ

                                 -- Кол-во: Только Продажа
                               , 0 AS Sale_Amount
                                 -- С\с продажа - calc из валюты в Грн
                               , 0 AS Sale_SummCost_calc

                                 -- Сумма продажа
                               , 0 AS Sale_Summ
                                  -- переводим в валюту 
                               , 0 AS Sale_Summ_curr

                                 -- С\с продажа - ГРН
                               , 0 AS Sale_SummCost
                                 -- С\с продажа - валюта
                               , 0 AS Sale_SummCost_curr

                                 -- Сумма Прайс
                               , 0 AS Sale_Summ_10100
                                 -- Сезонная скидка
                               , 0 AS Sale_Summ_10201
                                 -- Скидка outlet
                               , 0 AS Sale_Summ_10202
                                 -- Скидка клиента
                               , 0 AS Sale_Summ_10203
                                 -- скидка дополнительная
                               , 0 AS Sale_Summ_10204

                                 -- Скидка ИТОГО
                               , 0 AS Sale_Summ_10200
                                  -- переводим в валюту 
                               , 0 AS Sale_Summ_10200_curr

                                 -- Кол-во: Только Возврат
                               , 0 AS Return_Amount
                                 -- С\с возврат - calc из валюты в Грн
                               , 0 AS Return_SummCost_calc

                                 -- Сумма возврат
                               , 0 AS Return_Summ
                                  -- переводим в валюту 
                               , 0 AS Return_Summ_curr

                                 -- С\с возврат - ГРН
                               , 0 AS Return_SummCost
                                 -- С\с возврат - валюта
                               , 0 AS Return_SummCost_curr

                                 -- Скидка возврат
                               , 0 AS Return_Summ_10200
                                 -- переводим в валюту 
                               , 0 AS Return_Summ_10200_curr

                                 -- Кол-во: Продажа - Возврат
                               , 0 AS Result_Amount

                                 --  № п/п
                               , 1 AS Ord -- ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId ORDER BY CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC) AS Ord

                                 -- Кол-во продажа (ПО Сезонным скидкам)
                               , 0 AS Sale_Amount_InDiscount
                                 -- Кол-во продажа (ДО Сезонных скидок)
                               , 0 AS Sale_Amount_OutDiscount

                                 -- Кол-во: Только Возврат (ПО Сезонным скидкам)
                               , 0 AS Return_Amount_InDiscount
                                 -- Кол-во: Только Возврат (ДО Сезонных скидок)
                               , 0 AS Return_Amount_OutDiscount

                                  -- С\с продажа - валюта (ПО Сезонным скидкам)
                               , 0 AS Sale_SummCost_curr_InDiscount
                                  -- С\с продажа - валюта (ДО Сезонных скидок)
                               , 0 AS Sale_SummCost_curr_OutDiscount
                                 -- Сумма продажа (ПО Сезонным скидкам)
                               , 0 AS Sale_Summ_InDiscount
                                 -- Сумма продажа (ДО Сезонных скидок)
                               , 0 AS Sale_Summ_OutDiscount
                                 -- Скидка ИТОГО (ПО Сезонным скидкам)
                               , 0 AS Sale_Summ_10200_InDiscount
                                 -- Скидка ИТОГО (ДО Сезонных скидок)
                               , 0 AS Sale_Summ_10200_OutDiscount
                                    
                                 -- С\с возврат - валюта (ПО Сезонным скидкам)
                               , 0 AS Return_SummCost_curr_InDiscount
                                 -- С\с возврат - валюта (ДО Сезонных скидок)
                               , 0 AS Return_SummCost_curr_OutDiscount
                                 -- Сумма возврат (ПО Сезонным скидкам)
                               , 0 AS Return_Summ_InDiscount
                                 -- Сумма возврат (ДО Сезонных скидок)
                               , 0 AS Return_Summ_OutDiscount
                                 -- Скидка возврат (ПО Сезонным скидкам)
                               , 0 AS Return_Summ_10200_InDiscount
                                 -- Скидка возврат (ДО Сезонных скидок)
                               , 0 AS Return_Summ_10200_OutDiscount  
                               --
                               -- , 2 as x1

                               , Object_PartionGoods.Olap_Goods
                               , Object_PartionGoods.Olap_Partion

                          FROM tmpPartionGoods AS Object_PartionGoods
                               -- !!!для теста!!!
                               -- INNER JOIN Object ON Object.Id = Object_PartionGoods.GoodsId AND Object.ObjectCode = 89373

                               LEFT JOIN tmpReturnOut ON tmpReturnOut.PartionId = Object_PartionGoods.MovementItemId
                               LEFT JOIN _tmpUnit     ON _tmpUnit.UnitId        = Object_PartionGoods.UnitId

                          WHERE (_tmpUnit.UnitId > 0 OR inPartnerId <> 0 OR inBrandId <> 0)
                            AND (Object_PartionGoods.OperDate BETWEEN inStartDate AND inEndDate OR inIsPeriodAll = TRUE)
--                            AND (Object_PartionGoods.MovementItemId IN (SELECT tmpSale_all.PartionId FROM tmpSale_all)
--                              OR inIsPeriodAll = TRUE)

                         UNION ALL
                          -- 3. Остаток + Пемещения
                          SELECT Object_PartionGoods.MovementItemId AS PartionId
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

                                 -- !!!заменили!!!
                               , tmp.UnitId AS UnitId

                               , CASE WHEN inIsOperDate_doc = TRUE THEN DATE_TRUNC ('MONTH', Object_PartionGoods.OperDate) ELSE NULL :: TDateTime END AS OperDate_doc
                               , CASE WHEN inIsDay_doc      = TRUE THEN EXTRACT (DOW FROM Object_PartionGoods.OperDate)    ELSE NULL :: Integer   END AS OrdDay_doc
                               , 0 AS ClientId

                               , 0 AS ChangePercent
                               , 0 AS ChangePercentNext
                               , 0 AS DiscountSaleKindId

                               , Object_PartionGoods.UnitId     AS UnitId_in
                               , Object_PartionGoods.CurrencyId AS CurrencyId
                               , CASE WHEN inIsOperPrice    = TRUE THEN Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 :: TFloat END AS OperPrice

                                 -- Приход от поставщика - только для UnitId
                               , 0 AS Income_Amount
                               , 0 AS Income_Summ
                                 -- Приход от поставщика - только для UnitId
                               , 0 AS IncomeReal_Amount
                               , 0 AS IncomeReal_Summ

                                 -- Остаток - без учета "долга"
                               , tmp.Remains_Amount        AS Remains_Amount
                               , tmp.Remains_Amount * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS Remains_Summ
                                 -- Остаток - с учетом "долга"
                               , tmp.Remains_Amount_real   AS Remains_Amount_real
                               -- Остаток - с учетом "долга" на нач. периода
                               , tmp.RemainsStart   AS RemainsStart
                               -- Остаток - с учетом "долга" на конец периода
                               , tmp.RemainsEnd     AS RemainsEnd
                               -- остатки в ценах прихода в грн
                               , tmp.RemainsStart * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrencyStart.Amount, 0) END
                                                    / CASE WHEN tmpCurrencyStart.ParValue > 0 THEN tmpCurrencyStart.ParValue  ELSE 1 END                                                    AS RemainsStart_Summ
                               , tmp.RemainsEnd   * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrencyEnd.Amount, 0) END
                                                    / CASE WHEN tmpCurrencyEnd.ParValue > 0 THEN tmpCurrencyEnd.ParValue  ELSE 1 END                                                        AS RemainsEnd_Summ
                               
                               -- остатки в ценах прих. в вал
                               , tmp.RemainsStart * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS RemainsStart_Summ_curr
                               , tmp.RemainsEnd   * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS RemainsEnd_Summ_curr
                               
                               
                                -- ост. в ценах продажи в ГРН
                               , tmp.RemainsStart * Object_PartionGoods.OperPriceList / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrencyStart.Amount, 0) END
                                                    / CASE WHEN tmpCurrencyStart.ParValue > 0 THEN tmpCurrencyStart.ParValue  ELSE 1 END                                                AS RemainsStart_PriceListSumm
                               , tmp.RemainsEnd   * Object_PartionGoods.OperPriceList / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrencyEnd.Amount, 0) END
                                                    / CASE WHEN tmpCurrencyEnd.ParValue > 0 THEN tmpCurrencyEnd.ParValue  ELSE 1 END                                                    AS RemainsEnd_PriceListSumm
                                     
                               
                               -- остатки в ценах продажи в вал
                               , tmp.RemainsStart * Object_PartionGoods.OperPriceList / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END   AS RemainsStart_PriceListSumm_curr
                               , tmp.RemainsEnd   * Object_PartionGoods.OperPriceList / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END   AS RemainsEnd_PriceListSumm_curr




                                 -- Перемещение
                               , CASE WHEN tmp.Send_Amount > 0 THEN  1 * tmp.Send_Amount ELSE 0 END AS SendIn_Amount
                               , CASE WHEN tmp.Send_Amount < 0 THEN -1 * tmp.Send_Amount ELSE 0 END AS SendOut_Amount
                               , CASE WHEN tmp.Send_Amount > 0 THEN  1 * tmp.Send_Amount * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 END AS SendIn_Summ
                               , CASE WHEN tmp.Send_Amount < 0 THEN -1 * tmp.Send_Amount * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 END AS SendOut_Summ

                                 -- Списание + Возврат поставщ.
                               , 0 AS Loss_Amount
                               , 0 AS Loss_Summ

                                 -- Кол-во: Долг
                               , 0 AS Debt_Amount
                                 -- Сумма: Долг
                               , 0 AS Debt_Summ

                                 -- Кол-во: Только Продажа
                               , 0 AS Sale_Amount
                                 -- С\с продажа - calc из валюты в Грн
                               , 0 AS Sale_SummCost_calc

                                 -- Сумма продажа
                               , 0 AS Sale_Summ
                                  -- переводим в валюту 
                               , 0 AS Sale_Summ_curr

                                 -- С\с продажа - ГРН
                               , 0 AS Sale_SummCost
                                 -- С\с продажа - валюта
                               , 0 AS Sale_SummCost_curr

                                 -- Сумма Прайс
                               , 0 AS Sale_Summ_10100
                                 -- Сезонная скидка
                               , 0 AS Sale_Summ_10201
                                 -- Скидка outlet
                               , 0 AS Sale_Summ_10202
                                 -- Скидка клиента
                               , 0 AS Sale_Summ_10203
                                 -- скидка дополнительная
                               , 0 AS Sale_Summ_10204

                                 -- Скидка ИТОГО
                               , 0 AS Sale_Summ_10200
                                  -- переводим в валюту 
                               , 0 AS Sale_Summ_10200_curr

                                 -- Кол-во: Только Возврат
                               , 0 AS Return_Amount
                                 -- С\с возврат - calc из валюты в Грн
                               , 0 AS Return_SummCost_calc

                                 -- Сумма возврат
                               , 0 AS Return_Summ
                                  -- переводим в валюту 
                               , 0 AS Return_Summ_curr

                                 -- С\с возврат - ГРН
                               , 0 AS Return_SummCost
                                 -- С\с возврат - валюта
                               , 0 AS Return_SummCost_curr

                                 -- Скидка возврат
                               , 0 AS Return_Summ_10200
                                 -- переводим в валюту 
                               , 0 AS Return_Summ_10200_curr

                                 -- Кол-во: Продажа - Возврат
                               , 0 AS Result_Amount

                                 --  № п/п
                               , 1 AS Ord -- ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId ORDER BY CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC) AS Ord

                                 -- Кол-во продажа (ПО Сезонным скидкам)
                               , 0 AS Sale_Amount_InDiscount
                                 -- Кол-во продажа (ДО Сезонных скидок)
                               , 0 AS Sale_Amount_OutDiscount

                                 -- Кол-во: Только Возврат (ПО Сезонным скидкам)
                               , 0 AS Return_Amount_InDiscount
                                 -- Кол-во: Только Возврат (ДО Сезонных скидок)
                               , 0 AS Return_Amount_OutDiscount

                                  -- С\с продажа - валюта (ПО Сезонным скидкам)
                               , 0 AS Sale_SummCost_curr_InDiscount
                                  -- С\с продажа - валюта (ДО Сезонных скидок)
                               , 0 AS Sale_SummCost_curr_OutDiscount
                                 -- Сумма продажа (ПО Сезонным скидкам)
                               , 0 AS Sale_Summ_InDiscount
                                 -- Сумма продажа (ДО Сезонных скидок)
                               , 0 AS Sale_Summ_OutDiscount
                                 -- Скидка ИТОГО (ПО Сезонным скидкам)
                               , 0 AS Sale_Summ_10200_InDiscount
                                 -- Скидка ИТОГО (ДО Сезонных скидок)
                               , 0 AS Sale_Summ_10200_OutDiscount

                                 -- С\с возврат - валюта (ПО Сезонным скидкам)
                               , 0 AS Return_SummCost_curr_InDiscount
                                 -- С\с возврат - валюта (ДО Сезонных скидок)
                               , 0 AS Return_SummCost_curr_OutDiscount
                                 -- Сумма возврат (ПО Сезонным скидкам)
                               , 0 AS Return_Summ_InDiscount
                                 -- Сумма возврат (ДО Сезонных скидок)
                               , 0 AS Return_Summ_OutDiscount
                                 -- Скидка возврат (ПО Сезонным скидкам)
                               , 0 AS Return_Summ_10200_InDiscount
                                 -- Скидка возврат (ДО Сезонных скидок)
                               , 0 AS Return_Summ_10200_OutDiscount
                               
                               --
                               -- , 3 as x1

                               , Object_PartionGoods.Olap_Goods
                               , Object_PartionGoods.Olap_Partion

                          FROM tmpPartionGoods AS Object_PartionGoods
                               -- !!!для теста!!!
                               -- INNER JOIN Object ON Object.Id = Object_PartionGoods.GoodsId AND Object.ObjectCode = 89373

                               INNER JOIN (SELECT COALESCE (tmpRemains.PartionId,   tmpSend.PartionId) AS PartionId
                                                , COALESCE (tmpRemains.UnitId,      tmpSend.UnitId)    AS UnitId
                                                , COALESCE (tmpRemains.Amount,      0)                 AS Remains_Amount
                                                , COALESCE (tmpRemains.Amount_real, 0)                 AS Remains_Amount_real
                                                , COALESCE (tmpRemains.RemainsStart,0)                 AS RemainsStart
                                                , COALESCE (tmpRemains.RemainsEnd,  0)                 AS RemainsEnd
                                                , COALESCE (tmpSend.Amount,         0)                 AS Send_Amount
                                           FROM tmpRemains
                                                FULL JOIN tmpSend ON tmpSend.PartionId = tmpRemains.PartionId
                                                                 AND tmpSend.UnitId    = tmpRemains.UnitId
                                          ) AS tmp ON tmp.PartionId = Object_PartionGoods.MovementItemId

                               LEFT JOIN tmpCurrency AS tmpCurrencyStart
                                                     ON tmpCurrencyStart.CurrencyFromId = zc_Currency_Basis()
                                                    AND tmpCurrencyStart.CurrencyToId   = Object_PartionGoods.CurrencyId
                                                    AND inStartDate >= tmpCurrencyStart.StartDate
                                                    AND inStartDate <  tmpCurrencyStart.EndDate
 
                               LEFT JOIN tmpCurrency AS tmpCurrencyEnd
                                                     ON tmpCurrencyEnd.CurrencyFromId = zc_Currency_Basis()
                                                    AND tmpCurrencyEnd.CurrencyToId   = Object_PartionGoods.CurrencyId
                                                    AND inEndDate >= tmpCurrencyEnd.StartDate
                                                    AND inEndDate <  tmpCurrencyEnd.EndDate

                          --WHERE (Object_PartionGoods.OperDate BETWEEN inStartDate AND inEndDate OR inIsPeriodAll = TRUE)
                          --(Object_PartionGoods.MovementItemId IN (SELECT tmpSale_all.PartionId FROM tmpSale_all)
                          --    OR inIsPeriodAll = TRUE)
                         )
         , tmpData AS (SELECT tmpData_all.BrandId
                            , tmpData_all.PeriodId
                            , tmpData_all.PeriodYear
                            , tmpData_all.PartnerId
   
                            , tmpData_all.GoodsGroupId
                            , tmpData_all.LabelId
                            , tmpData_all.CompositionGroupId
                            , CASE WHEN inIsGoods = TRUE THEN tmpData_all.CompositionId ELSE 0 END AS CompositionId
   
                            , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsId       ELSE 0 END AS GoodsId
                            , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsInfoId   ELSE 0 END AS GoodsInfoId
                            , CASE WHEN inIsGoods = TRUE THEN tmpData_all.LineFabricaId ELSE 0 END AS LineFabricaId
                            , CASE WHEN inIsSize  = TRUE THEN tmpData_all.GoodsSizeId   ELSE 0 END AS GoodsSizeId
                            -- , STRING_AGG (DISTINCT CASE WHEN LENGTH (Object_GoodsSize.ValueData) = 1 THEN '0' ELSE '' END || Object_GoodsSize.ValueData, ', ' ORDER BY CASE WHEN LENGTH (Object_GoodsSize.ValueData) = 1 THEN '0' ELSE '' END || Object_GoodsSize.ValueData) AS GoodsSizeName
                            , STRING_AGG (DISTINCT Object_GoodsSize.ValueData, ', ' ORDER BY Object_GoodsSize.ValueData) AS GoodsSizeName
   
                            , tmpData_all.OperDate_doc
                            , tmpData_all.OrdDay_doc
                            , tmpData_all.UnitId
                            , tmpData_all.ClientId
                            , tmpData_all.ChangePercent
                            , tmpData_all.ChangePercentNext
                            , tmpData_all.DiscountSaleKindId
   
                            , tmpData_all.UnitId_in
                            , tmpData_all.CurrencyId
   
                            , tmpData_all.OperPrice
                            , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.Income_Amount     ELSE 0 END) AS Income_Amount
                            , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.Income_Summ       ELSE 0 END) AS Income_Summ
                            , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.IncomeReal_Amount ELSE 0 END) AS IncomeReal_Amount
                            , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.IncomeReal_Summ   ELSE 0 END) AS IncomeReal_Summ
   
                            , SUM (tmpData_all.Remains_Amount)      AS Remains_Amount
                            , SUM (tmpData_all.Remains_Summ)        AS Remains_Summ
                            , SUM (tmpData_all.Remains_Amount_real) AS Remains_Amount_real

                            , SUM (tmpData_all.RemainsStart)        AS RemainsStart
                            , SUM (tmpData_all.RemainsEnd)          AS RemainsEnd
                            , SUM (tmpData_all.RemainsStart_Summ)   AS RemainsStart_Summ
                            , SUM (tmpData_all.RemainsEnd_Summ)     AS RemainsEnd_Summ
                            , SUM (tmpData_all.RemainsStart_Summ_curr)     AS RemainsStart_Summ_curr
                            , SUM (tmpData_all.RemainsEnd_Summ_curr)       AS RemainsEnd_Summ_curr
                            , SUM (tmpData_all.RemainsStart_PriceListSumm) AS RemainsStart_PriceListSumm
                            , SUM (tmpData_all.RemainsEnd_PriceListSumm)   AS RemainsEnd_PriceListSumm
                            , SUM (tmpData_all.RemainsStart_PriceListSumm_curr) AS RemainsStart_PriceListSumm_curr
                            , SUM (tmpData_all.RemainsEnd_PriceListSumm_curr)   AS RemainsEnd_PriceListSumm_curr

                            , SUM (tmpData_all.SendIn_Amount)       AS SendIn_Amount
                            , SUM (tmpData_all.SendOut_Amount)      AS SendOut_Amount
                            , SUM (tmpData_all.SendIn_Summ)         AS SendIn_Summ
                            , SUM (tmpData_all.SendOut_Summ)        AS SendOut_Summ

                            , SUM (tmpData_all.Sale_Amount_InDiscount)  AS Sale_InDiscount
                            , SUM (tmpData_all.Sale_Amount_OutDiscount) AS Sale_OutDiscount

                            , SUM (tmpData_all.Return_Amount_InDiscount)  AS Return_InDiscount
                            , SUM (tmpData_all.Return_Amount_OutDiscount) AS Return_OutDiscount

                            , SUM (tmpData_all.Loss_Amount)             AS Loss_Amount
                            , SUM (tmpData_all.Loss_Summ)               AS Loss_Summ

                            , SUM (tmpData_all.Debt_Amount)             AS Debt_Amount
                            , SUM (tmpData_all.Debt_Summ)               AS Debt_Summ

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

                            , SUM (tmpData_all.Return_Amount)         AS Return_Amount

                              -- Сумма возврат
                            , SUM (tmpData_all.Return_Summ)           AS Return_Summ
                            , SUM (tmpData_all.Return_Summ_curr)      AS Return_Summ_curr

                              -- С\с возврат
                            , SUM (tmpData_all.Return_SummCost_calc)  AS Return_SummCost_calc -- calc из валюты в Грн
                            , SUM (tmpData_all.Return_SummCost)       AS Return_SummCost      -- ГРН
                            , SUM (tmpData_all.Return_SummCost_curr)  AS Return_SummCost_curr -- валюта

                              -- Скидка возврат
                            , SUM (tmpData_all.Return_Summ_10200)      AS Return_Summ_10200
                            , SUM (tmpData_all.Return_Summ_10200_curr) AS Return_Summ_10200_curr

                            , SUM (tmpData_all.Result_Amount)         AS Result_Amount
                            -- , SUM (tmpData_all.Result_Summ)         AS Result_Summ
                            -- , SUM (tmpData_all.Result_SummCost)     AS Result_SummCost
                            -- , SUM (tmpData_all.Result_Summ_10200)   AS Result_Summ_10200

                            , SUM (tmpData_all.Sale_SummCost_curr_InDiscount)    AS Sale_SummCost_curr_InDiscount
                            , SUM (tmpData_all.Sale_SummCost_curr_OutDiscount)   AS Sale_SummCost_curr_OutDiscount
                            , SUM (tmpData_all.Sale_Summ_InDiscount)             AS Sale_Summ_InDiscount
                            , SUM (tmpData_all.Sale_Summ_OutDiscount)            AS Sale_Summ_OutDiscount
                            , SUM (tmpData_all.Sale_Summ_10200_InDiscount)       AS Sale_Summ_10200_InDiscount
                            , SUM (tmpData_all.Sale_Summ_10200_OutDiscount)      AS Sale_Summ_10200_OutDiscount

                            , SUM (tmpData_all.Return_SummCost_curr_InDiscount)    AS Return_SummCost_curr_InDiscount
                            , SUM (tmpData_all.Return_SummCost_curr_OutDiscount)   AS Return_SummCost_curr_OutDiscount
                            , SUM (tmpData_all.Return_Summ_InDiscount)             AS Return_Summ_InDiscount
                            , SUM (tmpData_all.Return_Summ_OutDiscount)            AS Return_Summ_OutDiscount
                            , SUM (tmpData_all.Return_Summ_10200_InDiscount)       AS Return_Summ_10200_InDiscount
                            , SUM (tmpData_all.Return_Summ_10200_OutDiscount)      AS Return_Summ_10200_OutDiscount
                               
                            , tmpData_all.Olap_Goods
                            , tmpData_all.Olap_Partion

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
                            LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = tmpData_all.GoodsSizeId
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
                       GROUP BY tmpData_all.BrandId
                              , tmpData_all.PeriodId
                              , tmpData_all.PeriodYear
                              , tmpData_all.PartnerId
   
                              , tmpData_all.GoodsGroupId
                              , tmpData_all.LabelId
                              , tmpData_all.CompositionGroupId
                              , CASE WHEN inIsGoods = TRUE THEN tmpData_all.CompositionId ELSE 0 END
   
                              , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsId       ELSE 0 END
                              , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsInfoId   ELSE 0 END
                              , CASE WHEN inIsGoods = TRUE THEN tmpData_all.LineFabricaId ELSE 0 END
                              , CASE WHEN inIsSize  = TRUE THEN tmpData_all.GoodsSizeId   ELSE 0 END
   
                              , tmpData_all.OperDate_doc
                              , tmpData_all.OrdDay_doc
                              , tmpData_all.UnitId
                              , tmpData_all.ClientId
                              , tmpData_all.ChangePercent
                              , tmpData_all.ChangePercentNext
                              , tmpData_all.DiscountSaleKindId
   
                              , tmpData_all.UnitId_in
                              , tmpData_all.CurrencyId
                              , tmpData_all.OperPrice

                              -- , tmpData_all.x1
   
                              , tmpData_all.Olap_Goods
                              , tmpData_all.Olap_Partion

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
         , tmpDayOfWeek AS (SELECT zfCalc.Ord_dow, zfCalc.DayOfWeekName
                            FROM (SELECT GENERATE_SERIES (CURRENT_DATE, CURRENT_DATE + INTERVAL '6 DAY', '1 DAY' :: INTERVAL) AS OperDate) AS tmp
                                 CROSS JOIN zfCalc_DayOfWeekName_cross (tmp.OperDate) AS zfCalc
                           )

        -- Результат
        SELECT Object_Brand.ValueData        :: VarChar (100) AS BrandName
             , Object_Period.ValueData       :: VarChar (25)  AS PeriodName
             , tmpData.PeriodYear            :: Integer       AS PeriodYear
             , Object_Partner.Id                              AS PartnerId
             , Object_Partner.ValueData      :: VarChar (100) AS PartnerName

             -- , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupName_all
             , Object_GoodsGroup.ValueData                    AS GoodsGroupName
             , Object_Label.ValueData        :: VarChar (100) AS LabelName
             -- , Object_CompositionGroup.ValueData  AS CompositionGroupName
             , Object_Composition.ValueData  :: VarChar (50)  AS CompositionName

             , Object_Goods.Id                                AS GoodsId
             , Object_Goods.ObjectCode                        AS GoodsCode
             , Object_Goods.ValueData        :: VarChar (100) AS GoodsName
             , Object_GoodsInfo.ValueData    :: VarChar (100) AS GoodsInfoName
             , Object_LineFabrica.ValueData  :: VarChar (50)  AS LineFabricaName
             -- , Object_Fabrika.ValueData                    AS FabrikaName

             -- , Object_GoodsSize.Id                            AS GoodsSizeId
             -- , Object_GoodsSize.ValueData :: VarChar (50)  AS GoodsSizeName
             , tmpData.GoodsSizeId           :: Integer       AS GoodsSizeId
             , tmpData.GoodsSizeName         :: VarChar (50)  AS GoodsSizeName 

             , zfCalc_MonthYearName_cross (tmpData.OperDate_doc) :: VarChar (25) AS PeriodName_doc
             , EXTRACT (YEAR FROM tmpData.OperDate_doc)          :: Integer      AS PeriodYear_doc
             , zfCalc_MonthName_cross (tmpData.OperDate_doc)     :: VarChar (25) AS MonthName_doc
             , tmpDayOfWeek.DayOfWeekName                        :: VarChar (4)  AS DayName_doc

             , Object_Unit.ValueData        :: VarChar (100) AS UnitName
             , Object_Client.ValueData      :: VarChar (100) AS ClientName
             , Object_DiscountSaleKind.ValueData :: VarChar (15) AS DiscountSaleKindName
             , tmpData.ChangePercent        :: TFloat        AS ChangePercent
             , tmpData.ChangePercentNext    :: TFloat        AS ChangePercentNext
                                            
             , Object_Unit_In.ValueData     :: VarChar (100) AS UnitName_In
             , Object_Currency.ValueData    :: VarChar (10)  AS CurrencyName

             , CASE WHEN inIsOperPrice = TRUE      THEN tmpData.OperPrice
                    WHEN tmpData.Income_Amount > 0 THEN tmpData.Income_Summ        / tmpData.Income_Amount
                    WHEN tmpData.Sale_Amount   > 0 THEN tmpData.Sale_SummCost_curr / tmpData.Sale_Amount
                    WHEN tmpData.SendIn_Amount > 0 THEN tmpData.SendIn_Summ        / tmpData.SendIn_Amount
                    WHEN tmpData.Debt_Amount   > 0 THEN tmpData.Debt_Summ          / tmpData.Debt_Amount
                    
                    ELSE 0
               END                          :: TFloat AS OperPrice

               -- Приход - только для UnitId, и здесь вычитаем если было Списание или Возврат Поставщику
             , tmpData.Income_Amount        :: TFloat AS Income_Amount
             , tmpData.Income_Summ          :: TFloat AS Income_Summ
               -- Приход - РЕАЛЬНЫЙ - только для UnitId, и здесь НЕ вычитаем если было Списание или Возврат Поставщику
             , tmpData.IncomeReal_Amount    :: TFloat AS IncomeReal_Amount
             , tmpData.IncomeReal_Summ      :: TFloat AS IncomeReal_Summ
                                            
               -- Остаток - без учета "долга"
             , tmpData.Remains_Amount       :: TFloat AS Remains_Amount
             , tmpData.Remains_Summ         :: TFloat AS Remains_Summ
               -- Остаток - с учетом "долга"
             , tmpData.Remains_Amount_real  :: TFloat AS Remains_Amount_real

             , tmpData.RemainsStart       :: TFloat   AS RemainsStart
             , tmpData.RemainsEnd         :: TFloat   AS RemainsEnd
             , tmpData.RemainsStart_Summ  :: TFloat   AS RemainsStart_Summ
             , tmpData.RemainsEnd_Summ    :: TFloat   AS RemainsEnd_Summ
             , tmpData.RemainsStart_Summ_curr :: TFloat     AS RemainsStart_Summ_curr
             , tmpData.RemainsEnd_Summ_curr   :: TFloat     AS RemainsEnd_Summ_curr
             , tmpData.RemainsStart_PriceListSumm :: TFloat AS RemainsStart_PriceListSumm
             , tmpData.RemainsEnd_PriceListSumm   :: TFloat AS RemainsEnd_PriceListSumm
             , tmpData.RemainsStart_PriceListSumm_curr :: TFloat AS RemainsStart_PriceListSumm_curr
             , tmpData.RemainsEnd_PriceListSumm_curr   :: TFloat AS RemainsEnd_PriceListSumm_curr

             -- Перемещение
             , tmpData.SendIn_Amount        :: TFloat AS SendIn_Amount
             , tmpData.SendOut_Amount       :: TFloat AS SendOut_Amount
             , tmpData.SendIn_Summ          :: TFloat AS SendIn_Summ
             , tmpData.SendIn_Summ          :: TFloat AS SendIn_Summ

               -- Списание + Возврат поставщ.
             , tmpData.Loss_Amount          :: TFloat
             , tmpData.Loss_Summ            :: TFloat

               -- Кол-во Остаток - "долг"
             , tmpData.Debt_Amount          :: TFloat
               -- Сумма Остаток - "долг"
             , tmpData.Debt_Summ            :: TFloat

               -- Кол-во продажа - с учетом "долга"
             , (tmpData.Sale_Amount + tmpData.Debt_Amount) :: TFloat AS Sale_Amount
               -- Кол-во продажа - без учета "долга"
             , tmpData.Sale_Amount          :: TFloat AS Sale_Amount_real

               -- Кол-во продажа - ПО Сезонным скидкам
             , (COALESCE (tmpData.Sale_InDiscount,0) - COALESCE (tmpData.Return_InDiscount,0))      :: TFloat AS Result_InDiscount
               -- Кол-во продажа - ДО Сезонных скидок
             , (COALESCE (tmpData.Sale_OutDiscount,0) - COALESCE (tmpData.Return_OutDiscount,0))    :: TFloat AS Result_OutDiscount

             , (tmpData.Sale_SummCost_curr_InDiscount  - tmpData.Return_SummCost_curr_InDiscount)   :: TFloat  AS Result_SummCost_curr_InD
             , (tmpData.Sale_SummCost_curr_OutDiscount - tmpData.Return_SummCost_curr_OutDiscount)  :: TFloat  AS Result_SummCost_curr_OutD
             , (tmpData.Sale_Summ_InDiscount           - tmpData.Return_Summ_InDiscount)            :: TFloat  AS Result_Summ_InD
             , (tmpData.Sale_Summ_OutDiscount          - tmpData.Return_Summ_OutDiscount)           :: TFloat  AS Result_Summ_OutD
             , (tmpData.Sale_Summ_10200_InDiscount     - tmpData.Return_Summ_10200_InDiscount)      :: TFloat  AS Result_Summ_10200_InD
             , (tmpData.Sale_Summ_10200_OutDiscount    - tmpData.Return_Summ_10200_OutDiscount)     :: TFloat  AS Result_Summ_10200_OutD
                            
               -- Сумма продажа - без учета "долга"
             , tmpData.Sale_Summ            :: TFloat
             , tmpData.Sale_Summ_curr       :: TFloat
                                            
               -- С\с продажа - без учета "долга"
             , tmpData.Sale_SummCost_calc   :: TFloat AS Sale_SummCost      -- calc из валюты в Грн
             , tmpData.Sale_SummCost_curr   :: TFloat AS Sale_SummCost_curr -- валюта

               -- Курс. разн продажа
             , (tmpData.Sale_SummCost - tmpData.Sale_SummCost_calc) :: TFloat AS Sale_SummCost_diff
               -- Прибыль продажа с учетом курсовой разницы - без учета "долга"
             , (tmpData.Sale_Summ     - tmpData.Sale_SummCost_calc) :: TFloat AS Sale_Summ_prof

             , tmpData.Sale_Summ_10100      :: TFloat
             , tmpData.Sale_Summ_10201      :: TFloat
             , tmpData.Sale_Summ_10202      :: TFloat
             , tmpData.Sale_Summ_10203      :: TFloat
             , tmpData.Sale_Summ_10204      :: TFloat

               -- Скидка ИТОГО
             , tmpData.Sale_Summ_10200      :: TFloat
             , tmpData.Sale_Summ_10200_curr :: TFloat
                                            
               -- Кол-во возврат
             , tmpData.Return_Amount        :: TFloat

               -- Сумма возврат
             , tmpData.Return_Summ          :: TFloat
             , tmpData.Return_Summ_curr     :: TFloat

               -- С\с возврат
             , tmpData.Return_SummCost_calc :: TFloat AS Return_SummCost      -- calc из валюты в Грн
             , tmpData.Return_SummCost_curr :: TFloat AS Return_SummCost_curr -- валюта

               -- Курс. разн возврат
             , (tmpData.Return_SummCost - tmpData.Return_SummCost_calc) :: TFloat AS Return_SummCost_diff
               -- Убыток возврат
             , (tmpData.Return_Summ     - tmpData.Return_SummCost_calc) :: TFloat AS Return_Summ_prof

               -- Скидка возврат
             , tmpData.Return_Summ_10200      :: TFloat
             , tmpData.Return_Summ_10200_curr :: TFloat

               -- Кол. Итог - с учетом "долга"
             , (tmpData.Result_Amount + tmpData.Debt_Amount)     :: TFloat AS Result_Amount
               -- Кол. Итог - без учета "долга"
             , tmpData.Result_Amount                             :: TFloat AS Result_Amount_real

               -- Сумма Итог - без учета "долга"
             , (tmpData.Sale_Summ          - tmpData.Return_Summ)           :: TFloat AS Result_Summ
             , (tmpData.Sale_Summ_curr     - tmpData.Return_Summ_curr)      :: TFloat AS Result_Summ_curr

               -- С\с Итог - без учета "долга"
             , (tmpData.Sale_SummCost_calc - tmpData.Return_SummCost_calc)  :: TFloat AS Result_SummCost
             , (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr)  :: TFloat AS Result_SummCost_curr

               -- Курс. разн. Итог
             , (tmpData.Sale_SummCost - tmpData.Sale_SummCost_calc - tmpData.Return_SummCost + tmpData.Return_SummCost_calc) :: TFloat AS Result_SummCost_diff

               -- Прибыль Итог с учетом курсовой разницы - без учета "долга"
             , (tmpData.Sale_Summ      - tmpData.Sale_SummCost_calc - tmpData.Return_Summ      + tmpData.Return_SummCost_calc)         :: TFloat AS Result_Summ_prof
             , (tmpData.Sale_Summ_curr - tmpData.Sale_SummCost_curr - tmpData.Return_Summ_curr + tmpData.Return_SummCost_curr)         :: TFloat AS Result_Summ_prof_curr

               -- Скидка Итог
             , (tmpData.Sale_Summ_10200      - tmpData.Return_Summ_10200)      :: TFloat AS Result_Summ_10200
             , (tmpData.Sale_Summ_10200_curr - tmpData.Return_Summ_10200_curr) :: TFloat AS Result_Summ_10200_curr
             
               -- 1. % Продаж: кол-во продажи    / кол-во приход - с учетом "долга"
             , (tmpData.Result_Amount + tmpData.Debt_Amount)   :: TFloat AS Tax_Amount_calc1
             , (tmpData.Income_Amount + tmpData.SendIn_Amount) :: TFloat AS Tax_Amount_calc2
             , CASE WHEN (tmpData.Result_Amount + tmpData.Debt_Amount) > 0 AND (tmpData.Income_Amount + tmpData.SendIn_Amount) > 0
                         THEN (tmpData.Result_Amount + tmpData.Debt_Amount) / (tmpData.Income_Amount + tmpData.SendIn_Amount) * 100
                    ELSE 0
               END :: TFloat AS Tax_Amount

               -- 2. % Продаж: кол-во продажи    / кол-во приход - без учета "долга"
             , (tmpData.Result_Amount) :: TFloat AS Tax_Amount_real_calc1
             , (tmpData.Income_Amount) :: TFloat AS Tax_Amount_real_calc2
             , CASE WHEN tmpData.Result_Amount > 0 AND tmpData.Income_Amount > 0
                         THEN tmpData.Result_Amount / tmpData.Income_Amount * 100
                    ELSE 0
               END :: TFloat AS Tax_Amount_real

               -- 3. % Продаж: сумма с/с продажи / сумма с/с приход - без учета "долга"
             , (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr) :: TFloat AS Tax_Summ_curr_calc1
             , (tmpData.Income_Summ)                                       :: TFloat AS Tax_Summ_curr_calc2
             , CASE WHEN (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr) > 0 AND tmpData.Income_Summ > 0
                         THEN (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr) / tmpData.Income_Summ * 100
                    ELSE 0
               END :: TFloat AS Tax_Summ_curr

               -- 4. % Рентабельности: сумма продажи / сумма с/с - без учета "долга"
             , ((tmpData.Sale_Summ_curr     - tmpData.Return_Summ_curr) - (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr))   :: TFloat AS Tax_Summ_prof_calc1
             , (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr) :: TFloat AS Tax_Summ_prof_calc2
             , CASE WHEN (tmpData.Sale_Summ_curr     - tmpData.Return_Summ_curr) > 0 AND (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr) > 0
                         THEN (tmpData.Sale_Summ_curr     - tmpData.Return_Summ_curr) / (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr) * 100 - 100
                    ELSE 0
               END :: TFloat AS Tax_Summ_prof

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
               END :: VarChar (50) AS GroupsName1

               -- 2 - Следующий ПОСЛЕ П.1. + !!!для "Детское" - еще Следующий!!!
             , CASE WHEN tmpData.GroupId2_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup1.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup1.ValueData -- Object_Label.ValueData
                                   ELSE Object_GoodsGroup1.ValueData
                              END
                    WHEN tmpData.GroupId3_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup2.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup2.ValueData -- Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup2.ValueData
                              END
                    WHEN tmpData.GroupId4_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup3.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup3.ValueData -- Object_GoodsGroup2.ValueData
                                   ELSE Object_GoodsGroup3.ValueData
                              END
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup4.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup4.ValueData -- Object_GoodsGroup3.ValueData
                                   ELSE Object_GoodsGroup4.ValueData
                              END
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup5.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup5.ValueData -- Object_GoodsGroup4.ValueData
                                   ELSE Object_GoodsGroup5.ValueData
                              END
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup6.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup6.ValueData -- Object_GoodsGroup5.ValueData
                                   ELSE Object_GoodsGroup6.ValueData
                              END
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup7.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup7.ValueData -- Object_GoodsGroup6.ValueData
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
                                   THEN Object_GoodsGroup2.ValueData -- Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup2.ValueData
                              END
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup4.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup3.ValueData -- Object_GoodsGroup2.ValueData
                                   ELSE Object_GoodsGroup3.ValueData
                              END
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup5.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup4.ValueData -- Object_GoodsGroup3.ValueData
                                   ELSE Object_GoodsGroup4.ValueData
                              END
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup6.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup5.ValueData -- Object_GoodsGroup4.ValueData
                                   ELSE Object_GoodsGroup5.ValueData
                              END
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup7.ValueData)) = TRIM (LOWER ('Детское'))
                                   THEN Object_GoodsGroup6.ValueData -- Object_GoodsGroup5.ValueData
                                   ELSE Object_GoodsGroup6.ValueData
                              END
               END :: VarChar (50) AS GroupsName3

               -- 0 - Первая Группа СНИЗУ
             , Object_GoodsGroup1.ValueData :: VarChar (50) AS GroupsName4 -- а было AnalyticaName1, а в GroupsName4 - сейчас LabelName

             , CASE WHEN tmpData.Olap_Goods   > 0 THEN 'Да' ELSE 'Нет' END :: VarChar (3) AS isOLAP_Goods
             , CASE WHEN tmpData.Olap_Partion > 0 THEN 'Да' ELSE 'Нет' END :: VarChar (3) AS isOLAP_Partion
        FROM tmpData
            LEFT JOIN tmpDayOfWeek ON tmpDayOfWeek.Ord_dow = tmpData.OrdDay_doc

            LEFT JOIN Object AS Object_Client           ON Object_Client.Id           = tmpData.ClientId
            LEFT JOIN Object AS Object_Partner          ON Object_Partner.Id          = tmpData.PartnerId
            LEFT JOIN Object AS Object_Unit             ON Object_Unit.Id             = tmpData.UnitId
            LEFT JOIN Object AS Object_Unit_In          ON Object_Unit_In.Id          = tmpData.UnitId_in
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = tmpData.CurrencyId
            LEFT JOIN Object AS Object_DiscountSaleKind ON Object_DiscountSaleKind.Id = tmpData.DiscountSaleKindId

            -- LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
            --                        ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
            --                       AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpData.LabelId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = tmpData.CompositionId
            -- LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpData.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = tmpData.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpData.LineFabricaId
            -- LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpData.GoodsSizeId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = tmpData.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = tmpData.PeriodId
            LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = NULL -- tmpData.FabrikaId

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
 16.05.18         * add isOlap
 07.02.18         
*/

-- тест
-- SELECT LabelName, GroupsName4, GroupsName3, GroupsName2, GroupsName1 FROM gpReport_SaleOLAP (inStartDate:= '01.01.2017', inEndDate:= '31.12.2017', inUnitId:= 0, inPartnerId:= 2628, inBrandId:= 0, inPeriodId:= 0, inStartYear:= 2017, inEndYear:= 2017, inIsYear:= FALSE, inIsPeriodAll:= TRUE, inIsGoods:= FALSE, inIsSize:= FALSE, inIsClient_doc:= FALSE, inIsOperDate_doc:= FALSE, inIsDay_doc:= FALSE, inIsOperPrice:= FALSE, inIsDiscount:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_MotionOLAP (inStartDate:= '01.01.2017', inEndDate:= '31.12.2017', inUnitId:= 0, inPartnerId:= 2628, inBrandId:= 0, inPeriodId:= 0, inStartYear:= 2017, inEndYear:= 2017, inIsYear:= TRUE, inIsPeriodAll:= TRUE, inIsGoods:= FALSE, inIsSize:= FALSE, inIsClient_doc:= FALSE, inIsOperDate_doc:= FALSE, inIsDay_doc:= FALSE, inIsOperPrice:= FALSE, inIsDiscount:= FALSE, inIsMark:= FALSE, inSession:= zfCalc_UserAdmin());


--select * from Object_PartionGoods limit 10