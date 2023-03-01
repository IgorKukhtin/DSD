-- Function: gpInsertUpdate_MovementItem_AsinoPharmaSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_AsinoPharmaSP (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_AsinoPharmaSP(
 INOUT ioId                   Integer   , -- Ключ записи
    IN inMovementId           Integer   ,
 INOUT ioQueue                Integer   , -- Очередность
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbQueue Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF (SELECT StatusId FROM Movement WHERE Id = inMovementId) <> zc_Enum_Status_UnComplete()
    THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
  
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF EXISTS(SELECT 1
              FROM MovementItem
              WHERE MovementItem.DescId = zc_MI_Master()
                AND MovementItem.MovementId = inMovementId
                AND MovementItem.Id = ioId
                AND MovementItem.isErased <> FALSE) 
    THEN
      RAISE EXCEPTION 'Ошибка.Изменение удаленных строк не возможно.';
    END IF;
      
    IF COALESCE(ioId, 0) = 0
    THEN
      IF COALESCE(ioQueue, 0) < 0
      THEN
        RAISE EXCEPTION 'Порядок должен быть больше или равен 0';
      END IF;
      
      vbQueue := COALESCE((SELECT count(*)
                           FROM MovementItem
                           WHERE MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.MovementId = inMovementId
                             AND MovementItem.isErased = FALSE), 0)::Integer + 1;
    ELSE
      IF COALESCE(ioQueue, 0) <= 0
      THEN
        RAISE EXCEPTION 'Порядок должен быть больше 0';
      END IF;    
      
      vbQueue := (SELECT MovementItem.Amount
                  FROM MovementItem
                  WHERE MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.MovementId = inMovementId
                    AND MovementItem.Id = ioId)::Integer;
    END IF;
    
    IF COALESCE(ioQueue, 0) = 0
    THEN
      ioQueue := COALESCE((SELECT count(*)
                           FROM MovementItem
                           WHERE MovementItem.DescId = zc_MI_Master()
                             AND MovementItem.MovementId = inMovementId
                             AND MovementItem.isErased = FALSE), 0)::Integer + 1;
    ELSEIF ioQueue > COALESCE((SELECT count(*)
                               FROM MovementItem
                               WHERE MovementItem.DescId = zc_MI_Master()
                                 AND MovementItem.MovementId = inMovementId
                                 AND MovementItem.isErased = FALSE), 0)::Integer + 1
    THEN
        ioQueue := COALESCE((SELECT count(*)
                             FROM MovementItem
                             WHERE MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.MovementId = inMovementId
                               AND MovementItem.isErased = FALSE), 0)::Integer + 1;
    END IF;
        
    -- Если надо перенумеровываем
    IF EXISTS(SELECT 1
              FROM MovementItem
              WHERE MovementItem.DescId = zc_MI_Master()
                AND MovementItem.MovementId = inMovementId
                AND MovementItem.Amount > vbQueue
                AND MovementItem.isErased = FALSE) 
    THEN
    
      PERFORM lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := MovementItem.Id
                                                       , inMovementId          := inMovementId
                                                       , inQueue               := (MovementItem.Amount - 1)::Integer
                                                       , inUserId              := vbUserId)
      FROM MovementItem
      WHERE MovementItem.DescId = zc_MI_Master()
        AND MovementItem.MovementId = inMovementId
        AND MovementItem.Amount > vbQueue
        AND MovementItem.isErased = FALSE;
    END IF;

    IF EXISTS(SELECT 1
              FROM MovementItem
              WHERE MovementItem.DescId = zc_MI_Master()
                AND MovementItem.MovementId = inMovementId
                AND MovementItem.Amount >= ioQueue
                AND MovementItem.isErased = FALSE) 
    THEN
    
      PERFORM lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := MovementItem.Id
                                                       , inMovementId          := inMovementId
                                                       , inQueue               := (MovementItem.Amount + 1)::Integer
                                                       , inUserId              := vbUserId)
      FROM MovementItem
      WHERE MovementItem.DescId = zc_MI_Master()
        AND MovementItem.MovementId = inMovementId
        AND MovementItem.Amount >= ioQueue
        AND MovementItem.isErased = FALSE;
    END IF;
    
    
    -- сохранить запись
    ioId := lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := COALESCE(ioId,0)
                                                     , inMovementId          := inMovementId
                                                     , inQueue               := ioQueue
                                                     , inUserId              := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.02.23                                                       *
*/
--