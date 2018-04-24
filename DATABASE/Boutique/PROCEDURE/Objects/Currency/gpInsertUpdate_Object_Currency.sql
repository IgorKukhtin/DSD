-- Function: gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Currency(
 INOUT ioId           Integer,       -- Ключ объекта <Валюта>     
 INOUT ioCode         Integer,       -- Код объекта <Валюта>      
    IN inName         TVarChar,      -- Название объекта <Валюта> 
    IN inIncomeKoeff  TFloat  ,      -- Коэффициент при приходе
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Currency());


   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Currency_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Currency_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- проверка уникальности для свойства <Наименование>
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Currency(), inName); 
  

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Currency(), ioCode, inName);

   -- сохранили <Коэффициент при приходе>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Currency_IncomeKoeff(), ioId, inIncomeKoeff);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
24.04.18          *
13.05.17                                                          *
08.05.17                                                          *
02.03.17                                                          *
20.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Currency()
