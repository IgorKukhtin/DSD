-- Function: gpInsertUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, TVarChar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Tvarchar);
     
CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Договор>
    IN inCode                    Integer   ,    -- Код объекта <>
    IN inName                    TVarChar  ,    -- Название объекта <>
    IN inJuridicalBasisId        Integer   ,    -- ссылка на главное юр.лицо
    IN inJuridicalId             Integer   ,    -- ссылка на  юр.лицо
    IN inGroupMemberSPId         Integer   ,    -- ссылка на Категория пациента(Соц. проект)
    IN inBankAccountId           Integer   ,    -- ссылка на р/счет
    IN inMemberId                Integer   ,    -- ссылка на отв. по прайсу
    IN inDeferment               Integer   ,    -- Дней отсрочки
    IN inPercent                 TFloat    ,    -- % Корректировки наценки
    IN inPercentSP               TFloat    ,    -- % cкидки Соц.проект
    IN inTotalSumm               TFloat    ,    -- сумма осн. договора
    IN inOrderSumm               TFloat    ,    -- минимальная сумма для заказа
    IN inOrderSummComment        TVarChar  ,    -- Примечание к минимальной сумме для заказа
    IN inOrderTime               TVarChar  ,    -- информативно - максимальное время отправки
    IN inComment                 TVarChar  ,    -- примечание
    IN inSigningDate             TDateTime,     -- Дата подписания договора
    IN inStartDate               TDateTime,     -- Дата с которой действует договор
    IN inEndDate                 TDateTime,     -- Дата до которой действует договор    
    IN inisPartialPay            Boolean  ,     -- Оплата частями
    IN inisDefermentContract     Boolean  ,     -- Использовать в приходе отсрочку из договора
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   vbUserId:= inSession;

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Contract());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- проверка уникальности <Наименование>
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Contract(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Contract(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Contract(), vbCode_calc, inName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_JuridicalBasis(), ioId, inJuridicalBasisId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_GroupMemberSP(), ioId, inGroupMemberSPId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_BankAccount(), ioId, inBankAccountId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_Member(), ioId, inMemberId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_Deferment(), ioId, inDeferment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_Percent(), ioId, inPercent);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_PercentSP(), ioId, inPercentSP);
   -- сохранили свойство <минимальная сумма для заказа>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_OrderSumm(), ioId, inOrderSumm);
   -- сохранили свойство <сумма осн. договора>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_TotalSumm(), ioId, inTotalSumm);
   
   -- если номер договора пусто то дату подписания не записываем
   IF COALESCE (inName, '') <> '' 
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Signing(), ioId, inSigningDate);
   ELSE 
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Signing(), ioId, NULL);   
   END IF;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Start(), ioId, inStartDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_End(), ioId, inEndDate);
   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_Comment(), ioId, inComment);
   -- сохранили свойство <информативно - максимальное время отправки>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_OrderTime(), ioId, inOrderTime);
      -- сохранили свойство <Примечание к минимальной сумме для заказа>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_OrderSumm(), ioId, inOrderSummComment);
      -- сохранили свойство <Оплата частями>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_PartialPay(), ioId, inisPartialPay);
      -- сохранили свойство <Использовать в приходе отсрочку из договора>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_DefermentContract(), ioId, inisDefermentContract);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.01.19         *
 24.09.18         * add inMemberId
 20.08.18         * inTotalSumm
 14.02.18         *
 08.08.17         *
 03.05.17         * add BankAccountId
 16.03.17         * inPercentSP
 05.03.17         * inGroupMemberSPId
 08.12.16         * inPercent
 21.01.16         *
 21.09.14                         * 
 01.07.14         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Contract ()                            
