-- Function: gpInsertUpdate_Object_CashSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashSettings(TVarChar, TVarChar, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Boolean, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashSettings(
    IN inShareFromPriceName      TVarChar  ,     -- Перечень фраз в названиях товаров которые можно делить с любой ценой
    IN inShareFromPriceCode      TVarChar  ,     -- Перечень кодов товаров которые можно делить с любой ценой
    IN inisGetHardwareData       Boolean   ,     -- Получить данные аппаратной части
    IN inDateBanSUN              TDateTime ,     -- Запрет работы по СУН
    IN inSummaFormSendVIP        TFloat    ,     -- Сумма от которой показан товар при формировании перемещений VIP
    IN inSummaUrgentlySendVIP    TFloat    ,     -- Сумма перемещения от которой разрешен признак срочно
    IN inDaySaleForSUN           Integer   ,     -- Количество дней для контроля <Продано/Продажа до след СУН>
    IN inDayNonCommoditySUN      Integer   ,     -- Количество дней для контроля Комментария "Нетоварный вид"
    IN inisBlockVIP              Boolean   ,     -- Блокировать формирование перемещений VIP
    IN inisPairedOnlyPromo       Boolean   ,     -- При опускании парных контролировать только акционный
    IN inAttemptsSub             TFloat    ,     -- Количество попыток до успешной сдачи теста для предложения подмен
    IN inSession                 TVarChar        -- сессия пользователя
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

   -- сохранили Блокировать формирование перемещений VIP
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_BlockVIP(), vbID, inisBlockVIP);
   -- сохранили При опускании парных контролировать только акционный
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_PairedOnlyPromo(), vbID, inisPairedOnlyPromo);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (vbID, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.11.19                                                       *
*/