-- Function: gpInsertUpdate_MovementItem_StaffListClose()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_StaffListClose (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_StaffListClose(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inUnitId                 Integer   , -- Подразделение(Исключение)
    --IN inMemberId               Integer   , -- физ.лицо кто выполнил действие
    IN inAmount                 TFloat    , -- Открыт или закрыт  0 или 1
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_StaffListClose());
 
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_StaffListClose (ioId         := ioId
                                                       , inMovementId := inMovementId
                                                       , inUnitId     := inUnitId
                                                       , inAmount     := inAmount
                                                       , inUserId     := vbUserId
                                                        ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.25         *
*/

-- тест
--