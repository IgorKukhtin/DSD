-- Function: gpSelect_Object_Contract_Mobile (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Contract_Mobile (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Contract_Mobile (
     IN inMemberId         Integer  , -- физ.лицо
     IN inisShowAll        Boolean  , --
     IN inSession          TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer
             , Code             Integer   -- Код
             , Name             TVarChar  -- Название
             , ContractTagName  TVarChar  -- Признак договора
             , InfoMoneyName    TVarChar  -- УП статья
             , Comment          TVarChar  -- Примечание
             , PaidKindId       Integer   -- Форма оплаты
             , PaidKindName     TVarChar  -- Форма оплаты
             , JuridicalId      Integer   -- юр.лицо
             , JuridicalCode    Integer
             , JuridicalName    TVarChar
             , StartDate        TDateTime -- Дата с которой действует договор
             , EndDate          TDateTime -- Дата до которой действует договор
             , ChangePercent    TFloat    -- (-)% Скидки (+)% Наценки - для Скидки - отрицателеное значение, для Наценки - положительное
             , DelayDayCalendar TFloat    -- Отсрочка в календарных днях
             , DelayDayBank     TFloat    -- Отсрочка в банковских днях
             , isErased         Boolean   -- Удаленный ли элемент
             , isSync           Boolean   -- Синхронизируется (да/нет)
              )
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbUserId_Mobile Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!меняем значение!!! - с какими параметрами пользователь может просматривать данные с мобильного устройства
     vbUserId_Mobile:= (SELECT CASE WHEN lfGet.UserId > 0 THEN lfGet.UserId ELSE vbUserId END FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet);


     -- Результат
     RETURN QUERY
         SELECT tmpMobileContract.Id
              , tmpMobileContract.ObjectCode    AS Code
              , tmpMobileContract.ValueData     AS Name
              , tmpMobileContract.ContractTagName
              , tmpMobileContract.InfoMoneyName
              , tmpMobileContract.Comment
              , tmpMobileContract.PaidKindId
              , Object_PaidKind.ValueData       AS PaidKindName
              , Object_Juridical.Id             AS JuridicalId
              , Object_Juridical.ObjectCode     AS JuridicalCode
              , Object_Juridical.ValueData      AS JuridicalName

              , tmpMobileContract.StartDate
              , tmpMobileContract.EndDate
              , tmpMobileContract.ChangePercent
              , tmpMobileContract.DelayDayCalendar
              , tmpMobileContract.DelayDayBank
              , tmpMobileContract.isErased
              , tmpMobileContract.isSync
         FROM gpSelectMobile_Object_Contract (zc_DateStart(), vbUserId_Mobile :: TVarChar) AS tmpMobileContract
              LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMobileContract.PaidKindId
              LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                   ON ObjectLink_Contract_Juridical.ObjectId = tmpMobileContract.Id
                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
              LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId
         WHERE (tmpMobileContract.isErased = inisShowAll OR inisShowAll = True)
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 20.03.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Contract_Mobile (inMemberId:= 1, inisShowAll:= FALSE, inSession := zfCalc_UserAdmin())
