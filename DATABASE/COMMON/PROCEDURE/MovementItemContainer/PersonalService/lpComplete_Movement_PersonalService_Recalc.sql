 -- Function: lpComplete_Movement_PersonalService_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalService_Recalc (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalService_Recalc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbPersonalServiceListId_to_check Integer;
BEGIN
     -- таблица
     DELETE FROM _tmpMovement_Recalc;
     -- таблица
     DELETE FROM _tmpMI_Recalc;


     -- обновили PersonalServiceListId
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), MovementItem.Id, ObjectLink_Personal_PersonalServiceList.ChildObjectId)
     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                           ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = MovementItem.ObjectId
                              AND ObjectLink_Personal_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
       AND MILinkObject_PersonalServiceList.ObjectId IS NULL;



     -- сохранили список по всем документам за соответствующий <Месяц начислений>
     INSERT INTO _tmpMovement_Recalc (MovementId, StatusId, PersonalServiceListId, PaidKindId, ServiceDate, isRecalc, isRecalc_next)
        SELECT Movement.Id AS MovementId
             , Movement.StatusId
             , COALESCE (MovementLinkObject_PersonalServiceList.ObjectId, 0)       AS PersonalServiceListId
             , COALESCE (ObjectLink_PersonalServiceList_PaidKind.ChildObjectId, 0) AS PaidKindId
             , MovementDate_ServiceDate.ValueData                                  AS ServiceDate
             , CASE WHEN MovementFloat_TotalSummCard.ValueData         <> 0
                      OR MovementFloat_TotalSummCardSecond.ValueData   <> 0
                      OR MovementFloat_TotalSummAvCardSecond.ValueData <> 0
                      OR MovementFloat_TotalSummNalog.ValueData        <> 0
                      OR MovementFloat_TotalSummChild.ValueData        <> 0
                      OR MovementFloat_TotalSummMinusExt.ValueData     <> 0
                      OR MovementFloat_TotalSummNalogRet.ValueData     <> 0
                      OR MovementFloat_TotalSummAddOth.ValueData       <> 0
                      OR MovementFloat_TotalSummFineOth.ValueData      <> 0
                      OR MovementFloat_TotalSummHospOth.ValueData      <> 0
                      OR MovementFloat_TotalSummCompensation.ValueData <> 0
                      OR MovementFloat_TotalAvance.ValueData           <> 0
                         THEN TRUE
                    ELSE FALSE
               END AS isRecalc
               
               -- для Відомість 4.Лікарняні за рахунок ПФ
             , CASE WHEN MovementFloat_TotalSummCard.ValueData         <> 0
                         THEN TRUE
                    ELSE FALSE
               END AS isRecalc_next

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
                                          AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
             LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                  ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                                 AND ObjectLink_PersonalServiceList_PaidKind.DescId   = zc_ObjectLink_PersonalServiceList_PaidKind()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                     ON MovementFloat_TotalSummCard.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardSecond
                                     ON MovementFloat_TotalSummCardSecond.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummCardSecond.DescId = zc_MovementFloat_TotalSummCardSecond()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummAvCardSecond
                                     ON MovementFloat_TotalSummAvCardSecond.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummAvCardSecond.DescId = zc_MovementFloat_TotalSummAvCardSecond()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummNalog
                                     ON MovementFloat_TotalSummNalog.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummNalog.DescId = zc_MovementFloat_TotalSummNalog()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummChild
                                     ON MovementFloat_TotalSummChild.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummChild.DescId = zc_MovementFloat_TotalSummChild()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummMinusExt
                                     ON MovementFloat_TotalSummMinusExt.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummMinusExt.DescId     = zc_MovementFloat_TotalSummMinusExt()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummNalogRet
                                     ON MovementFloat_TotalSummNalogRet.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummNalogRet.DescId = zc_MovementFloat_TotalSummNalogRet()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummAddOth
                                     ON MovementFloat_TotalSummAddOth.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummAddOth.DescId = zc_MovementFloat_TotalSummAddOth()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummFineOth
                                     ON MovementFloat_TotalSummFineOth.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummFineOth.DescId     = zc_MovementFloat_TotalSummFineOth()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummHospOth
                                     ON MovementFloat_TotalSummHospOth.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummHospOth.DescId     = zc_MovementFloat_TotalSummHospOth()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummCompensation
                                     ON MovementFloat_TotalSummCompensation.MovementId = Movement.Id
                                    AND MovementFloat_TotalSummCompensation.DescId     = zc_MovementFloat_TotalSummCompensation()
             LEFT JOIN MovementFloat AS MovementFloat_TotalAvance
                                     ON MovementFloat_TotalAvance.MovementId = Movement.Id
                                    AND MovementFloat_TotalAvance.DescId     = zc_MovementFloat_TotalAvance()
                                    
        WHERE MovementDate_ServiceDate.MovementId = inMovementId
          AND MovementDate_ServiceDate.DescId     = zc_MIDate_ServiceDate();
     -- !!!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMovement_Recalc;


     -- формируются данные по элементам для переноса данных
     WITH -- Все документы из которых будем переносить сумму SummCardRecalc + SummCardSecondRecalc + SummAvCardSecondRecalc + SummNalogRecalc + SummNalogRetRecalc + SummChildRecalc + SummMinusExtRecalc + SummAddOthRecalc + SummFineOthRecalc + SummHospOthRecalc + SummCompensationRecalc, по идее таких документов 2
          tmpMovement_from AS (SELECT _tmpMovement_Recalc.MovementId, _tmpMovement_Recalc.ServiceDate, _tmpMovement_Recalc.PersonalServiceListId
                               FROM _tmpMovement_Recalc
                               WHERE _tmpMovement_Recalc.PaidKindId  = zc_Enum_PaidKind_FirstForm() -- обязательно БН
                                AND  (_tmpMovement_Recalc.StatusId   = zc_Enum_Status_Complete()    -- или проведенный (т.к. будет обнуление всех SummCard + SummNalog + SummNalogRet + SummChild + SummMinusExt + SummAddOth + SummFineOth + SummHospOth)
                                   OR _tmpMovement_Recalc.MovementId = inMovementId)                -- или текущий
                              )
          -- элементы с суммой для переноса
        , tmpMI_from AS (SELECT MovementItem.Id                                         AS MovementItemId
                              , tmpMovement_from.MovementId                             AS MovementId
                              , tmpMovement_from.ServiceDate                            AS ServiceDate
                              , tmpMovement_from.PersonalServiceListId                  AS PersonalServiceListId
                              , COALESCE (MovementItem.ObjectId, 0)                     AS ObjectId
                              , COALESCE (MILinkObject_Unit.ObjectId, 0)                AS UnitId
                              , COALESCE (MILinkObject_Position.ObjectId, 0)            AS PositionId
                              , COALESCE (MILinkObject_InfoMoney.ObjectId, 0)           AS InfoMoneyId
                              , COALESCE (MILinkObject_PersonalServiceList.ObjectId, 0) AS PersonalServiceListId_to -- !!!в какую ведедомость будем переносить, иначе перенесем в текущий MovementItemId!!!
                              , COALESCE (MIFloat_SummCardRecalc.ValueData, 0)          AS SummCardRecalc
                              , COALESCE (MIFloat_SummCardSecondRecalc.ValueData, 0)    AS SummCardSecondRecalc
                              , COALESCE (MIFloat_SummAvCardSecondRecalc.ValueData, 0)  AS SummAvCardSecondRecalc
                              , COALESCE (MIFloat_SummNalogRecalc.ValueData, 0)         AS SummNalogRecalc
                              , COALESCE (MIFloat_SummNalogRetRecalc.ValueData, 0)      AS SummNalogRetRecalc
                              , COALESCE (MIFloat_SummChildRecalc.ValueData, 0)         AS SummChildRecalc
                              , COALESCE (MIFloat_SummMinusExtRecalc.ValueData, 0)      AS SummMinusExtRecalc
                              , COALESCE (MIFloat_SummAddOthRecalc.ValueData, 0)        AS SummAddOthRecalc
                              , COALESCE (MIFloat_SummFineOthRecalc.ValueData, 0)       AS SummFineOthRecalc
                              , COALESCE (MIFloat_SummHospOthRecalc.ValueData, 0)       AS SummHospOthRecalc
                              , COALESCE (MIFloat_SummCompensationRecalc.ValueData, 0)  AS SummCompensationRecalc
                              , COALESCE (MIFloat_SummAvanceRecalc.ValueData, 0)        AS SummAvanceRecalc
                         FROM tmpMovement_from
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement_from.MovementId
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                          ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondRecalc
                                                          ON MIFloat_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummCardSecondRecalc.DescId = zc_MIFloat_SummCardSecondRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecondRecalc
                                                          ON MIFloat_SummAvCardSecondRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummAvCardSecondRecalc.DescId = zc_MIFloat_SummAvCardSecondRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRecalc
                                                          ON MIFloat_SummNalogRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummNalogRecalc.DescId = zc_MIFloat_SummNalogRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRetRecalc
                                                          ON MIFloat_SummNalogRetRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummNalogRetRecalc.DescId = zc_MIFloat_SummNalogRetRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummChildRecalc
                                                          ON MIFloat_SummChildRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummChildRecalc.DescId = zc_MIFloat_SummChildRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummMinusExtRecalc
                                                          ON MIFloat_SummMinusExtRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummMinusExtRecalc.DescId = zc_MIFloat_SummMinusExtRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummAddOthRecalc
                                                          ON MIFloat_SummAddOthRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummAddOthRecalc.DescId = zc_MIFloat_SummAddOthRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummFineOthRecalc
                                                          ON MIFloat_SummFineOthRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummFineOthRecalc.DescId = zc_MIFloat_SummFineOthRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummHospOthRecalc
                                                          ON MIFloat_SummHospOthRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummHospOthRecalc.DescId = zc_MIFloat_SummHospOthRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummCompensationRecalc
                                                          ON MIFloat_SummCompensationRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummCompensationRecalc.DescId = zc_MIFloat_SummCompensationRecalc()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummAvanceRecalc
                                                          ON MIFloat_SummAvanceRecalc.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummAvanceRecalc.DescId = zc_MIFloat_SummAvanceRecalc()
                                                         
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
                                                              AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()
                         -- т.е. есть что переносить
                         WHERE MIFloat_SummCardRecalc.ValueData         <> 0
                            OR MIFloat_SummCardSecondRecalc.ValueData   <> 0
                            OR MIFloat_SummAvCardSecondRecalc.ValueData <> 0
                            OR MIFloat_SummNalogRecalc.ValueData        <> 0
                            OR MIFloat_SummNalogRetRecalc.ValueData     <> 0
                            OR MIFloat_SummChildRecalc.ValueData        <> 0
                            OR MIFloat_SummMinusExtRecalc.ValueData     <> 0
                            OR MIFloat_SummAddOthRecalc.ValueData       <> 0
                            OR MIFloat_SummFineOthRecalc.ValueData      <> 0
                            OR MIFloat_SummHospOthRecalc.ValueData      <> 0
                            OR MIFloat_SummCompensationRecalc.ValueData <> 0
                            OR MIFloat_SummAvanceRecalc.ValueData       <> 0
                        )

          -- Все документы в которые будем переносить сумму SummCardRecalc + SummCardSecondRecalc + SummAvCardSecondRecalc + SummNalogRecalc + SummNalogRetRecalc + SummChildRecalc + SummMinusExtRecalc + SummAddOthRecalc + SummFineOthRecalc + SummHospOthRecalc + SummCompensationRecalc (здесь нет документов в которых сумма "останется")
        , tmpMovement_to AS (SELECT MovementId, PersonalServiceListId, StatusId
                             FROM _tmpMovement_Recalc
                             WHERE PaidKindId <> zc_Enum_PaidKind_FirstForm() OR isRecalc_next = TRUE
                               AND EXISTS (SELECT 1 FROM tmpMI_from))

            -- Все элементы по которым будем искать куда переносить сумму SummCardRecalc + SummCardSecondRecalc + SummAvCardSecondRecalc + SummNalogRecalc + SummNalogRetRecalc + SummChildRecalc + SummMinusExtRecalc + SummAddOthRecalc + SummFineOthRecalc + SummHospOthRecalc + SummCompensationRecalc
          , tmpMI_to_all AS (SELECT tmpMovement_to.PersonalServiceListId          AS PersonalServiceListId
                                  , tmpMovement_to.MovementId                     AS MovementId
                                  , MovementItem.Id                               AS MovementItemId
                                  , COALESCE (MovementItem.ObjectId, 0)           AS ObjectId
                                  , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
                                  , COALESCE (MILinkObject_Position.ObjectId, 0)  AS PositionId
                                  , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
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
                -- находим документы и элементы в которые перенесем сумму SummCardRecalc + SummCardSecondRecalc + SummAvCardSecondRecalc + SummNalogRecalc + SummNalogRetRecalc + SummChildRecalc + SummMinusExtRecalc
              , tmpMI_to AS (SELECT tmpMI_from.MovementId     AS MovementId_from
                                  , tmpMI_from.MovementItemId AS MovementItemId_from
                                  , COALESCE (tmpMovement_to.MovementId, COALESCE (tmpMovement_to_UnComplete.MovementId, 0)) AS MovementId_to
                                  , COALESCE (tmpMI_to_all.MovementItemId, 0)                                                AS MovementItemId_to
                             FROM tmpMI_from
                                  -- сначала найдем документ zc_Enum_Status_Complete
                                  LEFT JOIN tmpMovement_to ON tmpMovement_to.PersonalServiceListId = tmpMI_from.PersonalServiceListId_to
                                                          AND tmpMovement_to.StatusId = zc_Enum_Status_Complete()
                                  -- если не нашли, тогда уже документ zc_Enum_Status_UnComplete
                                  LEFT JOIN tmpMovement_to AS tmpMovement_to_UnComplete
                                                           ON tmpMovement_to_UnComplete.PersonalServiceListId = tmpMI_from.PersonalServiceListId_to
                                                          AND tmpMovement_to.PersonalServiceListId IS NULL
                                  -- находим элементы
                                  LEFT JOIN tmpMI_to_all ON tmpMI_to_all.MovementId            = COALESCE (tmpMovement_to.MovementId, tmpMovement_to_UnComplete.MovementId)
                                                        AND tmpMI_to_all.ObjectId              = tmpMI_from.ObjectId
                                                        AND tmpMI_to_all.UnitId                = tmpMI_from.UnitId
                                                        AND tmpMI_to_all.PositionId            = tmpMI_from.PositionId
                                                        AND tmpMI_to_all.InfoMoneyId           = tmpMI_from.InfoMoneyId
                                                        AND tmpMI_to_all.PersonalServiceListId = tmpMI_from.PersonalServiceListId_to
                            )
     -- данные что куда переносим
     INSERT INTO _tmpMI_Recalc (MovementId_from, MovementItemId_from, PersonalServiceListId_from, MovementId_to, MovementItemId_to
                              , PersonalServiceListId_to, ServiceDate, UnitId, PersonalId, PositionId, InfoMoneyId
                              , SummCardRecalc, SummCardSecondRecalc, SummAvCardSecondRecalc, SummNalogRecalc, SummNalogRetRecalc, SummChildRecalc, SummMinusExtRecalc, SummAddOthRecalc
                              , SummFineOthRecalc, SummHospOthRecalc, SummCompensationRecalc, SummAvanceRecalc
                              , isMovementComplete)
       SELECT tmpMI_from.MovementId            AS MovementId_from
            , tmpMI_from.MovementItemId        AS MovementItemId_from
            , tmpMI_from.PersonalServiceListId AS PersonalServiceListId_from
            , COALESCE (tmpMI_to.MovementId_to, tmpMI_to_Movement.MovementId_to) AS MovementId_to
            , COALESCE (tmpMI_to.MovementItemId_to, 0)                           AS MovementItemId_to
            , tmpMI_from.PersonalServiceListId_to
            , tmpMI_from.ServiceDate
            , tmpMI_from.UnitId
            , tmpMI_from.ObjectId
            , tmpMI_from.PositionId
            , tmpMI_from.InfoMoneyId
            , tmpMI_from.SummCardRecalc
            , tmpMI_from.SummCardSecondRecalc
            , tmpMI_from.SummAvCardSecondRecalc
            , tmpMI_from.SummNalogRecalc
            , tmpMI_from.SummNalogRetRecalc
            , tmpMI_from.SummChildRecalc
            , tmpMI_from.SummMinusExtRecalc
            , tmpMI_from.SummAddOthRecalc
            , tmpMI_from.SummFineOthRecalc
            , tmpMI_from.SummHospOthRecalc
            , tmpMI_from.SummCompensationRecalc
            , tmpMI_from.SummAvanceRecalc
            -- , CASE WHEN tmpMI_to.MovementItemId_to IS NULL AND tmpMovement_to.StatusId = zc_Enum_Status_Complete() THEN TRUE ELSE FALSE END AS isMovementComplete
            , CASE WHEN tmpMovement_to.StatusId = zc_Enum_Status_Complete() THEN TRUE ELSE FALSE END AS isMovementComplete
       FROM tmpMI_from
            -- из списка берется только один
            LEFT JOIN (SELECT tmpMI_to.MovementItemId_from, MAX (tmpMI_to.MovementItemId_to) AS MovementItemId_to FROM tmpMI_to WHERE tmpMI_to.MovementItemId_to <> 0 GROUP BY tmpMI_to.MovementItemId_from) AS tmp ON tmp.MovementItemId_from = tmpMI_from.MovementItemId
            -- если нашли MovementItemId_to, тогда нужен будет его MovementId_to
            LEFT JOIN tmpMI_to ON tmpMI_to.MovementItemId_from = tmp.MovementItemId_from
                              AND tmpMI_to.MovementItemId_to = tmp.MovementItemId_to
            -- если не нашли MovementItemId_to, тогда нужен MovementId_to
            LEFT JOIN tmpMI_to AS tmpMI_to_Movement ON tmpMI_to_Movement.MovementItemId_from = tmpMI_from.MovementItemId
                                                   AND tmpMI_to_Movement.MovementItemId_to = 0
            LEFT JOIN tmpMovement_to ON tmpMovement_to.MovementId = COALESCE (tmpMI_to.MovementId_to, tmpMI_to_Movement.MovementId_to)
      ;
     -- !!!!!!!!!!!!!!!!!!!!!!!
     ANALYZE _tmpMI_Recalc;


     -- распроводятся документы
     PERFORM lpUnComplete_Movement (inMovementId := tmp.MovementId_to
                                  , inUserId     := -1 * inUserId
                                   )
     FROM (SELECT DISTINCT _tmpMI_Recalc.MovementId_to FROM _tmpMI_Recalc WHERE _tmpMI_Recalc.isMovementComplete = TRUE
          UNION
           SELECT DISTINCT _tmpMovement_Recalc.MovementId AS MovementId_to FROM _tmpMovement_Recalc WHERE _tmpMovement_Recalc.StatusId = zc_Enum_Status_Complete() AND _tmpMovement_Recalc.isRecalc = TRUE
          ) AS tmp;


     -- создаются новые документы (!!!потом их надо провести!!!)
     UPDATE _tmpMI_Recalc SET MovementId_to      = tmp.MovementId_to
                            , isMovementComplete = TRUE
     FROM (SELECT lpInsertUpdate_Movement_PersonalService (ioId                      := 0
                                                         , inInvNumber               := CAST (NEXTVAL ('movement_personalservice_seq') AS TVarChar)
                                                         , inOperDate                := DATE_TRUNC ('MONTH', tmp.ServiceDate + INTERVAL '1 MONTH')
                                                         , inServiceDate             := tmp.ServiceDate
                                                         , inComment                 := ''
                                                         , inPersonalServiceListId   := tmp.PersonalServiceListId_to
                                                         , inJuridicalId             := ObjectLink_PersonalServiceList_Juridical.ChildObjectId
                                                         , inUserId                  := inUserId
                                                          ) AS MovementId_to
                , tmp.PersonalServiceListId_to
           FROM (SELECT _tmpMI_Recalc.PersonalServiceListId_to
                      , _tmpMI_Recalc.ServiceDate
                 FROM _tmpMI_Recalc
                 WHERE _tmpMI_Recalc.MovementId_to = 0
                   AND _tmpMI_Recalc.PersonalServiceListId_to <> 0 -- !!!важно, т.е. если введено куда переносить!!!
                 GROUP BY _tmpMI_Recalc.PersonalServiceListId_to
                        , _tmpMI_Recalc.ServiceDate
                ) AS tmp
                LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Juridical
                                     ON ObjectLink_PersonalServiceList_Juridical.ObjectId = tmp.PersonalServiceListId_to
                                    AND ObjectLink_PersonalServiceList_Juridical.DescId = zc_ObjectLink_PersonalServiceList_Juridical()
         ) AS tmp
     WHERE _tmpMI_Recalc.PersonalServiceListId_to = tmp.PersonalServiceListId_to;

 
      -- создаются новые элементы
     UPDATE _tmpMI_Recalc SET MovementItemId_to = tmp.MovementItemId_to
     FROM (SELECT lpInsertUpdate_MovementItem_PersonalService_item (ioId                 := 0
                                                                  , inMovementId         := _tmpMI_Recalc.MovementId_to
                                                                  , inPersonalId         := _tmpMI_Recalc.PersonalId
                                                                  , inIsMain             := CASE WHEN _tmpMI_Recalc.isMain = 1 THEN TRUE ELSE FALSE END

                                                                  , inSummService        := 0 :: TFloat
                                                                  , inSummCardRecalc     := 0 :: TFloat
                                                                  , inSummCardSecondRecalc:= 0 :: TFloat
                                                                  , inSummCardSecondCash := 0 :: TFloat
                                                                  , inSummAvCardSecondRecalc:= 0 :: TFloat
                                                                  , inSummNalogRecalc    := 0 :: TFloat
                                                                  , inSummNalogRetRecalc := 0 :: TFloat
                                                                  , inSummMinus          := 0 :: TFloat
                                                                  , inSummAdd            := 0 :: TFloat
                                                                  , inSummAddOthRecalc   := 0 :: TFloat

                                                                  , inSummHoliday        := 0 :: TFloat
                                                                  , inSummSocialIn       := 0 :: TFloat
                                                                  , inSummSocialAdd      := 0 :: TFloat
                                                                  , inSummChildRecalc    := 0 :: TFloat
                                                                  , inSummMinusExtRecalc := 0 :: TFloat

                                                                  , inSummFine           := 0 :: TFloat
                                                                  , inSummFineOthRecalc  := 0 :: TFloat
                                                                  , inSummHosp           := 0 :: TFloat
                                                                  , inSummHospOthRecalc  := 0 :: TFloat

                                                                  , inSummCompensationRecalc:= 0 :: TFloat
                                                                  , inSummAuditAdd       := 0 :: TFloat
                                                                  , inSummHouseAdd       := 0 :: TFloat
                                                                  , inSummAvanceRecalc   := 0 :: TFloat

                                                                  , inNumber             := ''
                                                                  , inComment            := ''
                                                                  , inInfoMoneyId        := _tmpMI_Recalc.InfoMoneyId
                                                                  , inUnitId             := _tmpMI_Recalc.UnitId
                                                                  , inPositionId         := _tmpMI_Recalc.PositionId
                                                                  , inMemberId           := NULL
                                                                  , inPersonalServiceListId  := _tmpMI_Recalc.PersonalServiceListId_to
                                                                  , inFineSubjectId      := NULL
                                                                  , inUnitFineSubjectId  := NULL
                                                                  , inUserId             := inUserId
                                                                   ) AS MovementItemId_to
                , _tmpMI_Recalc.MovementId_to
                , _tmpMI_Recalc.PersonalServiceListId_to
                , _tmpMI_Recalc.PersonalId
                , _tmpMI_Recalc.InfoMoneyId
                , _tmpMI_Recalc.UnitId
                , _tmpMI_Recalc.PositionId
           FROM (SELECT _tmpMI_Recalc.MovementId_to
                      , _tmpMI_Recalc.PersonalServiceListId_to
                      , _tmpMI_Recalc.PersonalId
                      , _tmpMI_Recalc.InfoMoneyId
                      , _tmpMI_Recalc.UnitId
                      , _tmpMI_Recalc.PositionId
                      , MAX (CASE WHEN COALESCE (MIBoolean_Main.ValueData, FALSE) = TRUE THEN 1 ELSE 0 END) AS isMain
                 FROM _tmpMI_Recalc
                      LEFT JOIN MovementItemBoolean AS MIBoolean_Main
                                                    ON MIBoolean_Main.MovementItemId = _tmpMI_Recalc.MovementItemId_from
                                                   AND MIBoolean_Main.DescId = zc_MIBoolean_Main()
                 WHERE _tmpMI_Recalc.MovementItemId_to       = 0
                   AND _tmpMI_Recalc.PersonalServiceListId_to <> 0 -- !!!важно, т.е. если введено куда переносить!!!
                 GROUP BY _tmpMI_Recalc.MovementId_to
                        , _tmpMI_Recalc.PersonalServiceListId_to
                        , _tmpMI_Recalc.PersonalId
                        , _tmpMI_Recalc.InfoMoneyId
                        , _tmpMI_Recalc.UnitId
                        , _tmpMI_Recalc.PositionId
                ) AS _tmpMI_Recalc
         ) AS tmp

     WHERE  _tmpMI_Recalc.MovementId_to            = tmp.MovementId_to
      -- AND _tmpMI_Recalc.PersonalServiceListId_to = tmp.PersonalServiceListId_to
       AND _tmpMI_Recalc.PersonalId               = tmp.PersonalId
       AND _tmpMI_Recalc.InfoMoneyId              = tmp.InfoMoneyId
       AND _tmpMI_Recalc.UnitId                   = tmp.UnitId
       AND _tmpMI_Recalc.PositionId               = tmp.PositionId
    ;

     -- !!!Выход если нет <Сумма на карточку (БН) для распределения>!!!
     -- IF NOT EXISTS (SELECT MovementId_from FROM _tmpMI_Recalc)
     -- THEN RETURN;
     -- END IF;


     -- сначала обнуляется у всех свойства <zc_MIFloat_SummCard> + <zc_MIFloat_SummCardSecond> + <zc_MIFloat_SummAvCardSecond> + <zc_MIFloat_SummNalog> + <zc_MIFloat_SummNalogRet> + <zc_MIFloat_SummChild> + <zc_MIFloat_SummMinusExt>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(),         MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecond(),   MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvCardSecond(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalog(),        MovementItem.Id, 0)
        -- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRet(),     MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChild(),        MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinusExt(),     MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAddOth(),       MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummFineOth(),      MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHospOth(),      MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCompensation(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), MovementItem.Id, CASE WHEN _tmpMovement_Recalc.PaidKindId = zc_Enum_PaidKind_FirstForm() THEN MILinkObject_PersonalServiceList.ObjectId ELSE NULL END)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvance(),       MovementItem.Id, 0)
     FROM _tmpMovement_Recalc
          INNER JOIN MovementItem ON MovementItem.MovementId = _tmpMovement_Recalc.MovementId AND MovementItem.DescId = zc_MI_Master()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                           ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList();

     -- сохранили свойства <zc_MIFloat_SummCard> + <zc_MIFloat_SummCardSecond> + <zc_MIFloat_SummAvCardSecond> + <zc_MIFloat_SummNalog> + <zc_MIFloat_SummNalogRet> + <zc_MIFloat_SummChild> + <zc_MIFloat_SummMinusExt>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(),         MovementItemId_to, SummCardRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecond(),   MovementItemId_to, SummCardSecondRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvCardSecond(), MovementItemId_to, SummAvCardSecondRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalog(),        MovementItemId_to, SummNalogRecalc)
        -- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRet(),     MovementItemId_to, SummNalogRetRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChild(),        MovementItemId_to, SummChildRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinusExt(),     MovementItemId_to, SummMinusExtRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAddOth(),       MovementItemId_to, SummAddOthRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummFineOth(),      MovementItemId_to, SummFineOthRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHospOth(),      MovementItemId_to, SummHospOthRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCompensation(), MovementItemId_to, SummCompensationRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvance(),       MovementItemId_to, SummAvanceRecalc)
           -- , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), MovementItemId_to, PersonalServiceListId_from)
     FROM (SELECT _tmpMI_Recalc.MovementItemId_to
                 /*, _tmpMI_Recalc.PersonalServiceListId_from,*/
                , SUM (_tmpMI_Recalc.SummCardRecalc)         AS SummCardRecalc
                , SUM (_tmpMI_Recalc.SummCardSecondRecalc)   AS SummCardSecondRecalc
                , SUM (_tmpMI_Recalc.SummAvCardSecondRecalc) AS SummAvCardSecondRecalc
                , SUM (_tmpMI_Recalc.SummNalogRecalc)        AS SummNalogRecalc
                , SUM (_tmpMI_Recalc.SummNalogRetRecalc)     AS SummNalogRetRecalc
                , SUM (_tmpMI_Recalc.SummChildRecalc)        AS SummChildRecalc
                , SUM (_tmpMI_Recalc.SummMinusExtRecalc)     AS SummMinusExtRecalc
                , SUM (_tmpMI_Recalc.SummAddOthRecalc)       AS SummAddOthRecalc
                , SUM (_tmpMI_Recalc.SummFineOthRecalc)      AS SummFineOthRecalc
                , SUM (_tmpMI_Recalc.SummHospOthRecalc)      AS SummHospOthRecalc
                , SUM (_tmpMI_Recalc.SummCompensationRecalc) AS SummCompensationRecalc
                , SUM (_tmpMI_Recalc.SummAvanceRecalc)       AS SummAvanceRecalc
           FROM _tmpMI_Recalc
           GROUP BY _tmpMI_Recalc.MovementItemId_to /*, _tmpMI_Recalc.PersonalServiceListId_from*/
           ) AS _tmpMI_Recalc
     WHERE MovementItemId_to <> 0;

     -- для остальных переносится в текущий MovementItemId
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCard(),         MovementItemId_from, SummCardRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardSecond(),   MovementItemId_from, SummCardSecondRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvCardSecond(), MovementItemId_from, SummAvCardSecondRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalog(),        MovementItemId_from, SummNalogRecalc)
        -- , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummNalogRet(),     MovementItemId_from, SummNalogRetRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChild(),        MovementItemId_from, SummChildRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinusExt(),     MovementItemId_from, SummMinusExtRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAddOth(),       MovementItemId_from, SummAddOthRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummFineOth(),      MovementItemId_from, SummFineOthRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHospOth(),      MovementItemId_from, SummHospOthRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCompensation(), MovementItemId_from, SummCompensationRecalc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAvance(),       MovementItemId_from, SummAvanceRecalc)
     FROM _tmpMI_Recalc
     WHERE MovementItemId_to = 0;

     -- пересчитали у всех Итоговые суммы
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (tmp.MovementId)
     FROM (SELECT _tmpMovement_Recalc.MovementId FROM _tmpMovement_Recalc UNION SELECT DISTINCT _tmpMI_Recalc.MovementId_to FROM _tmpMI_Recalc WHERE _tmpMI_Recalc.isMovementComplete = TRUE) AS tmp;


     -- !!!ВАЖНО - проверка!!!
     vbPersonalServiceListId_to_check:= (SELECT tmp.PersonalServiceListId_to
                                         FROM (SELECT DISTINCT _tmpMI_Recalc.PersonalServiceListId_to FROM _tmpMI_Recalc WHERE _tmpMI_Recalc.MovementItemId_to <> 0 AND _tmpMI_Recalc.PersonalServiceListId_to <> 0) AS tmp
                                              LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                                   ON ObjectLink_PersonalServiceList_Member.ObjectId = tmp.PersonalServiceListId_to
                                                                  AND ObjectLink_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
                                              LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                                   ON ObjectLink_User_Member.ChildObjectId = ObjectLink_PersonalServiceList_Member.ChildObjectId
                                                                  AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                         WHERE ObjectLink_User_Member.ObjectId IS NULL
                                         LIMIT 1
                                        );
     IF vbPersonalServiceListId_to_check <> 0 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Для ведомости <%> не установлено <Физ.лицо (пользователь)>.', lfGet_Object_ValueData (vbPersonalServiceListId_to_check);
     END IF;

     -- !!!ВАЖНО - доступ!!!
     UPDATE Movement SET AccessKeyId = tmp.AccessKeyId
     FROM (WITH tmp AS (SELECT DISTINCT _tmpMI_Recalc.MovementId_to, _tmpMI_Recalc.PersonalServiceListId_to FROM _tmpMI_Recalc WHERE _tmpMI_Recalc.MovementItemId_to <> 0 AND _tmpMI_Recalc.PersonalServiceListId_to <> 0)
           SELECT tmp.MovementId_to
                , lpGetAccessKey (ObjectLink_User_Member.ObjectId, zc_Enum_Process_InsertUpdate_Movement_PersonalService(), tmp.PersonalServiceListId_to) AS AccessKeyId
           FROM tmp
                -- Физ лица(пользователь)
                LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                     ON ObjectLink_PersonalServiceList_Member.ObjectId = tmp.PersonalServiceListId_to
                                    AND ObjectLink_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
                -- Руководитель подразделения
                LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PersonalHead
                                     ON ObjectLink_PersonalServiceList_PersonalHead.ObjectId = tmp.PersonalServiceListId_to
                                    AND ObjectLink_PersonalServiceList_PersonalHead.DescId   = zc_ObjectLink_PersonalServiceList_PersonalHead()
                -- Руководитель подразделения
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                     ON ObjectLink_Personal_Member.ObjectId = ObjectLink_PersonalServiceList_PersonalHead.ChildObjectId
                                    AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                -- 
                LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                     ON ObjectLink_User_Member.ChildObjectId = COALESCE (ObjectLink_PersonalServiceList_Member.ChildObjectId, ObjectLink_Personal_Member.ChildObjectId, ObjectLink_PersonalServiceList_PersonalHead.ChildObjectId)
                                    AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
          ) AS tmp
     WHERE Movement.Id = tmp.MovementId_to
       AND COALESCE (Movement.AccessKeyId, 0) <> tmp.AccessKeyId
    ;



     -- Проведение Новых док-тов  + сохранили протокол
     -- PERFORM lpComplete_Movement (inMovementId := tmp.MovementId_to
     --                            , inDescId     := zc_Movement_PersonalService()
     --                            , inUserId     := inUserId
     --                             )
     PERFORM lpComplete_Movement_PersonalService (inMovementId := tmp.MovementId_to
                                                , inUserId     := -1 * inUserId
                                                 )
     FROM (SELECT DISTINCT _tmpMI_Recalc.MovementId_to FROM _tmpMI_Recalc WHERE _tmpMI_Recalc.isMovementComplete = TRUE
          UNION
           SELECT DISTINCT _tmpMovement_Recalc.MovementId AS MovementId_to FROM _tmpMovement_Recalc WHERE _tmpMovement_Recalc.StatusId = zc_Enum_Status_Complete() AND _tmpMovement_Recalc.isRecalc = TRUE
          ) AS tmp;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.18         *
 24.02.17         *
 22.05.15                                        * all
 04.01.15                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_PersonalService_Recalc (inMovementId:= 429713, inUserId:= zfCalc_UserAdmin() :: Integer)
