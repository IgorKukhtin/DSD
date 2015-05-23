-- Function: lpComplete_Movement_PersonalService_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalService_Recalc (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalService_Recalc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
BEGIN
     -- таблица
     DELETE FROM _tmpMovement_Recalc;
     -- таблица
     DELETE FROM _tmpMI_Recalc;

          -- формируются данные - Все документы для распределения за соответствующий <Месяц начислений>
          WITH tmpMovement AS (SELECT Movement.Id AS MovementId
                                    , Movement.StatusId
                                    , COALESCE (ObjectLink_PersonalServiceList_PaidKind, 0) AS PaidKindId
                                    , COALESCE (MovementLinkObject_PersonalServiceList.ObjectId, 0) AS PersonalServiceListId
                               FROM MovementDate AS MovementDate_ServiceDate
                                    INNER JOIN MovementDate AS MovementDate_ServiceDate_find
                                                            ON MovementDate_ServiceDate_find.ValueData = MovementDate_ServiceDate.ValueData
                                                           AND MovementDate_ServiceDate_find.DescId = zc_MIDate_ServiceDate()
                                                           -- AND MovementDate_ServiceDate.MovementId <> tmpMovement.MovementId
                                    INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate_find.MovementId
                                                       -- AND Movement.OperDate BETWEEN tmpMovement.StartDate AND tmpMovement.EndDate
	                                               AND Movement.DescId = zc_Movement_PersonalService()
                                                       AND Movement.StatusId <> zc_Enum_Status_Erased()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                                  ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                                 AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                    LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                                         ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                                        AND ObjectLink_PersonalServiceList_PaidKind.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()
                               WHERE MovementDate_ServiceDate.MovementId = inMovementId
                                 AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                              )
     -- данные по всем документам для распределения за соответствующий <Месяц начислений>
     INSERT INTO _tmpMovement_Recalc (MovementId, StatusId, PaidKindId, PersonalServiceListId)
       SELECT tmpMovement.MovementId, tmpMovement.StatusId, tmpMovement.PaidKindId, tmpMovement.PersonalServiceListId FROM tmpMovement;

     -- !!!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMovement_Recalc;

     -- формируются данные по элементам для распределения
     WITH -- Все документы в которых будем искать zc_MIFloat_SummCardRecalc
          tmpMovement_from AS (SELECT _tmpMovement_Recalc.MovementId
                               FROM _tmpMovement_Recalc
                               WHERE _tmpMovement_Recalc.PaidKindId = zc_Enum_PaidKind_FirstForm()
                                AND  (_tmpMovement_Recalc.StatusId = zc_Enum_Status_Complete()
                                   OR _tmpMovement_Recalc.MovementId = inMovementId)
                              )
          -- элементы с суммой для распределния
        , tmpMI_from AS (SELECT MovementItem.Id                               AS MovementItemId
                              , tmpMovement_from.MovementId                   AS MovementId
                              , COALESCE (MovementItem.ObjectId, 0)           AS ObjectId
                              , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
                              , COALESCE (MILinkObject_Position.ObjectId, 0)  AS PositionId
                              , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
                              , COALESCE (MILinkObject_PersonalServiceList.ObjectId, tmpMovement_from.PersonalServiceListId) AS PersonalServiceListId_to
                              , (MIFloat_SummCardRecalc.ValueData)            AS SummCardRecalc
                         FROM tmpMovement_from
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_from.MovementId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                              INNER JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                           ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                                                          AND MIFloat_SummCardRecalc.ValueData <> 0
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                               ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                               ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                               ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                               ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                        )

          -- Все документы в которые будем распределять сумму zc_MIFloat_SummCardRecalc
        , tmpMovement_to AS (SELECT MovementId, PersonalServiceListId FROM _tmpMovement_Recalc WHERE StatusId = zc_Enum_Status_Complete() AND PaidKind <> zc_Enum_PaidKind_FirstForm() AND EXISTS (SELECT SummCardRecalc FROM tmpMI_from))

              -- Все элементы в которые будем распределять сумму zc_MIFloat_SummCardRecalc
          , tmpMI_to_all AS (SELECT MovementItem.Id AS MovementItemId
                                  , COALESCE (MovementItem.ObjectId, 0)           AS ObjectId
                                  , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
                                  , COALESCE (MILinkObject_Position.ObjectId, 0)  AS PositionId
                                  , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
                                  , tmpMovement_to.PersonalServiceListId
                             FROM tmpMovement_to
                                  INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_to.MovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                   ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                   ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                            )
              , tmpMI_to AS (SELECT tmpMI_from.MovementId     AS MovementId_from
                                  , tmpMI_from.MovementItemId AS MovementItemId_from
                                  , COALESCE (tmpMI_to_all.MovementItemId, 0) AS MovementItemId_to
                                  , tmpMI_from.SummCardRecalc
                             FROM tmpMI_from
                                  LEFT JOIN tmpMI_to_all ON tmpMI_to_all.ObjectId    = tmpMI_from.ObjectId
                                                        AND tmpMI_to_all.UnitId      = tmpMI_from.UnitId
                                                        AND tmpMI_to_all.PositionId  = tmpMI_from.PositionId
                                                        AND tmpMI_to_all.InfoMoneyId = tmpMI_from.InfoMoneyId
                                                        AND tmpMI_to_all.SummToPay   >= tmpMI_from.SummCardRecalc
                            )
     -- данные по элементам для распределения
     INSERT INTO _tmpMI_Recalc (MovementId_from, MovementItemId_from, MovementItemId_to, SummCardRecalc)
       SELECT MovementId_from, MovementItemId_from, MAX (MovementItemId_to), SummCardRecalc FROM tmpMI_to GROUP BY MovementId_from, MovementItemId_from, SummCardRecalc;
     -- !!!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMI_Recalc;


     -- !!!Выход если нет <Сумма на карточку (БН) для распределения>!!!
     IF NOT EXISTS (SELECT MovementId_from FROM _tmpMI_Recalc)
     THEN RETURN;
     END IF;


     -- устанавливается в 0 свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItem.Id, 0)
     FROM _tmpMovement_Recalc
          INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement_Recalc.MovementId AND MovementItem.DescId = zc_MI_Master();

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItemId_to, SummCardRecalc)
     FROM _tmpMI_Recalc
     WHERE MovementItemId_to <> 0;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(), MovementItemId_from, CASE WHEN MovementItemId_to <> 0 THEN 0 ELSE SummCardRecalc END)
     FROM _tmpMI_Recalc;

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (tmp.MovementId_from)
     FROM (SELECT MovementId_from FROM _tmpMI_Recalc GROUP BY MovementId_from) AS tmp;

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (MovementId)
     FROM _tmpMovement_Recalc;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.15                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_PersonalService_Recalc (inMovementId:= 429713, inUserId:= zfCalc_UserAdmin() :: Integer)
