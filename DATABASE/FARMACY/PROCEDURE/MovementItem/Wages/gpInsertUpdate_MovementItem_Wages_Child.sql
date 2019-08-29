-- Function: gpInsertUpdate_MovementItem_Wages_Child ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_Child (Integer, Integer, Integer, Boolean, Integer, TFloat, TDateTime, TFloat, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inParentId            Integer   , -- элемент мастер
    IN inAuto                Boolean   , -- Авто расчет
    IN inUnitId              Integer   , -- подразделение
    IN inAmount              TFloat    , -- Сумма начислено
    IN inDateCalculation     TDateTime , -- Дата расчета
    IN inSummaBase           TFloat    , -- Сумма базы
    IN inPayrollTypeID       Integer   , -- Тип начисления
    IN inComment             TVarChar  , -- Описание
    IN inSession             TVarChar   -- пользователь
 )
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- Ищем свободные zc_MI_Child() 
    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.DescId = zc_MI_Child()
                  AND MovementItem.ParentId = inParentId
                  AND MovementItem.isErased = TRUE)
      THEN
        SELECT MIN(MovementItem.ID)
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementID = inMovementId
          AND MovementItem.DescId = zc_MI_Child()
          AND MovementItem.ParentId = inParentId
          AND MovementItem.isErased = TRUE;
          
        UPDATE MovementItem SET isErased = FALSE WHERE ID = ioId;
      END IF;
    END IF;

    -- сохранили
    ioId := lpInsertUpdate_MovementItem_Wages_Child (ioId                  := ioId                  -- Ключ объекта <Элемент документа>
                                                   , inMovementId          := inMovementId          -- ключ Документа
                                                   , inParentId            := inParentId
                                                   , inAuto                := inAuto
                                                   , inUnitId              := inUnitId
                                                   , inAmount              := inAmount
                                                   , inDateCalculation     := inDateCalculation
                                                   , inSummaBase           := inSummaBase
                                                   , inPayrollTypeID       := inPayrollTypeID
                                                   , inComment             := inComment              
                                                   , inUserId              := vbUserId              -- пользователь
                                                    );

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.19                                                        *
*/

-- тест
-- 