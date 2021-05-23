-- Function: gpInsertUpdate_Object_ContractKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MedocLoadInfo(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MedocLoadInfo(
   IN inPeriod              TDateTime ,    -- Период
   IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;   
   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractKind());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- Период привели к началу месяца
   inPeriod := date_trunc('month', inPeriod);

   -- Пытаемся найти объект

   SELECT Id INTO vbId FROM Object_MedocLoadInfo_View WHERE Period = inPeriod;

   IF COALESCE(vbId, 0) = 0 THEN
      -- сохранили <Объект>
      vbId := lpInsertUpdate_Object(0, zc_Object_MedocLoadInfo(), 0, '');

      -- сохранили свойство <>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_MedocLoadInfo_Period(), vbId, inPeriod);
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_MedocLoadInfo_LoadDateTime(), vbId, current_timestamp);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MedocLoadInfo (TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
   25.05.15                       * 
*/

-- тест
-- SELECT * FROM ()
