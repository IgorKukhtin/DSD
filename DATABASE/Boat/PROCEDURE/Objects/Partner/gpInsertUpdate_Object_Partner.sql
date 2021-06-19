-- Торговая марка

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, Integer, TVarChar);
                                                     

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId              Integer,       -- ключ объекта <>
 INOUT ioCode            Integer,       -- свойство <Код >
    IN inName            TVarChar,      -- главное Название
    IN inComment         TVarChar,      --
    IN inFax             TVarChar,
    IN inPhone           TVarChar,
    IN inMobile          TVarChar,
    IN inIBAN            TVarChar,
    IN inStreet          TVarChar,
    IN inMember          TVarChar,
    IN inWWW             TVarChar,
    IN inEmail           TVarChar,
    IN inCodeDB          TVarChar,
    IN inTaxNumber       TVarChar,
    IN inDiscountTax     TFloat ,
    IN inDayCalendar     TFloat ,
    IN inDayBank         TFloat ,
    IN inBankId          Integer , 
    IN inPLZId           Integer ,
    IN inInfoMoneyId     Integer ,
    IN inTaxKindId       Integer ,
    IN inPaidKindId       Integer ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- Если код не установлен, определяем его как последний+1
   vbCode_calc:= lfGet_ObjectCode (ioCode, zc_Object_Partner());

   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Partner(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Partner(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Fax(), ioId, inFax);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Phone(), ioId, inPhone);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Mobile(), ioId, inMobile);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_IBAN(), ioId, inIBAN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Street(), ioId, inStreet);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Member(), ioId, inMember);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_WWW(), ioId, inWWW);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Email(), ioId, inEmail);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_CodeDB(), ioId, inCodeDB);
   -- сохранили свойство <Налоговый номер>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_TaxNumber(), ioId, inTaxNumber);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Comment(), ioId, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Partner_DiscountTax(), ioId, inDiscountTax);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Partner_DayCalendar(), ioId, inDayCalendar);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Partner_Bank(), ioId, inDayBank);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PLZ(), ioId, inPLZId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Bank(), ioId, inBankId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_TaxKind(), ioId, inTaxKindId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PaidKind(), ioId, inPaidKindId);
   
   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.21         *
 02.02.21         *
 09.11.20         *
 22.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Partner()
