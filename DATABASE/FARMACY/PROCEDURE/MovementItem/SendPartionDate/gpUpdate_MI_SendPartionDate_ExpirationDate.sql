-- Function: gpUpdate_MI_SendPartionDate_ExpirationDate()

DROP FUNCTION IF EXISTS gpUpdate_MI_SendPartionDate_ExpirationDate (Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_SendPartionDate_ExpirationDate(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inExpirationDate        TDateTime ,
    IN inExpirationDate_in     TDateTime ,
   OUT outisExpirationDateDiff Boolean   ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendPartionDate());
    vbUserId := inSession;

    IF COALESCE (inId,0) = 0
    THEN
        --
        
        RETURN;
    END IF;

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), inId, inExpirationDate);
    
    outisExpirationDateDiff := CASE WHEN inExpirationDate <> inExpirationDate_in THEN TRUE ELSE FALSE END;

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.19         *
*/