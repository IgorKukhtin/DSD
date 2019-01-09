-- Function: gpReport_Sale_Analysis()

DROP FUNCTION IF EXISTS gpReport_Sale_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Sale_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Sale_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Sale_Analysis (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Sale_Analysis (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inPartnerId        Integer  ,  -- Поставщик
    IN inBrandId          Integer  ,  --
    IN inPeriodId         Integer  ,  --
    IN inLineFabricaId    Integer  ,  --
    IN inStartYear        Integer  ,
    IN inEndYear          Integer  ,
    IN inPresent1         TFloat   ,
    IN inPresent2         TFloat   ,
    IN inPresent1_Summ    TFloat   ,
    IN inPresent2_Summ    TFloat   ,
    IN inPresent1_Prof    TFloat   ,
    IN inPresent2_Prof    TFloat   ,
    IN inIsPeriodAll      Boolean  , -- ограничение за Весь период (Да/Нет) (движение по Документам)
    IN inIsUnit           Boolean  , -- по выбранным подразделениям
    IN inIsBrand          Boolean  , -- по выбранным т орговым маркам
    IN inIsAmount         Boolean  , -- распределять по гридам по % продаж кол-во
    IN inIsSumm           Boolean  , -- распределять по гридам по % продаж сумма
    IN inIsProf           Boolean  , -- распределять по гридам по % прибыли
    IN inIsLineFabrica    Boolean  , -- показать Линию Да/нет
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

    -- порверка должно быть выбрано одно из распределений
    IF (COALESCE (inIsAmount, FALSE) = TRUE AND COALESCE (inIsSumm, FALSE) = TRUE)
    OR (COALESCE (inIsAmount, FALSE) = TRUE AND COALESCE (inIsProf, FALSE) = TRUE)
    OR (COALESCE (inIsSumm, FALSE) = TRUE   AND COALESCE (inIsProf, FALSE) = TRUE)
    THEN
        RAISE EXCEPTION 'Ошибка. Должен быть выбран только один вариан распределения';
    END IF;
    
 CREATE TEMP TABLE _tmpData (PartionId             Integer
                           , BrandName             TVarChar
                           , PeriodName            TVarChar
                           , PeriodYear            Integer
                           , PartnerId             Integer
                           , PartnerName           TVarChar
                           , LineFabricaName       TVarChar
              
                           , UnitName              TVarChar
                           , UnitName_In           TVarChar
                           , CurrencyName          TVarChar
              
                           , Income_Amount         TFloat
                           , Income_Summ           TFloat
              
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
                           , Sale_Summ_10201_curr  TFloat
                           , Sale_Summ_10202_curr  TFloat
                           , Sale_Summ_10203_curr  TFloat
                           , Sale_Summ_10204_curr  TFloat
                           , Tax_Amount            TFloat
                           , Tax_Summ_curr         TFloat
                           , Tax_Summ_prof         TFloat
                           , Tax_Summ_10200        TFloat
                           , Tax_Summ_10100        TFloat
                           , Tax_Summ_10203        TFloat
                           , Tax_Summ_10201        TFloat
                           , Tax_Summ_10202        TFloat
                           , Sale_Amount_10202        TFloat
                           , Sale_Amount_InDiscount   TFloat
                           , Sale_Amount_OutDiscount  TFloat
                           , Tax_Amount_10202  TFloat
                           , Tax_InDiscount    TFloat
                           , Tax_OutDiscount   TFloat
                         ) ON COMMIT DROP;
                           
        INSERT INTO _tmpData (BrandName
                            , PeriodName
                            , PeriodYear
                            , PartnerId
                            , PartnerName
                            , LineFabricaName
                           
                            , UnitName
                            , UnitName_In
                            , CurrencyName

                            , Income_Amount
                            , Income_Summ
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
                            , Sale_Summ_10201_curr
                            , Sale_Summ_10202_curr
                            , Sale_Summ_10203_curr
                            , Sale_Summ_10204_curr
             
                            , Tax_Amount
                            , Tax_Summ_curr
                            , Tax_Summ_prof
                            , Tax_Summ_10200 
                            , Tax_Summ_10100
                            , Tax_Summ_10203
                            , Tax_Summ_10201 
                            , Tax_Summ_10202

                            , Sale_Amount_10202
                            , Sale_Amount_InDiscount
                            , Sale_Amount_OutDiscount
                            , Tax_Amount_10202
                            , Tax_InDiscount
                            , Tax_OutDiscount
                              )
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

           -- Список торговых марок
         , tmpBrand AS (SELECT ObjectLink_Object.ChildObjectId AS BrandId
                       FROM Object
                            INNER JOIN ObjectLink AS ObjectLink_User
                                                  ON ObjectLink_User.ObjectId      = Object.Id
                                                 AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                 AND ObjectLink_User.ChildObjectId = vbUserId
                            INNER JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ObjectId    = Object.Id
                                                 AND ObjectLink_Object.DescId      = zc_ObjectLink_ReportOLAP_Object()
                       WHERE Object.DescId     = zc_Object_ReportOLAP()
                         AND Object.ObjectCode = zc_ReportOLAP_Brand()
                         AND Object.isErased   = FALSE
                         AND inIsBrand = TRUE
                      UNION
                       SELECT Object.Id AS BrandId
                       FROM Object
                       WHERE inIsBrand = FALSE 
                         AND (Object.Id = inBrandId OR inBrandId = 0)
                         AND Object.DescId = zc_Object_Brand()
                      )

         , tmpUnit2 AS (SELECT Object.Id AS UnitId
                        FROM Object
                        WHERE Object.DescId = zc_Object_Unit()
                       )

           -- Список - по приходам на эти магазины и строится отчет (и не важно кто продавал)
         , tmpUnit AS (SELECT ObjectLink_Object.ChildObjectId AS UnitId
                       FROM Object
                            INNER JOIN ObjectLink AS ObjectLink_User
                                                  ON ObjectLink_User.ObjectId      = Object.Id
                                                 AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                 AND ObjectLink_User.ChildObjectId = vbUserId
                            INNER JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ObjectId    = Object.Id
                                                 AND ObjectLink_Object.DescId      = zc_ObjectLink_ReportOLAP_Object()
                       WHERE Object.DescId     = zc_Object_ReportOLAP()
                         AND Object.ObjectCode = zc_ReportOLAP_Unit()
                         AND Object.isErased   = FALSE
                         AND inIsUnit = TRUE
                      UNION
                       SELECT inUnitId AS UnitId
                       WHERE inIsUnit = FALSE
                      )
           -- Партии - приходы на tmpUnit
         , tmpObject_PartionGoods AS (SELECT Object_PartionGoods.*
                                      FROM Object_PartionGoods
                                           INNER JOIN tmpUnit ON tmpUnit.UnitId = Object_PartionGoods.UnitId
                                           INNER JOIN tmpBrand ON tmpBrand.BrandId = Object_PartionGoods.BrandId
                                      WHERE (Object_PartionGoods.PartnerId  = inPartnerId        OR inPartnerId   = 0)
                                        --AND (Object_PartionGoods.BrandId    = inBrandId          OR inBrandId     = 0)
                                        AND (Object_PartionGoods.PeriodId   = inPeriodId         OR inPeriodId    = 0)
                                        AND (Object_PartionGoods.LineFabricaId = inLineFabricaId OR inLineFabricaId =0)
                                        AND (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                                      )
           -- Список ContainerId - для Object_PartionGoods
         /*, tmpContainer AS (SELECT Container.Id AS ContainerId
                            FROM Container
                                 -- INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                 INNER JOIN tmpObject_PartionGoods AS Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                            WHERE Container.DescId  = zc_Container_Count()
                           UNION ALL
                            SELECT Container.Id AS ContainerId
                            FROM Container
                                 -- INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                 INNER JOIN tmpObject_PartionGoods AS Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                            WHERE Container.DescId   = zc_Container_Summ()
                              AND Container.ObjectId = zc_Enum_Account_100301() -- прибыль текущего периода
                           )*/
          -- список Возврат Поставщику + Брак
        , tmpReturnOut AS (SELECT tmpObject_PartionGoods.MovementItemId AS PartionId
                                , SUM (-1 * MIContainer.Amount)      AS Amount
                           FROM tmpObject_PartionGoods
                                INNER JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.PartionId = tmpObject_PartionGoods.MovementItemId
                                                                AND MIContainer.MovementDescId IN (zc_Movement_ReturnOut(), zc_Movement_Loss())
                                                                AND MIContainer.DescId = zc_MIContainer_Count()
                                -- НЕ важно с какго подразделения, ГЛАВНОЕ - партия
                                INNER JOIN tmpUnit ON tmpUnit.UnitId = tmpObject_PartionGoods.UnitId
                           GROUP BY tmpObject_PartionGoods.MovementItemId
                          )

          -- итого приход по PartnerId + LineFabricaId   за минусом  Возврат Поставщику + Брак
        , tmpIncome AS (SELECT Object_PartionGoods.PartnerId
                             , CASE WHEN inIsLineFabrica = TRUE THEN Object_PartionGoods.LineFabricaId ELSE 0 END AS LineFabricaId
                             , SUM (COALESCE (Object_PartionGoods.Amount, 0) - COALESCE (tmpReturnOut.Amount, 0)) AS Income_Amount
                             , SUM ((COALESCE (Object_PartionGoods.Amount, 0) - COALESCE (tmpReturnOut.Amount, 0))  * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END) AS Income_Summ
                        FROM tmpObject_PartionGoods AS Object_PartionGoods
                             LEFT JOIN tmpReturnOut ON tmpReturnOut.PartionId = Object_PartionGoods.MovementItemId
                        WHERE Object_PartionGoods.isErased = FALSE
                        GROUP BY Object_PartionGoods.PartnerId
                               , CASE WHEN inIsLineFabrica = TRUE THEN Object_PartionGoods.LineFabricaId ELSE 0 END
                        )

          -- итого Остаток по PartnerId + LineFabricaId
        , tmpRemains AS (SELECT Object_PartionGoods.PartnerId                                                      AS PartnerId
                              , CASE WHEN inIsLineFabrica = TRUE THEN Object_PartionGoods.LineFabricaId ELSE 0 END AS LineFabricaId
                              , SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN Container.Amount ELSE 0 END)    AS Amount
                              , SUM (Container.Amount)                                                             AS Amount_real
                         FROM tmpObject_PartionGoods AS Object_PartionGoods
                              INNER JOIN Container ON Container.PartionId = Object_PartionGoods.MovementItemId
                                                  AND Container.DescId    = zc_Container_Count()
                                                  AND Container.Amount    <> 0
                              -- INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                              LEFT JOIN ContainerLinkObject AS CLO_Client
                                                            ON CLO_Client.ContainerId = Container.Id
                                                           AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                         GROUP BY Object_PartionGoods.PartnerId
                                , CASE WHEN inIsLineFabrica = TRUE THEN Object_PartionGoods.LineFabricaId ELSE 0 END
                        )
                                
         , tmpData_all AS (SELECT Object_PartionGoods.PartnerId
                                , Object_PartionGoods.BrandId
                                , Object_PartionGoods.PeriodId
                                , Object_PartionGoods.PeriodYear
                                , CASE WHEN inIsLineFabrica = TRUE THEN Object_PartionGoods.LineFabricaId ELSE 0 END AS LineFabricaId

                                  -- магазин кто продавал - подставим куда был приход
                                -- , COALESCE (MIContainer.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) :: Integer AS UnitId
                                , Object_PartionGoods.UnitId :: Integer AS UnitId
                                  -- магазин куда приход
                                , Object_PartionGoods.UnitId     AS UnitId_in

                                , Object_PartionGoods.CurrencyId AS CurrencyId

                                  -- Кол-во Приход от поставщика - только для UnitId
                                -- , (Object_PartionGoods.Amount) AS Income_Amount
                                -- , (Object_PartionGoods.Amount * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END) AS Income_Summ

                                  -- Кол-во: Долг
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN COALESCE (MIContainer.Amount,0) ELSE 0 END) AS Debt_Amount

                                  -- Кол-во: Продажа - возврат
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount < 0 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIContainer.Amount ELSE 0 END
                                     - CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount > 0 AND MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN 1 * MIContainer.Amount ELSE 0 END
                                       )    :: TFloat AS Sale_Amount
                                     
                                  -- С\с продажа - calc из валюты в Грн
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount < 0 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN -1 * MIContainer.Amount
                                                     * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                     * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                     / CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_SummCost_calc

                                  -- Сумма продажа
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN -1 * MIContainer.Amount
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ
                                   -- переводим в валюту 
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN -1 * MIContainer.Amount
                                                    / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                    * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                    -- !!!обнулили если нет КУРСА!!!
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ_curr

                                  -- С\с продажа - ГРН
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN  1 * MIContainer.Amount
                                            ELSE 0
                                       END) :: TFloat AS Sale_SummCost
                                  -- !!! ТОЛЬКО ДЛЯ ТЕСТОВОЙ БАЗЫ!!! С\с продажа - ГРН
                                /*, SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount < 0 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN -1 * MIContainer.Amount
                                                     * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                     * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                     / CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_SummCost*/

                                  -- С\с продажа - валюта
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount < 0 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN -1 * MIContainer.Amount
                                                    * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_SummCost_curr

                                  -- Сумма Прайс
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10100
                                  -- Сезонная скидка
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10201() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10201
                                  -- Скидка outlet
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10202() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10202
                                  -- Скидка клиента
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10203() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10203
                                  -- скидка дополнительная
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10204() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIContainer.Amount ELSE 0 END) :: TFloat AS Sale_Summ_10204

                                  -- Скидка ИТОГО
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN 1 * MIContainer.Amount
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ_10200
                                   -- переводим в валюту 
                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN 1 * MIContainer.Amount
                                                    / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                    * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                    -- !!!обнулили если нет КУРСА!!!
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ_10200_curr

                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10201() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN 1 * MIContainer.Amount
                                                    / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                    * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                    -- !!!обнулили если нет КУРСА!!!
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ_10201_curr

                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10202() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN 1 * MIContainer.Amount
                                                    / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                    * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                    -- !!!обнулили если нет КУРСА!!!
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ_10202_curr

                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10203() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN 1 * MIContainer.Amount
                                                    / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                    * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                    -- !!!обнулили если нет КУРСА!!!
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ_10203_curr

                                , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10204() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                 THEN 1 * MIContainer.Amount
                                                    / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                    * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                    -- !!!обнулили если нет КУРСА!!!
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                            ELSE 0
                                       END) :: TFloat AS Sale_Summ_10204_curr
                                  --  № п/п
                                /*, ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId
                                                     ORDER BY CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIContainer.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC
                                                    ) AS Ord*/

                                 -- Кол-во: скидка outlet
                                , SUM (CASE WHEN COALESCE (MILinkObject_DiscountSaleKind.ObjectId,0) = 290 AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount < 0 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIContainer.Amount ELSE 0 END
                                         - CASE WHEN COALESCE (MILinkObject_DiscountSaleKind.ObjectId,0) = 290 AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount > 0 AND MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN 1 * MIContainer.Amount ELSE 0 END
                                       )    :: TFloat AS Sale_Amount_10202
                                       
                                -- Кол-во продажа (ПО Сезонным скидкам)
                                , SUM (CASE WHEN COALESCE (MILinkObject_DiscountSaleKind.ObjectId,0) <> 290 AND COALESCE(tmpDiscountPeriod.PeriodId, 0) = 0 AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount < 0 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIContainer.Amount ELSE 0 END
                                     - CASE WHEN COALESCE (MILinkObject_DiscountSaleKind.ObjectId,0) <> 290 AND COALESCE(tmpDiscountPeriod_Ret.PeriodId, 0) = 0 AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount > 0 AND MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN 1 * MIContainer.Amount ELSE 0 END
                                       )    :: TFloat AS Sale_Amount_InDiscount
                                 -- Кол-во продажа (ДО Сезонных скидок)
                                , SUM (CASE WHEN COALESCE (MILinkObject_DiscountSaleKind.ObjectId,0) <> 290 AND COALESCE(tmpDiscountPeriod.PeriodId, 0) <> 0 AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount < 0 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIContainer.Amount ELSE 0 END
                                     - CASE WHEN COALESCE (MILinkObject_DiscountSaleKind.ObjectId,0) <> 290 AND COALESCE(tmpDiscountPeriod_Ret.PeriodId, 0) <> 0 AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount > 0 AND MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN 1 * MIContainer.Amount ELSE 0 END
                                       )    :: TFloat AS Sale_Amount_OutDiscount

                           FROM tmpObject_PartionGoods AS Object_PartionGoods
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.PartionId = Object_PartionGoods.MovementItemId
                                                               AND (MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                                 OR inIsPeriodAll = TRUE)
                                                               AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount(), zc_Movement_ReturnIn())
                                                               AND (MIContainer.AccountId = zc_Enum_Account_100301 () -- прибыль текущего периода
                                                                 OR MIContainer.DescId = zc_MIContainer_Count()
                                                                   )
                                /*LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                                 ON MILinkObject_PartionMI.MovementItemId = MIContainer.MovementItemId
                                                                AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                                LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId*/
                                
                                -- LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MIContainer.PartionId
                                
                                LEFT JOIN tmpCurrency  ON tmpCurrency.CurrencyFromId = zc_Currency_Basis()
                                                      AND tmpCurrency.CurrencyToId   = Object_PartionGoods.CurrencyId
                                                      AND MIContainer.OperDate       >= tmpCurrency.StartDate
                                                      AND MIContainer.OperDate       <  tmpCurrency.EndDate

                                -- надо ограничить, что б попали проводки "продажа" - от Клиента
                                INNER JOIN tmpUnit2 ON tmpUnit2.UnitId = MIContainer.ObjectExtId_Analyzer
                                
                                --
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                                 ON MILinkObject_PartionMI.MovementItemId = MIContainer.MovementItemId
                                                                AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                                LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                                 ON MILinkObject_DiscountSaleKind.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIContainer.MovementItemId)
                                                                AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()

                                LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                                LEFT JOIN tmpDiscountPeriod ON tmpDiscountPeriod.PeriodId = Object_PartionGoods.PeriodId
                                                           AND Movement.OperDate BETWEEN tmpDiscountPeriod.StartDate AND tmpDiscountPeriod.EndDate

                               -- док. продажи для док.возврата
                               LEFT JOIN MovementItem AS MovementItem_Sale ON MovementItem_Sale.Id = Object_PartionMI.ObjectCode
                               LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementItem_Sale.MovementId
                               -- период скидок для возврата по дате продажи
                               LEFT JOIN tmpDiscountPeriod AS tmpDiscountPeriod_Ret 
                                                           ON tmpDiscountPeriod_Ret.PeriodId = Object_PartionGoods.PeriodId
                                                          AND Movement_Sale.OperDate BETWEEN tmpDiscountPeriod_Ret.StartDate AND tmpDiscountPeriod_Ret.EndDate


-- where MIContainer.MovementId =  266623 

                           GROUP BY Object_PartionGoods.PartnerId
                                  , Object_PartionGoods.BrandId
                                  , Object_PartionGoods.PeriodId
                                  , Object_PartionGoods.PeriodYear
                                  -- , COALESCE (MIContainer.ObjectExtId_Analyzer, Object_PartionGoods.UnitId)
                                  , Object_PartionGoods.UnitId
                                  , Object_PartionGoods.CurrencyId
                                  -- , Object_PartionGoods.Amount
                                  -- , Object_PartionGoods.MovementItemId
                                  , CASE WHEN inIsLineFabrica = TRUE THEN Object_PartionGoods.LineFabricaId ELSE 0 END

                         /*   HAVING SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND COALESCE (MIContainer.AnalyzerId, 0) =  zc_Enum_AnalyzerId_SaleSumm_10300() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIContainer.Amount ELSE 0 END) <> 0
                                OR SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ()  AND COALESCE (MIContainer.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIContainer.Amount ELSE 0 END) <> 0
                                  -- Кол-во: Долг
                                OR SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() THEN MIContainer.Amount ELSE 0 END) <> 0
                                  -- Кол-во: Только Продажа
                                OR SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount < 0 AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIContainer.Amount ELSE 0 END
                                      - CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.Amount > 0 AND MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN 1 * MIContainer.Amount ELSE 0 END) <> 0
                          */)

       , tmpData AS (SELECT tmpData_all.PartnerId
                          , tmpData_all.BrandId
                          , tmpData_all.PeriodId
                          , tmpData_all.PeriodYear
                          , tmpData_all.LineFabricaId

                          , tmpData_all.UnitId
                          , tmpData_all.UnitId_in
                          , tmpData_all.CurrencyId

                          -- , SUM (tmpData_all.Income_Amount )        AS Income_Amount
                          -- , SUM (tmpData_all.Income_Summ)           AS Income_Summ
                          
                          , SUM (tmpData_all.Debt_Amount)           AS Debt_Amount
                          , SUM (tmpData_all.Sale_Amount)           AS Sale_Amount
 
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

                          , SUM (tmpData_all.Sale_Summ_10201_curr)  AS Sale_Summ_10201_curr
                          , SUM (tmpData_all.Sale_Summ_10202_curr)  AS Sale_Summ_10202_curr
                          , SUM (tmpData_all.Sale_Summ_10203_curr)  AS Sale_Summ_10203_curr
                          , SUM (tmpData_all.Sale_Summ_10204_curr)  AS Sale_Summ_10204_curr
                          
                          , SUM (tmpData_all.Sale_Amount_10202)       AS Sale_Amount_10202
                          , SUM (tmpData_all.Sale_Amount_InDiscount)  AS Sale_InDiscount
                          , SUM (tmpData_all.Sale_Amount_OutDiscount) AS Sale_OutDiscount

                     FROM tmpData_all

                     GROUP BY tmpData_all.BrandId
                            , tmpData_all.PeriodId
                            , tmpData_all.PeriodYear
                            , tmpData_all.PartnerId
                            , tmpData_all.UnitId
                            , tmpData_all.UnitId_in
                            , tmpData_all.CurrencyId
                            , tmpData_all.LineFabricaId
                    )


        -- Результат
        SELECT Object_Brand.ValueData    :: TVarChar      AS BrandName
             , Object_Period.ValueData   :: TVarChar      AS PeriodName
             , tmpData.PeriodYear        :: Integer       AS PeriodYear
             , Object_Partner.Id                          AS PartnerId
             , Object_Partner.ValueData  :: TVarChar      AS PartnerName
             , Object_LineFabrica.ValueData :: TVarChar   AS LineFabricaName

             , Object_Unit.ValueData        :: TVarChar   AS UnitName

             , Object_Unit_In.ValueData     :: TVarChar  AS UnitName_In
             , Object_Currency.ValueData    :: TVarChar  AS CurrencyName
             
             , tmpIncome.Income_Amount        :: TFloat
             , tmpIncome.Income_Summ          :: TFloat
                                            
             --, tmpData.Debt_Amount          :: TFloat
             -- остаток
             , tmpRemains.Amount            :: TFloat   AS Debt_Amount  --Amount_Real
             -- продажа - возврат + долг
             , (COALESCE (tmpData.Sale_Amount,0) + COALESCE (tmpData.Debt_Amount,0)) :: TFloat AS Sale_Amount 

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

             , tmpData.Sale_Summ_10201_curr :: TFloat
             , tmpData.Sale_Summ_10202_curr :: TFloat
             , tmpData.Sale_Summ_10203_curr :: TFloat
             , tmpData.Sale_Summ_10204_curr :: TFloat

               -- % кол-во продали    / кол-во приход
             , CASE WHEN tmpData.Sale_Amount > 0 AND tmpIncome.Income_Amount > 0
                         THEN tmpData.Sale_Amount / tmpIncome.Income_Amount * 100
                    ELSE 0
               END :: TFloat AS Tax_Amount

               -- % сумма с/с продали / сумма с/с приход
             , CASE WHEN tmpData.Sale_Summ_curr > 0 AND tmpIncome.Income_Summ > 0
                         THEN tmpData.Sale_Summ_curr * 100 / tmpIncome.Income_Summ
                    ELSE 0
               END :: TFloat AS Tax_Summ_curr

               -- %  рентабельности
             , CASE WHEN (tmpData.Sale_Summ_curr - tmpData.Sale_SummCost_curr) > 0 AND tmpData.Sale_SummCost_curr > 0
                         THEN (tmpData.Sale_Summ_curr- tmpData.Sale_SummCost_curr) * 100/ tmpData.Sale_SummCost_curr
                    ELSE 0
               END :: TFloat AS Tax_Summ_prof   
                         
               -- % сумма продажа     / сумма скидки
             , CASE WHEN tmpData.Sale_Summ_10200 > 0 AND tmpData.Sale_Summ_10100 > 0
                         THEN tmpData.Sale_Summ_10200 * 100 / tmpData.Sale_Summ_10100 
                    ELSE 0
               END :: TFloat AS Tax_Summ_10200 
             
               -- % сумма продажа итого    / сумма продажа с уч. скидки
             , CASE WHEN tmpData.Sale_Summ > 0 AND tmpData.Sale_Summ_10100 > 0
                         THEN tmpData.Sale_Summ * 100/ tmpData.Sale_Summ_10100  -- 100
                    ELSE 0
               END :: TFloat AS Tax_Summ_10100  
               
                -- % сумма скидки итого    / сумма скидки клиента + доп. скидка
             , CASE WHEN (COALESCE (tmpData.Sale_Summ_10203, 0) + COALESCE (tmpData.Sale_Summ_10204, 0)) > 0 AND tmpData.Sale_Summ_10200 > 0
                         THEN (COALESCE (tmpData.Sale_Summ_10203, 0) + COALESCE (tmpData.Sale_Summ_10204, 0)) * 100/ tmpData.Sale_Summ_10200  -- 100
                    ELSE 0
               END :: TFloat AS Tax_Summ_10203
               
                -- % сумма скидки итого    / сумма скидки сезон 
             , CASE WHEN COALESCE (tmpData.Sale_Summ_10201,0) > 0 AND tmpData.Sale_Summ_10200 > 0
                         THEN COALESCE (tmpData.Sale_Summ_10201,0) * 100/ tmpData.Sale_Summ_10200  -- 100
                    ELSE 0
               END :: TFloat AS Tax_Summ_10201

                -- % сумма скидки итого    / сумма скидки  outlet
             , CASE WHEN COALESCE (tmpData.Sale_Summ_10202, 0) > 0 AND tmpData.Sale_Summ_10200 > 0
                         THEN COALESCE (tmpData.Sale_Summ_10202, 0) * 100/ tmpData.Sale_Summ_10200  -- 100
                    ELSE 0
               END :: TFloat AS Tax_Summ_10202 
               
             -- кол-во продажа outlet
             , tmpData.Sale_Amount_10202       :: TFloat
               -- Кол-во продажа - ПО Сезонным скидкам
             , COALESCE (tmpData.Sale_InDiscount,0)    :: TFloat AS Sale_InDiscount
               -- Кол-во продажа - ДО Сезонных скидок
             , COALESCE (tmpData.Sale_OutDiscount,0)   :: TFloat AS Sale_OutDiscount

             --% кол-во продажа outlet
             , CASE WHEN COALESCE (tmpData.Sale_Amount,0) <> 0 THEN tmpData.Sale_Amount_10202 * 100 / tmpData.Sale_Amount ELSE 0 END :: TFloat AS Tax_Amount_10202
             --% Кол-во продажа - ПО Сезонным скидкам
             , CASE WHEN COALESCE (tmpData.Sale_Amount,0) <> 0 THEN COALESCE (tmpData.Sale_InDiscount,0) * 100 / tmpData.Sale_Amount ELSE 0 END :: TFloat AS Tax_InDiscount
             --% Кол-во продажа - ДО Сезонных скидок
             , CASE WHEN COALESCE (tmpData.Sale_Amount,0) <> 0 THEN COALESCE (tmpData.Sale_OutDiscount,0)* 100 / tmpData.Sale_Amount ELSE 0 END :: TFloat AS Tax_OutDiscount
              
        FROM tmpData
            LEFT JOIN Object AS Object_Partner          ON Object_Partner.Id          = tmpData.PartnerId
            LEFT JOIN Object AS Object_Unit             ON Object_Unit.Id             = tmpData.UnitId
            LEFT JOIN Object AS Object_Unit_In          ON Object_Unit_In.Id          = tmpData.UnitId_in
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = tmpData.CurrencyId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = tmpData.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = tmpData.PeriodId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpData.LineFabricaId
            LEFT JOIN tmpIncome ON tmpIncome.PartnerId     = tmpData.PartnerId
                               AND tmpIncome.LineFabricaId = tmpData.LineFabricaId
            LEFT JOIN tmpRemains ON tmpRemains.PartnerId     = tmpData.PartnerId
                                AND tmpRemains.LineFabricaId = tmpData.LineFabricaId
          ;

     --продажи больше 50% от прихода
     OPEN Cursor1 FOR
     SELECT _tmpData.*
          , CASE WHEN Tax_Amount    >= inPresent1      THEN 16744448 WHEN Tax_Amount    >= inPresent2      AND Tax_Amount    < inPresent1      THEN zc_Color_Yelow() WHEN Tax_Amount    < inPresent2      THEN zc_Color_Red() END AS Color_Amount
          , CASE WHEN Tax_Summ_curr >= inPresent1_Summ THEN 16744448 WHEN Tax_Summ_curr >= inPresent2_Summ AND Tax_Summ_curr < inPresent1_Summ THEN zc_Color_Yelow() WHEN Tax_Summ_curr < inPresent2_Summ THEN zc_Color_Red() END AS Color_Sum
          , CASE WHEN Tax_Summ_prof >= inPresent1_Prof THEN 16744448 WHEN Tax_Summ_prof >= inPresent2_Prof AND Tax_Summ_prof < inPresent1_Prof THEN zc_Color_Yelow() WHEN Tax_Summ_prof < inPresent2_Prof THEN zc_Color_Red() END AS Color_Prof
     FROM _tmpData
     WHERE (inIsAmount = TRUE AND Tax_Amount     >= inPresent1)
        OR (inIsSumm   = TRUE AND Tax_Summ_curr >= inPresent1_Summ)
        OR (inIsProf   = TRUE AND Tax_Summ_prof  >= inPresent1_Prof)
     ;
     RETURN NEXT Cursor1;


     --продажи больше 20% меньше 50% от прихода
     OPEN Cursor2 FOR
     SELECT _tmpData.*
          , CASE WHEN Tax_Amount    >= inPresent1      THEN 16744448 WHEN Tax_Amount    >= inPresent2      AND Tax_Amount    < inPresent1      THEN zc_Color_Yelow() WHEN Tax_Amount    < inPresent2      THEN zc_Color_Red() END AS Color_Amount
          , CASE WHEN Tax_Summ_curr >= inPresent1_Summ THEN 16744448 WHEN Tax_Summ_curr >= inPresent2_Summ AND Tax_Summ_curr < inPresent1_Summ THEN zc_Color_Yelow() WHEN Tax_Summ_curr < inPresent2_Summ THEN zc_Color_Red() END AS Color_Sum
          , CASE WHEN Tax_Summ_prof >= inPresent1_Prof THEN 16744448 WHEN Tax_Summ_prof >= inPresent2_Prof AND Tax_Summ_prof < inPresent1_Prof THEN zc_Color_Yelow() WHEN Tax_Summ_prof < inPresent2_Prof THEN zc_Color_Red() END AS Color_Prof
      FROM _tmpData
     WHERE (inIsAmount = TRUE AND Tax_Amount    >= inPresent2      AND Tax_Amount    < inPresent1)
        OR (inIsSumm   = TRUE AND Tax_Summ_curr >= inPresent2_Summ AND Tax_Summ_curr < inPresent1_Summ)
        OR (inIsProf   = TRUE AND Tax_Summ_prof >= inPresent2_Prof AND Tax_Summ_prof < inPresent1_Prof)
     ;
     RETURN NEXT Cursor2; 

     --продажи меньше 20% от прихода
     OPEN Cursor3 FOR
     SELECT _tmpData.*
          , CASE WHEN Tax_Amount    >= inPresent1      THEN 16744448 WHEN Tax_Amount    >= inPresent2      AND Tax_Amount    < inPresent1      THEN zc_Color_Yelow() WHEN Tax_Amount    < inPresent2      THEN zc_Color_Red() END AS Color_Amount
          , CASE WHEN Tax_Summ_curr >= inPresent1_Summ THEN 16744448 WHEN Tax_Summ_curr >= inPresent2_Summ AND Tax_Summ_curr < inPresent1_Summ THEN zc_Color_Yelow() WHEN Tax_Summ_curr < inPresent2_Summ THEN zc_Color_Red() END AS Color_Sum
          , CASE WHEN Tax_Summ_prof >= inPresent1_Prof THEN 16744448 WHEN Tax_Summ_prof >= inPresent2_Prof AND Tax_Summ_prof < inPresent1_Prof THEN zc_Color_Yelow() WHEN Tax_Summ_prof < inPresent2_Prof THEN zc_Color_Red() END AS Color_Prof
     FROM _tmpData
     WHERE (inIsAmount = TRUE AND Tax_Amount    < inPresent2)
        OR (inIsSumm   = TRUE AND Tax_Summ_curr < inPresent2_Summ)
        OR (inIsProf   = TRUE AND Tax_Summ_prof < inPresent2_Prof)
     ;
     RETURN NEXT Cursor3;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.12.18         *
 09.11.18         *
 26.07.18         *
*/

-- тест
-- select * from gpReport_Sale_Analysis(inStartDate := ('01.01.2018')::TDateTime , inEndDate := ('31.01.2018')::TDateTime , inUnitId := 1530 , inPartnerId := 0 , inBrandId := 0 , inPeriodId := 1554 , inLineFabricaId := 0 , inStartYear := 2001 , inEndYear := 2008 , inPresent1 := 80 , inPresent2 := 50 , inPresent1_Summ := 125 , inPresent2_Summ := 80 , inPresent1_Prof := 80 , inPresent2_Prof := 50 , inIsPeriodAll := 'True' , inIsUnit := 'False' , inIsBrand := 'False' , inIsAmount := 'True' , inIsSumm := 'False' , inIsProf := 'False' , inIsLineFabrica := 'False' ,  inSession := '8');