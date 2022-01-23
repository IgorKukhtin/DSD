-- Function: gpUpdate_Object_PickUpLogsAndDBF_Cash()

DROP FUNCTION IF EXISTS gpUpdate_Object_PickUpLogsAndDBF_Cash (Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PickUpLogsAndDBF_Cash(
    IN inCashSessionId  TVarChar  , -- ИД сессии
    IN inSession        TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectMinAmount());
   vbUserId := lpGetUserBySession (inSession); 

   
   IF EXISTS(SELECT Object_PickUpLogsAndDBF.Id
             FROM Object AS Object_PickUpLogsAndDBF
             WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
               AND Object_PickUpLogsAndDBF.ValueData = inCashSessionId)
   THEN
   
     SELECT Object_PickUpLogsAndDBF.Id
     INTO vbId
     FROM Object AS Object_PickUpLogsAndDBF
     WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
       AND Object_PickUpLogsAndDBF.ValueData = inCashSessionId;

     -- сохранили связь с <Тип расчета заработной платы>
     PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_PickUpLogsAndDBF_Loaded(), vbId, True);

     -- сохранили свойство <Дата начала действия>
     PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_PickUpLogsAndDBF_DateLoaded(), vbId, CURRENT_TIMESTAMP);
       
     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
   END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.06.21                                                       *
*/

-- тест
-- select * from gpUpdate_Object_PickUpLogsAndDBF_Cash(inCashSessionId := '{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}' ,  inSession := '3');