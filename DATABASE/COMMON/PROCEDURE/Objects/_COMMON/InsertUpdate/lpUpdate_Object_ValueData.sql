-- Function: lpUpdate_Object_ValueData()

DROP FUNCTION IF EXISTS lpUpdate_Object_ValueData (Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_ValueData(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inValueData           TVarChar  ,    --
    IN inUserId              Integer        -- Пользователь
)
  RETURNS VOID
AS
$BODY$
BEGIN
   -- !!!Только просмотр Аудитор!!!
   PERFORM lpCheckPeriodClose_auditor (NULL, NULL, NULL, NULL, inId, inUserId);

   -- изменили элемент справочника по значению <Ключ объекта>
   UPDATE Object SET ValueData = inValueData WHERE Id = inId;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.12.14                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_ValueData()
