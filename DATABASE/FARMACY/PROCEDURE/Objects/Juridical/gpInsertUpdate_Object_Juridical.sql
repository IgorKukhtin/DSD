-- Function: gpInsertUpdate_Object_Juridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, TFloat, TFloat, Boolean, Boolean, 
  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Подразделение>
    IN inCode                    Integer   ,    -- Код объекта <Подразделение>
    IN inName                    TVarChar  ,    -- Название объекта <Подразделение>
    IN inisCorporate             Boolean   ,    -- Признак наша ли собственность это юридическое лицо 
    IN inRetailId                Integer   ,    -- ссылка на подразделение
    IN inPercent                 TFloat    ,    
    IN inPayOrder                TFloat    ,    -- Очередь платежа
    IN inisLoadBarcode           Boolean   ,    -- импорт штрих-кодов
    IN inisDeferred              Boolean   ,    -- Исключение - заказ всегда "Отложен"
    IN inCBName                  TVarChar  ,    -- Полное название поставщика для клиент банка
    IN inCBMFO                   TVarChar  ,    -- МФО для клиент банка
    IN inCBAccount               TVarChar  ,    -- Расчетный счет для клиент банка
    IN inCBAccountOld            TVarChar  ,    -- Расчетный счет стврый для клиент банка
    IN inCBPurposePayment        TVarChar  ,    -- Назначение платежа для клиент банка
    IN inCodeRazom               Integer   ,    -- Код в системе "РАЗОМ"
    IN inCodeMedicard            Integer   ,    -- Код в системе "Medicard"
    IN inCodeOrangeCard          Integer   ,    -- Код в системе "Оранж Кард"
    IN inisUseReprice            boolean   ,    -- Участвуют в автопереоценке
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());
   vbUserId:= inSession;

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Juridical());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Juridical(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Juridical(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Juridical(), vbCode_calc, inName);

   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), ioId, inRetailId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isCorporate(), ioId, inisCorporate);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_Percent(), ioId, inPercent);
   
   -- сохранили свойство <Очередь платежа>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_PayOrder(), ioId, inPayOrder);

   -- сохранили свойство <Код в системе "РАЗОМ">
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_CodeRazom(), ioId, inCodeRazom);
   -- сохранили свойство <Код в системе "Medicard">
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_CodeMedicard(), ioId, inCodeMedicard);
   -- сохранили свойство <Код в системе "Оранж Кард">
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_CodeOrangeCard(), ioId, inCodeOrangeCard);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_LoadBarcode(), ioId, inisLoadBarcode);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_Deferred(), ioId, inisDeferred);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_UseReprice(), ioId, inisUseReprice);

   -- сохранили свойство <Полное название поставщика для клиент банка>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_CBName(), ioId, inCBName);
   -- сохранили свойство <МФО для клиент банка>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_CBMFO(), ioId, inCBMFO);
   -- сохранили свойство <Расчетный счет для клиент банка>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_CBAccount(), ioId, inCBAccount);
   -- сохранили свойство <Расчетный счет старый для клиент банка>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_CBAccountOld(), ioId, inCBAccountOld);
   -- сохранили свойство <Назначение платежа для клиент банка>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_CBPurposePayment(), ioId, inCBPurposePayment);

   -- сохранили протокол
   --PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.  Ярошенко Р.Ф.  Шаблий О.В.
 10.06.20                                                                                      * 
 06.09.19                                                                                      * 
 22.02.18         * dell inOrderSumm, inOrderSummComment, inOrderTime
 17.08.17         *              
 27.06.17                                                                        *
 14.01.17         *
 02.12.15                                                         * PayOrder
 10.04.15                        * 
 01.07.14         * 

*/

-- тест
--