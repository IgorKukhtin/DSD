-- Function: gpInsertUpdate_MovementItem_WagesTechnicalRediscount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesTechnicalRediscount(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesTechnicalRediscount(
    IN inUnitID                     Integer   , -- Плдразделение
    IN inOperDate                   TDateTime , --
   OUT outSummaTechnicalRediscount  TFloat    , -- Итого
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbId         Integer;
   DECLARE vbMovementId Integer;
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

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = date_trunc('month', inOperDate) AND Movement.DescId = zc_Movement_Wages())
    THEN
        SELECT Movement.ID
        INTO vbMovementId
        FROM Movement
        WHERE Movement.OperDate = date_trunc('month', inOperDate)
          AND Movement.DescId = zc_Movement_Wages();
    ELSE
        vbMovementId := lpInsertUpdate_Movement_Wages (ioId              := 0
                                                     , inInvNumber       := CAST (NEXTVAL ('Movement_Wages_seq')  AS TVarChar)
                                                     , inOperDate        := date_trunc('month', inOperDate)
                                                     , inUserId          := vbUserId
                                                       );

    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.DescId = zc_MI_Sign()
                                           AND MovementItem.MovementId = vbMovementId
                                           AND MovementItem.ObjectId = inUnitID)
    THEN
        SELECT MovementItem.id
        INTO vbId
        FROM MovementItem
        WHERE MovementItem.DescId = zc_MI_Sign()
          AND MovementItem.MovementId = vbMovementId
          AND MovementItem.ObjectId = inUnitID;
    ELSE
        vbId := 0;
    END IF;

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    IF vbIsInsert = TRUE
    THEN
         -- сохранили <Элемент документа>
        vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, 0, 0);
    END IF;

    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF EXISTS(SELECT 1
              FROM  MovementItem

                    LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                                  ON MIB_isIssuedBy.MovementItemId = MovementItem.Id
                                                 AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()
              WHERE MovementItem.Id = vbId
                AND COALESCE (MIB_isIssuedBy.ValueData, FALSE) = True)
    THEN
      RAISE EXCEPTION 'Ошибка. Дополнительные расходы выданы. Изменение сумм запрещено.';
    END IF;

    vbSumma := COALESCE((SELECT  Sum(COALESCE(MovementFloat_SummaManual.ValueData, MovementFloat_TotalDiffSumm.ValueData))
                         FROM Movement

                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  = inUnitID

                              LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalDiffSumm
                                                            ON MovementFloat_TotalDiffSumm.MovementId = Movement.Id
                                                           AND MovementFloat_TotalDiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()

                              LEFT OUTER JOIN MovementFloat AS MovementFloat_SummaManual
                                                            ON MovementFloat_SummaManual.MovementId = Movement.Id
                                                           AND MovementFloat_SummaManual.DescId = zc_MovementFloat_SummaManual()

                              LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                                        ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                                       AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()

                              LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                                        ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                                       AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()

                         WHERE Movement.OperDate BETWEEN date_trunc('month', inOperDate) AND date_trunc('month', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                           AND Movement.DescId = zc_Movement_TechnicalRediscount()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND COALESCE (MovementBoolean_RedCheck.ValueData, False) = False
                           AND COALESCE (MovementBoolean_Adjustment.ValueData, False) = False), 0);

     -- сохранили свойство <Штрафах по техническому переучету>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaTechnicalRediscount(), vbId, CASE WHEN vbSumma  > 0 THEN 0 ELSE vbSumma END);

    vbSumma := (SELECT SUM(MIFloat_Summa.ValueData)
                FROM MovementItemFloat AS MIFloat_Summa
                WHERE MIFloat_Summa.MovementItemId = vbId
                  AND MIFloat_Summa.DescId in (zc_MIFloat_SummaCleaning(), zc_MIFloat_SummaSP(), zc_MIFloat_SummaOther(),
                                               zc_MIFloat_ValidationResults(), zc_MIFloat_SummaSUN1(),
                                               zc_MIFloat_SummaTechnicalRediscount()));

     -- сохранили <Элемент документа>
    vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, COALESCE (vbSumma, 0)::TFloat, 0);

    outSummaTechnicalRediscount := COALESCE((SELECT SUM(MIFloat_SummaTechnicalRediscount.ValueData)
                                             FROM MovementItemFloat AS MIFloat_SummaTechnicalRediscount
                                             WHERE MIFloat_SummaTechnicalRediscount.MovementItemId = vbId
                                               AND MIFloat_SummaTechnicalRediscount.DescId = zc_MIFloat_SummaTechnicalRediscount()), 0);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.02.20                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesTechnicalRediscount (, inSession:= '2')