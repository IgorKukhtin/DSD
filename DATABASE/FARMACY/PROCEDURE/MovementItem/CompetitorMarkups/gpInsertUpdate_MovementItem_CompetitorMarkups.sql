-- Function: gpInsertUpdate_MovementItem_CompetitorMarkups()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_CompetitorMarkups(Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_CompetitorMarkups(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsID             Integer   , -- Товар
    IN inCompetitorId        Integer   , -- Конкурент
    IN inValue               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups());

    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT MovementItem.Id 
                FROM MovementItem
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.ObjectId = inGoodsID)
      THEN
        SELECT MovementItem.Id 
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.ObjectId = inGoodsID;
      END IF;
    END IF;

    -- сохранили
    IF COALESCE (ioId, 0) = 0
    THEN
    
        ioId := lpInsertUpdate_MovementItem_CompetitorMarkups (ioId                  := ioId                  -- Ключ объекта <Элемент документа>
                                                             , inMovementId          := inMovementId          -- ключ Документа
                                                             , inGoodsID             := inGoodsID             -- товар
                                                             , inUserId              := vbUserId              -- пользователь
                                                               );
    END IF;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.05.22                                                        *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_CompetitorMarkups(ioId := 0 , inMovementId := 27717912 , inGoodsID := 18922 , inCompetitorId := 0 , inValue := 0 ,  inSession := '3');