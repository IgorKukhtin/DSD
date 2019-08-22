 -- Function: gpUpdate_Movement_Check_Deadlines()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_Deadlines (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_Deadlines(
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbJackdawsChecksId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpGetUserBySession (inSession);

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION 'Учтановка признака <Сроки.> вам запрещено.';
    END IF;

    SELECT StatusId
    INTO vbStatusId
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                      ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                     AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
    WHERE Id = inMovementId;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    IF vbStatusId = zc_Enum_Status_Complete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение признака <Сроки.> в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- Проверяем наличие и тип чека

    IF NOT EXISTS(SELECT Movement.Id
                      FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_Delay
                                                       ON Movement.Id = MovementBoolean_Delay.MovementId
                                                      AND MovementBoolean_Delay.DescId    = zc_MovementBoolean_Delay()
                                                      AND MovementBoolean_Delay.ValueData = TRUE
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                                         ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                                        AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
                            LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId


                            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                     ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                         ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                        AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                            LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

                      WHERE Movement.ID = inMovementId
                        AND Movement.DescId = zc_Movement_Check()
                        AND zc_Enum_Status_Erased() = Movement.StatusId
                        AND COALESCE(MovementString_InvNumberOrder.ValueData, '') = ''
                        AND EXISTS(SELECT *
                                   FROM MovementItem
                                   WHERE MovementItem.MovementId = Movement.ID
                                     AND MovementItem.DescId     = zc_MI_Master()
                                     AND MovementItem.isErased   = FALSE))
    THEN
        RAISE EXCEPTION 'Ошибка.Чек ненайден.';
    END IF;

    -- Пропускаем если нехватает неличия

    IF EXISTS(WITH
            tmpMov AS (SELECT Movement.Id
                           , MovementLinkObject_Unit.ObjectId AS UnitId
                       FROM Movement

                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                       WHERE Movement.Id = inMovementId
                      )
          , tmpMI_all AS (SELECT tmpMov.Id AS MovementId, tmpMov.UnitId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
                          FROM tmpMov
                               INNER JOIN MovementItem
                                       ON MovementItem.MovementId = tmpMov.Id
                                      AND MovementItem.DescId     = zc_MI_Master()
                                      AND MovementItem.isErased   = FALSE
                          GROUP BY tmpMov.Id, tmpMov.UnitId, MovementItem.ObjectId
                     )
          , tmpMI AS (SELECT tmpMI_all.UnitId, tmpMI_all.GoodsId, SUM (tmpMI_all.Amount) AS Amount
                      FROM tmpMI_all
                      GROUP BY tmpMI_all.UnitId, tmpMI_all.GoodsId
                     )
          , tmpRemains AS (SELECT tmpMI.GoodsId
                                , tmpMI.UnitId
                                , tmpMI.Amount           AS Amount_mi
                                , COALESCE (SUM (Container.Amount), 0) AS Amount_remains
                           FROM tmpMI
                                LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                   AND Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.WhereObjectId = tmpMI.UnitId
                                                   AND Container.Amount <> 0
                           GROUP BY tmpMI.GoodsId
                                  , tmpMI.UnitId
                                  , tmpMI.Amount
                           HAVING COALESCE (SUM (Container.Amount), 0) < tmpMI.Amount
                          )

          SELECT DISTINCT tmpMov.Id AS MovementId
                       FROM tmpMov
                            INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMov.Id
                            INNER JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_all.GoodsId
                                                 AND tmpRemains.UnitId  = tmpMI_all.UnitId)
    THEN
        RAISE EXCEPTION 'Ошибка.Нехватает наличия.';
        RETURN;
    END IF;



    -- Отменили удаление
    IF vbStatusId = zc_Enum_Status_Erased()
    THEN
      PERFORM gpUnComplete_Movement_Check (inMovementId, inSession, inSession);
    END IF;

    -- Установили признак галка
    SELECT Object.ID
    INTO vbJackdawsChecksId
    FROM Object
    WHERE Object.DescId = zc_Object_JackdawsChecks()
      AND Object.ObjectCode = 1;

    IF COALESCE (vbJackdawsChecksId, 0) <> 0
    THEN
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_JackdawsChecks(), inMovementId, vbJackdawsChecksId);
    END IF;


    -- Провели чек
    PERFORM gpComplete_Movement_CheckAdmin (inMovementId, 0, 0, inSession);

    -- сохранили отметку <Сроки>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deadlines(), inMovementId, True);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 04.04.19                                                                    *
*/
-- тест
-- select * from gpUpdate_Movement_Check_Deadlines(inMovementId := 12604238,  inSession := '3');