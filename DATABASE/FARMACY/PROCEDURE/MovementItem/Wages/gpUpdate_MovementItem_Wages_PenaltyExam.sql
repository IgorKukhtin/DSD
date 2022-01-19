-- Function: gpUpdate_MovementItem_Wages_PenaltyExam()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Wages_PenaltyExam(TDateTime, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Wages_PenaltyExam(
    IN inOperDate            TDateTime , -- Дата расчета
    IN inUserID              Integer   , -- Сотрудник
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- Получаем vbMovementId
    SELECT Movement.Id, Movement.StatusId
    INTO vbMovementId, vbStatusId
    FROM Movement
    WHERE Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate)
      AND Movement.DescId = zc_Movement_Wages();

    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF COALESCE (vbMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Документ ЗП не найден.';
    END IF;

    IF EXISTS(SELECT 1  FROM MovementItem
              WHERE MovementItem.MovementID = vbMovementId
                AND MovementItem.ObjectID = inUserId
                AND MovementItem.DescId = zc_MI_Master())
    THEN
      SELECT MovementItem.ID
      INTO vbId
      FROM MovementItem
      WHERE MovementItem.MovementID = vbMovementId
        AND MovementItem.ObjectID = inUserId
        AND MovementItem.DescId = zc_MI_Master();

       -- сохранили свойство <Штраф по сдаче экзамена>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PenaltyExam(), vbId, - 500);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (vbId, inUserID, False);

    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.04.21                                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_Wages_PenaltyExam (CURRENT_DATE, inSession:= '3')