-- Function: gpSelectMobile_Object_Partner (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Partner (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Partner (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id              Integer
             , ObjectCode      Integer  -- Код
             , ValueData       TVarChar -- Название
             , Address         TVarChar -- Адрес точки доставки
             , GPSN            TFloat   -- GPS координаты точки доставки (широта)
             , GPSE            TFloat   -- GPS координаты точки доставки (долгота)
             , Schedule        TVarChar -- График посещения ТТ - по каким дням недели - в строчке 7 символов разделенных ";" t значит true и f значит false
             , DebtSum         TFloat   -- Сумма долга (нам) - НАЛ - т.к НАЛ долг формируется только в разрезе Контрагентов + договоров + для некоторых по № накладных
             , OverSum         TFloat   -- Сумма просроченного долга (нам) - НАЛ - Просрочка наступает спустя определенное кол-во дней
             , OverDays        Integer  -- Кол-во дней просрочки (нам)
             , PrepareDayCount TFloat   -- За сколько дней принимается заказ
             , JuridicalId     Integer  -- Юридическое лицо
             , RouteId         Integer  -- Маршрут
             , ContractId      Integer  -- Договор - все возможные договора...
             , PriceListId     Integer  -- Прайс-лист - по каким ценам будет формироваться заказ
             , PriceListId_ret Integer  -- Прайс-лист Возврата - по каким ценам будет формироваться возврат
             , isErased        Boolean  -- Удаленный ли элемент
             , isSync          Boolean  -- Синхронизируется (да/нет)
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
                , tmpDebt AS (SELECT tmpPartner.PartnerId
                                   , ContainerLinkObject_Contract.ObjectId AS ContractId 
                                   , SUM (Container_Summ.Amount)::TFloat AS Amount
                              FROM Container AS Container_Summ
                                   JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                                   ON ObjectLink_Account_AccountGroup.ObjectId = Container_Summ.ObjectId
                                                  AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup() 
                                                  AND ObjectLink_Account_AccountGroup.ChildObjectId = zc_Enum_AccountGroup_30000() -- Дебиторы
                                   JOIN ContainerLinkObject AS ContainerLinkObject_Partner
                                                            ON ContainerLinkObject_Partner.ContainerId = Container_Summ.Id
                                                           AND ContainerLinkObject_Partner.DescId = zc_ContainerLinkObject_Partner()
                                   JOIN ContainerLinkObject AS ContainerLinkObject_Contract
                                                            ON ContainerLinkObject_Contract.ContainerId = Container_Summ.Id
                                                           AND ContainerLinkObject_Contract.DescId = zc_ContainerLinkObject_Contract()
                                   JOIN tmpPartner ON tmpPartner.PartnerId = ContainerLinkObject_Partner.ObjectId
                              WHERE Container_Summ.DescId = zc_Container_Summ()
                                AND Container_Summ.Amount <> 0.0
                              GROUP BY tmpPartner.PartnerId
                                     , ContainerLinkObject_Contract.ObjectId 
                             )
             SELECT Object_Partner.Id
                  , Object_Partner.ObjectCode
                  , Object_Partner.ValueData
                  , ObjectString_Partner_Address.ValueData  AS Address
                  , ObjectFloat_Partner_GPSN.ValueData      AS GPSN
                  , ObjectFloat_Partner_GPSE.ValueData      AS GPSE
                  , REPLACE (REPLACE (LOWER (COALESCE (ObjectString_Partner_Schedule.ValueData, 't;t;t;t;t;t;t')), 'true', 't'), 'false', 'f')::TVarChar AS Schedule
                  , COALESCE (tmpDebt.Amount, 0.0)::TFloat  AS DebtSum
                  , CAST(0.0 AS TFloat)                     AS OverSum
                  , CAST(0 AS Integer)                      AS OverDays
                  , COALESCE (ObjectFloat_Partner_PrepareDayCount.ValueData, CAST (0.0 AS TFloat)) AS PrepareDayCount
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
                  LEFT JOIN ObjectString AS ObjectString_Partner_Schedule
                                         ON ObjectString_Partner_Schedule.ObjectId = Object_Partner.Id
                                        AND ObjectString_Partner_Schedule.DescId = zc_ObjectString_Partner_Schedule() 
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_GPSN
                                        ON ObjectFloat_Partner_GPSN.ObjectId = Object_Partner.Id
                                       AND ObjectFloat_Partner_GPSN.DescId = zc_ObjectFloat_Partner_GPSN() 
                  LEFT JOIN ObjectFloat AS ObjectFloat_Partner_GPSE
                                        ON ObjectFloat_Partner_GPSE.ObjectId = Object_Partner.Id
                                       AND ObjectFloat_Partner_GPSE.DescId = zc_ObjectFloat_Partner_GPSE()
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
