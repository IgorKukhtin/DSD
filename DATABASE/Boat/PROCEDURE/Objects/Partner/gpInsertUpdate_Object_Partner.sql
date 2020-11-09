-- Торговая марка

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId              Integer,       -- ключ объекта <Бренд>
 INOUT ioCode            Integer,       -- свойство <Код Бренда>
    IN inName            TVarChar,      -- главное Название Бренда
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
    IN inBankId          Integer , 
    IN inPLZId           Integer ,
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
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Partner(), inName);

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
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Comment(), ioId, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PLZ(), ioId, inPLZId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Bank(), ioId, inBankId);

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
 09.11.20         *
 22.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Partner()
