-- создаются функции
DO $$
BEGIN

   -- Это Виды норм для топлива, не Enum, но нужны
   IF NOT EXISTS (SELECT * FROM Object WHERE DescId = zc_Object_RateFuelKind())
   THEN
       PERFORM lpInsertUpdate_Object (0, zc_Object_RateFuelKind(), 1, 'Лето');
   END IF;

   -- Добавляем роли:
   -- zc_Enum_Role_Admin
   PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Role_Admin(), inDescId:= zc_Object_Role(), inCode:= lfGet_ObjectCode_byEnum ('zc_Enum_Role_Admin'), inName:= 'Роль администратора', inEnumName:= 'zc_Enum_Role_Admin');

END $$;
/*
DO $$
DECLARE ioId integer;
BEGIN

   IF NOT EXISTS(SELECT * FROM OBJECT
   JOIN ObjectLink AS RoleRight_Role
     ON RoleRight_Role.descid = zc_ObjectLink_RoleRight_Role()
    AND RoleRight_Role.childobjectid = zc_Enum_Role_Admin()
    AND RoleRight_Role.objectid = OBJECT.id

   JOIN ObjectLink AS RoleRight_Process
     ON RoleRight_Process.descid = zc_ObjectLink_RoleRight_Process()
    AND RoleRight_Process.childobjectid = zc_Enum_Process_InsertUpdate_Object_User()
    AND RoleRight_Process.objectid = OBJECT.id
  WHERE OBJECT.descid = zc_Object_RoleRight()) THEN
     -- Создаем права роли администратора
     ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleRight(), 0, '');
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RoleRight_Role(), ioId, zc_Enum_Role_Admin());
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RoleRight_Process(), ioId, zc_Enum_Process_InsertUpdate_Object_User());
   END IF;

END $$;
*/
DO $$
  DECLARE ioId integer;
  DECLARE UserId integer;
  DECLARE DefaultKeyId Integer;
  DECLARE vbKey TVarChar;
  DECLARE vbRetailId Integer;
BEGIN
   -- Нельзя вставить штатными средствами потому что не сработает проверка прав!!!
   SELECT Id INTO UserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';

   IF COALESCE(UserId, 0) = 0 THEN
     -- Создаем администратора
     UserId := lpInsertUpdate_Object(0, zc_Object_User(), 0, 'Админ');

     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), UserId, 'Админ');
   END IF;

   vbKey := 'zc_Object_Retail';

   -- Добавляем ключ дефолта
   SELECT Id INTO DefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

   IF COALESCE(DefaultKeyId, 0) = 0 THEN 
      INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"DescName":"zc_Object_Retail"}') RETURNING Id INTO DefaultKeyId;
   END IF;

   -- Добавляем сеть "Не болей"

   SELECT Id INTO vbRetailId FROM Object WHERE DescId = zc_Object_Retail() AND ValueData = 'Не болей';

   IF COALESCE(vbRetailId, 0) = 0 THEN 
      vbRetailId := lpInsertUpdate_Object( 0, zc_Object_Retail(), 1, 'Не болей');
   END IF;

   IF COALESCE(lpGet_DefaultValue('zc_Object_Retail', zc_Enum_Role_Admin()), '') = '0' THEN
      INSERT INTO DefaultValue(DefaultKeyId, UserKeyId, DefaultValue) 
                VALUES(DefaultKeyId, zc_Enum_Role_Admin(), vbRetailId);
   END IF;

   IF NOT EXISTS(SELECT * FROM OBJECT

     JOIN ObjectLink AS UserRole_Role
       ON UserRole_Role.descid = zc_ObjectLink_UserRole_Role()
      AND UserRole_Role.childobjectid = zc_Enum_Role_Admin()
      AND UserRole_Role.objectid = OBJECT.id

     JOIN ObjectLink AS UserRole_User
       ON UserRole_User.descid = zc_ObjectLink_UserRole_User()
      AND UserRole_User.childobjectid = UserId
      AND UserRole_User.objectid = OBJECT.id
  WHERE OBJECT.descid = zc_Object_UserRole()) THEN

     -- Соединяем пользователя с ролью
     ioId := lpInsertUpdate_Object(ioId, zc_Object_UserRole(), 0, '');

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserRole_Role(), ioId, zc_Enum_Role_Admin());

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserRole_User(), ioId, UserId);
   END IF;
END $$;


DO $$
BEGIN

     -- !!! Валюты
     IF zc_Enum_Currency_Basis() IS NULL
     THEN IF EXISTS (SELECT Id FROM Object WHERE DescId = zc_Object_Currency() AND ObjectCode = 980)
          THEN PERFORM lpUpdate_Object_Enum_byCode (inCode:= 980,  inDescId:= zc_Object_Currency(), inEnumName:= 'zc_Enum_Currency_Basis');
          -- ELSE PERFORM lpInsertUpdate_Object_Enum (inId:=zc_Enum_Currency_Basis(),  inDescId:= zc_Object_Currency(), inCode:= 980, inName:= 'грн', inEnumName:= 'zc_Enum_Currency_Basis');
          END IF;
     END IF;

     -- !!! Глобальные константы
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_Marion(),  inDescId:= zc_Object_GlobalConst(), inCode:= 1, inName:= 'Коды Мариона', inEnumName:= 'zc_Enum_GlobalConst_Marion');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_BarCode(),  inDescId:= zc_Object_GlobalConst(), inCode:= 2, inName:= 'Штрих-коды', inEnumName:= 'zc_Enum_GlobalConst_BarCode');

     -- !!! формы оплаты
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidKind_FirstForm(),  inDescId:= zc_Object_PaidKind(), inCode:= 1, inName:= 'БН', inEnumName:= 'zc_Enum_PaidKind_FirstForm');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidKind_SecondForm(), inDescId:= zc_Object_PaidKind(), inCode:= 2, inName:= 'Нал', inEnumName:= 'zc_Enum_PaidKind_SecondForm');

     -- !!! Типы НДС
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_NDSKind_Common(),  inDescId:= zc_Object_NDSKind(), inCode:= 1, inName:= '20% - общее основание', inEnumName:= 'zc_Enum_NDSKind_Common');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_NDSKind_Medical(), inDescId:= zc_Object_NDSKind(), inCode:= 2, inName:= '7% - медикаменты', inEnumName:= 'zc_Enum_NDSKind_Medical');

     -- !!! Типы корректировок долга по приходной накладной
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ChangeIncomePaymentKind_Bonus(), inDescId:= zc_Object_ChangeIncomePaymentKind(), inCode:= 1, inName:= 'Корректировка по бонусу', inEnumName:= 'zc_Enum_ChangeIncomePaymentKind_Bonus');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ChangeIncomePaymentKind_Other(), inDescId:= zc_Object_ChangeIncomePaymentKind(), inCode:= 2, inName:= 'Корректировка по прочим причинам', inEnumName:= 'zc_Enum_ChangeIncomePaymentKind_Other');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ChangeIncomePaymentKind_ReturnOut(), inDescId:= zc_Object_ChangeIncomePaymentKind(), inCode:= 3, inName:= 'Корректировка по возвратам', inEnumName:= 'zc_Enum_ChangeIncomePaymentKind_ReturnOut');
     
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_NDSKind_NDS(), zc_Enum_NDSKind_Common(), 20);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_NDSKind_NDS(), zc_Enum_NDSKind_Medical(), 7);

     -- !!! Типы импорта
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_Excel(),  inDescId:= zc_Object_FileTypeKind(), inCode:= 1, inName:= 'Excel', inEnumName:= 'zc_Enum_FileTypeKind_Excel');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_DBF(), inDescId:= zc_Object_FileTypeKind(), inCode:= 2, inName:= 'DBF', inEnumName:= 'zc_Enum_FileTypeKind_DBF');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_MMO(), inDescId:= zc_Object_FileTypeKind(), inCode:= 3, inName:= 'MMO', inEnumName:= 'zc_Enum_FileTypeKind_MMO');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_FileTypeKind_ODBC(), inDescId:= zc_Object_FileTypeKind(), inCode:= 4, inName:= 'ODBC', inEnumName:= 'zc_Enum_FileTypeKind_ODBC');

     -- !!! Статусы документов
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_UnComplete(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_UnComplete(), inName:= 'Не проведен', inEnumName:= 'zc_Enum_Status_UnComplete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Complete(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Complete(), inName:= 'Проведен', inEnumName:= 'zc_Enum_Status_Complete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Status_Erased(), inDescId:= zc_Object_Status(), inCode:= zc_Enum_StatusCode_Erased(), inName:= 'Удален', inEnumName:= 'zc_Enum_Status_Erased');

     -- !!! Статусы документов EDI
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EDIStatus_ORDERS(), inDescId:= zc_Object_EDIStatus(), inCode:= zc_Enum_EDIStatus_ORDERS(), inName:= 'Заказ', inEnumName:= 'zc_Enum_EDIStatus_ORDERS');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EDIStatus_DESADV(), inDescId:= zc_Object_EDIStatus(), inCode:= zc_Enum_EDIStatus_DESADV(), inName:= 'Отгружено', inEnumName:= 'zc_Enum_EDIStatus_DESADV');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EDIStatus_COMDOC(), inDescId:= zc_Object_EDIStatus(), inCode:= zc_Enum_EDIStatus_COMDOC(), inName:= 'Получено', inEnumName:= 'zc_Enum_EDIStatus_COMDOC');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EDIStatus_DECLAR(), inDescId:= zc_Object_EDIStatus(), inCode:= zc_Enum_EDIStatus_DECLAR(), inName:= 'Налоговая', inEnumName:= 'zc_Enum_EDIStatus_DECLAR');
    
     -- !!! Тип контакта
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_CreateOrder()  , inDescId:= zc_Object_ContactPersonKind(), inCode:= 1, inName:= 'Формирование заказов'                , inEnumName:= 'zc_Enum_ContactPersonKind_CreateOrder');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_CheckDocument(), inDescId:= zc_Object_ContactPersonKind(), inCode:= 2, inName:= 'Проверка документов'                 , inEnumName:= 'zc_Enum_ContactPersonKind_CheckDocument');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_AktSverki()    , inDescId:= zc_Object_ContactPersonKind(), inCode:= 3, inName:= 'Акты сверки и выполенных работ'      , inEnumName:= 'zc_Enum_ContactPersonKind_AktSverki');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_ProcessOrder() , inDescId:= zc_Object_ContactPersonKind(), inCode:= 4, inName:= 'Обработка заказов'                   , inEnumName:= 'zc_Enum_ContactPersonKind_ProcessOrder');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_PriceListIn()  , inDescId:= zc_Object_ContactPersonKind(), inCode:= 5, inName:= 'Обработка прайса-поставщика'         , inEnumName:= 'zc_Enum_ContactPersonKind_PriceListIn');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContactPersonKind_IncomeMMO()    , inDescId:= zc_Object_ContactPersonKind(), inCode:= 6, inName:= 'Обработка ММО прихода от поставщика' , inEnumName:= 'zc_Enum_ContactPersonKind_IncomeMMO');

     -- !!! Типы счетов
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Active(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= 'Активный', inEnumName:= 'zc_Enum_AccountKind_Active');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_Passive(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= 'Пассивный', inEnumName:= 'zc_Enum_AccountKind_Passive');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountKind_All(), inDescId:= zc_Object_AccountKind(), inCode:= 1, inName:= 'Активно/Пассивный', inEnumName:= 'zc_Enum_AccountKind_All');

     -- !!! Типы маршрутов
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_RouteKind_Internal(), inDescId:= zc_Object_RouteKind(), inCode:= 1, inName:= 'Город', inEnumName:= 'zc_Enum_RouteKind_Internal');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_RouteKind_External(), inDescId:= zc_Object_RouteKind(), inCode:= 2, inName:= 'Межгород', inEnumName:= 'zc_Enum_RouteKind_External');

     -- !!! Типы рабочего времени
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Work(),      inDescId:= zc_Object_WorkTimeKind(), inCode:= 1, inName:= 'рабочий день'              , inEnumName:= 'zc_Enum_WorkTimeKind_Work');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_WorkTime(),  inDescId:= zc_Object_WorkTimeKind(), inCode:= 2, inName:= 'рабочий день (по времени)' , inEnumName:= 'zc_Enum_WorkTimeKind_WorkTime');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Holiday(),   inDescId:= zc_Object_WorkTimeKind(), inCode:= 3, inName:= 'отпуск'                    , inEnumName:= 'zc_Enum_WorkTimeKind_Holiday');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_Hospital(),  inDescId:= zc_Object_WorkTimeKind(), inCode:= 4, inName:= 'больничный'                , inEnumName:= 'zc_Enum_WorkTimeKind_Hospital');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_SkipOut(),   inDescId:= zc_Object_WorkTimeKind(), inCode:= 5, inName:= '-замена'                   , inEnumName:= 'zc_Enum_WorkTimeKind_SkipOut');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_WorkTimeKind_SkipIn(),    inDescId:= zc_Object_WorkTimeKind(), inCode:= 6, inName:= '+замена'                   , inEnumName:= 'zc_Enum_WorkTimeKind_SkipIn');

     -- !!! Типы формирования налогового документа
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Tax(),      		 inDescId:= zc_Object_DocumentTaxKind(), inCode:= 1, inName:= 'Налоговая', inEnumName:= 'zc_Enum_DocumentTaxKind_Tax');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(),  inDescId:= zc_Object_DocumentTaxKind(), inCode:= 2, inName:= 'Сводная налоговая по юр.л.(реализация)', inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR(), inDescId:= zc_Object_DocumentTaxKind(), inCode:= 3, inName:= 'Сводная налоговая по юр.л.(реализация-возвраты)', inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryPartnerS(), 	 inDescId:= zc_Object_DocumentTaxKind(), inCode:= 4, inName:= 'Сводная налоговая по т.т.(реализация)', inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryPartnerS');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR(), 	 inDescId:= zc_Object_DocumentTaxKind(), inCode:= 5, inName:= 'Сводная налоговая по т.т.(реализация-возвраты)', inEnumName:= 'zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Corrective(), 	 		inDescId:= zc_Object_DocumentTaxKind(), inCode:= 6, inName:= 'Корректировка', inEnumName:= 'zc_Enum_DocumentTaxKind_Corrective');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR(),  inDescId:= zc_Object_DocumentTaxKind(), inCode:= 7, inName:= 'Сводная корректировка по юр.л.(возвраты)' , inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR(), inDescId:= zc_Object_DocumentTaxKind(), inCode:= 8, inName:= 'Сводная корректировка по юр.л.(реализация-возвраты)' , inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR(),    inDescId:= zc_Object_DocumentTaxKind(), inCode:= 9, inName:= 'Сводная корректировка по т.т.(возвраты)' , inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR(),   inDescId:= zc_Object_DocumentTaxKind(), inCode:= 10, inName:= 'Сводная корректировка по т.т.(реализация-возвраты)' , inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_CorrectivePrice(),              inDescId:= zc_Object_DocumentTaxKind(), inCode:= 11, inName:= 'Коорректировка цены', inEnumName:= 'zc_Enum_DocumentTaxKind_CorrectivePrice');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_DocumentTaxKind_Prepay(),                       inDescId:= zc_Object_DocumentTaxKind(), inCode:= 12, inName:= 'Предоплата', inEnumName:= 'zc_Enum_DocumentTaxKind_Prepay');

     -- !!! Типы моделей начисления
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_DaySheetWorkTime(),   inDescId:= zc_Object_ModelServiceKind(), inCode:= 1, inName:= 'По дням табель'         , inEnumName:= 'zc_Enum_ModelServiceKind_DaySheetWorkTime');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_MonthSheetWorkTime(), inDescId:= zc_Object_ModelServiceKind(), inCode:= 2, inName:= 'За месяц табель'        , inEnumName:= 'zc_Enum_ModelServiceKind_MonthSheetWorkTime');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_SatSheetWorkTime(),   inDescId:= zc_Object_ModelServiceKind(), inCode:= 3, inName:= 'По субботам табель'     , inEnumName:= 'zc_Enum_ModelServiceKind_SatSheetWorkTime');
   --  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_MonthFundPay(),       inDescId:= zc_Object_ModelServiceKind(), inCode:= 4, inName:= 'За месяц Фонд/Доплата'  , inEnumName:= 'zc_Enum_ModelServiceKind_MonthFundPay');
   --  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ModelServiceKind_TurnFundPay(),        inDescId:= zc_Object_ModelServiceKind(), inCode:= 5, inName:= 'За 1 смену Фонд/Доплата', inEnumName:= 'zc_Enum_ModelServiceKind_TurnFundPay');

     -- !!! Типы выбора данных
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_InWeight(),  inDescId:= zc_Object_SelectKind(), inCode:= 1, inName:= 'Кол-во приход с пересчетом в вес', inEnumName:= 'zc_Enum_SelectKind_InWeight');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_OutWeight(), inDescId:= zc_Object_SelectKind(), inCode:= 2, inName:= 'Кол-во расход с пересчетом в вес', inEnumName:= 'zc_Enum_SelectKind_OutWeight');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_InAmount(),  inDescId:= zc_Object_SelectKind(), inCode:= 3, inName:= 'Кол-во приход',                    inEnumName:= 'zc_Enum_SelectKind_InAmount');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SelectKind_OutAmount(), inDescId:= zc_Object_SelectKind(), inCode:= 4, inName:= 'Кол-во расход',                    inEnumName:= 'zc_Enum_SelectKind_OutAmount');

     -- !!! Типы сумм для штатного расписания
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_Month(),           inDescId:= zc_Object_StaffListSummKind(), inCode:= 1, inName:= 'Фонд за месяц'                                           , inEnumName:= 'zc_Enum_StaffListSummKind_Month');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_Day(),             inDescId:= zc_Object_StaffListSummKind(), inCode:= 2, inName:= 'Доплата за 1 день на всех'                               , inEnumName:= 'zc_Enum_StaffListSummKind_Day');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_Personal(),        inDescId:= zc_Object_StaffListSummKind(), inCode:= 3, inName:= 'Доплата за 1 день на человека'                           , inEnumName:= 'zc_Enum_StaffListSummKind_Personal');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursPlan(),       inDescId:= zc_Object_StaffListSummKind(), inCode:= 4, inName:= 'Фонд за общий план часов (постоянный) в месяц на человека', inEnumName:= 'zc_Enum_StaffListSummKind_HoursPlan');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursDay(),        inDescId:= zc_Object_StaffListSummKind(), inCode:= 5, inName:= 'Фонд за план часов (расчетный) в месяц на человека'       , inEnumName:= 'zc_Enum_StaffListSummKind_HoursDay');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursPlanConst(),  inDescId:= zc_Object_StaffListSummKind(), inCode:= 6, inName:= 'Фонд постоянный для факт часов в месяц на человека'       , inEnumName:= 'zc_Enum_StaffListSummKind_HoursPlanConst');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_HoursDayConst(),   inDescId:= zc_Object_StaffListSummKind(), inCode:= 7, inName:= '(не используется).Фонд постоянный для факт часов в рабочие дни на человека' , inEnumName:= 'zc_Enum_StaffListSummKind_HoursDayConst');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_StaffListSummKind_WorkHours(),       inDescId:= zc_Object_StaffListSummKind(), inCode:= 11,inName:= '(не используется).Количество рабочих часов в день'                          , inEnumName:= 'zc_Enum_StaffListSummKind_WorkHours');


     -- !!! Состояние договора
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_Signed(), inDescId:= zc_Object_ContractStateKind(), inCode:= 1, inName:= 'Подписан' , inEnumName:= 'zc_Enum_ContractStateKind_Signed');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_UnSigned(), inDescId:= zc_Object_ContractStateKind(), inCode:= 2, inName:= 'Не подписан' , inEnumName:= 'zc_Enum_ContractStateKind_UnSigned');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_Close(), inDescId:= zc_Object_ContractStateKind(), inCode:= 3, inName:= 'Завершен' , inEnumName:= 'zc_Enum_ContractStateKind_Close');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractStateKind_Partner(), inDescId:= zc_Object_ContractStateKind(), inCode:= 4, inName:= 'У контрагента' , inEnumName:= 'zc_Enum_ContractStateKind_Partner');
     
     -- !!! Типы условий договоров
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_ChangePercent()         , inDescId:= zc_Object_ContractConditionKind(), inCode:= 1,  inName:= '(-)% Скидки (+)% Наценки'     , inEnumName:= 'zc_Enum_ContractConditionKind_ChangePercent');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_ChangePrice()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 2,  inName:= 'Скидка в цене'                , inEnumName:= 'zc_Enum_ContractConditionKind_ChangePrice');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayDayCalendar()      , inDescId:= zc_Object_ContractConditionKind(), inCode:= 3,  inName:= 'Отсрочка в календарных днях'               , inEnumName:= 'zc_Enum_ContractConditionKind_DelayDayCalendar');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayDayBank()          , inDescId:= zc_Object_ContractConditionKind(), inCode:= 4,  inName:= 'Отсрочка в банковских днях'                , inEnumName:= 'zc_Enum_ContractConditionKind_DelayDayBank');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayCreditLimit()      , inDescId:= zc_Object_ContractConditionKind(), inCode:= 5,  inName:= 'Отсрочка товарный кредит'                  , inEnumName:= 'zc_Enum_ContractConditionKind_DelayCreditLimit');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_DelayPrepay()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 6,  inName:= 'Предоплата'                                , inEnumName:= 'zc_Enum_ContractConditionKind_DelayPrepay');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditPercent()         , inDescId:= zc_Object_ContractConditionKind(), inCode:= 11,  inName:= '% по кредиту'                      , inEnumName:= 'zc_Enum_ContractConditionKind_CreditPercent');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditLimit()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 12,  inName:= 'Лимит кредита'                     , inEnumName:= 'zc_Enum_ContractConditionKind_CreditLimit');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditPercentService()  , inDescId:= zc_Object_ContractConditionKind(), inCode:= 13,  inName:= '% за выдачу/обслуживание кредита'  , inEnumName:= 'zc_Enum_ContractConditionKind_CreditPercentService');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_CreditPercentReceived() , inDescId:= zc_Object_ContractConditionKind(), inCode:= 14,  inName:= '% за транш по кредиту'             , inEnumName:= 'zc_Enum_ContractConditionKind_CreditPercentReceived');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentSale()      , inDescId:= zc_Object_ContractConditionKind(), inCode:= 21, inName:= '% бонуса за отгрузку'         , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentSale');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentSaleReturn(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 22, inName:= '% бонуса за отгрузку-возврат' , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentSaleReturn');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusPercentAccount()   , inDescId:= zc_Object_ContractConditionKind(), inCode:= 23, inName:= '% бонуса за оплату'           , inEnumName:= 'zc_Enum_ContractConditionKind_BonusPercentAccount');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusMonthlyPayment()   , inDescId:= zc_Object_ContractConditionKind(), inCode:= 24, inName:= 'бонус - ежемесячный платеж'   , inEnumName:= 'zc_Enum_ContractConditionKind_BonusMonthlyPayment');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusMonthlyPaymentAdv(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 25, inName:= 'реклама - ежемесячный платеж'   , inEnumName:= 'zc_Enum_ContractConditionKind_BonusMonthlyPaymentAdv');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusUpSaleSummPVAT()   , inDescId:= zc_Object_ContractConditionKind(), inCode:= 26, inName:= 'бонусы роста,при достижении плана продаж (от суммы с НДС)'   , inEnumName:= 'zc_Enum_ContractConditionKind_BonusUpSaleSummPVAT');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusUpSaleSummMVAT()   , inDescId:= zc_Object_ContractConditionKind(), inCode:= 27, inName:= 'бонусы роста,при достижении плана продаж (от суммы без НДС)' , inEnumName:= 'zc_Enum_ContractConditionKind_BonusUpSaleSummMVAT');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_BonusYearlyPayment()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 28, inName:= 'годовой бюджет'               , inEnumName:= 'zc_Enum_ContractConditionKind_BonusYearlyPayment');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_LimitReturn()           , inDescId:= zc_Object_ContractConditionKind(), inCode:= 29, inName:= 'ограничение по возвратам'     , inEnumName:= 'zc_Enum_ContractConditionKind_LimitReturn');

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime1()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 101, inName:= 'Ставка за время (без экспедитора с холодильником), грн/ч'  , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime1');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime2()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 102, inName:= 'Ставка за время (с экспедитором без холодильника), грн/ч'  , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime2');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime3()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 103, inName:= 'Ставка за время (без экспедитора без холодильника), грн/ч' , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime3');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportTime4()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 104, inName:= 'Ставка за время (с экспедитором с холодильником), грн/ч'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportTime4');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportDistance() , inDescId:= zc_Object_ContractConditionKind(), inCode:= 105, inName:= 'Ставка за пробег, грн/км'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportDistance');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportOneTrip()  , inDescId:= zc_Object_ContractConditionKind(), inCode:= 106, inName:= 'Ставка за маршрут в одну сторону, грн'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportOneTrip');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportRoundTrip(), inDescId:= zc_Object_ContractConditionKind(), inCode:= 107, inName:= 'Ставка за маршрут в обе стороны, грн'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportRoundTrip');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ContractConditionKind_TransportPoint()    , inDescId:= zc_Object_ContractConditionKind(), inCode:= 108, inName:= 'Ставка за точку, грн'   , inEnumName:= 'zc_Enum_ContractConditionKind_TransportPoint');

     -- !!!
     -- !!! Виды товаров
     -- !!!
     -- PERFORM lpUpdate_Object_Enum_byCode (inCode:= 1,  inDescId:= zc_Object_GoodsKind(), inEnumName:= 'zc_Enum_GoodsKind_Main');

     -- !!! Виды соц.проектов
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SPKind_SP(),   inDescId:= zc_Object_SPKind(), inCode:= 1, inName:= 'Соц. проект',        inEnumName:= 'zc_Enum_SPKind_SP');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_SPKind_1303(), inDescId:= zc_Object_SPKind(), inCode:= 2, inName:= 'Постановление 1303', inEnumName:= 'zc_Enum_SPKind_1303');


END $$;

DO $$
BEGIN

   --- !!! Типы рабочего времени комментарий
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_ModelServiceKind_Comment(),  zc_Enum_ModelServiceKind_DaySheetWorkTime(),   'значение для модели рассчитывается для каждого дня и само начисление происходит для ФИО из табеля по дням');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_ModelServiceKind_Comment(),  zc_Enum_ModelServiceKind_MonthSheetWorkTime(), 'значение для модели рассчитывается итого за месяц и само начисление происходит для всех ФИО из табеля за месяц');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_ModelServiceKind_Comment(),  zc_Enum_ModelServiceKind_SatSheetWorkTime(),   'значение для модели рассчитывается только для дней "суббота" и само начисление происходит для ФИО из табеля по дням "суббота"');

     --- !!! Типы рабочего времени комментарий
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_Month(),         '1,2,3 не важны.За месяц эта сумма будет начислена(распределена в пропорции факт дней на кол-во людей) на всех кто отмечен в табеле.');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_Day(),           '1,2,3 не важны.За день эта сумма будет начислена(распределена в пропорции факт часов на кол-во людей) на всех кто отмечен в табеле.');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_Personal(),      '1,2,3 не важны.За день эта сумма будет начислена каждому кто отмечен в табеле.');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_HoursPlan(),     '1-важно,2,3 не важны.За месяц расчетная(Цена часа=фонд/1-важно) сумма будет начислена из расчета "факт часов"*"Цена часа" каждому кто отмечен в табеле.(возможна переработка-слесаря).');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_HoursDay(),      '2-важно,1,3 не важны.За месяц расчетная(Цена часа=фонд/2-важно*р.дн.)сумма будет начислена из расчета "факт часов"*"Цена часа" каждому кто отмечен в табеле.(возможна переработка-слесаря).');
     PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_HoursPlanConst(),'1,2,3 не важны.За месяц эта сумма будет начислена (распределяется в пропорции факт часов человека) каждому кто отмечен в табеле.');
     -- PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_HoursDayConst(), '(не используется).За месяц эта сумма будет начислена в пропорции факт/план_часов*р.дн. каждому кто отмечен в табеле.');
     -- PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_StaffListSummKind_Comment(), zc_Enum_StaffListSummKind_WorkHours(),     '(не используется).Используется для расчета Фонда за план часов в рабочие дни на человека.');
     
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_InfoMoneyDestination_20500(), inDescId:= zc_Object_InfoMoneyDestination(), inCode:= 20500,  inName:= 'Предоплата', inEnumName:= 'zc_Enum_InfoMoneyDestination_20500');

-- КОНСТАНТА НИЖЕ НЕ СТАВИТСЯ АВТОМАТОМ!!! 
--     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_GlobalConst_ConnectParam(),  inDescId:= zc_Object_GlobalConst(), inCode:= 3, inName:= 'http://91.210.37.210/farmacy/index.php', inEnumName:= 'zc_Enum_GlobalConst_ConnectParam');
     
END $$;

DO $$
BEGIN

-- !!!
-- !!! Баланс: 1-уровень Управленческих Счетов
-- !!!

-- 20000; "Запасы"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountGroup_20000(), inDescId:= zc_Object_AccountGroup(), inCode:= 20000, inName:= 'Запасы' , inEnumName:= 'zc_Enum_AccountGroup_20000');

-- 40000; "Денежные средства"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountGroup_40000(), inDescId:= zc_Object_AccountGroup(), inCode:= 40000, inName:= 'Денежные средства' , inEnumName:= 'zc_Enum_AccountGroup_40000');

-- 70000; "Кредиторы"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountGroup_70000(), inDescId:= zc_Object_AccountGroup(), inCode:= 70000, inName:= 'Кредиторы' , inEnumName:= 'zc_Enum_AccountGroup_70000');

-- 100000; "Собственный капитал"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountGroup_100000(), inDescId:= zc_Object_AccountGroup(), inCode:= 100000, inName:= 'Собственный капитал' , inEnumName:= 'zc_Enum_AccountGroup_100000');

-- !!!
-- !!! Баланс: 2-уровень Управленческих Счетов
-- !!!

-- 20000; "Запасы"; 20100; "Склад"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_20100(), inDescId:= zc_Object_AccountDirection(), inCode:= 20100, inName:= 'Склад' , inEnumName:= 'zc_Enum_AccountDirection_20100');
-- 20000; "Запасы"; 20200; "Аптека"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_20200(), inDescId:= zc_Object_AccountDirection(), inCode:= 20200, inName:= 'Аптека' , inEnumName:= 'zc_Enum_AccountDirection_20200');

-- 40000; "Денежные средства"; 40100; "касса"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_40100(), inDescId:= zc_Object_AccountDirection(), inCode:= 40100, inName:= 'Касса' , inEnumName:= 'zc_Enum_AccountDirection_40100');
-- 40000; "Денежные средства"; 40300; "рассчетный счет"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_40300(), inDescId:= zc_Object_AccountDirection(), inCode:= 40300, inName:= 'Рассчетный счет' , inEnumName:= 'zc_Enum_AccountDirection_40300');

-- 70000; "Кредиторы"; 70100; "Поставщики"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_70100(), inDescId:= zc_Object_AccountDirection(), inCode:= 70100, inName:= 'Поставщики' , inEnumName:= 'zc_Enum_AccountDirection_70100');
-- 100000; "Собственный капитал"; 100300; "Прибыль текущего периода"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AccountDirection_100300(), inDescId:= zc_Object_AccountDirection(), inCode:= 100300, inName:= 'Прибыль текущего периода' , inEnumName:= 'zc_Enum_AccountDirection_100300');

-- !!!
-- !!! Баланс: Управленческие Счета (1+2+3 уровень)
-- !!!

-- 40101; "Касса";
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Account_40101(), inDescId:= zc_Object_Account(), inCode:= 40101, inName:= 'Касса' , inEnumName:= 'zc_Enum_Account_40101');
-- 40301; "Расчетный счет";
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Account_40301(), inDescId:= zc_Object_Account(), inCode:= 40301, inName:= 'Расчетный счет' , inEnumName:= 'zc_Enum_Account_40301');

-- !!!
-- !!! УП: 2-уровень Управленческие назначения
-- !!!

-- 10000; "Основное сырье"; 10200; "Медикаменты"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_InfoMoneyDestination_10200(), inDescId:= zc_Object_InfoMoneyDestination(), inCode:= 10200, inName:= 'Медикаменты' , inEnumName:= 'zc_Enum_InfoMoneyDestination_10200');
-- 80000; "Собственный капиталл"; 80400; "Прибыль текущего периода"
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_InfoMoneyDestination_80400(), inDescId:= zc_Object_InfoMoneyDestination(), inCode:= 80400, inName:= 'Прибыль текущего периода' , inEnumName:= 'zc_Enum_InfoMoneyDestination_80400');

-- !!!
-- !!! Баланс: Управленческие Счета (1+2+3 уровень)
-- !!!
-- 100301; "прибыль текущего периода";
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Account_100301(), inDescId:= zc_Object_Account(), inCode:= 100301, inName:= 'Прибыль текущего периода' , inEnumName:= 'zc_Enum_Account_100301');

-- !!!
-- !!! Типі оплат 
-- !!!
-- 0. Наличка
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidType_Cash(),  inDescId:= zc_Object_PaidType(), inCode:= 1, inName:= 'Наличка', inEnumName:= 'zc_Enum_PaidType_Cash');
  PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_PaidType_Card(), inDescId:= zc_Object_PaidType(), inCode:= 2, inName:= 'Карточка', inEnumName:= 'zc_Enum_PaidType_Card');

-- !!! Типы аналитик для проводок
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleCount_10400(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 101, inName:= 'Кол-во, реализация, у покупателя', inEnumName:= 'zc_Enum_AnalyzerId_SaleCount_10400');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleCount_10500(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 102, inName:= 'Кол-во, реализация, Скидка за вес', inEnumName:= 'zc_Enum_AnalyzerId_SaleCount_10500');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleCount_40200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 103, inName:= 'Кол-во, реализация, Разница в весе', inEnumName:= 'zc_Enum_AnalyzerId_SaleCount_40200');

     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10400(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 111, inName:= 'Сумма с/с, реализация, у покупателя', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10400');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10500(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 112, inName:= 'Сумма с/с, реализация, Скидка за вес', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10500');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_40200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 113, inName:= 'Сумма с/с, реализация, Разница в весе', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_40200');

     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10100(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 121, inName:= 'Сумма, реализация, у покупателя (по оптовым ценам)', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10100');
     -- PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10200(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 122, inName:= 'Сумма, реализация, Разница с оптовыми ценами', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10200');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_SaleSumm_10300(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 123, inName:= 'Сумма, реализация, Скидка дополнительная', inEnumName:= 'zc_Enum_AnalyzerId_SaleSumm_10300');
     
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_AnalyzerId_ReturnInSumm_10300(),  inDescId:= zc_Object_AnalyzerId(), inCode:= 223, inName:= 'Сумма, возврат, Скидка дополнительная', inEnumName:= 'zc_Enum_AnalyzerId_ReturnInSumm_10300');

     -- !!!
     -- !!! Типы связей
     -- !!!

     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_UnitJuridical(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 1, inName:= 'Связь подразделений для поставщиков', inEnumName:= 'zc_Enum_ImportExportLinkType_UnitJuridical');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_UnitUnitId(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 2, inName:= 'Связь подразделения со старым складом', inEnumName:= 'zc_Enum_ImportExportLinkType_UnitUnitId');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_DefaultFileName(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 3, inName:= 'Имя файла по умолчанию', inEnumName:= 'zc_Enum_ImportExportLinkType_DefaultFileName');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_UnitEmailSign(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 4, inName:= 'Подпись для подразделения', inEnumName:= 'zc_Enum_ImportExportLinkType_UnitEmailSign');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_ClientEmailSubject(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 5, inName:= 'Тема письма', inEnumName:= 'zc_Enum_ImportExportLinkType_ClientEmailSubject');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_OldClientLink(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 6, inName:= 'Связь поставщиков со старым складом', inEnumName:= 'zc_Enum_ImportExportLinkType_OldClientLink');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_UploadCompliance(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 7, inName:= 'Связи объектов с кодами в учетной системе поставщика для выгрузок', inEnumName:= 'zc_Enum_ImportExportLinkType_UploadCompliance');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ImportExportLinkType_QlikView(),  inDescId:= zc_Object_ImportExportLinkType(), inCode:= 8, inName:= '№ юрлиц и подразделений для QlikView', inEnumName:= 'zc_Enum_ImportExportLinkType_QlikView');
 
END $$;

--Загрузчик НТЗ
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_MCS() ;
        
    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_MCS() ;
    -- Создаем Тип загрузки НТЗ
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка неснижаемого товарного запаса', 
                                                       inProcedureName := 'gpInsertUpdate_Object_MCS_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_MCS');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка неснижаемого товарного запаса',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_MCS');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUnitId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inUnitId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Идентификатор подразделения',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код товара',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMCSValue';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inMCSValue', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'НТЗ', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_MCS Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceForm;zc_Object_ImportSetting_MCS';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
    
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_MCS()::TBlob, inSession := ''::TVarChar);
END $$;

--
--Загрузчик Цен
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Price() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Price() ;
    -- Создаем Тип загрузки НТЗ
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка розничных цен', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Price_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Price');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка розничных цен',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Price');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUnitId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inUnitId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Идентификатор подразделения',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код товара',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPriceValue';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inPriceValue', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPriceForm;zc_Object_ImportSetting_Price';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;

    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Price()::TBlob, inSession := ''::TVarChar);
END $$;

--
--Загрузчик Остатка по переучету
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Inventory() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Inventory() ;
    -- Создаем Тип загрузки остатка по переучету
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка остатка по переучету', 
                                                       inProcedureName := 'gpInsertUpdate_MovementItem_Inventory_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Inventory');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка остатка по переучету',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Inventory');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMovementId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inMovementId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Идентификатор переучета',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код товара',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Остаток', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inPrice', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
                                                      
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Inventory Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TInventoryForm;zc_Object_ImportSetting_Inventory';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TInventoryForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Inventory()::TBlob, inSession := ''::TVarChar);
END $$;


--
--Загрузчик минимального округления
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Goods_MinimumLot() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Goods_MinimumLot() ;
    -- Создаем Тип загрузки минимального округления
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка минимального округления', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Goods_MinimumLot', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Goods_MinimumLot');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка минимального округления',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Goods_MinimumLot');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код товара поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inObjectId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inObjectId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMinimumLot';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inMinimumLot', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Минимальное округление', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
                                                      
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Goods_MinimumLot Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_MinimumLot';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
       INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsPartnerCodeForm","DescName":"zc_Object_ImportSetting_Goods_MinimumLot"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Goods_MinimumLot()::TBlob, inSession := ''::TVarChar);
END $$;

--
--Загрузчик признака <Выгружается в отчете для поставщика>
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Goods_IsUpload() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Goods_IsUpload() ;
    -- Создаем Тип загрузки признака <Выгружается в отчете для поставщика>
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка признака <Выгружается в отчете для поставщика>', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Goods_IsUpload', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Goods_IsUpload');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка признака <Выгружается в отчете для поставщика>',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Goods_IsUpload');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код товара поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inObjectId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inObjectId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inIsUpload';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inIsUpload', 
                                                                inParamType     := 'ftBoolean', 
                                                                inUserParamName := 'Признак <Выгружается в отчете для поставщика>', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := 'TRUE'::TVarChar,
                                                      inSession           := vbUserId::TVarChar);
                                                      
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Goods_IsUpload Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_IsUpload';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
       INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsPartnerCodeForm","DescName":"zc_Object_ImportSetting_Goods_IsUpload"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Goods_IsUpload()::TBlob, inSession := ''::TVarChar);
END $$;





--
--Загрузчик признака <Товар под спецусловия>
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Goods_IsSpecCondition() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Goods_IsSpecCondition() ;
    -- Создаем Тип загрузки признака <Товар под спецусловия>
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка признака <Товар под спецусловия>', 
                                                       inProcedureName := 'gpInsertUpdate_Object_Goods_IsSpecCondition', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Goods_IsSpecCondition');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка признака <Товар под спецусловия>',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Goods_IsSpecCondition');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код товара поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inObjectId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inObjectId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inIsSpecCondition';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inIsSpecCondition', 
                                                                inParamType     := 'ftBoolean', 
                                                                inUserParamName := 'Признак <Товар под спецусловия>', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := 'TRUE'::TVarChar,
                                                      inSession           := vbUserId::TVarChar);


      -- !!! Типы установок для почты
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EmailKind_OutOrder() , inDescId:= zc_Object_EmailKind(), inCode:= 1, inName:= 'Исходящая для заказов поставщикам'     , inEnumName:= 'zc_Enum_EmailKind_OutOrder');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EmailKind_InPrice()  , inDescId:= zc_Object_EmailKind(), inCode:= 2, inName:= 'Входящая для прайс-листа поставщика'   , inEnumName:= 'zc_Enum_EmailKind_InPrice');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EmailKind_IncomeMMO(), inDescId:= zc_Object_EmailKind(), inCode:= 3, inName:= 'Входящая для ММО прихода от поставщика', inEnumName:= 'zc_Enum_EmailKind_IncomeMMO');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_EmailKind_OutReport(), inDescId:= zc_Object_EmailKind(), inCode:= 4, inName:= 'Исходящая для отправки отчетов'        , inEnumName:= 'zc_Enum_EmailKind_OutReport');

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Goods_IsSpecCondition Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_IsSpecCondition';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
       INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsPartnerCodeForm","DescName":"zc_Object_ImportSetting_Goods_IsSpecCondition"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Goods_IsSpecCondition()::TBlob, inSession := ''::TVarChar);
END $$;




--Загрузчик данные по Маркетинговый контракт
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Promo() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Promo() ;
    -- Создаем Тип загрузки данных по Маркетинговому контракту
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка данных по Маркетинговому контракту', 
                                                       inProcedureName := 'gpInsertUpdate_MovementItem_Promo_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Promo');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка данных по Маркетинговому контракту',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Promo');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMovementId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inMovementId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Идентификатор переучета',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код товара',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Количество', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPrice';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inPrice', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Цена', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
                                                      
END $$;



--
-- Загрузка прайсов по 3-м контрактам - !!!копируем из "Загрузка прайсов по 2-м контрактам"!!!
DO $$
  DECLARE vbImportTypeId_from Integer;
  DECLARE vbImportTypeId Integer;
BEGIN
    -- Поиск, из кого будем копировать
    vbImportTypeId_from:= (SELECT Id FROM Object WHERE DescId = zc_Object_ImportType() AND LOWER (ValueData) = LOWER ('Загрузка прайсов по 2-м контрактам'));
    -- Поиск, если уже создали
    vbImportTypeId:= (SELECT Id FROM Object WHERE DescId = zc_Object_ImportType() AND LOWER (ValueData) = LOWER ('Загрузка прайсов по 3-м контрактам'));
    -- Создаем Тип загрузки данных по Маркетинговому контракту
    vbImportTypeId:= gpInsertUpdate_Object_ImportType (ioId            := vbImportTypeId
                                                     , inCode          := (SELECT ObjectCode FROM Object WHERE Id = vbImportTypeId)
                                                     , inName          := COALESCE ((SELECT ValueData FROM Object WHERE Id = vbImportTypeId), 'Загрузка прайсов по 3-м контрактам')
                                                     , inProcedureName := 'gpInsertUpdate_Movement_LoadPriceList_3Contract'
                                                     , inSession       := zfCalc_UserAdmin()
                                                      );
    -- !!!копируем!!! - 1 раз, т.к. Insert
    PERFORM gpInsertUpdate_Object_ImportTypeItems (ioId            := 0
                                                 , inParamNumber   := tmpFrom.ParamNumber + CASE WHEN tmpFrom.ParamNumber >=4 THEN 1 ELSE 0 END
                                                 , inName          := tmpFrom.Name
                                                 , inParamType     := tmpFrom.ParamType
                                                 , inUserParamName := tmpFrom.UserParamName
                                                 , inImportTypeId  := vbImportTypeId
                                                 , inSession       := zfCalc_UserAdmin()
                                                  )
    FROM gpSelect_Object_ImportTypeItems (inSession := zfCalc_UserAdmin()) AS tmpFrom
    WHERE tmpFrom.ImportTypeId = vbImportTypeId_from
      AND NOT EXISTS (SELECT 1 FROM gpSelect_Object_ImportTypeItems (inSession := zfCalc_UserAdmin()) AS tmpTo WHERE tmpTo.ImportTypeId = vbImportTypeId)
   ;

    -- !!!переброска!!!
    -- select * from gpInsertUpdate_Object_ImportGroupItems (ioId:= 977343, inImportSettingsId:= 977329, inImportGroupId:= 2489142, inSession:= zfCalc_UserAdmin());
                                         
END $$;




DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Inventory Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPromoForm;zc_Object_ImportSetting_Promo';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPromoForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Promo()::TBlob, inSession := ''::TVarChar);
END $$;

 
DO $$
BEGIN
     -- !!! Статус заказа
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ConfirmedKind_UnComplete(), inDescId:= zc_Object_ConfirmedKind(), inCode:= 1,  inName:= 'Не подтвержден'    , inEnumName:= 'zc_Enum_ConfirmedKind_UnComplete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ConfirmedKind_Complete(),   inDescId:= zc_Object_ConfirmedKind(), inCode:= 2,  inName:= 'Подтвержден'       , inEnumName:= 'zc_Enum_ConfirmedKind_Complete');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ConfirmedKind_SmsNo(),      inDescId:= zc_Object_ConfirmedKind(), inCode:= 21, inName:= 'Не отправлено СМС' , inEnumName:= 'zc_Enum_ConfirmedKind_SmsNo');
     PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_ConfirmedKind_SmsYes(),     inDescId:= zc_Object_ConfirmedKind(), inCode:= 22, inName:= 'Отправлено СМС'    , inEnumName:= 'zc_Enum_ConfirmedKind_SmsYes');
END $$;



--Загрузчик Данные по Соц.проекту
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_GoodsSP() ;
        
    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_GoodsSP() ;
    -- Создаем Тип загрузки НТЗ
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка данных по товарам Соц.проекта', 
                                                       inProcedureName := 'gpInsertUpdate_Object_GoodsSP_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_GoodsSP');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка данных по товарам Соц.проекта',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 3,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_GoodsSP');
   --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Наш Код товара',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'Q',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
   /* vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Назва (наша)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'R',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);    
*/

vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPriceSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inPriceSP', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Розмір відшкодування за упаковку(15)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'O',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

  /*  vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGroupSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inGroupSP', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Групи відшкодування – І або ІІ', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
*/
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCountSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inCountSP', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Кількість одиниць лікарського засобу(6)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inColSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inColSP', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := '№ п.п.(1)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPriceOptSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inPriceOptSP', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Оптово-відпускна ціна за упаковку(11)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'K',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPriceRetSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inPriceRetSP', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Роздрібна ціна за упаковку (12)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'L',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inDailyNormSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inDailyNormSP', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Добова доза лікарського засобу, рекомендована ВООЗ(13)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'M',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inDailyCompensationSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 8, 
                                                                inName          := 'inDailyCompensationSP', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Розмір відшкодування добової дози лікарського засобу, грн(14)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'N',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPaymentSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 9, 
                                                                inName          := 'inPaymentSP', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Сума доплати за упаковку, грн(16)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'P',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inDateReestrSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 10, 
                                                                inName          := 'inDateReestrSP', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Дата закінчення строку дії реєстраційного посвідчення на лікарський засіб(10)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'J',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPack';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 11, 
                                                                inName          := 'inPack', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Сила дії (дозування)(5)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inIntenalSPName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 12, 
                                                                inName          := 'inIntenalSPName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Міжнародна непатентована назва(2)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBrandSPName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 13, 
                                                                inName          := 'inBrandSPName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Торг. назва лікарського засобу(3)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inKindOutSPName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 14, 
                                                                inName          := 'inKindOutSPName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Форма випуску(4)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);


--
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCodeATX';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 15, 
                                                                inName          := 'inCodeATX', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код АТХ(7)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMakerSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 16, 
                                                                inName          := 'inMakerSP', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Найменування виробника, країна(8)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'H',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inReestrSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 17, 
                                                                inName          := 'inReestrSP', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Номер реєстраційного посвідчення на лікарський засіб(9)', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'I',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inInsertDateSP';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 18, 
                                                                inName          := 'inInsertDateSP', 
                                                                inParamType     := 'ftDateTime', 
                                                                inUserParamName := 'Дата загрузки', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'R',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);


  
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_GoodsSP Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsSPForm;zc_Object_ImportSetting_GoodsSP';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsSPForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
    
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_GoodsSP()::TBlob, inSession := ''::TVarChar);
END $$;

--Загрузчик признака <Условия хранения>
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_Goods_ConditionsKeep() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_Goods_ConditionsKeep() ;
    -- Создаем Тип загрузки признака <Товар под спецусловия>
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка признака <Условия хранения>', 
                                                       inProcedureName := 'gpUpdate_Goods_ConditionsKeep', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_Goods_ConditionsKeep');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка признака <Условия хранения>',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 5,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_Goods_ConditionsKeep');

    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inObjectId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inObjectId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код товара поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
 
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inisUpdate';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inisUpdate', 
                                                                inParamType     := 'ftBoolean', 
                                                                inUserParamName := 'Записывать да/нет',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := 'False'::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inConditionsKeepName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inConditionsKeepName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Признак <Условия хранения>', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'N',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := ''::TVarChar,
                                                      inSession           := vbUserId::TVarChar);
                                                      

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_Goods_ConditionsKeep Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_ConditionsKeep';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN
       INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsPartnerCodeForm","DescName":"zc_Object_ImportSetting_Goods_ConditionsKeep"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_Goods_ConditionsKeep()::TBlob, inSession := ''::TVarChar);
END $$;




--Загрузчик данные по Маркетинговый контракт для подразделений
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_PromoUnit() ;

    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_PromoUnit() ;
    -- Создаем Тип загрузки данных по Маркетинговому контракту
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка данных по Маркетинговому контракту по подразделению', 
                                                       inProcedureName := 'gpInsertUpdate_MovementItem_PromoUnit_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_PromoUnit');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка данных по Маркетинговому контракту по подразделению',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_PromoUnit');
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMovementId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inMovementId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Идентификатор документа',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUnitId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inUnitId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Идентификатор подразделения',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код товара',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmount';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inAmount', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Количество', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inAmountPlanMax';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inAmountPlanMax', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'Количество для премии', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
                                                      
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_PromoUnit Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TPromoUnitForm;zc_Object_ImportSetting_PromoUnit';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPromoUnitForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
        
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_PromoUnit()::TBlob, inSession := ''::TVarChar);
END $$;




--Загрузчик ФИО врача по Соц.проекту
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_MedicSP() ;
        
    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_MedicSP() ;
    -- Создаем Тип загрузки
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка данных ФИО врача (Соц.проект)', 
                                                       inProcedureName := 'gpInsertUpdate_Object_MedicSP_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_MedicSP');
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка данных ФИО врача (Соц.проект)',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_MedicSP');
   --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMedicSPName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inMedicSPName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'ФИО врача',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inPartnerMedicalName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inPartnerMedicalName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Медицинское учреждение', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_MedicSP Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TMedicSPForm;zc_Object_ImportSetting_MedicSP';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TMedicSPForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
    
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_MedicSP()::TBlob, inSession := ''::TVarChar);
END $$;

--Загрузчик Данные по штрих-кодам
DO $$
  DECLARE vbImportTypeId Integer;
  DECLARE vbImportTypeCode Integer;
  DECLARE vbImportTypeItemId Integer;
  DECLARE vbImportSettingId Integer;
  DECLARE vbImportSettingCode Integer;
  DECLARE vbImportSettingsItem Integer;
  DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';

    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_BarCode();
    SELECT Id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_BarCode();

    -- Создаем Тип загрузки
    vbImportTypeId:= gpInsertUpdate_Object_ImportType (ioId            := COALESCE(vbImportTypeId, 0), 
                                                       inCode          := COALESCE(vbImportTypeCode, 0), 
                                                       inName          := 'Загрузка данных по штрих-кодам', 
                                                       inProcedureName := 'gpInsertUpdate_Object_GoodsBarCode_Load',
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_BarCode');

    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка данных по штрих-кодам',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_BarCode');

   --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Наш Код товара',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название товара', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inProducerName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inProducerName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Производитель', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);
  
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код товара поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'E',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBarCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inBarCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Штрих-код',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'F',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inJuridicalName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inJuridicalName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Поставщик',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'G',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_GoodsSP Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsBarCodeForm;zc_Object_ImportSetting_BarCode';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsBarCodeForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
    
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_BarCode()::TBlob, inSession := ''::TVarChar);
END $$;

---Загрузчик Данные по штрих-кодам из прайс-листа
DO $$
  DECLARE vbImportTypeId Integer;
  DECLARE vbImportTypeCode Integer;
  DECLARE vbImportTypeItemId Integer;
  DECLARE vbImportSettingId Integer;
  DECLARE vbImportSettingCode Integer;
  DECLARE vbImportSettingsItem Integer;
  DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';

    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_BarCode_Price();
    SELECT Id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_BarCode_Price();

    -- Создаем Тип загрузки
    vbImportTypeId:= gpInsertUpdate_Object_ImportType (ioId            := COALESCE(vbImportTypeId, 0), 
                                                       inCode          := COALESCE(vbImportTypeCode, 0), 
                                                       inName          := 'Загрузка данных по штрих-кодам из прайс-листа', 
                                                       inProcedureName := 'gpInsertUpdate_Object_GoodsBarCode_Load_Price',
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_BarCode_Price');

    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка данных по штрих-кодам из прайс-листа',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 5,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_BarCode_Price');

   --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inJuridicalId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inJuridicalId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Поставщик',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);
                                                         
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inCommonCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inCommonCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Общий Код товара',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Название товара', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'C',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inProducerName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 4, 
                                                                inName          := 'inProducerName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Производитель', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'D',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);
  
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 5, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Код товара поставщика',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);

    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inBarCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 6, 
                                                                inName          := 'inBarCode', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Штрих-код',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'M',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);
                                                      
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inJuridicalName';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId, 0), 
                                                                inParamNumber   := 7, 
                                                                inName          := 'inJuridicalName', 
                                                                inParamType     := 'ftString', 
                                                                inUserParamName := 'Юр.лицо',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarChar,
                                                      inSession           := vbUserId::TVarChar);                                                      

END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_BarCode_Price Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TGoodsBarCodeForm;zc_Object_ImportSetting_BarCode_Price';

    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TGoodsBarCodeForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
    
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_BarCode_Price()::TBlob, inSession := ''::TVarChar);
END $$;


--Загрузчик НТЗ в zc_Object_DataExcel
DO $$
DECLARE vbImportTypeId Integer;
DECLARE vbImportTypeCode Integer;
DECLARE vbImportTypeItemId Integer;
DECLARE vbImportSettingId Integer;
DECLARE vbImportSettingCode Integer;
DECLARE vbImportSettingsItem Integer;
DECLARE vbUserId Integer;
BEGIN
    SELECT Id INTO vbUserId FROM Object WHERE DescId = zc_Object_User() AND ValueData = 'Админ';
    SELECT Id, ObjectCode INTO vbImportSettingId, vbImportSettingCode FROM Object WHERE DescId = zc_Object_ImportSettings() AND Id = zc_Enum_ImportSetting_MCSExcel() ;
        
    SELECT id, ObjectCode INTO vbImportTypeId, vbImportTypeCode FROM Object WHERE DescId = zc_Object_ImportType() AND Id = zc_Enum_ImportType_MCSExcel() ;
    -- Создаем Тип загрузки НТЗ
    vbImportTypeId := gpInsertUpdate_Object_ImportType(ioId            := COALESCE(vbImportTypeId,0), 
                                                       inCode          := COALESCE(vbImportTypeCode,0), 
                                                       inName          := 'Загрузка неснижаемого товарного запаса', 
                                                       inProcedureName := 'gpInsertUpdate_Object_DataExcel_MCS_From_Excel', 
                                                       inSession       := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportTypeId, 'zc_Enum_ImportType_MCSExcel);
    --Создаём настройку загрузки
    vbImportSettingId := gpInsertUpdate_Object_ImportSettings(ioId           := COALESCE(vbImportSettingId,0),
                                                              inCode         := COALESCE(vbImportSettingCode,0),
                                                              inName         := 'Загрузка неснижаемого товарного запаса (Ассортимент сети)',
                                                              inJuridicalId  := NULL::Integer,
                                                              inContractId   := NULL::Integer,
                                                              inFileTypeId   := zc_Enum_FileTypeKind_Excel(),
                                                              inImportTypeId := vbImportTypeId,
                                                              inEmailId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_Email()),
                                                              inContactPersonId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectLink_ImportSettings_ContactPerson()),
                                                              inStartRow     := 2,
                                                              inHDR          := False,
                                                              inDirectory    := NULL::TVarChar,
                                                              inQuery        := NULL::TVarChar,
                                                              inStartTime    := NULL::TVarChar,
                                                              inEndTime      := NULL::TVarChar,
                                                              inTime         := 0,
                                                              inIsMultiLoad  := (SELECT ValueData FROM ObjectBoolean WHERE ObjectId = vbImportSettingId AND DescId = zc_ObjectBoolean_ImportSettings_MultiLoad()),
                                                              inSession      := vbUserId::TVarChar);
    --Создали Enum
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), vbImportSettingId, 'zc_Enum_ImportSetting_MCSExcel');
    
    --Добавляем Итемы
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inUnitId';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 1, 
                                                                inName          := 'inUnitId', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Идентификатор подразделения',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := '%EXTERNALPARAM%',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
                                                      
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inGoodsCode';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 2, 
                                                                inName          := 'inGoodsCode', 
                                                                inParamType     := 'ftInteger', 
                                                                inUserParamName := 'Код товара',
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'A',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
    
    vbImportTypeItemId := 0;
    Select id INTO vbImportTypeItemId FROM Object_ImportTypeItems_View WHERE ImportTypeId = vbImportTypeId AND Name = 'inMCSValue';
    vbImportTypeItemId := gpInsertUpdate_Object_ImportTypeItems(ioId            := COALESCE(vbImportTypeItemId,0), 
                                                                inParamNumber   := 3, 
                                                                inName          := 'inMCSValue', 
                                                                inParamType     := 'ftFloat', 
                                                                inUserParamName := 'НТЗ', 
                                                                inImportTypeId  := vbImportTypeId, 
                                                                inSession       := vbUserId::TVarChar);
    vbImportSettingsItem := 0;
    Select id INTO vbImportSettingsItem FROM Object_ImportSettingsItems_View WHERE ImportSettingsId = vbImportSettingId AND ImportTypeItemsId = vbImportTypeItemId;
    PERFORM gpInsertUpdate_Object_ImportSettingsItems(ioId                := vbImportSettingsItem,
                                                      inName              := 'B',
                                                      inImportSettingsId  := vbImportSettingId,
                                                      inImportTypeItemsId := vbImportTypeItemId,
                                                      inDefaultValue      := NULL::TVarCHar,
                                                      inSession           := vbUserId::TVarChar);
END $$;

DO $$
    DECLARE vbKey TVarChar;
    DECLARE vbDefaultKeyId Integer;
    DECLARE vbImportSetting_MCS Integer;
    DECLARE vbId Integer;
BEGIN
    vbKey := 'TReport_Check_AssortmentForm;zc_Object_ImportSetting_MCSExcel';
              TReport_Check_AssortmentForm;zc_Object_ImportSetting_MCSExcel
    -- Добавляем ключ дефолта
    SELECT Id INTO vbDefaultKeyId FROM DefaultKeys WHERE Key = vbKey; 

    IF COALESCE(vbDefaultKeyId, 0) = 0 THEN 
        INSERT INTO DefaultKeys(Key, KeyData) VALUES(vbKey, '{"FormClassName":"TPriceForm","DescName":"zc_Object_ImportSettings"}') RETURNING Id INTO vbDefaultKeyId;
    END IF;
    
    SELECT ID INTO vbId
    FROM DefaultValue 
    WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId is NULL;
    
    PERFORM gpInsertUpdate_DefaultValue(ioId := COALESCE(vbId,0), inDefaultKeyId := vbDefaultKeyId, inUserKey := 0, inDefaultValue := zc_Enum_ImportSetting_MCSExcel()::TBlob, inSession := ''::TVarChar);
END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.    Воробкало А.А.  Ярошенко Р.Ф.
 30.10.17         * Загрузчик НТЗ в zc_Object_DataExcel
 07.07.17         * Загрузка данных по штрих-кодам
 05.06.17                                                                                     * Загрузка данных по штрих-кодам
 23.05.17         * Виды соц.проектов
 06.05.17         * Загрузка ФИО врача по Соц.проекту
 04.02.17         * Загрузка данных по Маркетинговому контракту по подразделению
 07.01.17         * Загрузка Признака <Условия хранения>
 21.12.16         * соц.проект
 25.04.16         * 
 18.02.16         * Загрузчик признака <Товар под спецусловия>
 15.08.15                                                                       *Загрузчик минимального округления
 28.07.15                                                                       *Загрузчики НТЗ / Цен / переучета
 23.07.14                         * Скопировано для аптек
*/
