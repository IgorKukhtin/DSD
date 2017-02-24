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
           CREATE TEMP TABLE tmpJuridical ON COMMIT DROP
           AS (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
               FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                    JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                   AND ObjectLink_Partner_Juridical.ChildObjectId IS NOT NULL
               WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
              );
           
           IF inSyncDateIn > zc_DateZero()
           THEN
                RETURN QUERY
                  WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS JuridicalId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                       FROM ObjectProtocol
                                            JOIN Object AS Object_Juridical
                                                        ON Object_Juridical.Id = ObjectProtocol.ObjectId
                                                       AND Object_Juridical.DescId = zc_Object_Juridical() 
                                       WHERE ObjectProtocol.OperDate > inSyncDateIn
                                       GROUP BY ObjectProtocol.ObjectId
                                      )
                  SELECT Object_Juridical.Id
                       , Object_Juridical.ObjectCode
                       , Object_Juridical.ValueData
                       , CAST(0.0 AS TFloat) AS DebtSum
                       , CAST(0.0 AS TFloat) AS OverSum
                       , CAST(0 AS Integer) AS OverDays
                       , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                       , Object_Juridical.isErased
                       , EXISTS(SELECT 1 FROM tmpJuridical WHERE tmpJuridical.JuridicalId = Object_Juridical.Id) AS isSync
                  FROM Object AS Object_Juridical
                       JOIN tmpProtocol ON tmpProtocol.JuridicalId = Object_Juridical.Id
                       JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                       ON ObjectLink_Contract_Juridical.ChildObjectId = Object_Juridical.Id
                                      AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                  WHERE Object_Juridical.DescId = zc_Object_Juridical();
           ELSE
                RETURN QUERY
                  SELECT Object_Juridical.Id
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
                  WHERE Object_Juridical.DescId = zc_Object_Juridical()
                    AND EXISTS(SELECT 1 FROM tmpJuridical WHERE tmpJuridical.JuridicalId = Object_Juridical.Id);
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
-- SELECT * FROM gpSelectMobile_Object_Juridical(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
