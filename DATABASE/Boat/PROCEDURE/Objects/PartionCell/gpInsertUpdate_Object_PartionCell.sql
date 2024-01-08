-- Function: gpInsertUpdate_Object_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartionCell (Integer,Integer,TVarChar,TFloat,TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartionCell(
 INOUT ioId	          Integer,   	-- ключ объекта <Единица измерения>
    IN inCode         Integer,      -- свойство <Код Единицы измерения>
    IN inName         TVarChar,     -- главное Название Единицы измерения
    IN inLevel        TFloat  ,
    IN inComment      TVarChar,
    IN inSession      TVarChar      -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его
   inCode:=lfGet_ObjectCode (inCode, zc_Object_PartionCell());

   -- проверка уникальности для свойства <Наименование Единицы измерения>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PartionCell(), inName);
   -- проверка уникальности для свойства <Код Единицы измерения>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PartionCell(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PartionCell(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PartionCell_Comment(), ioId, inComment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_Level(), ioId, inLevel);
   
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 08.01.24         *

*/

-- тест
-- 