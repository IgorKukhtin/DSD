-- Function: gpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- определяем <Статус>
    SELECT Movement.StatusId, Movement.OperDate 
    INTO vbStatusId, vbOperDate   
    FROM Movement 
    WHERE Movement.Id = inMovementId;

    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    SELECT Movement.ID
    INTO vbMovementId  
    FROM Movement 
    WHERE Movement.OperDate = vbOperDate - INTERVAL '1 MONTH' 
      AND Movement.DescId = zc_Movement_Wages();
    

    IF NOT EXISTS(SELECT 1 FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_SummaCleaning
                                                     ON MIFloat_SummaCleaning.MovementItemId = MovementItem.Id
                                                    AND MIFloat_SummaCleaning.DescId = zc_MIFloat_SummaCleaning()

                         LEFT JOIN MovementItemFloat AS MIFloat_SummaOther
                                                     ON MIFloat_SummaOther.MovementItemId = MovementItem.Id
                                                    AND MIFloat_SummaOther.DescId = zc_MIFloat_SummaOther()
                  WHERE MovementItem.MovementID = vbMovementId
                    AND MovementItem.ObjectID NOT IN (SELECT MovementItem.ObjectID FROM MovementItem
                                                      WHERE MovementItem.MovementID = inMovementId
                                                        AND MovementItem.DescId = zc_MI_Sign())
                    AND MovementItem.DescId = zc_MI_Sign()
                    AND (COALESCE(MIFloat_SummaCleaning.ValueData, 0) <> 0 OR COALESCE(MIFloat_SummaOther.ValueData, 0) <> 0))
    THEN
      RAISE EXCEPTION 'Ошибка. Не найдены новые данные для копирования.';
    END IF;
      

    -- сохранили
    PERFORM lpInsertUpdate_MovementItem_WagesAdditionalExpenses (ioId                      := 0                                            -- Ключ объекта <Элемент документа>
                                                               , inMovementId              := inMovementId                                 -- ключ Документа
                                                               , inUnitID                  := MovementItem.ObjectID                        -- Подразделение
                                                               , inSummaCleaning           := COALESCE(MIFloat_SummaCleaning.ValueData, 0) -- Уборка
                                                               , inSummaSP                 := 0::TFloat                                    -- СП
                                                               , inSummaOther              := COALESCE(MIFloat_SummaOther.ValueData, 0)    -- Прочее
                                                               , inSummaValidationResults  := 0                                            -- Результаты проверки
                                                               , inSummaFullChargeFact     := 0                                            -- Полное списание факт
                                                               , inisIssuedBy              := False                                        -- Выдано
                                                               , inComment                 := COALESCE(MIS_Comment.ValueData, '')          -- Примечание
                                                               , inUserId                  := vbUserId                                     -- пользователь
                                                                 )
    FROM MovementItem

         LEFT JOIN MovementItemFloat AS MIFloat_SummaCleaning
                                     ON MIFloat_SummaCleaning.MovementItemId = MovementItem.Id
                                    AND MIFloat_SummaCleaning.DescId = zc_MIFloat_SummaCleaning()

         LEFT JOIN MovementItemFloat AS MIFloat_SummaOther
                                     ON MIFloat_SummaOther.MovementItemId = MovementItem.Id
                                    AND MIFloat_SummaOther.DescId = zc_MIFloat_SummaOther()

         LEFT JOIN MovementItemString AS MIS_Comment
                                      ON MIS_Comment.MovementItemId = MovementItem.Id
                                     AND MIS_Comment.DescId = zc_MIString_Comment()
    
    WHERE MovementItem.MovementID = vbMovementId
      AND MovementItem.ObjectID NOT IN (SELECT MovementItem.ObjectID FROM MovementItem
                                        WHERE MovementItem.MovementID = inMovementId
                                          AND MovementItem.DescId = zc_MI_Sign())
      AND MovementItem.DescId = zc_MI_Sign()
      AND (COALESCE(MIFloat_SummaCleaning.ValueData, 0) <> 0 OR COALESCE(MIFloat_SummaOther.ValueData, 0) <> 0);
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.10.19                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy (, inSession:= '2')
