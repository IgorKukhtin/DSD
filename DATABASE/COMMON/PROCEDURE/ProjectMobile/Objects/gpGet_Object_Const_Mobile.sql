-- Function: gpGet_Object_Const_Mobile (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Const_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Const_Mobile(
     IN inMemberId       Integer  , -- физ.лицо
     IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE (PaidKindId_First      Integer   -- Форма оплаты - БН
             , PaidKindName_First    TVarChar  -- Форма оплаты - НАЛ
             , PaidKindId_Second     Integer   -- Форма оплаты - НАЛ
             , PaidKindName_Second   TVarChar  -- Форма оплаты - НАЛ
             , StatusId_UnComplete   Integer   -- Статус - Не проведен
             , StatusName_UnComplete TVarChar  -- Статус - Не проведен
             , StatusId_Complete     Integer   -- Статус - Проведен
             , StatusName_Complete   TVarChar  -- Статус - Проведен
             , StatusId_Erased       Integer   -- Статус - Удален
             , StatusName_Erased     TVarChar  -- Статус - Удален
             , UnitId                Integer   -- Подразделение - на какой склад будет оформляться заказ + какие остатки будем загружать из главной БД + и т.п.
             , UnitName              TVarChar  -- Подразделение
             , UnitId_ret            Integer   -- Подразделение Возврата - на какой склад будет оформляться возврат
             , UnitName_ret          TVarChar  -- Подразделение Возврата
             , CashId                Integer   -- Касса - используется если будет формироваться приход денег
             , CashName              TVarChar  -- Касса
             , MemberId              Integer   -- Физ. лицо
             , MemberName            TVarChar  -- Физ. лицо, информативно
             , PersonalId            Integer   -- Сотрудник
             , UserId                Integer   -- Пользователь
             , UserLogin             TVarChar  -- Логин
             -- , UserPassword          TVarChar  -- Пароль
             , WebService            TVarChar  -- Веб-сервис через который происходит коннект к основной БД
             -- , SyncDateIn         TDateTime -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
             -- , SyncDateOut        TDateTime -- Дата/время последней синхронизации - когда "успешно" выгружалась иходящая информация - заказы, возвраты и т.д
             -- , MobileVersion         TVarChar  -- Версия мобильного приложения. Пример: "1.0.3.625"
             -- , MobileAPKFileName     TVarChar  -- Название ".apk" файла мобильного приложения. Пример: "ProjectMobile.apk"
             , PriceListId_def       Integer   -- Прайс-лист для "безликих" ТТ, т.е. добавленных на мобильном устройстве
             , PriceListName_def     TVarChar  -- Прайс-лист для "безликих" ТТ, т.е. добавленных на мобильном устройстве
             , OperDate_diff         Integer   -- на сколько дней позже создавать док Возврат и Приход денег, т.е. при создании документов дата документа по умолчанию будет идти не сегодняшним числом а например - завтрашним
             , ReturnDayCount        Integer   -- сколько дней принимаются возвраты по старым ценам
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
     vbUserId_Mobile:= (SELECT lfGet.UserId FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet);


     -- Результат
     RETURN QUERY
       SELECT tmpMobileConst.PaidKindId_First
            , tmpMobileConst.PaidKindName_First
            , tmpMobileConst.PaidKindId_Second
            , tmpMobileConst.PaidKindName_Second

            , tmpMobileConst.StatusId_Complete
            , tmpMobileConst.StatusName_Complete
            , tmpMobileConst.StatusId_UnComplete
            , tmpMobileConst.StatusName_UnComplete
            , tmpMobileConst.StatusId_Erased
            , tmpMobileConst.StatusName_Erased

            , tmpMobileConst.UnitId
            , tmpMobileConst.UnitName
            , tmpMobileConst.UnitId_ret
            , tmpMobileConst.UnitName_ret
            , tmpMobileConst.CashId
            , tmpMobileConst.CashName

            , tmpMobileConst.MemberId
            , tmpMobileConst.MemberName
            , tmpMobileConst.PersonalId

            , tmpMobileConst.UserId
            , tmpMobileConst.UserLogin

            , tmpMobileConst.WebService

            , tmpMobileConst.PriceListId_def
            , tmpMobileConst.PriceListName_def
            , tmpMobileConst.OperDate_diff
            , tmpMobileConst.ReturnDayCount

       FROM gpGetMobile_Object_Const (vbUserId_Mobile :: TVarChar) AS tmpMobileConst
      ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Const_Mobile (inMemberId := 149833 ,  inSession := '5');
