-- Function: gpSelectMobile_Object_Juridical (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Juridical (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Juridical (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- Код
             , ValueData  TVarChar -- Название
             , DebtSum    TFloat   -- Сумма долга (нам) - БН - т.к. БН долг формируется только в разрезе Юр Лиц + договоров
             , OverSum    TFloat   -- Сумма просроченного долга (нам) - БН - Просрочка наступает спустя определенное кол-во дней
             , OverDays   Integer  -- Кол-во дней просрочки (нам)
             , ContractId Integer  -- Договор - все возможные договора...
             , isErased   Boolean  -- Удаленный ли элемент
             , isSync     Boolean  -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             SELECT DISTINCT Object_Juridical.Id
                  , Object_Juridical.ObjectCode
                  , Object_Juridical.ValueData
                  , CAST(0.0 AS TFloat) AS DebtSum
                  , CAST(0.0 AS TFloat) AS OverSum
                  , CAST(0 AS Integer) AS OverDays
                  , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                  , Object_Juridical.isErased
                  , CAST(true AS Boolean) AS isSync
             FROM Object AS Object_Juridical
                  JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                  ON ObjectLink_Contract_Juridical.ChildObjectId = Object_Juridical.Id
                                 AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                  JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                  ON ObjectLink_Partner_Juridical.ChildObjectId = Object_Juridical.Id
                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                  JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                  ON ObjectLink_Partner_PersonalTrade.ObjectId = ObjectLink_Partner_Juridical.ObjectId
                                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                 AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId 
             WHERE Object_Juridical.DescId = zc_Object_Juridical();
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
-- SELECT * FROM gpSelectMobile_Object_Juridical(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
