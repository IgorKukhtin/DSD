-- Function: gpInsertUpdate_MovementItem_WagesAdditionalExpenses()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesAdditionalExpenses(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesAdditionalExpenses(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitID              Integer   , -- Плдразделение
    IN inSummaCleaning       TFloat    , -- Уборка
    IN inSummaSP             TFloat    , -- СП
    IN inSummaOther          TFloat    , -- Прочее
    IN inValidationResults   TFloat    , -- Результаты проверки
    IN inSummaFullChargeFact TFloat    , -- Полное списание факт
    IN inisIssuedBy          Boolean   , -- Выдано
    IN inComment             TVarChar  , -- Примечание
   OUT outSummaTotal         TFloat    , -- Итого
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1  FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUnitID
                  AND MovementItem.DescId = zc_MI_Sign())
      THEN
        SELECT MovementItem.ID
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementID = inMovementId
          AND MovementItem.ObjectID = inUnitID
          AND MovementItem.DescId = zc_MI_Sign();
      END IF;
    ELSE
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUnitID
                  AND MovementItem.ID <> ioId
                  AND MovementItem.DescId = zc_MI_Sign())
      THEN
        RAISE EXCEPTION 'Ошибка. Дублироапние подразделения запрещено.';
      END IF;
      
      IF EXISTS( SELECT 1
        FROM  MovementItem

              LEFT JOIN MovementItemFloat AS MIFloat_SummaCleaning
                                          ON MIFloat_SummaCleaning.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaCleaning.DescId = zc_MIFloat_SummaCleaning()

              LEFT JOIN MovementItemFloat AS MIFloat_SummaSP
                                          ON MIFloat_SummaSP.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaSP.DescId = zc_MIFloat_SummaSP()

              LEFT JOIN MovementItemFloat AS MIFloat_SummaOther
                                          ON MIFloat_SummaOther.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaOther.DescId = zc_MIFloat_SummaOther()

              LEFT JOIN MovementItemFloat AS MIFloat_ValidationResults
                                          ON MIFloat_ValidationResults.MovementItemId = MovementItem.Id
                                         AND MIFloat_ValidationResults.DescId = zc_MIFloat_ValidationResults()

              LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                            ON MIB_isIssuedBy.MovementItemId = MovementItem.Id
                                           AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

        WHERE MovementItem.Id = ioId 
          AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = True
          AND (COALESCE (MIFloat_SummaCleaning.ValueData, 0) <> COALESCE (inSummaCleaning, 0)
            OR COALESCE (MIFloat_SummaSP.ValueData, 0) <>  COALESCE (inSummaSP, 0)
            OR COALESCE (MIFloat_SummaOther.ValueData, 0) <>  COALESCE (inSummaOther, 0)
            OR COALESCE (MIFloat_ValidationResults.ValueData, 0) <>  COALESCE (inValidationResults, 0)))
      THEN
        RAISE EXCEPTION 'Ошибка. Дополнительные расходы выданы. Изменение сумм запрещено.';            
      END IF;
      
      
    END IF;

    -- сохранили
    ioId := lpInsertUpdate_MovementItem_WagesAdditionalExpenses (ioId                  := ioId                  -- Ключ объекта <Элемент документа>
                                                               , inMovementId          := inMovementId          -- ключ Документа
                                                               , inUnitID              := inUnitID              -- Подразделение
                                                               , inSummaCleaning       := inSummaCleaning       -- Уборка
                                                               , inSummaSP             := inSummaSP             -- СП
                                                               , inSummaOther          := inSummaOther          -- Прочее
                                                               , inValidationResults   := inValidationResults   -- Результаты проверки
                                                               , inSummaFullChargeFact := inSummaFullChargeFact -- Полное списание факт 
                                                               , inisIssuedBy          := inisIssuedBy          -- Выдано
                                                               , inComment             := inComment             -- Примечание
                                                               , inUserId              := vbUserId              -- пользователь
                                                                 );

   outSummaTotal := COALESCE((SELECT Amount FROM MovementItem WHERE MovementItem.ID = ioId), 0);
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.10.19                                                        *
 01.09.19                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesAdditionalExpenses (, inSession:= '2')

