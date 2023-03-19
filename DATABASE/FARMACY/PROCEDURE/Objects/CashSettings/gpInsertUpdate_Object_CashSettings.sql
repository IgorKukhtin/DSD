-- Function: gpInsertUpdate_Object_CashSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashSettings(TVarChar, TVarChar, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Boolean, Boolean, 
                                                           TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, TFloat, Integer, Boolean, 
                                                           Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TFloat, TFloat, Boolean, TFloat, Integer, 
                                                           Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer, Integer, TFloat, TFloat, Boolean, 
                                                           TFloat, TFloat, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, 
                                                           Boolean, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashSettings(
    IN inShareFromPriceName         TVarChar  ,     -- Перечень фраз в названиях товаров которые можно делить с любой ценой
    IN inShareFromPriceCode         TVarChar  ,     -- Перечень кодов товаров которые можно делить с любой ценой
    IN inisGetHardwareData          Boolean   ,     -- Получить данные аппаратной части
    IN inDateBanSUN                 TDateTime ,     -- Запрет работы по СУН
    IN inSummaFormSendVIP           TFloat    ,     -- Сумма от которой показан товар при формировании перемещений VIP
    IN inSummaUrgentlySendVIP       TFloat    ,     -- Сумма перемещения от которой разрешен признак срочно
    IN inDaySaleForSUN              Integer   ,     -- Количество дней для контроля <Продано/Продажа до след СУН>
    IN inDayNonCommoditySUN         Integer   ,     -- Количество дней для контроля Комментария "Нетоварный вид"
    IN inisBlockVIP                 Boolean   ,     -- Блокировать формирование перемещений VIP
    IN inisPairedOnlyPromo          Boolean   ,     -- При опускании парных контролировать только акционный
    IN inAttemptsSub                TFloat    ,     -- Количество попыток до успешной сдачи теста для предложения подмен
    IN inUpperLimitPromoBonus       TFloat    ,     -- Верхний предел сравнения (маркет бонусы)
    IN inLowerLimitPromoBonus       TFloat    ,     -- Нижний предел сравнения (маркет бонусы)
    IN inMinPercentPromoBonus       TFloat    ,     -- Минимальная наценка (маркет бонусы)
    IN inDayCompensDiscount         Integer   ,     -- Дней до компенсации по дисконтным проектам
    IN inMethodsAssortmentGuidesId  Integer   ,     -- Методы выбора аптек ассортимента
    IN inAssortmentGeograph         Integer   ,     -- Аптек аналитиков по географии
    IN inAssortmentSales            Integer   ,     -- Аптек аналитиков по продажам
    IN inCustomerThreshold          TFloat    ,     -- Порог срабатывание при заказе под клиента
    IN inPriceCorrectionDay         Integer   ,     -- Период дней для системы коррекции цены по итогам роста/падения средних продаж
    IN inisRequireUkrName           Boolean   ,     -- Требовать заполнение Украинского названия
    IN inisRemovingPrograms	        Boolean   ,     -- Удаление сторонних программ
    IN inPriceSamples               TFloat    ,     -- Порог цены Сэмплов от
    IN inSamples21                  TFloat    ,     -- Скидка сэмплов кат 2.1 (от 90-200 дней)
    IN inSamples22                  TFloat    ,     -- Скидка сэмплов кат 2.2 (от 50-90 дней)
    IN inSamples3                   TFloat    ,     -- Скидка сэмплов кат 3 (от 0 до 50 дней)
    IN inTelegramBotToken           TVarChar  ,     -- Токен телеграм бота
    IN inPercentIC                  TFloat    ,     -- Процент от продажи страховым компаниям для з/п фармацевтам
    IN inPercentUntilNextSUN        TFloat    ,     -- Процент для подсветки комента "Продано/Продажа до след СУН"
    IN inisEliminateColdSUN         Boolean   ,     -- Исключать Холод из СУН
    IN inTurnoverMoreSUN2           TFloat    ,     -- Оборот больше за прошлый месяц для распределения СУН 2
    IN inDeySupplOutSUN2            Integer   ,     -- Продажи дней для аптек откуда дополнения СУН 2
    IN inDeySupplInSUN2             Integer   ,     -- Продажи дней для аптек куда дополнения СУН 2
    IN inExpressVIPConfirm          Integer   ,     -- Чеков для экспресс подтверждение ВИП
    IN inPriceFormSendVIP           TFloat    ,     -- Цена от которой показан товар при формировании перемещений VIP
    IN inMinPriceSale               TFloat    ,     -- Минимальная цена товара при отпуске
    IN inDeviationsPrice1303        TFloat    ,     -- Процент отклонение от отпускной цены при отпуске по 1303
    IN inisWagesCheckTesting        Boolean   ,     -- Контроль сдачи экзамен при выдача зарплаты
    IN inNormNewMobileOrders        Integer   ,     -- Норма по новым заказам мобильного приложения
    IN inUserUpdateMarketingId      Integer   ,     -- Сотрудник для редактирование в ЗП суммы Маркетинга
    IN inLimitCash                  TFloat    ,     -- Ограничение при покупки наличными
    IN inAddMarkupTabletki          TFloat    ,     -- Доп наценка на Таблетки на поз по выставленным наценкам
    IN inisShoresSUN                Boolean   ,     -- Берега отдельно по СУН
    IN inFixedPercent               TFloat    ,     -- Фиксированный процент выполнения плана
    IN inMobMessSum                 TFloat    ,     -- Сообщение по созданию заказа по приложению от суммы чека
    IN inMobMessCount               Integer   ,     -- 	Сообщение по созданию заказа по приложению после чека

    IN inisEliminateColdSUN2        Boolean   ,     -- Исключать Холод из СУН 2
    IN inisEliminateColdSUN3        Boolean   ,     -- Исключать Холод из Э-СУН
    IN inisEliminateColdSUN4        Boolean   ,     -- Исключать Холод из СУН ПИ
    IN inisEliminateColdSUA         Boolean   ,     -- Исключать Холод из СУA

    IN inisOnlyColdSUN              Boolean   ,     -- Только по Холоду СУН 1
    IN inisOnlyColdSUN2             Boolean   ,     -- Только по Холоду СУН 3
    IN inisOnlyColdSUN3             Boolean   ,     -- Только по Холоду Э-СУН
    IN inisOnlyColdSUN4             Boolean   ,     -- Только по Холоду СУН ПИ
    IN inisOnlyColdSUA              Boolean   ,     -- Только по Холоду СУA
    IN inSendCashErrorTelId         TVarChar  ,     -- ID в телеграм для отправки ошибок на кассах
    IN inisCancelBansSUN            Boolean   ,     -- Отмена запретов по всем СУН

    IN inSession                    TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbID Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Driver());
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Разрешено только системному администратору';
   END IF;

   -- пытаемся найти код
   vbID := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CashSettings());

   -- сохранили <Объект>
   vbID := lpInsertUpdate_Object (vbID, zc_Object_CashSettings(), 1, 'Общие настройки касс');
   
   -- сохранили Перечень фраз в названиях товаров которые можно делить с любой ценой
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_ShareFromPriceName(), vbID, inShareFromPriceName);
   
   -- сохранили Перечень кодов товаров которые можно делить с любой ценой
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_ShareFromPriceCode(), vbID, inShareFromPriceCode);

   -- сохранили Получить данные аппаратной части
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_GetHardwareData(), vbID, inisGetHardwareData);
   -- сохранили Запрет работы по СУН
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashSettings_DateBanSUN(), vbID, inDateBanSUN);

   -- сохранили Сумма от которой показан товар при формировании перемещений VIP
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_SummaFormSendVIP(), vbID, inSummaFormSendVIP);
      -- сохранили Сумма перемещения от которой разрешен признак срочно
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP(), vbID, inSummaUrgentlySendVIP);
      -- сохранили Количество дней для контроля <Продано/Продажа до след СУН>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DaySaleForSUN(), vbID, inDaySaleForSUN);
      -- сохранили Количество дней для контроля Комментария "Нетоварный вид"
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DayNonCommoditySUN(), vbID, inDayNonCommoditySUN);
      -- сохранили Количество попыток до успешной сдачи теста для предложения подмен
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AttemptsSub(), vbID, inAttemptsSub);
      -- сохранили Верхний предел сравнения (маркет бонусы)
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_UpperLimitPromoBonus(), vbID, inUpperLimitPromoBonus);
      -- сохранили Нижний предел сравнения (маркет бонусы)
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_LowerLimitPromoBonus(), vbID, inLowerLimitPromoBonus);
      -- сохранили Минимальная наценка (маркет бонусы)
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_MinPercentPromoBonus(), vbID, inMinPercentPromoBonus);
      -- сохранили Дней до компенсации по дисконтным проектам
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DayCompensDiscount(), vbID, inDayCompensDiscount);
      -- сохранили Порог срабатывание при заказе под клиента
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_CustomerThreshold(), vbID, inCustomerThreshold);
      -- сохранили Период дней для системы коррекции цены по итогам роста/падения средних продаж
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_PriceCorrectionDay(), vbID, inPriceCorrectionDay);

      -- сохранили Аптек аналитиков по географии
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AssortmentGeograph(), vbID, inAssortmentGeograph);
      -- сохранили Дней до компенсации по дисконтным проектам
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AssortmentSales(), vbID, inAssortmentSales);

   -- сохранили Блокировать формирование перемещений VIP
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_BlockVIP(), vbID, inisBlockVIP);
   -- сохранили Аптек аналитиков по продажам
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_PairedOnlyPromo(), vbID, inisPairedOnlyPromo);

   -- сохранили Требовать заполнение Украинского названия
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_RequireUkrName(), vbID, inisRequireUkrName);
   -- сохранили Удаление сторонних программ
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_RemovingPrograms(), vbID, inisRemovingPrograms);

   -- сохранили Исключать Холод из СУН 1
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_EliminateColdSUN(), vbID, inisEliminateColdSUN);
   -- сохранили Исключать Холод из СУН 2
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_EliminateColdSUN2(), vbID, inisEliminateColdSUN2);
   -- сохранили Исключать Холод из СУН 3
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_EliminateColdSUN3(), vbID, inisEliminateColdSUN3);
   -- сохранили Исключать Холод из СУН 4
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_EliminateColdSUN4(), vbID, inisEliminateColdSUN4);
   -- сохранили Исключать Холод из СУA
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_EliminateColdSUA(), vbID, inisEliminateColdSUA);

   -- сохранили Порог цены Сэмплов от
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_CashSettings_PriceSamples(), vbID, inPriceSamples);
   -- сохранили Скидка сэмплов кат 2.1 (от 90-200 дней)
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_CashSettings_Samples21(), vbID, inSamples21);
   -- сохранили Скидка сэмплов кат 2.2 (от 50-90 дней)
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_CashSettings_Samples22(), vbID, inSamples22);
   -- сохранили Скидка сэмплов кат 3 (от 0 до 50 дней)
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_CashSettings_Samples3(), vbID, inSamples3);

      -- сохранили Дней до компенсации по дисконтным проектам
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AssortmentSales(), vbID, inAssortmentSales);

   -- сохранили Токен телеграм бота
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_TelegramBotToken(), vbID, inTelegramBotToken);
   -- ID в телеграм для отправки ошибок на кассах
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_SendCashErrorTelId(), vbID, inSendCashErrorTelId);

      -- сохранили Процент от продажи страховым компаниям для з/п фармацевтам
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_PercentIC(), vbID, inPercentIC);

      -- сохранили Процент для подсветки комента "Продано/Продажа до след СУН"
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_PercentUntilNextSUN(), vbID, inPercentUntilNextSUN);

      -- сохранили 	Оборот больше за прошлый месяц для распределения СУН 2
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_TurnoverMoreSUN2(), vbID, inTurnoverMoreSUN2);

      -- сохранили 	Продажи дней для аптек откуда дополнения СУН 2
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DeySupplOutSUN2(), vbID, inDeySupplOutSUN2);
      -- сохранили 	Продажи дней для аптек куда дополнения СУН 2
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DeySupplInSUN2(), vbID, inDeySupplInSUN2);
   
      -- сохранили Чеков для экспресс подтверждение ВИП
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_ExpressVIPConfirm(), vbID, inExpressVIPConfirm);

      -- сохранили Цена от которой показан товар при формировании перемещений VIP
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_PriceFormSendVIP(), vbID, inPriceFormSendVIP);
   
     -- Минимальная цена товара при отпуске
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_MinPriceSale(), vbID, inMinPriceSale);
   
     -- Процент отклонение от отпускной цены при отпуске по 1303
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DeviationsPrice1303(), vbID, inDeviationsPrice1303);
   
     -- Норма по новым заказам мобильного приложения
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_NormNewMobileOrders(), vbID, inNormNewMobileOrders);

     -- Ограничение при покупки наличными
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_LimitCash(), vbID, inLimitCash);
   
    -- Доп наценка на Таблетки на поз по выставленным наценкам
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AddMarkupTabletki(), vbID, inAddMarkupTabletki);
   
    -- Фиксированный процент выполнения плана
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_FixedPercent(), vbID, inFixedPercent);
   
    -- Сообщение по созданию заказа по приложению от суммы чека
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_MobMessSum(), vbID, inMobMessSum);
    -- 	Сообщение по созданию заказа по приложению после чека
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_MobMessCount(), vbID, inMobMessCount);
   

   -- Контроль сдачи экзамен при выдача зарплаты
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_WagesCheckTesting(), vbID, inisWagesCheckTesting);

   -- Методы выбора аптек ассортимента
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CashSettings_MethodsAssortment(), vbID, inMethodsAssortmentGuidesId);

   -- Сотрудник для редактирование в ЗП суммы Маркетинга
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CashSettings_UserUpdateMarketing(), vbID, inUserUpdateMarketingId);
   
   -- Берега отдельно по СУН
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_ShoresSUN(), vbID, inisShoresSUN);

   -- Только по Холоду СУН
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_OnlyColdSUN(), vbID, inisOnlyColdSUN);
   -- Только по Холоду СУН2
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_OnlyColdSUN2(), vbID, inisOnlyColdSUN2);
   -- Только по Холоду СУН3
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_OnlyColdSUN3(), vbID, inisOnlyColdSUN3);
   -- Только по Холоду СУН4
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_OnlyColdSUN4(), vbID, inisOnlyColdSUN4);
   -- Только по Холоду СУA
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_OnlyColdSUA(), vbID, inisOnlyColdSUA);
   -- Отмена запретов по всем СУН
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_CancelBansSUN(), vbID, inisCancelBansSUN);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (vbID, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.11.19                                                       *
*/