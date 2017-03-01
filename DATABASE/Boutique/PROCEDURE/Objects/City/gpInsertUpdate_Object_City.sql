-- Function: gpInsertUpdate_Object_City (Integer,  TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_City (Integer,  TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_City(
 INOUT ioId           Integer,       -- Ключ объекта <Населенный пункт>
    IN inName         TVarChar,      -- Название объекта <Населенный пункт>
    IN inSession      TVarChar       -- сессия пользователя
)
  RETURNS integer 
  AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_City());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (Code_max, 0) = 0 THEN Code_max := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   Code_max:=lfGet_ObjectCode (Code_max, zc_Object_City()); 

   -- проверка уникальности для свойства <Наименование Населенный пункт>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_City(), inName);
   -- проверка уникальности для свойства <Код Населенный пункт>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_City(), Code_max);



   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_City(), Code_max, inName);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
28.02.2017                                                          *


*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_City()
