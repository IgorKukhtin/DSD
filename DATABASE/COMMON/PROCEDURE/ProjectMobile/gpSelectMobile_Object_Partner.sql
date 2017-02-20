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
             , GPS             TVarChar -- GPS координаты точки доставки
             , Schedule        TVarChar -- График посещения ТТ - по каким дням недели - в строчке 7 символов разделенных ";" t значит true и f значит false
             , DebtSum         TFloat   -- Сумма долга (нам) - НАЛ - т.к НАЛ долг формируется только в разрезе Контрагентов + договоров + для некоторых по № накладных
             , OverSum         TFloat   -- Сумма просроченного долга (нам) - НАЛ - Просрочка наступает спустя определенное кол-во дней
             , OverDays        Integer  -- Кол-во дней просрочки (нам)
             , PrepareDayCount Integer  -- За сколько дней принимается заказ
             , JuridicalId     Integer  -- Юридическое лицо
             , RouteId         Integer  -- Маршрут
             , ContractId      Integer  -- Договор - все возможные договора...
             , PriceListId     Integer  -- Прайс-лист - по каким ценам будет формироваться заказ
             , PriceListId_ret Integer  -- Прайс-лист Возврата - по каким ценам будет формироваться возврат
             , isErased        Boolean  -- Удаленный ли элемент
             , isSync          Boolean  -- Синхронизируется (да/нет)
)
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPersonalId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
  vbUserId:= lpGetUserBySession (inSession);

  vbPersonalId := (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

  -- Результат
  IF vbPersonalId IS NOT NULL THEN
    RETURN QUERY
      SELECT 
        Object_Partner.Id
        , Object_Partner.ObjectCode
        , Object_Partner.ValueData
        , CAST('' AS TVarChar) AS Address
        , CAST('' AS TVarChar) AS GPS
          -- !!!ВРЕМЕННО - ДЛЯ ТЕСТА!!!
        , CASE WHEN ObjectLink_Partner_PersonalTrade.ChildObjectId > 0
                    THEN 't;f;t;f;t;f;f;'
               ELSE ''
          END :: TVarChar AS Schedule
        , CAST(0.0 AS TFloat) AS DebtSum
        , CAST(0.0 AS TFloat) AS OverSum
        , CAST(0 AS Integer) AS OverDays
        , CAST(0 AS Integer) AS PrepareDayCount
        , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
        , CAST(0 AS Integer) AS RouteId
        , ObjectLink_Contract_Juridical.ObjectId AS ContractId
        , CAST(0 AS Integer) AS PriceListId
        , CAST(0 AS Integer) AS PriceListId_ret
        , Object_Partner.isErased
        , CASE WHEN ObjectLink_Partner_PersonalTrade.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isSync
      FROM Object AS Object_Partner
        LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade 
                             ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id
                            AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                            AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
        LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                             ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                            AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                             ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
      WHERE Object_Partner.DescId = zc_Object_Partner()
     -- !!!ВСЁ - ВРЕМЕННО - ДЛЯ ТЕСТА!!!
        AND ObjectLink_Partner_PersonalTrade.ChildObjectId > 0
     UNION
      SELECT *
      FROM
     (SELECT 
        Object_Partner.Id
        , Object_Partner.ObjectCode
        , Object_Partner.ValueData
        , CAST('' AS TVarChar) AS Address
        , CAST('' AS TVarChar) AS GPS
        , '' :: TVarChar AS Schedule
        , CAST(0.0 AS TFloat) AS DebtSum
        , CAST(0.0 AS TFloat) AS OverSum
        , CAST(0 AS Integer) AS OverDays
        , CAST(0 AS Integer) AS PrepareDayCount
        , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
        , CAST(0 AS Integer) AS RouteId
        , ObjectLink_Contract_Juridical.ObjectId AS ContractId
        , CAST(0 AS Integer) AS PriceListId
        , CAST(0 AS Integer) AS PriceListId_ret
        , Object_Partner.isErased
        , CASE WHEN ObjectLink_Partner_PersonalTrade.ChildObjectId > 0 THEN TRUE ELSE FALSE END AS isSync
      FROM Object AS Object_Partner
        LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade 
                             ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id
                            AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                            AND ObjectLink_Partner_PersonalTrade.ChildObjectId = 340847 -- vbPersonalId
        LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                             ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                            AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                             ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
      WHERE Object_Partner.DescId = zc_Object_Partner()
        AND ObjectLink_Partner_PersonalTrade.ChildObjectId IS NULL
      LIMIT 10) AS tmp
     ;

  END IF;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_Partner(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin()) WHERE isSync = TRUE
