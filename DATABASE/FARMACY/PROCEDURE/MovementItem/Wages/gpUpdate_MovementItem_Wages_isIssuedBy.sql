-- Function: gpUpdate_MovementItem_Wages_isIssuedBy()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Wages_isIssuedBy(INTEGER, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Wages_isIssuedBy(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inisIssuedBy          Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (inId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Документ не сохранен.';
    END IF;

     -- сохранили свойство <На карту>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), inId, NOT inisIssuedBy);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.08.19                                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_Wages_isIssuedBy (, inSession:= '2')

