-- Function: gpInsertUpdate_MovementItem_WagesSUN1()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesSUN1(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesSUN1(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitID              Integer   , -- Плдразделение
    IN inSummaWeek1          TFloat    , --
    IN inSummaWeek2          TFloat    , --
    IN inSummaWeek3          TFloat    , --
    IN inSummaWeek4          TFloat    , --
    IN inSummaWeek5          TFloat    , --
   OUT outSummaSUN1          TFloat    , -- Итого
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Record
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbSumma    TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

     -- Разрешаем только сотрудникам с правами админа    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Разрешено только системному администратору';
    END IF;
    
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

              LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                            ON MIB_isIssuedBy.MovementItemId = MovementItem.Id
                                           AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()
        WHERE MovementItem.Id = ioId
          AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = True)
      THEN
        RAISE EXCEPTION 'Ошибка. Дополнительные расходы выданы. Изменение сумм запрещено.';
      END IF;


    END IF;

   outSummaSUN1 := COALESCE (inSummaWeek1, 0) + COALESCE (inSummaWeek2, 0) + COALESCE (inSummaWeek3, 0) +
                   COALESCE (inSummaWeek4, 0) + COALESCE (inSummaWeek5, 0);

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    IF vbIsInsert = TRUE
    THEN
         -- сохранили <Элемент документа>
        ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, COALESCE (outSummaSUN1, 0)::TFloat, 0);
    END IF;

     -- сохранили свойство <По неделям>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek1(), ioId, inSummaWeek1);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek2(), ioId, inSummaWeek2);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek3(), ioId, inSummaWeek3);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek4(), ioId, inSummaWeek4);
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaWeek5(), ioId, inSummaWeek5);

     -- сохранили свойство <Итог по СУН1>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaSUN1(), ioId, outSummaSUN1);

     -- сохранили свойство <Итог>
    IF vbIsInsert = FALSE
    THEN
        vbSumma := (SELECT SUM(MIFloat_SummaSUN1.ValueData)
                    FROM MovementItemFloat AS MIFloat_SummaSUN1
                    WHERE MIFloat_SummaSUN1.MovementItemId = ioId
                      AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaCleaning(), zc_MIFloat_SummaSP(), zc_MIFloat_SummaOther(),
                                                       zc_MIFloat_ValidationResults(), zc_MIFloat_SummaSUN1(),
                                                       zc_MIFloat_SummaTechnicalRediscount()));
         -- сохранили <Элемент документа>
        ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, COALESCE (vbSumma, 0)::TFloat, 0);
    END IF;


    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.02.20                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesSUN1 (, inSession:= '2')
