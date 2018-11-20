-- Function: gpInsertUpdate_MI_ReportUnLiquid_Comment)

DROP FUNCTION IF EXISTS gpUpdate_MI_ReportUnLiquid_Comment(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReportUnLiquid_Comment(
    IN inId                  Integer  , -- Дата начала отчета
    IN inComment             TVarChar , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ReportUnLiquid());
     vbUserId := inSession;

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.18         *
*/

-- тест
--