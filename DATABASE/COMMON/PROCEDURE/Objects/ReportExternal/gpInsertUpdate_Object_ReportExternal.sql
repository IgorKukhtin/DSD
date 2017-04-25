-- Function: gpInsertUpdate_Object_ReportExternal()

-- DROP FUNCTION gpInsertUpdate_Object_ReportExternal();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReportExternal(
 INOUT ioId          Integer  ,    -- ид
    IN inName        TVarChar ,    -- Название функции (отчета)
    IN inSession     TVarChar      -- сессия пользователя
)
RETURNS Integer AS
$BODY$
DECLARE 
BEGIN

      PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ReportExternal(), inName);

      ioId:= lpInsertUpdate_Object(ioId, zc_Object_ReportExternal(), 0, inName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*  
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 25.04.17                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReportExternal(ioId:= 0, inName:= 'gpReport_Balance_1111', inSession:= zfCalc_UserAdmin())
                            