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
             , PrepareDayCount Integer  -- За сколько дней принимается заказ
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
           CREATE TEMP TABLE tmpPartner ON COMMIT DROP
           AS (SELECT ObjectLink_Partner_PersonalTrade.ObjectId AS PartnerId
               FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
               WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
              );

           IF inSyncDateIn > zc_DateStart()
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS PartnerId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                       FROM ObjectProtocol
                                            JOIN Object AS Object_Partner
                                                        ON Object_Partner.Id = ObjectProtocol.ObjectId
                                                       AND Object_Partner.DescId = zc_Object_Partner() 
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId
                                      )
                  SELECT Object_Partner.Id
                       , Object_Partner.ObjectCode
                       , Object_Partner.ValueData
                       , CAST('' AS TVarChar) AS Address
                         -- !!!ВРЕМЕННО - ДЛЯ ТЕСТА!!!
                       , CAST(50.426527 AS TFloat) AS GPSN
                       , CAST(30.563033 AS TFloat) AS GPSE
                         -- !!!ВРЕМЕННО - ДЛЯ ТЕСТА!!!
                       , CASE WHEN EXISTS(SELECT 1 FROM tmpPartner WHERE tmpPartner.PartnerId = Object_Partner.Id)
                                   THEN 't;f;t;f;t;f;f;'
                              ELSE ''
                         END :: TVarChar AS Schedule
                       , CAST(0.0 AS TFloat)  AS DebtSum
                       , CAST(0.0 AS TFloat)  AS OverSum
                       , CAST(0 AS Integer)   AS OverDays
                       , CAST(0 AS Integer)   AS PrepareDayCount
                       , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                       , CAST(0 AS Integer)   AS RouteId
                       , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                       , CAST(0 AS Integer)   AS PriceListId
                       , CAST(0 AS Integer)   AS PriceListId_ret
                       , Object_Partner.isErased
                       , EXISTS(SELECT 1 FROM tmpPartner WHERE tmpPartner.PartnerId = Object_Partner.Id) AS isSync
                  FROM Object AS Object_Partner
                       JOIN tmpProtocol ON tmpProtocol.PartnerId = Object_Partner.Id
                       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                            ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                            ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                           AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                  WHERE Object_Partner.DescId = zc_Object_Partner();
           ELSE
                RETURN QUERY
                  SELECT Object_Partner.Id
                       , Object_Partner.ObjectCode
                       , Object_Partner.ValueData
                       , CAST('' AS TVarChar) AS Address
                         -- !!!ВРЕМЕННО - ДЛЯ ТЕСТА!!!
                       , CAST(50.426527 AS TFloat) AS GPSN
                       , CAST(30.563033 AS TFloat) AS GPSE
                         -- !!!ВРЕМЕННО - ДЛЯ ТЕСТА!!!
                       , CAST('t;f;t;f;t;f;f;' AS TVarChar) AS Schedule
                       , CAST(0.0 AS TFloat)  AS DebtSum
                       , CAST(0.0 AS TFloat)  AS OverSum
                       , CAST(0 AS Integer)   AS OverDays
                       , CAST(0 AS Integer)   AS PrepareDayCount
                       , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                       , CAST(0 AS Integer)   AS RouteId
                       , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                       , CAST(0 AS Integer)   AS PriceListId
                       , CAST(0 AS Integer)   AS PriceListId_ret
                       , Object_Partner.isErased
                       , CAST(true AS Boolean) AS isSync
                  FROM Object AS Object_Partner
                       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                            ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                            ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                           AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                  WHERE Object_Partner.DescId = zc_Object_Partner()
                    AND EXISTS(SELECT 1 FROM tmpPartner WHERE tmpPartner.PartnerId = Object_Partner.Id);
           END IF;
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
