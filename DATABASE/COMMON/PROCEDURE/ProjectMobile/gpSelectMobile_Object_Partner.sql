-- Function: gpSelectMobile_Object_Partner (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Partner (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Partner (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer
             , ObjectCode       Integer  -- Код
             , ValueData        TVarChar -- Название
             , Address          TVarChar -- Адрес точки доставки
             , GPSN             TFloat   -- GPS координаты точки доставки (широта)
             , GPSE             TFloat   -- GPS координаты точки доставки (долгота)
             , Schedule         TVarChar -- График посещения ТТ - по каким дням недели - в строчке 7 символов разделенных ";" t значит true и f значит false
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
             , PriceListId      Integer  -- Прайс-лист - по каким ценам будет формироваться заказ
             , PriceListId_ret  Integer  -- Прайс-лист Возврата - по каким ценам будет формироваться возврат
             , isErased         Boolean  -- Удаленный ли элемент
             , isSync           Boolean  -- Синхронизируется (да/нет)
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

      -- Результат
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             WITH tmpPartner AS (SELECT ObjectLink_Partner_PersonalTrade.ObjectId AS PartnerId
                                 FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                   AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                )
                , tmpDayInfo AS (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId              AS ContractId
                                      , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                                      , ObjectLink_Partner_Juridical.ObjectId                            AS PartnerId
                                      , zfCalc_DetermentPaymentDate (ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                                                   , MIN (ObjectFloat_ContractCondition_Value.ValueData)::Integer
                                                                   , CURRENT_DATE)::Date AS ContractDate
                                 FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                      JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                      ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                                                                                            , zc_Enum_ContractConditionKind_DelayDayBank()
                                                                                                                             )
                                      JOIN ObjectFloat AS ObjectFloat_ContractCondition_Value
                                                       ON ObjectFloat_ContractCondition_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                      AND ObjectFloat_ContractCondition_Value.DescId = zc_ObjectFloat_ContractCondition_Value() 
                                                      AND ObjectFloat_ContractCondition_Value.ValueData <> 0.0
                                      JOIN Object AS Object_ContractCondition
                                                  ON Object_ContractCondition.Id = ObjectLink_ContractCondition_Contract.ObjectId
                                                 AND NOT Object_ContractCondition.isErased 
                                      JOIN Object AS Object_Contract
                                                  ON Object_Contract.Id = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                 AND NOT Object_Contract.isErased 
                                      JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                      ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                     AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical() 
                                      JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                      ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                      JOIN tmpPartner ON tmpPartner.PartnerId = ObjectLink_Partner_Juridical.ObjectId
                                 WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId
                                        , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                        , ObjectLink_Partner_Juridical.ObjectId
                                )
                , tmpContainer AS (SELECT Container_Summ.Id      AS ContainerId
                                        , CLO_Partner.ObjectId   AS PartnerId
                                        , CLO_Contract.ObjectId  AS ContractId
                                        , Container_Summ.Amount
                                        , COALESCE (tmpDayInfo.ContractDate, CURRENT_DATE)::Date AS ContractDate
                                   FROM Container AS Container_Summ
                                        JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                                        ON ObjectLink_Account_AccountGroup.ObjectId = Container_Summ.ObjectId
                                                       AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup() 
                                                       AND ObjectLink_Account_AccountGroup.ChildObjectId = zc_Enum_AccountGroup_30000() -- Дебиторы
                                        JOIN ContainerLinkObject AS CLO_Partner
                                                                 ON CLO_Partner.ContainerId = Container_Summ.Id
                                                                AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                        JOIN tmpPartner ON tmpPartner.PartnerId = CLO_Partner.ObjectId
                                        JOIN ContainerLinkObject AS CLO_Contract
                                                                 ON CLO_Contract.ContainerId = Container_Summ.Id
                                                                AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                        JOIN ContainerLinkObject AS CLO_PaidKind
                                                                 ON CLO_PaidKind.ContainerId = Container_Summ.Id
                                                                AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind() 
                                                                AND CLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() -- только Нал
                                        LEFT JOIN tmpDayInfo ON tmpDayInfo.PartnerId = CLO_Partner.ObjectId
                                                            AND tmpDayInfo.ContractId = CLO_Contract.ObjectId
                                   WHERE Container_Summ.DescId = zc_Container_Summ()
                                     AND Container_Summ.Amount <> 0.0
                                  )
                , tmpMIContainer AS (SELECT MovementItemContainer.ContainerId
                                          , SUM (MovementItemContainer.Amount)::TFloat AS Summ
                                     FROM MovementItemContainer
                                          JOIN tmpContainer ON tmpContainer.ContainerId = MovementItemContainer.ContainerId
                                     WHERE MovementItemContainer.DescId = zc_MIContainer_Summ()
                                       AND (MovementItemContainer.MovementDescId = zc_Movement_Sale()
                                        OR (MovementItemContainer.MovementDescId = zc_Movement_TransferDebtOut() AND MovementItemContainer.isActive))
                                       AND MovementItemContainer.OperDate >= tmpContainer.ContractDate
                                     GROUP BY MovementItemContainer.ContainerId  
                                    )
                , tmpDebt AS (SELECT tmpContainer.PartnerId
                                   , tmpContainer.ContractId
                                   , SUM (tmpContainer.Amount)::TFloat                                               AS DebtSum
                                   , SUM (tmpContainer.Amount - COALESCE (tmpMIContainer.Summ, 0.0)::TFloat)::TFloat AS OverSum
                                   , MAX (zfCalc_OverDayCount (tmpContainer.ContainerId, tmpContainer.Amount - COALESCE (tmpMIContainer.Summ, 0.0)::TFloat, tmpContainer.ContractDate)) AS OverDays
                              FROM tmpContainer
                                   LEFT JOIN tmpMIContainer ON tmpContainer.ContainerId = tmpMIContainer.ContainerId
                              GROUP BY tmpContainer.PartnerId
                                     , tmpContainer.ContractId
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
             SELECT Object_Partner.Id
                  , Object_Partner.ObjectCode
                  , Object_Partner.ValueData
                  , ObjectString_Partner_Address.ValueData  AS Address
                  , ObjectFloat_Partner_GPSN.ValueData      AS GPSN
                  , ObjectFloat_Partner_GPSE.ValueData      AS GPSE
                  , REPLACE (REPLACE (LOWER (COALESCE (ObjectString_Partner_Schedule.ValueData, 't;t;t;t;t;t;t')), 'true', 't'), 'false', 'f')::TVarChar AS Schedule
                  , COALESCE (tmpDebt.DebtSum, 0.0)::TFloat AS DebtSum
                  , COALESCE (tmpDebt.OverSum, 0.0)::TFloat AS OverSum
                  , COALESCE (tmpDebt.OverDays, 0)::Integer AS OverDays
                  , COALESCE (ObjectFloat_Partner_PrepareDayCount.ValueData, 0.0)::TFloat  AS PrepareDayCount
                  , COALESCE (ObjectFloat_Partner_DocumentDayCount.ValueData, 0.0)::TFloat AS DocumentDayCount
                  , CASE WHEN tmpStoreRealDoc.OperDate IS NULL THEN 0.0::TFloat ELSE DATE_PART ('day', CURRENT_DATE::TDateTime - tmpStoreRealDoc.OperDate)::TFloat END AS CalcDayCount
                  , 7.0::TFloat AS OrderDayCount
                  , COALESCE (ObjectBoolean_Retail_OperDateOrder.ValueData, false)::Boolean AS isOperDateOrder
                  , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                  , ObjectLink_Partner_Route.ChildObjectId     AS RouteId
                  , ObjectLink_Contract_Juridical.ObjectId     AS ContractId
                  , COALESCE (ObjectLink_Partner_PriceList.ChildObjectId, zc_PriceList_Basis()) AS PriceListId
                  , COALESCE (ObjectLink_Partner_PriceListPrior.ChildObjectId, zc_PriceList_BasisPrior()) AS PriceListId_ret
                  , Object_Partner.isErased
                  , CAST(true AS Boolean) AS isSync
             FROM Object AS Object_Partner
                  JOIN tmpPartner ON tmpPartner.PartnerId = Object_Partner.Id
                  JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                  ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                  JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                  ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                  LEFT JOIN tmpDebt ON tmpDebt.PartnerId = Object_Partner.Id
                                   AND tmpDebt.ContractId = ObjectLink_Contract_Juridical.ObjectId
                  LEFT JOIN tmpStoreRealDoc ON tmpStoreRealDoc.PartnerId = Object_Partner.Id                
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
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_PrepareDayCount
                                        ON ObjectFloat_Partner_PrepareDayCount.ObjectId = Object_Partner.Id
                                       AND ObjectFloat_Partner_PrepareDayCount.DescId = zc_ObjectFloat_Partner_PrepareDayCount() 
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_DocumentDayCount
                                        ON ObjectFloat_Partner_DocumentDayCount.ObjectId = Object_Partner.Id
                                       AND ObjectFloat_Partner_DocumentDayCount.DescId = zc_ObjectFloat_Partner_DocumentDayCount() 
                  LEFT JOIN ObjectString AS ObjectString_Partner_Schedule
                                         ON ObjectString_Partner_Schedule.ObjectId = Object_Partner.Id
                                        AND ObjectString_Partner_Schedule.DescId = zc_ObjectString_Partner_Schedule() 
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_GPSN
                                        ON ObjectFloat_Partner_GPSN.ObjectId = Object_Partner.Id
                                       AND ObjectFloat_Partner_GPSN.DescId = zc_ObjectFloat_Partner_GPSN() 
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_GPSE
                                        ON ObjectFloat_Partner_GPSE.ObjectId = Object_Partner.Id
                                       AND ObjectFloat_Partner_GPSE.DescId = zc_ObjectFloat_Partner_GPSE()
                  LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                       ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Retail_OperDateOrder
                                          ON ObjectBoolean_Retail_OperDateOrder.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                         AND ObjectBoolean_Retail_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()                      
             WHERE Object_Partner.DescId = zc_Object_Partner();
      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_Partner(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
