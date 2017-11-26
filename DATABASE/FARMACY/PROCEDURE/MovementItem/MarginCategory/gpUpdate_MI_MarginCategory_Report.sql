-- Function: gpUpdate_MI_MarginCategory_Report()

DROP FUNCTION IF EXISTS gpUpdate_MI_MarginCategory_Report (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_MarginCategory_Report(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inisReport            Boolean  , -- 
   OUT outisReport           Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- определили признак
     outisReport:= NOT inisReport;


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Report(), inId, outisReport);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 26.11.17         *
*/

-- тест