 -- Function: lpInsertUpdate_Object_DataExcel ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_DataExcel (Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_DataExcel(
    IN inId             Integer   ,    -- ключ объекта <> 
    IN inCode           Integer   ,    -- код объекта 
    IN inName           TVarChar  ,    -- 
    IN inUserId         Integer -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
 
       -- сохранили/получили <Объект> по ИД
       inId := lpInsertUpdate_Object (inId, zc_Object_DataExcel(), inCode, inName);

       -- сохранили свойство <Дата создания>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), inId, CURRENT_TIMESTAMP);
       -- сохранили свойство <Пользователь (создание)>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), inId, inUserId);

       -- сохранили протокол
       PERFORM lpInsert_ObjectProtocol (inId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 30.10.17         *
*/

-- тест
--