-- Function: gpInsertUpdate_Object_MarginReportItem(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginReportItem (Integer, Integer, Integer, Tfloat, Tfloat,Tfloat,Tfloat,Tfloat,Tfloat,Tfloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginReportItem (Integer, Integer, Tfloat, Tfloat,Tfloat,Tfloat,Tfloat,Tfloat,Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginReportItem(
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
   DECLARE vbid Integer;   
   
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginReportItem());
   UserId := inSession;

   -- проверка inMarginReportId должен быть установлен
   IF COALESCE (inMarginReportId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Значение <Категория наценки для отчета (Ценовая интервенция)> должно быть установлено.';
   END IF;

   vbid := (SELECT  ObjectLink_MarginReport.ObjectId AS Id 
            FROM ObjectLink AS ObjectLink_MarginReport
               INNER JOIN ObjectLink AS ObjectLink_Unit
                                     ON ObjectLink_Unit.DescId = zc_ObjectLink_MarginReportItem_Unit()
                                    AND ObjectLink_Unit.ObjectId = ObjectLink_MarginReport.ObjectId
                                    AND ObjectLink_Unit.ChildObjectId = inUnitId --2082813
            WHERE ObjectLink_MarginReport.DescId = zc_ObjectLink_MarginReportItem_MarginReport()
              AND ObjectLink_MarginReport.ChildObjectId = inMarginReportId );--2082813 

   -- сохранили <Объект>
   vbid := lpInsertUpdate_Object (COALESCE (vbid,0), zc_Object_MarginReportItem(), 0, '');
   
   -- сохранили свойство <вирт. % для 1-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent1(), vbid, inPersent1);
   -- сохранили свойство <вирт. % для 2-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent2(), vbid, inPersent2);
   -- сохранили свойство <вирт. % для 3-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent3(), vbid, inPersent3);
   -- сохранили свойство <вирт. % для 4-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent4(), vbid, inPersent4);
   -- сохранили свойство <вирт. % для 5-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent5(), vbid, inPersent5);
   -- сохранили свойство <вирт. % для 6-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent6(), vbid, inPersent6);
   -- сохранили свойство <вирт. % для 7-ого передела>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent7(), vbid, inPersent7);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MarginReportItem_MarginReport(), vbid, inMarginReportId);
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MarginReportItem_Unit(), vbid, inUnitId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (vbid, UserId);

   
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
