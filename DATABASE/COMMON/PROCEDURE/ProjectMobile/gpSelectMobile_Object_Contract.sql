-- Function: gpSelectMobile_Object_Contract (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Contract (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Contract (
  IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
  IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer
             , ObjectCode       Integer   -- Код
             , ValueData        TVarChar  -- Название
             , ContractTagName  TVarChar  -- Признак договора
             , InfoMoneyName    TVarChar  -- УП статья
             , Comment          TVarChar  -- Примечание
             , PaidKindId       Integer   -- Форма оплаты
             , StartDate        TDateTime -- Дата с которой действует договор
             , EndDate          TDateTime -- Дата до которой действует договор
             , ChangePercent    TFloat    -- (-)% Скидки (+)% Наценки - для Скидки - отрицателеное значение, для Наценки - положительное
             , DelayDayCalendar TFloat    -- Отсрочка в календарных днях
             , DelayDayBank     TFloat    -- Отсрочка в банковских днях 
             , isErased         Boolean   -- Удаленный ли элемент
             , isSync           Boolean   -- Синхронизируется (да/нет)
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
      WITH tmpJuridical AS (
        SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
        FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
          JOIN ObjectLink AS ObjectLink_Partner_Juridical
                          ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                         AND ObjectLink_Partner_Juridical.ChildObjectId IS NOT NULL
        WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
          AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
      )
      SELECT 
        Object_Contract.Id
        , Object_Contract.ObjectCode
        , Object_Contract.ValueData
        , CAST('' AS TVarChar) AS ContractTagName
        , CAST('' AS TVarChar) AS InfoMoneyName
        , CAST('' AS TVarChar) AS Comment
        , CAST(0  AS Integer) AS PaidKindId
        , CAST(CURRENT_DATE AS TDateTime) AS StartDate
        , CAST(CURRENT_DATE AS TDateTime) AS EndDate
        , CAST(0.0 AS TFloat) AS ChangePercent
        , CAST(0.0 AS TFloat) AS DelayDayCalendar
        , CAST(0.0 AS TFloat) AS DelayDayBank    
        , Object_Contract.isErased
        , (ObjectLink_Contract_Juridical.ChildObjectId IS NOT NULL AND EXISTS(SELECT 1 FROM tmpJuridical WHERE tmpJuridical.JuridicalId = ObjectLink_Contract_Juridical.ChildObjectId)) AS isSync
      FROM Object AS Object_Contract
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                             ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                            AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
      WHERE Object_Contract.DescId = zc_Object_Contract();
  END IF;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_Contract(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
