-- Function: gpGetMobile_Object_Const (TVarChar)

DROP FUNCTION IF EXISTS gpGetMobile_Object_Const (TVarChar);

CREATE OR REPLACE FUNCTION gpGetMobile_Object_Const(
    IN inSession          TVarChar       -- сессия пользователя
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
             , UserPassword          TVarChar  -- Пароль
             , WebService            TVarChar  -- Веб-сервис через который происходит коннект к основной БД
             , WebService_two        TVarChar  -- Веб-сервис через который происходит коннект к основной БД (2)
             , WebService_three      TVarChar  -- Веб-сервис через который происходит коннект к основной БД (3)
             , WebService_four       TVarChar  -- Веб-сервис через который происходит коннект к основной БД (4)
             -- , SyncDateIn         TDateTime -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
             -- , SyncDateOut        TDateTime -- Дата/время последней синхронизации - когда "успешно" выгружалась иходящая информация - заказы, возвраты и т.д
             , MobileVersion         TVarChar  -- Версия мобильного приложения. Пример: "1.0.3.625"
             , MobileAPKFileName     TVarChar  -- Название ".apk" файла мобильного приложения. Пример: "ProjectMobile.apk"
             , PriceListId_def       Integer   -- Прайс-лист для "безликих" ТТ, т.е. добавленных на мобильном устройстве
             , PriceListName_def     TVarChar  -- Прайс-лист для "безликих" ТТ, т.е. добавленных на мобильном устройстве
             , OperDate_diff         Integer   -- на сколько дней позже создавать док Возврат и Приход денег, т.е. при создании документов дата документа по умолчанию будет идти не сегодняшним числом а например - завтрашним
             , ReturnDayCount        Integer   -- сколько дней принимаются возвраты по старым ценам
             , CriticalOverDays      Integer   -- Количество дней просрочки|После которого формирование заявки невозможно (default 21)
             , CriticalDebtSum       TFloat    -- Сумма долга|После которого формирование заявки невозможно (default 1 грн.)
             , APIKey                TVarChar  -- APIKey для гугл карт
             , CriticalWeight        TFloat    -- Минимально допустимый Вес заявки
)
AS
$BODY$
  DECLARE vbUserId     Integer;

  DECLARE vbMemberId      Integer;
  DECLARE vbPersonalId    Integer;
  DECLARE vbUnitId        Integer;
  DECLARE vbBranchId      Integer;
  DECLARE vbBranchId_cash Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- Если пользователь inSession - ПУСТО - !!!ВЫХОД!!!
     /*IF COALESCE (inSession, '') = '' OR COALESCE (inSession, '0') = '0'
     THEN
         RETURN;
     END IF;*/


     -- нашли параметры
     SELECT ObjectLink_User_Member.ChildObjectId AS MemberId
          , lfSelect.PersonalId                  AS PersonalId
          , CASE WHEN vbUserId = 5866615 -- Матіюк В.Ю.
                      THEN 8411 -- Склад ГП ф.Киев

                 WHEN vbUserId = 10105228  -- Трубін О.С.
                      THEN 8425 -- Склад ГП ф.Харьков

                 ELSE lfSelect.UnitId
            END AS UnitId
          , CASE WHEN vbUserId = 5866615 -- Матіюк В.Ю.
                      THEN 8379 -- филиал Киев

                 WHEN vbUserId = 10105228  -- Трубін О.С.
                      THEN 8381 -- филиал Харьков

                 WHEN ObjectLink_Unit_Branch.ChildObjectId = 8377 -- филиал Кр.Рог
                      THEN zc_Branch_Basis()

                 WHEN ObjectLink_Unit_Branch.ChildObjectId = 301310 -- филиал Запорожье
                      THEN zc_Branch_Basis()

                 ELSE COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
            END AS BranchId

          , CASE WHEN vbUserId = 5866615 -- Матіюк В.Ю.
                      THEN 8379 -- филиал Киев

                 WHEN vbUserId = 10105228  -- Трубін О.С.
                      THEN 8381 -- филиал Харьков

                 WHEN ObjectLink_Unit_Branch.ChildObjectId = 8377 -- филиал Кр.Рог
                      THEN zc_Branch_Basis()

                 ELSE COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
            END AS BranchId_cash


            INTO vbMemberId, vbPersonalId, vbUnitId, vbBranchId, vbBranchId_cash

     FROM ObjectLink AS ObjectLink_User_Member
          LEFT JOIN lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                                                                    ON lfSelect.MemberId = ObjectLink_User_Member.ChildObjectId
                                                                   AND lfSelect.Ord      = 1
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = lfSelect.UnitId
                              AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
     WHERE ObjectLink_User_Member.ObjectId = CASE WHEN vbUserId = 5 OR vbUserId = 9457 THEN 1059546 -- !!!ВРЕМЕННО - ДЛЯ ТЕСТА!!! - Админ    -> 1059546  - Ищик Н.Н.
                                                --WHEN vbUserId = 1123966 THEN 81169 -- !!!ВРЕМЕННО - ДЛЯ ТЕСТА!!! - test_mob -> 1000168 - Молдован Е.А.
                                                  ELSE vbUserId
                                             END
       AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
    ;

     -- проверка - свойство должно быть установлено
     IF COALESCE (vbMemberId, 0) =  0 THEN
        RAISE EXCEPTION 'Ошибка.У пользователя <%> Не установлено значение <ФИО (физ.лицо)>.', lfGet_Object_ValueData (vbUserId);
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (vbPersonalId, 0) =  0 THEN
        RAISE EXCEPTION 'Ошибка.У пользователя <%> Не установлено значение <ФИО (Сотрудник)>.', lfGet_Object_ValueData (vbUserId);
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (vbUnitId, 0) =  0 THEN
        RAISE EXCEPTION 'Ошибка.У сотрудника <%> Не установлено значение <Подразделение>.', lfGet_Object_ValueData (vbPersonalId);
     END IF;

     -- Результат
     RETURN QUERY
       WITH tmpPersonal AS (SELECT vbMemberId                AS MemberId
                                 , Object_Member.ValueData   AS MemberName
                                 , vbPersonalId              AS PersonalId
                                 , CASE (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbBranchId)
                                        WHEN 1  THEN 8459    -- филиал zc_Branch_Basis - Склад Реализации
                                        WHEN 2  THEN 8411    -- филиал Киев      - Склад ГП ф Киев
                                        WHEN 3  THEN 8417    -- филиал Николаев (Херсон) - Склад ГП ф.Николаев (Херсон)
                                        WHEN 4  THEN 346093  -- филиал Одесса    - Склад ГП ф.Одесса
                                        WHEN 5  THEN 8415    -- филиал Черкассы (Кировоград) - Склад ГП ф.Черкассы (Кировоград)
                                        WHEN 7  THEN 8413    -- филиал Кр.Рог    - Склад ГП ф.Кривой Рог
                                        WHEN 9  THEN 8425    -- филиал Харьков   - Склад ГП ф.Харьков
                                        WHEN 11 THEN 301309  -- филиал Запорожье - Склад ГП ф.Запорожье
                                        WHEN 12 THEN 3080691 -- филиал Львов     - Склад ГП ф.Львов
                                        -- WHEN ??? THEN 8459   -- филиал ???    - Склад Реализации
                                        ELSE vbUnitId
                                   END AS UnitId
                                 , CASE (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbBranchId)
                                        WHEN 1  THEN 8461    -- филиал zc_Branch_Basis - Склад Возвратов
                                        WHEN 2  THEN 428365  -- филиал Киев      - Склад возвратов ф.Киев
                                        WHEN 3  THEN 428364  -- филиал Николаев (Херсон) - Склад возвратов ф.Николаев (Херсон)
                                        WHEN 4  THEN 346094  -- филиал Одесса    - Склад возвратов ф.Одесса
                                        WHEN 5  THEN 428363  -- филиал Черкассы (Кировоград) - Склад возвратов ф.Черкассы (Кировоград)
                                        WHEN 7  THEN 428366  -- филиал Кр.Рог    - Склад возвратов ф.Кривой Рог
                                        WHEN 9  THEN 409007  -- филиал Харьков   - Склад возвратов ф.Харьков
                                        WHEN 11 THEN 309599  -- филиал Запорожье - Склад возвратов ф.Запорожье
                                        WHEN 12 THEN 3080696 -- филиал Львов     - Склад возвратов ф.Львов
                                        -- WHEN ??? THEN 8461   -- филиал ???    - Склад Возвратов
                                        ELSE vbUnitId
                                   END AS UnitId_ret
                            FROM Object AS Object_Member
                            WHERE Object_Member.Id = vbMemberId
                           )
       -- Результат
       SELECT Object_PaidKind_FirstForm.Id           AS PaidKindId_First
            , Object_PaidKind_FirstForm.ValueData    AS PaidKindName_First
            , Object_PaidKind_SecondForm.Id          AS PaidKindId_Second
            , Object_PaidKind_SecondForm.ValueData   AS PaidKindName_Second

            , Object_Status_UnComplete.Id            AS StatusId_UnComplete
            , Object_Status_UnComplete.ValueData     AS StatusName_UnComplete
            , Object_Status_Complete.Id              AS StatusId_Complete
            , Object_Status_Complete.ValueData       AS StatusName_Complete
            , Object_Status_Erased.Id                AS StatusId_Erased
            , Object_Status_Erased.ValueData         AS StatusName_Erased

            , Object_Unit.Id                         AS UnitId
            , Object_Unit.ValueData                  AS UnitName
            , Object_Unit_ret.Id                     AS UnitId_ret
            , Object_Unit_ret.ValueData              AS UnitName_ret
            , Object_Cash.Id                         AS CashId
            , Object_Cash.ValueData                  AS CashName

            , tmpPersonal.MemberId
            , tmpPersonal.MemberName
            , tmpPersonal.PersonalId

            , Object_User.Id               AS UserId
            , Object_User.ValueData        AS UserLogin
            , ObjectString_User_.ValueData AS UserPassword

--          , 'http//project-vds.vds.colocall.com/projectmobile/index.php' :: TVarChar AS WebService
--          , 'http//project-vds.vds.colocall.com/projectmobile/index.php' :: TVarChar AS WebService_two
--          , 'http//project-vds.vds.colocall.com/projectmobile/index.php' :: TVarChar AS WebService_three
--          , 'http//project-vds.vds.colocall.com/projectmobile/index.php' :: TVarChar AS WebService_four

--            , LOWER ('http//integer-srv.alan.dp.ua/projectmobile/index.php')   :: TVarChar AS WebService
  --          , LOWER ('http//integer-srv2.alan.dp.ua/projectmobile/index.php')    :: TVarChar AS WebService_two
    --        , LOWER ('http//integer-srv-r.alan.dp.ua/projectmobile/index.php') :: TVarChar AS WebService_three
      --      , LOWER ('http//integer-srv2-r.alan.dp.ua/projectmobile/index.php')  :: TVarChar AS WebService_four

            , CASE WHEN vbUserId = 5 OR 1=1 THEN LOWER ('http://integer-srv2.alan.dp.ua/projectmobile/index.php')
                                            ELSE LOWER ('http://integer-srv.alan.dp.ua/projectmobile/index.php')    END :: TVarChar AS WebService

            , CASE WHEN vbUserId = 5 OR 1=1 THEN LOWER ('http://integer-srv.alan.dp.ua/projectmobile/index.php') 
                                            ELSE LOWER ('http://integer-srv2.alan.dp.ua/projectmobile/index.php')   END :: TVarChar AS WebService_two

            , CASE WHEN vbUserId = 5 OR 1=1 THEN LOWER ('http://integer-srv2-r.alan.dp.ua/projectmobile/index.php')
                                            ELSE LOWER ('http://integer-srv-r.alan.dp.ua/projectmobile/index.php')  END :: TVarChar AS WebService_three

            , CASE WHEN vbUserId = 5 OR 1=1 THEN LOWER ('http://integer-srv-r.alan.dp.ua/projectmobile/index.php')
                                            ELSE LOWER ('http://integer-srv2-r.alan.dp.ua/projectmobile/index.php') END :: TVarChar AS WebService_four

/*
            , LOWER ('http://integer-srv2.alan.dp.ua/projectmobile/index.php')    :: TVarChar AS WebService
            , LOWER ('http://integer-srv.alan.dp.ua/projectmobile/index.php')   :: TVarChar AS WebService_two
            , LOWER ('http://integer-srv2.alan.dp.ua/projectmobile/index.php')  :: TVarChar AS WebService_three
            , LOWER ('http://integer-srv.alan.dp.ua/projectmobile/index.php') :: TVarChar AS WebService_four
*/
            -- AS LastDateIn
            -- AS LastDateOut

            -- , '1.26.0'::TVarChar             AS MobileVersion
             , getMobileConst.MobileVersion
            -- , 'ProjectMobile.apk'::TVarChar  AS MobileAPKFileName
            , getMobileConst.MobileAPKFileName

            , Object_PriceList_def.Id        AS PriceListId_def
            , Object_PriceList_def.ValueData AS PriceListName_def

            -- , 0::Integer  AS OperDate_diff  -- пока на один день позже для всех, потом будет для каждого филиала отдельно задаваться
            , getMobileConst.OperDateDiff AS OperDate_diff  -- пока на один день позже для всех, потом будет для каждого филиала отдельно задаваться
            -- , 14::Integer AS ReturnDayCount -- пока 14 дней
            , getMobileConst.ReturnDayCount -- пока 14 дней
            -- , 21::Integer AS CriticalOverDays
            , getMobileConst.CriticalOverDays
            -- , 1::TFloat   AS CriticalDebtSum
            , getMobileConst.CriticalDebtSum
            , zc_Google_APIKey() AS APIKey

            , 5::TFloat   AS CriticalWeight

       FROM tmpPersonal
            LEFT JOIN gpGet_Object_MobileConst_BySession (inSession:= inSession) AS getMobileConst ON 1 = 1
            LEFT JOIN Object AS Object_PaidKind_FirstForm  ON Object_PaidKind_FirstForm.Id = zc_Enum_PaidKind_FirstForm()
            LEFT JOIN Object AS Object_PaidKind_SecondForm ON Object_PaidKind_SecondForm.Id = zc_Enum_PaidKind_SecondForm()

            LEFT JOIN Object AS Object_Status_UnComplete ON Object_Status_UnComplete.Id = zc_Enum_Status_UnComplete()
            LEFT JOIN Object AS Object_Status_Complete   ON Object_Status_Complete.Id   = zc_Enum_Status_Complete()
            LEFT JOIN Object AS Object_Status_Erased     ON Object_Status_Erased.Id     = zc_Enum_Status_Erased()

            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpPersonal.UnitId -- Склад Реализации
            LEFT JOIN Object AS Object_Unit_ret ON Object_Unit_ret.Id = tmpPersonal.UnitId_ret
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch
                                 ON ObjectLink_Cash_Branch.ChildObjectId = vbBranchId_cash
                                AND ObjectLink_Cash_Branch.DescId        = zc_ObjectLink_Cash_Branch()
                                AND vbBranchId_cash                      <> zc_Branch_Basis()
            LEFT JOIN Object AS Object_Cash     ON Object_Cash.Id     = CASE WHEN vbBranchId_cash = zc_Branch_Basis() THEN 14462 /*Касса Днепр*/ ELSE ObjectLink_Cash_Branch.ObjectId END

            LEFT JOIN Object AS Object_User ON Object_User.Id = vbUserId
            LEFT JOIN ObjectString AS ObjectString_User_
                                   ON ObjectString_User_.ObjectId = Object_User.Id
                                  AND ObjectString_User_.DescId = zc_ObjectString_User_Password()

            LEFT JOIN Object AS Object_ConnectParam ON Object_ConnectParam.Id = zc_Enum_GlobalConst_ConnectParam ()

            LEFT JOIN Object AS Object_PriceList_def ON Object_PriceList_def.Id = zc_PriceList_Basis()
      ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.   Шаблий Щ.В.
 21.03.19                                                                    * APIKey
 04.12.17                                                       * WebService_three, WebService_four
 11.05.17                                                       * OperDate_diff
 17.02.17                                        *
*/
/*
-------- GetCurrentCoordinates :
try (LocManagerObj :=TAndroidHelper.Context.getSystemService(TJContext.JavaClass.LOCATION_SERVICE)
FCurCoordinatesMsg:= 'ошибка при обращении к Сервису GPS';

if not Assigned(LocManagerObj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.LOCATION_SERVICE))
FCurCoordinatesMsg:= 'не запущен Сервис GPS';

if not Assigned(LocationManager := TJLocationManager.Wrap((LocManagerObj as ILocalObject).GetObjectID))
FCurCoordinatesMsg:= 'нет доступа Сервиса к Менеджеру GPS'

if   not LocationManager.isProviderEnabled(TJLocationManager.JavaClass.GPS_PROVIDER)
 and not locationManager.isProviderEnabled(TJLocationManager.JavaClass.NETWORK_PROVIDER)
 and ...
FCurCoordinatesMsg:= 'на телефоне не запущен Сервис или нет доступа к GPS или NETWORK сетям'


-------- GetAddress:
if not Assigned(geocoder:= TJGeocoder.JavaClass.init(SharedActivityContext))
FCurCoordinatesMsg:= ' нет доступа к службе Адреса - geocoder для: '+FloatToStr(Latitude)+', '+FloatToStr(Longitude)+'';

if not geocoder.getFromLocation(Latitude, Longitude,1).size > 0
FCurCoordinatesMsg:= ' не раскодирован Адрес для '+FloatToStr(Latitude)+', '+FloatToStr(Longitude)+''

if not Assigned(TJAddress.Wrap((AddressList.get(0) as ILocalObject).GetObjectID))
FCurCoordinatesMsg:= ' ошибка в службе при раскодировании Адреса для: '+FloatToStr(Latitude)+', '+FloatToStr(Longitude);

except
FCurCoordinatesMsg:= ' ошибка в службе при определении Адреса для: '+FloatToStr(Latitude)+', '+FloatToStr(Longitude)+''
*/
-- тест
-- SELECT * FROM ObjectString where DescId = zc_ObjectString_MobileConst_MobileVersion();
-- UPDATE ObjectString SET ValueData = '1.61.0' WHERE DescId = zc_ObjectString_MobileConst_MobileVersion();
-- UPDATE ObjectString SET ValueData = '1.72.0' WHERE DescId = zc_ObjectString_MobileConst_MobileVersion();
-- SELECT * FROM gpGetMobile_Object_Const (inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpGetMobile_Object_Const (inSession:= '1000168')
-- D:\Project-Basis\Bin\aMobile.sdb
