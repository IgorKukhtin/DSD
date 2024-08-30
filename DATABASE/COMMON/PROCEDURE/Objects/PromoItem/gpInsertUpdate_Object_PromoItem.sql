-- Function: gpInsertUpdate_Object_PromoItem(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PromoItem (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PromoItem(
 INOUT ioId             Integer,       -- Ключ объекта <>
    IN inCode           Integer,       -- свойство <Код >
    IN inName           TVarChar,      -- свойство <Наименование >
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId  Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId  := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PromoItem());
      vbUserId:= lpGetUserBySession (inSession);


   inCode:= lfGet_ObjectCode (inCode, zc_Object_PromoItem());

   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_PromoItem(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PromoItem(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PromoItem(), inCode, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId );

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.24         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PromoItem(1,1,'1','1')