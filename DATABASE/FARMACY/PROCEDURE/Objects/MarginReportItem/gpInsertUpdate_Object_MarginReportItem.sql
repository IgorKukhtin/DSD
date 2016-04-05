-- Function: gpInsertUpdate_Object_MarginReportItem(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginReportItem (Integer, Integer, Integer, Tfloat, Tfloat,Tfloat,Tfloat,Tfloat,Tfloat,Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginReportItem(
 INOUT ioId             Integer,       -- Ключ объекта <Виды форм оплаты>
    IN inMarginReportId Integer,       -- 
    IN inUnitId         Integer,       -- 

    IN inPersent1       Tfloat,        -- вирт. % для 1-ого передела
    IN inPersent2       Tfloat,        -- вирт. % для 2-ого передела
    IN inPersent3       Tfloat,        -- вирт. % для 3-ого передела
    IN inPersent4       Tfloat,        -- вирт. % для 4-ого передела
    IN inPersent5       Tfloat,        -- вирт. % для 5-ого передела
    IN inPersent6       Tfloat,        -- вирт. % для 6-ого передела
    IN inPersent7       Tfloat,        -- вирт. % для 7-ого передела 
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS INTEGER AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginReportItem());
   UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   Code_max := lfGet_ObjectCode(inCode, zc_Object_MarginReportItem());
   
   -- проверка прав уникальности для свойства <Наименование Вида формы оплаты>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MarginReportItem(), inName);
   -- проверка прав уникальности для свойства <Код Вида формы оплаты>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MarginReportItem(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MarginReportItem(), Code_max, inName);
   
   -- сохранили свойство <вирт. % для 1-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent1(), ioId, inPersent1);
   -- сохранили свойство <вирт. % для 2-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent2(), ioId, inPersent2);
   -- сохранили свойство <вирт. % для 3-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent3(), ioId, inPersent3);
   -- сохранили свойство <вирт. % для 4-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent4(), ioId, inPersent4);
   -- сохранили свойство <вирт. % для 5-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent5(), ioId, inPersent5);
   -- сохранили свойство <вирт. % для 6-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent6(), ioId, inPersent6);
   -- сохранили свойство <вирт. % для 7-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent7(), ioId, inPersent7);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.16         *
*/

-- тест
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MarginReportItem(0, 2,'ау','2'); ROLLBACK
