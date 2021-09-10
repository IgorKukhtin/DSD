-- Function: gpUpdate_Object_Maker_UnPlanned (Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Maker_UnPlanned (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Maker_UnPlanned(
    IN inId                  Integer  ,     -- ключ объекта <Производитель>
    IN inStartDateUnPlanned  TDateTime,     -- Дата начала для внепланового отчета
    IN inEndDateUnPlanned    TDateTime,     -- Дата окончания для внепланового отчета
    IN inSession             TVarChar       -- сессия пользователя
)
 RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSendPlan TDateTime;    
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Maker());
   vbUserId := inSession;

   -- сохранили свойство <Дата начала для внепланового отчета>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_StartDateUnPlanned(), inId, inStartDateUnPlanned);
   -- сохранили свойство <Дата окончания для внепланового отчета>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_EndDateUnPlanned(), inId, inEndDateUnPlanned);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Maker_UnPlanned(), inId, True);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.09.21                                                       *
 
*/

-- тест
-- select * from gpUpdate_Object_Maker_UnPlanned(inId := 3605302 , inStartDateUnPlanned := ('01.05.2021')::TDateTime , inEndDateUnPlanned := ('31.08.2021')::TDateTime ,  inSession := '3');