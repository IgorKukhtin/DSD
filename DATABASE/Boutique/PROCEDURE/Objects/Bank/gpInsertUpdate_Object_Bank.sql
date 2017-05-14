-- Function: gpInsertUpdate_Object_Bank (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Bank (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Bank(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Подразделения> 
 INOUT ioCode                     Integer   ,    -- Код объекта <Подразделения> 
    IN inName                     TVarChar  ,    -- Название объекта <Подразделения>
    IN inMFO                      TVarChar  ,    -- МФО
    IN inSWIFT                    TVarChar  ,    -- SWIFT код
    IN inIBAN                     TVarChar  ,    -- IBAN код счета
    IN inJuridicalId              Integer   ,    -- ключ объекта <Юридические лица> 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Bank());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Bank_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Bank_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Bank(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Bank(), ioCode, inName);

   -- сохранили МФО
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_MFO(), ioId, inMFO);
   -- сохранили SWIFT код
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_SWIFT(), ioId, inSWIFT);
   -- сохранили IBAN код счета
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_IBAN(), ioId, inIBAN);

   -- сохранили связь с <Юридические лица>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Bank_Juridical(), ioId, inJuridicalId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
13.05.17                                                           *
09.05.17                                                           *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Bank()
