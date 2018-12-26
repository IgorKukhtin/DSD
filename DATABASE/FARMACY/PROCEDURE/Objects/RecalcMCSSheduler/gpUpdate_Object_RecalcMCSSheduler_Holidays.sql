-- Function: gpUpdate_Object_RecalcMCSSheduler_Holidays()

DROP FUNCTION IF EXISTS gpUpdate_Object_RecalcMCSSheduler_Holidays(TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_RecalcMCSSheduler_Holidays(
    IN inBeginHolidays TDateTime, 
    IN inEndHolidays TDateTime,
    IN inSession  TVarChar       -- сессия пользователя
    )
RETURNS VOID
AS
$BODY$
DECLARE
    vbUserId Integer;
    vbId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId := inSession;

   IF EXISTS (SELECT 1 FROM Object WHERE DescId = zc_Object_RecalcMCSSheduler())
   THEN
     SELECT Min(Id)
     INTO vbId
     FROM Object
     WHERE DescId = zc_Object_RecalcMCSSheduler();

      -- сохранили <>
      PERFORM lpInsertUpdate_ObjectDate(zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays(), vbId, inBeginHolidays);
      PERFORM lpInsertUpdate_ObjectDate(zc_ObjectFloat_RecalcMCSSheduler_EndHolidays(), vbId, inEndHolidays);
   ELSE 
     RAISE EXCEPTION 'Ошибка. Надо сохранить хоть одно задание..';    
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_RecalcMCSSheduler_Holidays(TDateTime, TDateTime, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.12.18                                                       *

*/