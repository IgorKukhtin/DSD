-- Function: gpSelectMobile_Object_Partner (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Partner_2 (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelectMobile_Object_Partner (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Partner (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer
             , ObjectCode       Integer  -- Код
             , ValueData        TVarChar -- Название
             , GUID             TVarChar -- Глобальный уникальный идентификатор. Для синхронизации с Главной БД
             , ShortName        TVarChar -- Условное обозначение
             , Address          TVarChar -- Адрес точки доставки
             , ShortAddress     TVarChar -- Адрес точки доставки для представления на карте
             , GPSN             TFloat   -- GPS координаты точки доставки (широта)
             , GPSE             TFloat   -- GPS координаты точки доставки (долгота)
             , Schedule         TVarChar -- График посещения ТТ - по каким дням недели - в строчке 7 символов разделенных ";" t значит TRUE и f значит FALSE
             , Delivery         TVarChar -- График завоза на ТТ - по каким дням недели - в строчке 7 символов разделенных ";" t значит TRUE и f значит FALSE
             , DebtSum          TFloat   -- Сумма долга (нам) - НАЛ - т.к НАЛ долг формируется только в разрезе Контрагентов + договоров + для некоторых по № накладных
             , OverSum          TFloat   -- Сумма просроченного долга (нам) - НАЛ - Просрочка наступает спустя определенное кол-во дней
             , OverDays         Integer  -- Кол-во дней просрочки (нам)
             , PrepareDayCount  TFloat   -- За сколько дней принимается заказ
             , DocumentDayCount TFloat   -- Через сколько дней оформляется документально, возможно понадобится рассчитать дату когда приедет покупателю
             , CalcDayCount     TFloat   -- Расчетное кол-во дней, используется для расчета средней отгрузки за день
             , OrderDayCount    TFloat   -- Кол-во дней для заказа, используется для расчета заказываемого количества товара в заказе
             , isOperDateOrder  Boolean  -- цена по дате заявки, в момент переоценки цены продажи - некоторым ТТ отгрузка происходит по дате заявки, т.е. по старым ценам, а некоторым ТТ на дату когда приедет к покупателю, т.е. по новым ценам
             , JuridicalId      Integer  -- Юридическое лицо
             , RouteId          Integer  -- Маршрут
             , ContractId       Integer  -- Договор - все возможные договора...
             , PaidKindId       Integer  -- Договор - все возможные договора...
             , PriceListId      Integer  -- Прайс-лист - по каким ценам будет формироваться заказ
             , PriceListId_ret  Integer  -- Прайс-лист Возврата - по каким ценам будет формироваться возврат
             , ContainerId      Integer
             , isOrderMin       Boolean  -- Разрешен минимальный заказ = заказ меньше 5 кг.
             , isErased         Boolean  -- Удаленный ли элемент
             , isSync           Boolean  -- Синхронизируется (да/нет)
             , ContractId_orig     Integer
             , ContractId_Key      Integer
             , ContractId_Key_calc Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- Определяем сотрудника для пользователя
      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));


      -- таблица - список Container
      -- CREATE TEMP TABLE _tmpContainer_OverDayCount (ContainerId Integer) ON COMMIT DROP;


      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
           RETURN QUERY
             WITH tmpPartner AS (SELECT lfSelect.Id          AS PartnerId
                                      , lfSelect.JuridicalId AS JuridicalId
                                 FROM lfSelectMobile_Object_Partner (FALSE, inSession) AS lfSelect
                                )
           , tmpContract_Key AS (SELECT -- это ObjectId - объединение
                                        -- View_Contract_ContractKey.ContractKeyId
                                        0 AS ContractKeyId
                                        -- это все ContractId
                                      , COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                                        -- это "главный" ContractId
                                      , CASE WHEN View_Contract_ContractKey.ContractId_Key IN (8679226, 583450)
                                                  -- !!!замена!!!
                                                  THEN 8679226
                                             WHEN View_Contract_ContractKey.ContractId_Key IN (8318399, 1029784)
                                                  -- !!!замена!!!
                                                  THEN 8318399

                                             WHEN View_Contract_ContractKey.ContractId_Key IN (10112693, 7530763)
                                                  -- !!!замена!!!
                                                  THEN 10112693

                                             WHEN (Object.ValueData ILIKE '%физобмен%' 
                                                OR Object.ValueData ILIKE '%обмін%'
                                                OR Object.ValueData ILIKE '%обмiн%')
                                              AND COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) <> View_Contract_ContractKey.ContractId_Key 
                                                  -- !!!замена!!!
                                                  THEN View_Contract_ContractKey.ContractId
                                                  ELSE View_Contract_ContractKey.ContractId_Key
                                        END AS ContractId_Key

                                  FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                                       LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                                       LEFT JOIN Object ON Object.Id = View_Contract_ContractKey.ContractId_Key
                                  -- WHERE 1=0
                                )
                , tmpContract AS (SELECT DISTINCT
                                         tmpPartner.PartnerId                        AS PartnerId
                                         -- "оригинал"
                                       , ObjectLink_Contract_Juridical.ObjectId      AS ContractId
                                         -- подставили "главный", если есть
                                       , COALESCE (tmpContract_Key.ContractId_Key, ObjectLink_Contract_Juridical.ObjectId) AS ContractId_Key

                                       , tmpPartner.JuridicalId                      AS JuridicalId
                                     --, ObjectLink_Contract_PriceList.ChildObjectId AS PriceListId

                                         -- потом уберем Закрытые
                                       , COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) AS ContractStateKindId
                                  FROM tmpPartner
                                       JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                       ON ObjectLink_Contract_Juridical.ChildObjectId = tmpPartner.JuridicalId
                                                      AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
                                       LEFT JOIN tmpContract_Key ON tmpContract_Key.ContractId = ObjectLink_Contract_Juridical.ObjectId
                                       -- убрали Удаленные
                                       JOIN Object AS Object_Contract
                                                   ON Object_Contract.Id       = COALESCE (tmpContract_Key.ContractId_Key, ObjectLink_Contract_Juridical.ObjectId)
                                                  AND Object_Contract.isErased = FALSE
                                       -- НЕ убрали Закрытые
                                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                                         -- ON ObjectLink_Contract_ContractStateKind.ObjectId      = Object_Contract.Id
                                                            ON ObjectLink_Contract_ContractStateKind.ObjectId      = ObjectLink_Contract_Juridical.ObjectId
                                                           AND ObjectLink_Contract_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()
                                                           -- AND ObjectLink_Contract_ContractStateKind.ChildObjectId = zc_Enum_ContractStateKind_Close()
                                       -- Ограничим - ТОЛЬКО если ГП
                                       INNER JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                             ON ObjectLink_Contract_InfoMoney.ObjectId = ObjectLink_Contract_Juridical.ObjectId
                                                            AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                                            AND ObjectLink_Contract_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                                                                                              , zc_Enum_InfoMoney_30102() -- Доходы + Тушенка   + Тушенка
                                                                                                               )
                                  -- НЕ убрали Закрытые
                                  -- WHERE ObjectLink_Contract_ContractStateKind.ChildObjectId IS NULL
                                 )
                 , tmpContract_PriceList AS (SELECT tmpContract.ContractId, OL_ContractPriceList_PriceList.ChildObjectId AS PriceListId
                                                  , ObjectDate_StartDate.ValueData AS StartDate, ObjectDate_EndDate.ValueData AS EndDate
                                             FROM (SELECT DISTINCT tmpContract.ContractId FROM tmpContract) AS tmpContract
                                                  INNER JOIN ObjectLink AS OL_ContractPriceList_Contract
                                                                        ON OL_ContractPriceList_Contract.ChildObjectId = tmpContract.ContractId
                                                                       AND OL_ContractPriceList_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                                                  INNER JOIN Object AS Object_ContractPriceList ON Object_ContractPriceList.Id       = OL_ContractPriceList_Contract.ObjectId
                                                                                               AND Object_ContractPriceList.isErased = FALSE
                                                  INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                                        ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractPriceList_StartDate()
                                                  INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                                        ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractPriceList_EndDate()
                                                  INNER JOIN ObjectLink AS OL_ContractPriceList_PriceList
                                                                       ON OL_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                                      AND OL_ContractPriceList_PriceList.DescId   = zc_ObjectLink_ContractPriceList_PriceList()
                                                                      AND OL_ContractPriceList_PriceList.ChildObjectId > 0
                                            )
          , tmpContract_state AS (SELECT tmpContract_find.PartnerId
                                       , tmpContract_find.ContractId_Key
                                       , tmpContract_find.ContractId_Key_calc
                                  FROM (SELECT
                                               tmpContract.PartnerId
                                               -- подставили "главный", если есть
                                             , tmpContract.ContractId_Key            AS ContractId_Key
                                               -- подставим "оригинал" - если "главный" - ЗАКРЫТ
                                             , tmpContract.ContractId                AS ContractId_Key_calc
                                               -- № п/п
                                             , ROW_NUMBER() OVER (PARTITION BY tmpContract.ContractId_Key, tmpContract.PartnerId
                                                                  ORDER BY CASE -- если "главный" НЕ ЗАКРЫТ - он и будет "первым"
                                                                                WHEN tmpContract.ContractId_Key = tmpContract.ContractId AND tmpContract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                                                     THEN 1
                                                                                WHEN tmpContract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                                                     THEN 2
                                                                                ELSE 3
                                                                           END ASC
                                                                         , tmpContract.ContractId DESC
                                                                 ) AS Ord
                                               -- потом уберем Закрытые
                                             , tmpContract.ContractStateKindId
                                        FROM tmpContract
                                       ) AS tmpContract_find
                                  -- выбрали по возможности - "главный" и НЕ ЗАКРЫТ или последний НЕ ЗАКРЫТ
                                  WHERE tmpContract_find.Ord = 1
                                    AND tmpContract_find.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                 )

            , tmpDayInfo_all AS (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId              AS ContractId
                                      , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                                      , tmpContract.PartnerId
                                      , zfCalc_DetermentPaymentDate (ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                                                   , MIN (ObjectFloat_ContractCondition_Value.ValueData)::Integer
                                                                   , CURRENT_DATE)::Date AS ContractDate
                                      , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())  :: TDateTime AS StartDate
                                      , COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())      :: TDateTime AS EndDate
                                 FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                      -- выбрали оригинал"
                                      JOIN tmpContract ON tmpContract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                      -- выбрали по "главному"
                                      -- JOIN tmpContract ON tmpContract.ContractId_Key = ObjectLink_ContractCondition_Contract.ChildObjectId
                                      -- выбираем только ДВА условия
                                      JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                      ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId   = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                                                                                            , zc_Enum_ContractConditionKind_DelayDayBank()
                                                                                                                             )
                                      JOIN ObjectFloat AS ObjectFloat_ContractCondition_Value
                                                       ON ObjectFloat_ContractCondition_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                      AND ObjectFloat_ContractCondition_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                      AND ObjectFloat_ContractCondition_Value.ValueData <> 0.0
                                      -- убрали Удаленные
                                      JOIN Object AS Object_ContractCondition
                                                  ON Object_ContractCondition.Id       = ObjectLink_ContractCondition_Contract.ObjectId
                                                 AND Object_ContractCondition.isErased = FALSE

                                      LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                           ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                                                          AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractCondition_StartDate()
                                      LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                                           ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                                                          AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractCondition_EndDate()

                                 WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId
                                        , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                        , tmpContract.PartnerId
                                        , ObjectDate_StartDate.ValueData
                                        , ObjectDate_EndDate.ValueData
                                )
                , tmpDayInfo AS (SELECT tmpDayInfo_all.*
                                 FROM tmpDayInfo_all
                                 WHERE CURRENT_DATE BETWEEN tmpDayInfo_all.StartDate AND tmpDayInfo_all.EndDate
                                )
                , tmpContainer AS (SELECT Container_Summ.Id          AS ContainerId
                                        , CLO_Partner.ObjectId       AS PartnerId
                                         -- "оригинал"               
                                        , CLO_Contract.ObjectId      AS ContractId
                                         -- подставили "главный", если есть
                                        , tmpContract.ContractId_Key AS ContractId_Key

                                        , CLO_PaidKind.ObjectId      AS PaidKindId
                                        , Container_Summ.Amount      AS Amount
                                        , COALESCE (tmpDayInfo.ContractDate, CURRENT_DATE) :: TDateTime AS ContractDate
                                   FROM Container AS Container_Summ
                                        JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                                        ON ObjectLink_Account_AccountGroup.ObjectId = Container_Summ.ObjectId
                                                       AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
                                                       AND ObjectLink_Account_AccountGroup.ChildObjectId = zc_Enum_AccountGroup_30000() -- !!!ограничение - только Дебиторы!!!
                                        JOIN ContainerLinkObject AS CLO_Partner
                                                                 ON CLO_Partner.ContainerId = Container_Summ.Id
                                                                AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                        JOIN ContainerLinkObject AS CLO_Contract
                                                                 ON CLO_Contract.ContainerId = Container_Summ.Id
                                                                AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                        JOIN tmpContract ON tmpContract.PartnerId  = CLO_Partner.ObjectId
                                                        AND tmpContract.ContractId = CLO_Contract.ObjectId
                                        JOIN ContainerLinkObject AS CLO_PaidKind
                                                                 ON CLO_PaidKind.ContainerId = Container_Summ.Id
                                                                AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                AND CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() -- !!!ограничение - только Нал!!!
                                        LEFT JOIN tmpDayInfo ON tmpDayInfo.PartnerId  = CLO_Partner.ObjectId
                                                            -- выбрали оригинал"
                                                            AND tmpDayInfo.ContractId = CLO_Contract.ObjectId
                                                            -- выбрали по "главному"
                                                            -- AND tmpDayInfo.ContractId = tmpContract.ContractId_Key
                                   WHERE Container_Summ.DescId = zc_Container_Summ()
                                     AND Container_Summ.Amount <> 0.0
                                   --AND Container_Summ.Id  In (2696933, 2718742)
                                  )
                , tmpMIContainer AS (SELECT MovementItemContainer.ContainerId
                                          , SUM (MovementItemContainer.Amount)::TFloat AS Summ
                                     FROM MovementItemContainer
                                          JOIN tmpContainer ON tmpContainer.ContainerId = MovementItemContainer.ContainerId
                                     WHERE MovementItemContainer.DescId = zc_MIContainer_Summ()
                                       AND (MovementItemContainer.MovementDescId  = zc_Movement_Sale()
                                         OR (MovementItemContainer.MovementDescId = zc_Movement_TransferDebtOut()
                                         AND MovementItemContainer.isActive = TRUE)
                                           )
                                       AND MovementItemContainer.OperDate > tmpContainer.ContractDate
                                       AND MovementItemContainer.OperDate < CURRENT_DATE
                                     GROUP BY MovementItemContainer.ContainerId
                                    )
                , tmpMIContainerNow AS (SELECT MovementItemContainer.ContainerId
                                             , SUM (MovementItemContainer.Amount)::TFloat AS Summ
                                        FROM MovementItemContainer
                                             JOIN tmpContainer ON tmpContainer.ContainerId = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescId = zc_MIContainer_Summ()
                                          AND MovementItemContainer.OperDate >= CURRENT_DATE
                                        GROUP BY MovementItemContainer.ContainerId
                                       )
                , tmpDebtAll AS (SELECT tmpContainer.ContainerId
                                      , tmpContainer.PartnerId
                                      , tmpContainer.ContractId
                                      , tmpContainer.ContractId_Key
                                      , tmpContainer.PaidKindId
                                      , (tmpContainer.Amount - COALESCE (tmpMIContainerNow.Summ, 0.0)::TFloat) AS DebtSum
                                      , (tmpContainer.Amount - COALESCE (tmpMIContainerNow.Summ, 0.0)::TFloat - COALESCE (tmpMIContainer.Summ, 0.0)::TFloat) AS OverSum
                                   -- , (zfCalc_OverDayCount (tmpContainer.ContainerId, tmpContainer.Amount - COALESCE (tmpMIContainerNow.Summ, 0.0)::TFloat - COALESCE (tmpMIContainer.Summ, 0.0)::TFloat, tmpContainer.ContractDate)) AS OverDays
                                   -- , (zfCalc_OverDayCount2 (tmpContainer.ContainerId, tmpContainer.Amount, tmpContainer.ContractDate)) AS OverDays2
                                      , SUM (tmpContainer.Amount) OVER (PARTITION BY tmpContainer.PartnerId, ABS (tmpContainer.Amount)) AS ResortSum
                                      , tmpContainer.ContractDate
                                 FROM tmpContainer
                                      LEFT JOIN tmpMIContainer ON tmpContainer.ContainerId = tmpMIContainer.ContainerId
                                      LEFT JOIN tmpMIContainerNow ON tmpContainer.ContainerId = tmpMIContainerNow.ContainerId
                                )
         , tmpDebtAll_all AS (SELECT CASE WHEN 1=0 /*inSession = '489010'*/ THEN tmpDebtAll.ContainerId ELSE 0 END AS ContainerId
                                   , tmpDebtAll.PartnerId
                                     -- объединили по "главному"
                                   , tmpDebtAll.ContractId_Key AS ContractId
                                     -- оставили "оригинал"
                                   -- , tmpDebtAll.ContractId
                                   , tmpDebtAll.PaidKindId
                                   , MIN (tmpDebtAll.ContractDate)  AS ContractDate
                                   , SUM (tmpDebtAll.DebtSum)::TFloat AS DebtSum
                                   , SUM (tmpDebtAll.OverSum)::TFloat AS OverSum
                              FROM tmpDebtAll
                              WHERE tmpDebtAll.ResortSum <> 0.0
                              GROUP BY CASE WHEN 1=0 /*inSession = '489010'*/ THEN tmpDebtAll.ContainerId ELSE 0 END
                                     , tmpDebtAll.PartnerId
                                     , tmpDebtAll.ContractId_Key
                                     -- , tmpDebtAll.ContractId
                                     , tmpDebtAll.PaidKindId
                             )
                , tmpDebt AS (SELECT tmpDebtAll_all.ContainerId
                                   , tmpDebtAll_all.PartnerId
                                     -- здесь "главный"
                                   , tmpDebtAll_all.ContractId
                                   , tmpDebtAll_all.PaidKindId
                                   , tmpDebtAll_all.DebtSum
                                   , tmpDebtAll_all.OverSum
                                   , tmpDebtAll_all.ContractDate
                                   , zfCalc_OverDayCount_all (tmpDebtAll_all.PartnerId, tmpDebtAll_all.ContractId, tmpDebtAll_all.PaidKindId, tmpDebtAll_all.OverSum, tmpDebtAll_all.ContractDate) AS OverDays
                              FROM tmpDebtAll_all
                             )
                , tmpStoreRealDoc AS (SELECT SR.PartnerId, SR.StoreRealId, SR.OperDate
                                      FROM (SELECT MovementLinkObject_Partner.ObjectId AS PartnerId
                                                 , Movement_StoreReal.Id AS StoreRealId
                                                 , Movement_StoreReal.OperDate
                                                 , ROW_NUMBER () OVER (PARTITION BY MovementLinkObject_Partner.ObjectId ORDER BY Movement_StoreReal.OperDate DESC) AS RowNum
                                            FROM Movement AS Movement_StoreReal
                                                 JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                         ON MovementLinkObject_Partner.MovementId = Movement_StoreReal.Id
                                                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                                 JOIN tmpPartner ON tmpPartner.PartnerId = MovementLinkObject_Partner.ObjectId
                                            WHERE Movement_StoreReal.DescId = zc_Movement_StoreReal()
                                              AND Movement_StoreReal.StatusId = zc_Enum_Status_Complete()
                                           ) AS SR
                                      WHERE SR.RowNum = 1
                                     )
             -- Результат
             SELECT DISTINCT
                    Object_Partner.Id
                  , Object_Partner.ObjectCode
                  , Object_Partner.ValueData
                --, ('(' ||COALESCE (Object_PriceList.ValueData, '') || ') ' ||Object_Partner.ValueData) :: TVarChar
                  , ObjectString_Partner_GUID.ValueData      AS GUID
                  , (COALESCE (Object_PriceList.ValueData, '') || CASE WHEN ObjectString_Partner_ShortName.ValueData <> '' THEN ' *' || ObjectString_Partner_ShortName.ValueData ELSE '' END) :: TVarChar AS ShortName
                  , ObjectString_Partner_Address.ValueData   AS Address
                  , ObjectString_Partner_Address.ValueData   AS ShortAddress
                  , ObjectFloat_Partner_GPSN.ValueData       AS GPSN
                  , ObjectFloat_Partner_GPSE.ValueData       AS GPSE
                  --, REPLACE (REPLACE (LOWER (COALESCE (ObjectString_Partner_Schedule.ValueData, 't;t;t;t;t;t;t')), 'TRUE', 't'), 'FALSE', 'f')::TVarChar AS Schedule
                  --, REPLACE (REPLACE (LOWER (COALESCE (ObjectString_Partner_Delivery.ValueData, 'f;f;f;f;f;f;f')), 'TRUE', 't'), 'FALSE', 'f')::TVarChar AS Delivery
                  , zfReCalc_ScheduleOrDelivery (ObjectString_Partner_Schedule.ValueData, ObjectString_Partner_Delivery.ValueData, FALSE) AS Schedule
                  , zfReCalc_ScheduleOrDelivery (ObjectString_Partner_Schedule.ValueData, ObjectString_Partner_Delivery.ValueData, TRUE)  AS Delivery
                  , COALESCE (tmpDebt.DebtSum, 0.0)::TFloat  AS DebtSum
                  , COALESCE (tmpDebt.OverSum, 0.0)::TFloat  AS OverSum
                  , CASE WHEN COALESCE (tmpDebt.OverSum, 0.0) > 0.0 THEN COALESCE (tmpDebt.OverDays, 0)::Integer ELSE 0::Integer END AS OverDays
                  , COALESCE (ObjectFloat_Partner_PrepareDayCount.ValueData, 0.0)::TFloat  AS PrepareDayCount
                  , COALESCE (ObjectFloat_Partner_DocumentDayCount.ValueData, 0.0)::TFloat AS DocumentDayCount
                  , CASE WHEN tmpStoreRealDoc.OperDate IS NULL THEN 0.0::TFloat ELSE DATE_PART ('day', CURRENT_DATE::TDateTime - tmpStoreRealDoc.OperDate)::TFloat END AS CalcDayCount
                  , 7.0::TFloat AS OrderDayCount
                  , COALESCE (ObjectBoolean_Retail_OperDateOrder.ValueData, FALSE)::Boolean AS isOperDateOrder
                  , tmpContract.JuridicalId
                  , ObjectLink_Partner_Route.ChildObjectId   AS RouteId
                    -- объединили по "главному"
                  , tmpContract_state.ContractId_Key_calc AS ContractId
               -- , tmpContract.ContractId_Key            AS ContractId
                    -- оставили "оригинал"
              -- , tmpContract.ContractId
                  , COALESCE (tmpDebt.PaidKindId, ObjectLink_Contract_PaidKind.ChildObjectId) :: Integer AS PaidKindId

                    -- в следующем порядке: 1.1) ---акционный у контрагента 1.2) ---акционный у договора 1.3) ---акционный у юр.лица 2.1) обычный у контрагента 2.2) обычный у договора 2.3) обычный у юр.лица 3) zc_PriceList_Basis
                  , COALESCE (ObjectLink_Partner_PriceList.ChildObjectId
                            , COALESCE (tmpContract_PriceList.PriceListId
                                      , COALESCE (ObjectLink_Juridical_PriceList.ChildObjectId
                                                , zc_PriceList_Basis()))) AS PriceListId

                    -- так для возвратов ГП по "старым ценам" - 1) обычный у контрагента 2) обычный у юр.лица 3) zc_PriceList_BasisPrior
                --, COALESCE (ObjectLink_Partner_PriceListPrior.ChildObjectId, COALESCE (ObjectLink_Juridical_PriceListPrior.ChildObjectId, zc_PriceList_Basis() /*zc_PriceList_BasisPrior()*/)) AS PriceListId_ret
                  , COALESCE (ObjectLink_Partner_PriceList.ChildObjectId
                            , COALESCE (tmpContract_PriceList.PriceListId
                                      , COALESCE (ObjectLink_Juridical_PriceList.ChildObjectId
                                                , zc_PriceList_Basis()))) AS PriceListId_ret

                  , tmpDebt.ContainerId :: Integer AS ContainerId

                --, COALESCE (ObjectBoolean_isOrderMin.ValueData, FALSE) :: Boolean AS isOrderMin
                  , CASE WHEN COALESCE (Object_Route.ValueData, '')    ILIKE '%самовывоз%'
                           OR COALESCE (Object_Contract.ValueData, '') ILIKE '%обмен%'
                           OR COALESCE (Object_Contract.ValueData, '') ILIKE '%обмін%'
                           OR COALESCE (Object_Contract.ValueData, '') ILIKE '%обмiн%'
                           OR COALESCE (ObjectBoolean_isOrderMin.ValueData, FALSE) = TRUE
                           OR COALESCE (ObjectFloat_SummOrderMin.ValueData, 0) > 0
                              THEN TRUE
                         ELSE FALSE
                    END :: Boolean AS isOrderMin

                  , Object_Partner.isErased
                  , TRUE :: Boolean AS isSync
                  
                    -- оставили "оригинал"
                  , tmpContract.ContractId                :: Integer ContractId_orig
                  , tmpContract.ContractId_Key            :: Integer ContractId_Key
                  , tmpContract_state.ContractId_Key_calc :: Integer ContractId_Key_calc

             FROM Object AS Object_Partner
                  -- убрали Закрытые
                  JOIN tmpContract_state ON tmpContract_state.PartnerId = Object_Partner.Id
                  --
                  JOIN tmpContract ON tmpContract.ContractId = tmpContract_state.ContractId_Key_calc
                  LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpContract.ContractId
                  
                  -- нашли прайс
                  LEFT JOIN tmpContract_PriceList ON tmpContract_PriceList.ContractId  = tmpContract.ContractId
                                                 AND tmpContract_PriceList.PriceListId > 0
                                                 AND CURRENT_DATE + INTERVAL '1 DAY' BETWEEN tmpContract_PriceList.StartDate AND tmpContract_PriceList.EndDate

                  LEFT JOIN tmpDebt ON tmpDebt.PartnerId  = Object_Partner.Id
                                   -- AND tmpDebt.ContractId = tmpContract.ContractId
                                   AND tmpDebt.ContractId = tmpContract.ContractId_Key
                  LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                    -- ON ObjectLink_Contract_PaidKind.ObjectId = tmpContract.ContractId
                                       ON ObjectLink_Contract_PaidKind.ObjectId = tmpContract.ContractId_Key
                                      AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()

                  LEFT JOIN tmpStoreRealDoc ON tmpStoreRealDoc.PartnerId = Object_Partner.Id
                  LEFT JOIN ObjectString AS ObjectString_Partner_ShortName
                                         ON ObjectString_Partner_ShortName.ObjectId = Object_Partner.Id
                                        AND ObjectString_Partner_ShortName.DescId = zc_ObjectString_Partner_ShortName()
                  LEFT JOIN ObjectString AS ObjectString_Partner_Address
                                         ON ObjectString_Partner_Address.ObjectId = Object_Partner.Id
                                        AND ObjectString_Partner_Address.DescId = zc_ObjectString_Partner_Address()
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                       ON ObjectLink_Partner_PriceList.ObjectId = Object_Partner.Id
                                      AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPrior
                                       ON ObjectLink_Partner_PriceListPrior.ObjectId = Object_Partner.Id
                                      AND ObjectLink_Partner_PriceListPrior.DescId = zc_ObjectLink_Partner_PriceListPrior()
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                                       ON ObjectLink_Partner_Route.ObjectId = Object_Partner.Id
                                      AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
                  LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId
                  
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_PrepareDayCount
                                        ON ObjectFloat_Partner_PrepareDayCount.ObjectId = Object_Partner.Id
                                       AND ObjectFloat_Partner_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount()
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_DocumentDayCount
                                        ON ObjectFloat_Partner_DocumentDayCount.ObjectId = Object_Partner.Id
                                       AND ObjectFloat_Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount()
                  LEFT JOIN ObjectString AS ObjectString_Partner_Schedule
                                         ON ObjectString_Partner_Schedule.ObjectId = Object_Partner.Id
                                        AND ObjectString_Partner_Schedule.DescId = zc_ObjectString_Partner_Schedule()
                  LEFT JOIN ObjectString AS ObjectString_Partner_Delivery
                                         ON ObjectString_Partner_Delivery.ObjectId = Object_Partner.Id
                                        AND ObjectString_Partner_Delivery.DescId = zc_ObjectString_Partner_Delivery()
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_GPSN
                                        ON ObjectFloat_Partner_GPSN.ObjectId = Object_Partner.Id
                                       AND ObjectFloat_Partner_GPSN.DescId = zc_ObjectFloat_Partner_GPSN()
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_GPSE
                                        ON ObjectFloat_Partner_GPSE.ObjectId = Object_Partner.Id
                                       AND ObjectFloat_Partner_GPSE.DescId = zc_ObjectFloat_Partner_GPSE()

                  LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = tmpContract.JuridicalId
                                      AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                  LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                       ON ObjectLink_Juridical_PriceList.ObjectId = tmpContract.JuridicalId
                                      AND ObjectLink_Juridical_PriceList.DescId   = zc_ObjectLink_Juridical_PriceList()
                  LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPrior
                                       ON ObjectLink_Juridical_PriceListPrior.ObjectId = tmpContract.JuridicalId
                                      AND ObjectLink_Juridical_PriceListPrior.DescId   = zc_ObjectLink_Juridical_PriceListPrior()

                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Retail_OperDateOrder
                                          ON ObjectBoolean_Retail_OperDateOrder.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                         AND ObjectBoolean_Retail_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()
                  LEFT JOIN ObjectString AS ObjectString_Partner_GUID
                                         ON ObjectString_Partner_GUID.ObjectId = Object_Partner.Id
                                        AND ObjectString_Partner_GUID.DescId = zc_ObjectString_Partner_GUID()

                  LEFT JOIN ObjectBoolean AS ObjectBoolean_isOrderMin
                                          ON ObjectBoolean_isOrderMin.ObjectId = tmpContract.JuridicalId
                                         AND ObjectBoolean_isOrderMin.DescId   = zc_ObjectBoolean_Juridical_isOrderMin()
                  LEFT JOIN ObjectFloat AS ObjectFloat_SummOrderMin
                                        ON ObjectFloat_SummOrderMin.ObjectId = tmpContract.JuridicalId
                                       AND ObjectFloat_SummOrderMin.DescId   = zc_ObjectFloat_Juridical_SummOrderMin()
                                         
                  LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id  = COALESCE (ObjectLink_Partner_PriceList.ChildObjectId
                                                                                         , COALESCE (tmpContract_PriceList.PriceListId
                                                                                                   , COALESCE (ObjectLink_Juridical_PriceList.ChildObjectId
                                                                                                             , zc_PriceList_Basis())))
             WHERE Object_Partner.DescId   = zc_Object_Partner()
               AND Object_Partner.isErased = FALSE
               -- AND (COALESCE (tmpDebt.PaidKindId, ObjectLink_Contract_PaidKind.ChildObjectId) = 4 or inSession <> '1839161')
           --LIMIT CASE WHEN vbUserId = 1058558 THEN 1 ELSE 500000 END
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;

      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 30.05.17                                                         * ShortAddress
 28.03.17         * add Delivery
 17.02.17                                                         *
*/
/*
with a as (SELECT * FROM gpSelectMobile_Object_Partner (inSyncDateIn:= zc_DateStart(), inSession:= '11121333'))
, b as (SELECT Id, ContractId FROM a group by Id, ContractId having count(*) > 1)
select Object2.*, Object .ValueData, *
from a
 join b on b.Id = a.Id
       and b.ContractId  = a.ContractId 
 LEFT JOIN Object ON Object.Id = a.ContractId 
 LEFT JOIN Object AS Object2 ON Object2.Id = a.ContractId_Key
*/
-- тест
-- SELECT * FROM gpSelectMobile_Object_Partner (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelectMobile_Object_Partner (inSyncDateIn:= zc_DateStart(), inSession:= '1072129')
