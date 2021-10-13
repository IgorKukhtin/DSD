-- Function: gpInsertUpdate_MovementItem_WagesFullCharge()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesFullCharge(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesFullCharge(
    IN inUnitID                     Integer   , -- Плдразделение
    IN inOperDate                   TDateTime , --
   OUT outSummaFullCharge           TFloat    , -- Итого
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbId         Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId   Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbSumma      TFloat;
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

    vbSumma := COALESCE(Round((
                         SELECT SUM (COALESCE (Round(MovementFloat_TotalSumm.ValueData, 2), 0) - COALESCE(MovementFloat_SummaFund.ValueData, 0))
                         FROM Movement

                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  = inUnitID

                              INNER JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                            ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                           AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()

                              LEFT JOIN MovementFloat AS MovementFloat_SummaFund
                                                      ON MovementFloat_SummaFund.MovementId =  Movement.Id
                                                     AND MovementFloat_SummaFund.DescId = zc_MovementFloat_SummaFund()
                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                         WHERE Movement.OperDate BETWEEN date_trunc('month', inOperDate) AND date_trunc('month', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                           AND Movement.DescId = zc_Movement_Loss()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND MovementLinkObject_ArticleLoss.ObjectId = 13892113), 2), 0);

     -- сохранили свойство <Полное списание>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaFullChargeMonth(), vbId, - vbSumma);

     -- сохранили <Элемент документа>
    vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), inUnitId, vbMovementId, lpGet_MovementItem_WagesAE_TotalSum (vbId, vbUserId), 0);

    outSummaFullCharge := COALESCE((SELECT SUM(MIFloat_SummaFullCharge.ValueData)
                                    FROM MovementItemFloat AS MIFloat_SummaFullCharge
                                    WHERE MIFloat_SummaFullCharge.MovementItemId = vbId
                                      AND MIFloat_SummaFullCharge.DescId = zc_MIFloat_SummaFullCharge()), 0);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.03.20                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesFullCharge (inUnitID := 183289, inOperDate := '01.10.2021', inSession := '3')

 