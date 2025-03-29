-- Function: lpComplete_Movement_PersonalService (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalService (Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalService (Integer, Integer);
-- DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalService (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalService(
    IN inMovementId          Integer               , -- ключ Документа
--  IN inIsPersonalOut_check Boolean  DEFAULT TRUE , --
    IN inUserId              Integer                 -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_check      Integer;
   DECLARE vbServiceDate           TDateTime;
   DECLARE vbServiceDateId         Integer;
   DECLARE vbServiceDateId_next    Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbMovementItemId_err    Integer;
   DECLARE vbInsertDate            TDateTime;
   DECLARE vbIsNalog               Boolean;
BEGIN
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMovement_Recalc'))
     THEN
         -- таблица - по документам, для lpComplete_Movement_PersonalService_Recalc
         DELETE FROM _tmpMovement_Recalc;
         -- таблица - по элементам, для lpComplete_Movement_PersonalService_Recalc
         DELETE FROM _tmpMI_Recalc;
     ELSE
         -- таблица - по документам, для lpComplete_Movement_PersonalService_Recalc
         CREATE TEMP TABLE _tmpMovement_Recalc (MovementId Integer, StatusId Integer, PersonalServiceListId Integer, PaidKindId Integer, ServiceDate TDateTime, isRecalc Boolean, isRecalc_next Boolean) ON COMMIT DROP;
         -- таблица - по элементам, для lpComplete_Movement_PersonalService_Recalc
         CREATE TEMP TABLE _tmpMI_Recalc (MovementId_from Integer, MovementItemId_from Integer, PersonalServiceListId_from Integer
                                        , MovementId_to Integer, MovementItemId_to Integer, PersonalServiceListId_to Integer
                                        , ServiceDate TDateTime, UnitId Integer, PersonalId Integer, PositionId Integer, InfoMoneyId Integer
                                        , SummCardRecalc TFloat, SummCardSecondRecalc TFloat, SummAvCardSecondRecalc TFloat, SummCardSecondDiff TFloat, SummNalogRecalc TFloat, SummNalogRetRecalc TFloat
                                        , SummChildRecalc TFloat, SummMinusExtRecalc TFloat, SummAddOthRecalc TFloat, SummFineOthRecalc TFloat, SummHospOthRecalc TFloat
                                        , SummCompensationRecalc TFloat, SummAvanceRecalc TFloat
                                        , isMovementComplete Boolean) ON COMMIT DROP;
     END IF;

     -- Нашли
     vbServiceDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate());
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= vbServiceDate);
     vbServiceDateId_next:= lpInsertFind_Object_ServiceDate (inOperDate:= vbServiceDate + INTERVAL '1 MONTH');
     -- Нашли
     vbPersonalServiceListId:= (SELECT MLO.ObjectId AS PersonalServiceListId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList());


     -- !!!СНАЧАЛА - Ведомость охрана!!!
     IF inUserId > 0 -- AND vbPersonalServiceListId = 301885 -- Ведомость охрана
     AND NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbPersonalServiceListId AND OB.DescId = zc_ObjectBoolean_PersonalServiceList_Recalc() AND OB.ValueData = TRUE)
     AND NOT EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = vbPersonalServiceListId AND OB.DescId = zc_ObjectBoolean_PersonalServiceList_Detail() AND OB.ValueData = TRUE)
     AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = vbPersonalServiceListId AND OL.DescId = zc_ObjectLink_PersonalServiceList_PaidKind() AND OL.ChildObjectId = zc_Enum_PaidKind_FirstForm())
     AND vbPersonalServiceListId <> 1064330 -- Відомість 1.Лікарняні за рахунок ПФ
     THEN
         PERFORM lpUpdate_MI_PersonalService_SummAuditAdd (inMovementId, vbPersonalServiceListId, inUserId);

     ELSEIF inUserId > 0
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, inUserId, FALSE)
         FROM -- сохранили
              (SELECT MovementItem.Id AS MovementItemId
                      -- Сумма доплата за ревизию - Ведомость охрана
                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAuditAdd(), MovementItem.Id, 0)
                      -- Сумма доплата за прогул
                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSkip(), MovementItem.Id, 0)
                      -- Сумма доплата за санобработка
                    , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMedicdayAdd(), MovementItem.Id, 0)
               FROM MovementItem
                    LEFT JOIN MovementItemFloat AS MIF_SummAuditAdd
                                                ON MIF_SummAuditAdd.MovementItemId = MovementItem.Id
                                               AND MIF_SummAuditAdd.DescId         = zc_MIFloat_SummAuditAdd()
                    LEFT JOIN MovementItemFloat AS MIF_SummSkip
                                                ON MIF_SummSkip.MovementItemId = MovementItem.Id
                                               AND MIF_SummSkip.DescId         = zc_MIFloat_SummSkip()
                    LEFT JOIN MovementItemFloat AS MIF_SummMedicdayAdd
                                                ON MIF_SummMedicdayAdd.MovementItemId = MovementItem.Id
                                               AND MIF_SummMedicdayAdd.DescId         = zc_MIFloat_SummMedicdayAdd()
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId = zc_MI_Master()
                 AND MovementItem.isErased = FALSE
                 AND (MIF_SummAuditAdd.ValueData <> 0 OR MIF_SummSkip.ValueData <> 0 OR MIF_SummMedicdayAdd.ValueData <> 0)
              ) AS tmp
            ;

     END IF;


     -- !!!СНАЧАЛА - пересчитали сумму затраты!!!
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId
                    -- SummService
                  , COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummService()), 0)
                    -- SummMinus
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummMinus()), 0)
                    -- SummFine
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummFine()), 0)
                    -- SummFineOth
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummFineOth()), 0)
                    -- SummAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummAdd()), 0)
                    -- SummAddOth
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummAddOth()), 0)
                    -- SummHoliday
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummHoliday()), 0)
                    -- SummHosp
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummHosp()), 0)
                    -- SummHospOth
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummHospOth()), 0)
                    -- SummCompensation
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummCompensation()), 0)
                  -- SummAuditAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummAuditAdd()), 0)
                  -- SummHouseAdd
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummHouseAdd()), 0)
                    -- "плюс" <за санобработка>
                  + COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummMedicdayAdd()), 0)
                    -- "минус" <за прогул>
                  - COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = MovementItem.Id AND MIF.DescId = zc_MIFloat_SummSkip()), 0)
                    --
                  , MovementItem.ParentId
                  )
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE;


     -- Проверка - других быть не должно
     vbMovementId_check:= (SELECT MovementDate_ServiceDate.MovementId
                           FROM MovementDate AS MovementDate_ServiceDate
                                INNER JOIN Movement ON Movement.Id       = MovementDate_ServiceDate.MovementId
                                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                                   AND Movement.DescId   = zc_Movement_PersonalService()
                                INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                              ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                                             AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                             AND MovementLinkObject_PersonalServiceList.ObjectId   = vbPersonalServiceListId
                           WHERE MovementDate_ServiceDate.ValueData = vbServiceDate
                            AND MovementDate_ServiceDate.DescId     = zc_MIDate_ServiceDate()
                            AND MovementDate_ServiceDate.MovementId <> inMovementId
                           LIMIT 1
                          );
     IF vbMovementId_check <> 0 -- AND inUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Найдена другая <Ведомость начисления> № <%> от <%> для <%> за <%>.Дублирование запрещено. <%> <%>  № <%> от <%> для <%> за <%>'
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_check)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_check))
                       , lfGet_Object_ValueData ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = vbMovementId_check AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()))
                       , zfCalc_MonthYearName ((SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = vbMovementId_check AND MovementDate.DescId = zc_MIDate_ServiceDate()))
                       , vbMovementId_check
                       , inMovementId
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                       , lfGet_Object_ValueData ((SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalServiceList()))
                       , zfCalc_MonthYearName ((SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate()))
                        ;
     END IF;


     -- Проверка - НЕ должно быть уволенных
     IF EXISTS (SELECT 1
                FROM ObjectLink AS OL_PaidKind
                WHERE OL_PaidKind.ObjectId      = vbPersonalServiceListId
                  AND OL_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                  AND OL_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!вот он БН!!!
               )
        AND 1=0
     THEN
         IF ABS (inUserId) = zfCalc_UserAdmin() :: Integer
            OR NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = ABS (inUserId))
         THEN
             -- Нашли
             vbInsertDate:= (SELECT MIN (tmp.OperDate)
                             FROM (SELECT MIN (MovementProtocol.OperDate) AS OperDate FROM MovementProtocol WHERE MovementProtocol.MovementId = inMovementId
                         UNION ALL SELECT MIN (MovementProtocol.OperDate) AS OperDate FROM MovementProtocol_arc AS MovementProtocol WHERE MovementProtocol.MovementId = inMovementId
                         UNION ALL SELECT MIN (MovementProtocol.OperDate) AS OperDate FROM MovementProtocol_arc_arc AS MovementProtocol WHERE MovementProtocol.MovementId = inMovementId
                                  ) AS tmp
                            );
             -- Нашли
             vbIsNalog:= EXISTS (SELECT 1
                                 FROM MovementItem
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRecalc
                                                                  ON MIFloat_SummNalogRecalc.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_SummNalogRecalc.DescId         = zc_MIFloat_SummNalogRecalc()
                                      /*LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRetRecalc
                                                                   ON MIFloat_SummNalogRetRecalc.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_SummNalogRetRecalc.DescId         = zc_MIFloat_SummNalogRetRecalc()*/
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                   AND (MIFloat_SummNalogRecalc.ValueData <> 0 /*OR MIFloat_SummNalogRetRecalc.ValueData <> 0*/)
                                );
             -- для ведомости БН - нельзя "текущий" месяц
             vbMovementItemId_err:= (SELECT MovementItem.Id
                                     FROM MovementItem
                                          LEFT JOIN MovementItemLinkObject AS MILO_Position
                                                                           ON MILO_Position.MovementItemId = MovementItem.Id
                                                                          AND MILO_Position.DescId         = zc_MILinkObject_Position()
                                          LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                               ON ObjectLink_Personal_Position.ObjectId = MovementItem.ObjectId
                                                              AND ObjectLink_Personal_Position.DescId   = zc_ObjectLink_Personal_Position()
                                          LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                               ON ObjectDate_DateOut.ObjectId = MovementItem.ObjectId
                                                              AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = FALSE
                                       -- еще условие - Должность
                                       AND COALESCE (MILO_Position.ObjectId, 0) = COALESCE (ObjectLink_Personal_Position.ChildObjectId, 0)
                                       -- т.е. раньше чем Дата созданиня ДОК.
                                       AND COALESCE (CASE WHEN vbIsNalog = TRUE
                                                               THEN DATE_TRUNC ('MONTH', ObjectDate_DateOut.ValueData) + INTERVAL '1 MONTH'
                                                          ELSE ObjectDate_DateOut.ValueData
                                                     END, zc_DateEnd()) <= vbInsertDate
                                       -- !!!пока убрал!!! - т.е. раньше чем 1-ое число след. месяца
                                       -- AND COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) < DATE_TRUNC ('MONTH', vbServiceDate) + INTERVAL'1 MONTH'
                                    LIMIT 1
                                    );
             IF vbMovementItemId_err > 0 -- AND 1=0
             THEN RAISE EXCEPTION 'Ошибка.Сотрудник <%> <%> <%> уволен <%>. Необходимо его удалить в ведомости за <%> № <%> от <%> которая создана <%>.'
                           , lfGet_Object_ValueData_sh ((SELECT MI.ObjectId FROM MovementItem AS MI WHERE MI.Id = vbMovementItemId_err))
                           , lfGet_Object_ValueData_sh ((SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMovementItemId_err AND MILO.DescId = zc_MILinkObject_Position()))
                           , lfGet_Object_ValueData_sh ((SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMovementItemId_err AND MILO.DescId = zc_MILinkObject_Unit()))
                           , zfConvert_DateToString ((SELECT ObjectDate_DateOut.ValueData FROM MovementItem AS MI LEFT JOIN ObjectDate AS ObjectDate_DateOut ON ObjectDate_DateOut.ObjectId = MI.ObjectId AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out() WHERE MI.Id = vbMovementItemId_err))
                           , zfCalc_MonthYearName (vbServiceDate)
                           , (SELECT Movement.InvNumber FROM MovementItem AS MI LEFT JOIN Movement ON Movement.Id = MI.MovementId WHERE MI.Id = vbMovementItemId_err)
                           , zfConvert_DateToString ((SELECT Movement.OperDate FROM MovementItem AS MI LEFT JOIN Movement ON Movement.Id = MI.MovementId WHERE MI.Id = vbMovementItemId_err))
                           , zfConvert_DateTimeToString (vbInsertDate)
                           --, vbMovementItemId_err
                            ;
             END IF;
         END IF;

     ELSEIF 1=1
        AND (NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = ABS (inUserId))
          OR ABS (inUserId) = zfCalc_UserAdmin() :: Integer
            )
     AND inUserId <> 6561986 -- Брикова В.В.
     AND inUserId <> 5
     AND inUserId > 0
     AND NOT EXISTS (SELECT 1
                     FROM ObjectBoolean AS ObjectBoolean_PersonalOut
                     WHERE ObjectBoolean_PersonalOut.ObjectId  = vbPersonalServiceListId
                       AND ObjectBoolean_PersonalOut.DescId    = zc_ObjectBoolean_PersonalServiceList_PersonalOut()
                       AND ObjectBoolean_PersonalOut.ValueData = TRUE --
                    )
     THEN
         -- для остальных - нельзя "следующий" месяц
         vbMovementItemId_err:= (SELECT MovementItem.Id
                                 FROM MovementItem
                                      LEFT JOIN MovementItemLinkObject AS MILO_Position
                                                                       ON MILO_Position.MovementItemId = MovementItem.Id
                                                                      AND MILO_Position.DescId         = zc_MILinkObject_Position()
                                      LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                           ON ObjectLink_Personal_Position.ObjectId = MovementItem.ObjectId
                                                          AND ObjectLink_Personal_Position.DescId   = zc_ObjectLink_Personal_Position()
                                      LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                           ON ObjectDate_DateOut.ObjectId = MovementItem.ObjectId
                                                          AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                   -- еще условие - Должность
                                   AND COALESCE (MILO_Position.ObjectId, 0) = COALESCE (ObjectLink_Personal_Position.ChildObjectId, 0)
                                   -- т.е. раньше чем 1-ое число след. месяца
                                   AND COALESCE (ObjectDate_DateOut.ValueData + INTERVAL'1 MONTH', zc_DateEnd()) < DATE_TRUNC ('MONTH', vbServiceDate) + INTERVAL'1 MONTH'
                                 LIMIT 1
                                );
         IF vbMovementItemId_err > 0 -- AND 1=0
         THEN RAISE EXCEPTION 'Ошибка.Сотрудник <%> <%> <%> уволен <%>. Необходимо его удалить в ведомости <%> за <%> № <%> от <%>.' --  id=%
                       , lfGet_Object_ValueData_sh ((SELECT MI.ObjectId FROM MovementItem AS MI WHERE MI.Id = vbMovementItemId_err))
                       , lfGet_Object_ValueData_sh ((SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMovementItemId_err AND MILO.DescId = zc_MILinkObject_Position()))
                       , lfGet_Object_ValueData_sh ((SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMovementItemId_err AND MILO.DescId = zc_MILinkObject_Unit()))
                       , zfConvert_DateToString ((SELECT ObjectDate_DateOut.ValueData FROM MovementItem AS MI LEFT JOIN ObjectDate AS ObjectDate_DateOut ON ObjectDate_DateOut.ObjectId = MI.ObjectId AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out() WHERE MI.Id = vbMovementItemId_err))
                       , lfGet_Object_ValueData_sh (vbPersonalServiceListId)
                       , zfCalc_MonthYearName (vbServiceDate)
                       , (SELECT Movement.InvNumber FROM MovementItem AS MI LEFT JOIN Movement ON Movement.Id = MI.MovementId WHERE MI.Id = vbMovementItemId_err)
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM MovementItem AS MI LEFT JOIN Movement ON Movement.Id = MI.MovementId WHERE MI.Id = vbMovementItemId_err))
                       --, vbMovementItemId_err
                        ;
         END IF;

     END IF;


     -- заменили данные !!!если это <Сумма налогов - удержания с сотрудника для распределения>!!!
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRecalc
                                                 ON MIFloat_SummNalogRecalc.MovementItemId = MovementItem.Id
                                                AND MIFloat_SummNalogRecalc.DescId         = zc_MIFloat_SummNalogRecalc()
                     /*LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRetRecalc
                                                  ON MIFloat_SummNalogRetRecalc.MovementItemId = MovementItem.Id
                                                 AND MIFloat_SummNalogRetRecalc.DescId         = zc_MIFloat_SummNalogRetRecalc()*/
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND (MIFloat_SummNalogRecalc.ValueData <> 0 /*OR MIFloat_SummNalogRetRecalc.ValueData <> 0*/)
               )
     THEN
          PERFORM lpInsertUpdate_MovementItem (tmp.MovementItemId, zc_MI_Master(), tmp.PersonalId, inMovementId, tmp.Amount, tmp.ParentId)
                , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(),                tmp.MovementItemId, tmp.UnitId)
                , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(),            tmp.MovementItemId, tmp.PositionId)
                , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), tmp.MovementItemId, tmp.PersonalServiceListId)
          FROM (WITH tmpMI AS (SELECT MovementItem.Id                          AS MovementItemId
                                    , MovementItem.ParentId                    AS ParentId
                                    , MovementItem.ObjectId                    AS PersonalId
                                    , ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                    , MovementItem.Amount                      AS Amount
                               FROM MovementItem
                                    INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                          ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                              )
             , tmpPersonal AS (SELECT tmp.MemberId                                          AS MemberId
                                    , ObjectLink_Personal_Member.ObjectId                   AS PersonalId
                                    , ObjectLink_Personal_PersonalServiceList.ChildObjectId AS PersonalServiceListId
                                    , ObjectLink_Personal_Position.ChildObjectId            AS PositionId
                                    , ObjectLink_Personal_Unit.ChildObjectId                AS UnitId
                                    , ROW_NUMBER() OVER (PARTITION BY tmp.MemberId
                                                         -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                                         ORDER BY CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                                , CASE WHEN ObjectLink_Personal_PersonalServiceList.ChildObjectId > 0 THEN 0 ELSE 1 END
                                                                , CASE WHEN ObjectBoolean_Official.ValueData = TRUE THEN 0 ELSE 1 END
                                                                , CASE WHEN ObjectBoolean_Main.ValueData = TRUE THEN 0 ELSE 1 END
                                                                , ObjectLink_Personal_Member.ObjectId
                                                        ) AS Ord
                               FROM (SELECT DISTINCT tmpMI.MemberId FROM tmpMI) AS tmp
                                               -- получили ВСЕХ сотрудников
                                               INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                                     ON ObjectLink_Personal_Member.ChildObjectId = tmp.MemberId
                                                                    AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                               INNER JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId
                                                                                   AND Object_Personal.isErased = FALSE
                                               LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                                    ON ObjectDate_DateOut.ObjectId = Object_Personal.Id
                                                                   AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()
                                               LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                                    ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                   AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                                                       ON ObjectBoolean_Official.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                      AND ObjectBoolean_Official.DescId   = zc_ObjectBoolean_Member_Official()
                                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                       ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                                      AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                                    ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                                                                   AND ObjectLink_Personal_Position.DescId   = zc_ObjectLink_Personal_Position()
                                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                    ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                                   AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                              )
                -- результат
                SELECT tmpMI.MovementItemId
                     , tmpMI.ParentId
                     , tmpMI.Amount
                     , tmpPersonal.PersonalId
                     , tmpPersonal.PositionId
                     , tmpPersonal.UnitId
                     , tmpPersonal.PersonalServiceListId
                FROM tmpMI
                     INNER JOIN tmpPersonal ON tmpPersonal.MemberId = tmpMI.MemberId
                                           AND tmpPersonal.Ord      = 1
                     LEFT JOIN MovementItemLinkObject AS MILO_Unit
                                                      ON MILO_Unit.MovementItemId = tmpMI.MovementItemId
                                                     AND MILO_Unit.DescId         = zc_MILinkObject_Unit()
                     LEFT JOIN MovementItemLinkObject AS MILO_Position
                                                      ON MILO_Position.MovementItemId = tmpMI.MovementItemId
                                                     AND MILO_Position.DescId         = zc_MILinkObject_Position()
                     LEFT JOIN MovementItemLinkObject AS MILO_PersonalServiceList
                                                      ON MILO_PersonalServiceList.MovementItemId = tmpMI.MovementItemId
                                                     AND MILO_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()
                WHERE tmpMI.PersonalId                  <> tmpPersonal.PersonalId
                   OR tmpPersonal.PositionId            <> COALESCE (MILO_Position.ObjectId, 0)
                   OR tmpPersonal.UnitId                <> COALESCE (MILO_Unit.ObjectId, 0)
                   OR tmpPersonal.PersonalServiceListId <> COALESCE (MILO_PersonalServiceList.ObjectId, 0)
               ) AS tmp;
     END IF;


     -- распределение !!!если это БН!!! - <На карточку БН (ввод) - 1ф> + <На карточку БН (ввод) - 2ф> + <Налоги - удержания (ввод)> + <Алименты - удержание (ввод)> + <Удержания сторон. юр.л. (ввод)>
     IF (EXISTS (SELECT ObjectLink_PersonalServiceList_PaidKind.ChildObjectId
                 FROM MovementLinkObject AS MovementLinkObject_PersonalServiceList
                      INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                                            ON ObjectLink_PersonalServiceList_PaidKind.ObjectId      = MovementLinkObject_PersonalServiceList.ObjectId
                                           AND ObjectLink_PersonalServiceList_PaidKind.DescId        = zc_ObjectLink_PersonalServiceList_PaidKind()
                                           AND ObjectLink_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm() -- !!!вот он БН!!!
                 WHERE MovementLinkObject_PersonalServiceList.MovementId = inMovementId
                   AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                )
      /*OR EXISTS (SELECT 1
                 FROM MovementItem
                      INNER JOIN MovementItemFloat AS MIFloat_SummCompensationRecalc
                                                   ON MIFloat_SummCompensationRecalc.MovementItemId = MovementItem.Id
                                                  AND MIFloat_SummCompensationRecalc.DescId         IN (zc_MIFloat_SummCompensationRecalc())
                                                  AND MIFloat_SummCompensationRecalc.ValueData      > 0
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                )*/
        )
    AND inUserId > 0
     THEN
          PERFORM lpComplete_Movement_PersonalService_Recalc (inMovementId := inMovementId
                                                            , inUserId     := inUserId
                                                             );
     END IF;


     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, PersonalServiceListId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , AnalyzerId, ObjectIntId_Analyzer
                         , IsActive, IsMaster
                          )
        -- 1.1. долг сотруднику по ЗП, или расчеты с Учредителем
        SELECT Movement.DescId
             , Movement.OperDate
             , COALESCE (Object_ObjectTo.Id, COALESCE (MovementItem.ObjectId, 0)) AS ObjectId
             , COALESCE (Object_ObjectTo.DescId, COALESCE (Object.DescId, 0))     AS ObjectDescId
             , -1 * MovementItem.Amount AS OperSumm
             , MovementItem.Id AS MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
               -- Управленческие назначения
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

               -- Бизнес Баланс: из какой кассы будет выплачено
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (MILinkObject_Unit.ObjectId, 0))          AS UnitId
             , COALESCE (ObjectLink_PersonalTo_Position.ChildObjectId, COALESCE (MILinkObject_Position.ObjectId, 0))  AS PositionId
             , COALESCE (MovementLinkObject_PersonalServiceList.ObjectId, 0) AS PersonalServiceListId

               -- Филиал Баланс: всегда по подразделению !!!в кассе и р/счете - делать аналогично!!!
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId_Balance
               -- Филиал ОПиУ: не используется !!!в кассе и р/счете - делать аналогично!!!
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) AS BranchId_ProfitLoss

               -- Месяц начислений - есть
             , CASE WHEN View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_60000() -- Заработная плата
                         THEN vbServiceDateId
                    ELSE 0
               END AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , 0                     AS AnalyzerId           -- не надо, т.к. это обычная ЗП
             , MovementItem.ObjectId AS ObjectIntId_Analyzer -- надо, сохраним "оригинал"

             -- , CASE WHEN -1 * MovementItem.Amount >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsActive -- всегда такая
             , TRUE AS IsMaster
        FROM Movement
             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

             LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                    ON MovementDate_ServiceDate.MovementId = Movement.Id
                                   AND MovementDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                              ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                          ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                         AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()

             -- нашли Физ лицо
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             -- если у Физ лица установлено - На кого "переносятся" затраты в "Налоги с ЗП" или в "Мобильная связь"
             LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             LEFT JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = ObjectLink_Member_ObjectTo.ChildObjectId
                                                AND Object_ObjectTo.DescId = zc_Object_Personal()
             LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Unit ON ObjectLink_PersonalTo_Unit.ObjectId = ObjectLink_Member_ObjectTo.ChildObjectId
                                                               AND ObjectLink_PersonalTo_Unit.DescId = zc_ObjectLink_Personal_Unit()
             LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Position ON ObjectLink_PersonalTo_Position.ObjectId = ObjectLink_Member_ObjectTo.ChildObjectId
                                                                   AND ObjectLink_PersonalTo_Position.DescId = zc_ObjectLink_Personal_Position()

             LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (MILinkObject_Unit.ObjectId, 0))
                                                           AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

             -- LEFT JOIN MovementItemFloat AS MIF_SummNalog ON MIF_SummNalog.MovementItemId = MovementItem.Id AND MIF_SummNalog.DescId = zc_MIFloat_SummNalog()
             -- LEFT JOIN MovementItemFloat AS MIF_SummPhone ON MIF_SummPhone.MovementItemId = MovementItem.Id AND MIF_SummPhone.DescId = zc_MIFloat_SummPhone()

        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_PersonalService()
          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          -- AND (MovementItem.Amount <> 0 OR MIF_SummNalog.ValueData <> 0 OR MIF_SummPhone.ValueData <> 0)
       ;


     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0)
     THEN
         RAISE EXCEPTION 'В документе не определен <Сотрудник>. Проведение невозможно.';
     END IF;

     -- проверка
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0)
     THEN
         RAISE EXCEPTION 'У не установлено <Главное юр лицо.> Проведение невозможно.';
     END IF;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, PersonalServiceListId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , AnalyzerId, ObjectIntId_Analyzer
                         , IsActive, IsMaster
                          )
        -- 1.2.1. ОПиУ по ЗП (кроме перевыставления и Учредителя)
        WITH tmpMI_find AS (SELECT _tmpItem.*
                                 , MIF.DescId    AS DescId_find
                                 , MIF.ValueData AS OperSumm_find
                            FROM _tmpItem
                                 INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem.MovementItemId
                                                                    AND MIF.DescId         = zc_MIFloat_SummChild()
                            WHERE MIF.ValueData <> 0
                           UNION ALL
                            SELECT _tmpItem.*
                                 , MIF.DescId    AS DescId_find
                                 , MIF.ValueData AS OperSumm_find
                            FROM _tmpItem
                                 INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem.MovementItemId
                                                                    AND MIF.DescId         = zc_MIFloat_SummMinusExt()
                            WHERE MIF.ValueData <> 0
                           )
           ,  tmpMI_re AS (SELECT tmpMI_find.*, -1 * tmpMI_find.OperSumm_find AS OperSumm_re
                                , CASE WHEN tmpMI_find.DescId_find = zc_MIFloat_SummChild()    THEN zc_Enum_InfoMoney_60102() -- ЗП - Алименты
                                       WHEN tmpMI_find.DescId_find = zc_MIFloat_SummMinusExt() THEN zc_Enum_InfoMoney_60104() -- ЗП - Удержания сторон. юр.л.
                                  END AS InfoMoneyId_re
                           FROM tmpMI_find
                          UNION ALL
                           SELECT tmpMI_find.*, 1 * tmpMI_find.OperSumm_find AS OperSumm_re
                                , zc_Enum_InfoMoney_60101() AS InfoMoneyId_re -- ЗП - ЗП
                           FROM tmpMI_find
                          )
        -- результат
        SELECT tmpMI_re.MovementDescId
             , tmpMI_re.OperDate
             , tmpMI_re.ObjectId
             , tmpMI_re.ObjectDescId
             , tmpMI_re.OperSumm_re AS OperSumm
             , tmpMI_re.MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , tmpMI_re.InfoMoneyGroupId
               -- Управленческие назначения
             , tmpMI_re.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , tmpMI_re.InfoMoneyId_re

               -- Бизнес Баланс: из какой кассы будет выплачено
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , tmpMI_re.JuridicalId_Basis

             , tmpMI_re.UnitId
             , tmpMI_re.PositionId
             , tmpMI_re.PersonalServiceListId

               -- Филиал Баланс: всегда по подразделению !!!в кассе и р/счете - делать аналогично!!!
             , tmpMI_re.BranchId_Balance
               -- Филиал ОПиУ: не используется !!!в кассе и р/счете - делать аналогично!!!
             , tmpMI_re.BranchId_ProfitLoss

               -- Месяц начислений - есть
             , tmpMI_re.ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , tmpMI_re.AnalyzerId           -- не надо, т.к. это обычная ЗП
             , tmpMI_re.ObjectIntId_Analyzer -- надо, сохраним "оригинал"

             , TRUE  AS IsActive -- всегда такая
             , FALSE AS IsMaster
        FROM tmpMI_re

       UNION ALL
        -- 1.2.1. ОПиУ по ЗП (кроме перевыставления и Учредителя)
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , 0 AS ObjectId
             , 0 AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

               -- Группы ОПиУ
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления
             , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId            -- используется, для аналитики WhereObjectId_Analyzer
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению
             , _tmpItem.BranchId_ProfitLoss AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , 0 AS AnalyzerId               -- не надо, т.к. это ОПиУ
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это ОПиУ
             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = _tmpItem.UnitId

             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = _tmpItem.ObjectId
                                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             LEFT JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = ObjectLink_Member_ObjectTo.ChildObjectId
                                                AND Object_ObjectTo.DescId = zc_Object_Founder()

        WHERE ObjectLink_Unit_Contract.ChildObjectId IS NULL
          AND Object_ObjectTo.Id IS NULL

       UNION ALL
         -- 1.2.2. Перевыставление затрат на Юр Лицо - по ЗП
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, 0) AS ObjectId
             , COALESCE (Object.DescId, 0) AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо всегда из договора
             , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis

             , 0 AS UnitId                -- не используется
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: всегда "Главный филиал" (нужен для НАЛ долгов)
             , zc_Branch_Basis() AS BranchId_Balance
               -- Филиал ОПиУ: здесь не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , ObjectLink_Unit_Contract.ChildObjectId     AS ContractId
             , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId

             , 0 AS AnalyzerId               -- не надо, т.к. это Перевыставление
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это Перевыставление

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             INNER JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = _tmpItem.UnitId
                                                              AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                  AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                 AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object ON Object.Id = ObjectLink_Contract_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = _tmpItem.ObjectId
                                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             LEFT JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = ObjectLink_Member_ObjectTo.ChildObjectId
                                                AND Object_ObjectTo.DescId = zc_Object_Founder()

        WHERE ObjectLink_Unit_Contract.ChildObjectId > 0
          AND Object_ObjectTo.Id IS NULL

       UNION ALL
         -- 1.2.3. Перевыставление затрат на Учредителя - по ЗП
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , Object_ObjectTo.Id     AS ObjectId
             , Object_ObjectTo.DescId AS ObjectDescId
             , -1 * _tmpItem.OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения - не используется
             , 0 AS InfoMoneyGroupId
               -- Управленческие назначения - не используется
             , 0 AS InfoMoneyDestinationId
               -- Управленческие статьи назначения - не используется
             , 0 AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , 0 AS UnitId                -- не используется
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId
             , 0 AS PaidKindId

             , 0 AS AnalyzerId               -- не надо, т.к. это Перевыставление
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это Перевыставление

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster

        FROM _tmpItem
             INNER JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = _tmpItem.ObjectId
                                                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             INNER JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                                AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             INNER JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = ObjectLink_Member_ObjectTo.ChildObjectId
                                                 AND Object_ObjectTo.DescId = zc_Object_Founder()

       UNION ALL
        -- 1.3.1. ОПиУ по налогам - удержания с ЗП (или Учредителя) - !!!доход!!!
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , 0 AS ObjectId
             , 0 AS ObjectDescId
             , -1 * COALESCE (MIF.ValueData, 0) + 1 * COALESCE (MIF_ret.ValueData, 0) AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

               -- Группы ОПиУ
             , 0 AS ProfitLossGroupId     -- сформируем позже
               -- Аналитики ОПиУ - направления
             , 0 AS ProfitLossDirectionId -- сформируем позже

               -- Управленческие группы назначения
             , View_InfoMoney.InfoMoneyGroupId
               -- Управленческие назначения
             , View_InfoMoney.InfoMoneyDestinationId
               -- Управленческие статьи назначения - Налоговые платежи по ЗП - Отчисления
             , View_InfoMoney.InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: ObjectLink_Unit_Business
             , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId            -- используется, для аналитики WhereObjectId_Analyzer
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: всегда по подразделению
             , _tmpItem.BranchId_ProfitLoss AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , 0 AS AnalyzerId -- не надо, т.к. это ОПиУ
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это ОПиУ

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster
        FROM _tmpItem
             LEFT JOIN MovementItemFloat AS MIF     ON MIF.MovementItemId     = _tmpItem.MovementItemId AND MIF.DescId     = zc_MIFloat_SummNalog()
             LEFT JOIN MovementItemFloat AS MIF_ret ON MIF_ret.MovementItemId = _tmpItem.MovementItemId AND MIF_ret.DescId = zc_MIFloat_SummNalogRet()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business ON ObjectLink_Unit_Business.ObjectId = _tmpItem.UnitId
                                                             AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_50101() -- Налоговые платежи по ЗП - Отчисления
        WHERE MIF.ValueData <> 0 OR MIF_ret.ValueData <> 0

       UNION ALL
        -- 1.3.2.1. долг сотруднику по ЗП - удержания с ЗП
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , _tmpItem.ObjectId
             , _tmpItem.ObjectDescId
             , 1 * COALESCE (MIF.ValueData, 0) AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: из какой кассы будет выплачено
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId
             , _tmpItem.PositionId
             , _tmpItem.PersonalServiceListId

               -- Филиал Баланс: всегда по подразделению !!!в кассе и р/счете - делать аналогично!!!
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ: не используется !!!в кассе и р/счете - делать аналогично!!!
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: есть
             , _tmpItem.ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , zc_Enum_AnalyzerId_PersonalService_Nalog() AS AnalyzerId -- надо, т.к. это удержания с ЗП
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это удержания с ЗП

             , _tmpItem.IsActive -- всегда такая
             , FALSE AS IsMaster
        FROM _tmpItem
             LEFT JOIN MovementItemFloat AS MIF     ON MIF.MovementItemId     = _tmpItem.MovementItemId AND MIF.DescId     = zc_MIFloat_SummNalog()

             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = _tmpItem.ObjectId
                                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             LEFT JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = ObjectLink_Member_ObjectTo.ChildObjectId
                                                AND Object_ObjectTo.DescId = zc_Object_Founder()
        WHERE MIF.ValueData <> 0
          AND Object_ObjectTo.Id IS NULL

       UNION ALL
        -- 1.3.2.2. долг сотруднику по ЗП - возмещение к ЗП
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , _tmpItem.ObjectId
             , _tmpItem.ObjectDescId
             , -1 * COALESCE (MIF_ret.ValueData, 0) AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: из какой кассы будет выплачено
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId
             , _tmpItem.PositionId
             , _tmpItem.PersonalServiceListId

               -- Филиал Баланс: всегда по подразделению !!!в кассе и р/счете - делать аналогично!!!
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ: не используется !!!в кассе и р/счете - делать аналогично!!!
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: есть
             , _tmpItem.ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , zc_Enum_AnalyzerId_PersonalService_NalogRet() AS AnalyzerId -- надо, т.к. это возмещение к ЗП
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это возмещение к ЗП

             , _tmpItem.IsActive -- всегда такая
             , FALSE AS IsMaster
        FROM _tmpItem
             LEFT JOIN MovementItemFloat AS MIF_ret ON MIF_ret.MovementItemId = _tmpItem.MovementItemId AND MIF_ret.DescId = zc_MIFloat_SummNalogRet()

             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = _tmpItem.ObjectId
                                                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                               AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             LEFT JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = ObjectLink_Member_ObjectTo.ChildObjectId
                                                AND Object_ObjectTo.DescId = zc_Object_Founder()
        WHERE MIF_ret.ValueData <> 0
          AND Object_ObjectTo.Id IS NULL

       UNION ALL
         -- 1.3.3.1. Перевыставление по налогам на Учредителя
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , Object_ObjectTo.Id     AS ObjectId
             , Object_ObjectTo.DescId AS ObjectDescId
             , 1 * COALESCE (MIF.ValueData, 0) AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения - не используется
             , 0 AS InfoMoneyGroupId
               -- Управленческие назначения - не используется
             , 0 AS InfoMoneyDestinationId
               -- Управленческие статьи назначения - не используется
             , 0 AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , 0 AS UnitId                -- не используется
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId
             , 0 AS PaidKindId

             , zc_Enum_AnalyzerId_PersonalService_Nalog() AS AnalyzerId -- надо, т.к. это Перевыставление - Налоги
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это удержания с ЗП

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster

        FROM _tmpItem
             LEFT JOIN MovementItemFloat AS MIF     ON MIF.MovementItemId     = _tmpItem.MovementItemId AND MIF.DescId     = zc_MIFloat_SummNalog()

             INNER JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = _tmpItem.ObjectId
                                                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             INNER JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                                AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             INNER JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = ObjectLink_Member_ObjectTo.ChildObjectId
                                                 AND Object_ObjectTo.DescId = zc_Object_Founder()
        WHERE MIF.ValueData <> 0

       UNION ALL
         -- 1.3.3.2. Перевыставление по возмещению налогов на Учредителя
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , Object_ObjectTo.Id     AS ObjectId
             , Object_ObjectTo.DescId AS ObjectDescId
             , -1 * COALESCE (MIF_ret.ValueData, 0) AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения - не используется
             , 0 AS InfoMoneyGroupId
               -- Управленческие назначения - не используется
             , 0 AS InfoMoneyDestinationId
               -- Управленческие статьи назначения - не используется
             , 0 AS InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , 0 AS UnitId                -- не используется
             , 0 AS PositionId            -- не используется
             , 0 AS PersonalServiceListId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId
             , 0 AS PaidKindId

             , zc_Enum_AnalyzerId_PersonalService_NalogRet() AS AnalyzerId -- надо, т.к. это Перевыставление - Налоги
             , _tmpItem.ObjectIntId_Analyzer -- надо, т.к. это удержания с ЗП

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster

        FROM _tmpItem
             LEFT JOIN MovementItemFloat AS MIF_ret ON MIF_ret.MovementItemId = _tmpItem.MovementItemId AND MIF_ret.DescId = zc_MIFloat_SummNalogRet()

             INNER JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = _tmpItem.ObjectId
                                                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
             INNER JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                                AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
             INNER JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id     = ObjectLink_Member_ObjectTo.ChildObjectId
                                                 AND Object_ObjectTo.DescId = zc_Object_Founder()
        WHERE MIF_ret.ValueData <> 0


      UNION ALL
        -- перевыставления - <Карта БН (округление) - 2ф>
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , _tmpItem.ObjectId
             , _tmpItem.ObjectDescId

               -- <Карта БН (округление) - 2ф>
             , tmpServiceDate.mySign * MIF_SummCardSecondDiff.ValueData AS OperSumm

             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                               -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId   -- сформируем позже

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , _tmpItem.InfoMoneyGroupId
               -- Управленческие назначения
             , _tmpItem.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , _tmpItem.InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо
             , zc_Juridical_Basis() AS JuridicalId_Basis

             , _tmpItem.UnitId
             , _tmpItem.PositionId
             , MILinkObject_PersonalServiceList.ObjectId AS PersonalServiceListId

               -- Филиал Баланс
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ
             , _tmpItem.BranchId_ProfitLoss

               -- Месяц начислений: перевыставления
             , tmpServiceDate.ServiceDateId

             , 0 AS ContractId
             , 0 AS PaidKindId

             , zc_Enum_AnalyzerId_PersonalService_SummDiff() -- это Карта БН (округление) - 2ф
             , _tmpItem.ObjectIntId_Analyzer                 -- надо, сохраним "оригинал"

             , NOT _tmpItem.IsActive
             , NOT _tmpItem.IsMaster

        FROM _tmpItem
             LEFT JOIN (SELECT -1 AS mySign, vbServiceDateId AS ServiceDateId UNION SELECT 1 AS mySign, vbServiceDateId_next AS ServiceDateId
                       ) AS tmpServiceDate ON 1 = 1
             -- <Карта БН (округление) - 2ф>
             LEFT JOIN MovementItemFloat AS MIF_SummCardSecondDiff
                                         ON MIF_SummCardSecondDiff.MovementItemId = _tmpItem.MovementItemId
                                        AND MIF_SummCardSecondDiff.DescId         = zc_MIFloat_SummCardSecondDiff()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                              ON MILinkObject_PersonalServiceList.MovementItemId = _tmpItem.MovementItemId
                                             AND MILinkObject_PersonalServiceList.DescId         = zc_MILinkObject_PersonalServiceList()

        WHERE MIF_SummCardSecondDiff.ValueData <> 0
          AND MILinkObject_PersonalServiceList.ObjectId > 0
          --AND inUserId <> 5
       ;


IF inUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.<%>', (select count(*) from _tmpItem);
end if;

/*
     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     -- 2.1. долг сотруднику по Соц.Выпл
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , IsActive, IsMaster
                          )
        SELECT _tmpItem.MovementDescId
             , _tmpItem.OperDate
             , _tmpItem.ObjectId
             , _tmpItem.ObjectDescId
             , -1 * (COALESCE (MIFloat_SummSocialIn.ValueData, 0) + COALESCE (MIFloat_SummSocialAdd.ValueData, 0)) AS OperSumm
             , _tmpItem.MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже
             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId                   -- не используется

               -- Управленческие группы назначения
             , View_InfoMoney.InfoMoneyGroupId
               -- Управленческие назначения
             , View_InfoMoney.InfoMoneyDestinationId
               -- Управленческие статьи назначения
             , View_InfoMoney.InfoMoneyId

               -- Бизнес Баланс: из какой кассы будет выплачено
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо: из какой кассы будет выплачено
             , _tmpItem.JuridicalId_Basis

             , _tmpItem.UnitId
             , _tmpItem.PositionId

               -- Филиал Баланс: всегда по подразделению
             , _tmpItem.BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: есть
             , _tmpItem.ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , FALSE AS IsActive
             , TRUE AS IsMaster
        FROM _tmpItem
              LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                          ON MIFloat_SummSocialIn.MovementItemId = _tmpItem.MovementItemId
                                         AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
              LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                          ON MIFloat_SummSocialAdd.MovementItemId = _tmpItem.MovementItemId
                                         AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()
              LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60103() -- Заработная плата + Алименты
       ;
*/


     -- 4.10. ФИНИШ - пересчитали сумму к выплате (если есть "другие" расчеты) - ДА надо "минус" <Налоги - удержания с ЗП> И <Алименты - удержания> И <Удержания сторонними юр.л.>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummToPay(), tmpMovement.MovementItemId, -1 * OperSumm
                                                                                                 + tmpMovement.SummSocialAdd
                                                                                               --+ tmpMovement.SummHouseAdd
                                                                                                 - tmpMovement.SummTransport
                                                                                                 + tmpMovement.SummTransportAdd
                                                                                                 + tmpMovement.SummTransportAddLong
                                                                                                 + tmpMovement.SummTransportTaxi
                                                                                                 - tmpMovement.SummPhone

                                                                                                 - tmpMovement.SummNalog
                                                                                                 + tmpMovement.SummNalogRet
                                                                                                 - tmpMovement.SummChild
                                                                                                 - tmpMovement.SummMinusExt

                                                                                                 -- + tmpMovement.SummAddOth
                                              )
             -- Сумма ГСМ (удержание за заправку, хотя может быть и доплатой...)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransport()       , tmpMovement.MovementItemId, tmpMovement.SummTransport)
             -- Сумма командировочные (доплата)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportAdd()    , tmpMovement.MovementItemId, tmpMovement.SummTransportAdd)
             -- Сумма дальнобойные (доплата, тоже командировочные)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportAddLong(), tmpMovement.MovementItemId, tmpMovement.SummTransportAddLong)
             -- Сумма на такси (доплата)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportTaxi()   , tmpMovement.MovementItemId, tmpMovement.SummTransportTaxi)
             -- Сумма Моб.связь (удержание)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPhone()           , tmpMovement.MovementItemId, tmpMovement.SummPhone)
     FROM (WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                             --, _tmpItem.ContainerId
                               , _tmpItem.ObjectId
                               , _tmpItem.PersonalServiceListId
                               , _tmpItem.UnitId
                               , _tmpItem.PositionId
                               , _tmpItem.InfoMoneyId
                               , _tmpItem.ObjectIntId_Analyzer
                               , COALESCE (_tmpItem.OperSumm, 0) AS OperSumm
                               , COALESCE (MIFloat_SummSocialAdd.ValueData, 0) AS SummSocialAdd
                               , COALESCE (MIFloat_SummHouseAdd.ValueData, 0)  AS SummHouseAdd
                               , COALESCE (MIFloat_SummNalog.ValueData, 0)     AS SummNalog
                               , COALESCE (MIFloat_SummNalogRet.ValueData, 0)  AS SummNalogRet
                               , COALESCE (MIFloat_SummChild.ValueData, 0)     AS SummChild
                               , COALESCE (MIFloat_SummMinusExt.ValueData, 0)  AS SummMinusExt
                            -- , COALESCE (MIFloat_SummAddOth.ValueData, 0)    AS SummAddOth
                         FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                                          ON MIFloat_SummSocialAdd.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummHouseAdd
                                                          ON MIFloat_SummHouseAdd.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummHouseAdd.DescId = zc_MIFloat_SummHouseAdd()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummNalog
                                                          ON MIFloat_SummNalog.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummNalog.DescId = zc_MIFloat_SummNalog()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRet
                                                          ON MIFloat_SummNalogRet.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummNalogRet.DescId         = zc_MIFloat_SummNalogRet()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummChild
                                                          ON MIFloat_SummChild.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()
                              LEFT JOIN MovementItemFloat AS MIFloat_SummMinusExt
                                                          ON MIFloat_SummMinusExt.MovementItemId = MovementItem.Id
                                                         AND MIFloat_SummMinusExt.DescId = zc_MIFloat_SummMinusExt()
                           -- LEFT JOIN MovementItemFloat AS MIFloat_SummAddOth
                           --                             ON MIFloat_SummAddOth.MovementItemId = MovementItem.Id
                           --                            AND MIFloat_SummAddOth.DescId = zc_MIFloat_SummAddOth()
                              LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = MovementItem.Id
                                                AND _tmpItem.IsMaster       = TRUE
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                        )
    , tmpListContainer AS (SELECT DISTINCT CLO_Personal.ContainerId         AS ContainerId
                                         , CLO_PersonalServiceList.ObjectId AS PersonalServiceListId
                                         , CLO_Unit.ObjectId                AS UnitId
                                         , CLO_Personal.ObjectId            AS PersonalId
                                         , CLO_Position.ObjectId            AS PositionId
                                         , CLO_InfoMoney.ObjectId           AS InfoMoneyId
                           FROM _tmpItem
                                INNER JOIN ObjectLink AS OL_Personal_Member
                                                      ON OL_Personal_Member.ObjectId = _tmpItem.ObjectId
                                                     AND OL_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                INNER JOIN ObjectLink AS OL_Personal_Member_f
                                                      ON OL_Personal_Member_f.ChildObjectId = OL_Personal_Member.ChildObjectId
                                                     AND OL_Personal_Member_f.DescId        = zc_ObjectLink_Personal_Member()

                                INNER JOIN ContainerLinkObject AS CLO_Personal
                                                               ON CLO_Personal.ObjectId = OL_Personal_Member_f.ObjectId
                                                              AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                               ON CLO_ServiceDate.ContainerId = CLO_Personal.ContainerId
                                                              AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                                                              AND CLO_ServiceDate.ObjectId    = vbServiceDateId
                                INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                               ON CLO_PersonalServiceList.ContainerId = CLO_Personal.ContainerId
                                                              AND CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                                              AND CLO_PersonalServiceList.ObjectId    = _tmpItem.PersonalServiceListId
                                INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                               ON CLO_InfoMoney.ContainerId = CLO_Personal.ContainerId
                                                              AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                              AND CLO_InfoMoney.ObjectId    = _tmpItem.InfoMoneyId
                                LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = CLO_Personal.ContainerId
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                LEFT JOIN ContainerLinkObject AS CLO_Position
                                                              ON CLO_Position.ContainerId = CLO_Personal.ContainerId
                                                             AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                           WHERE _tmpItem.ObjectDescId = zc_Object_Personal()
                             AND _tmpItem.AnalyzerId <> zc_Enum_AnalyzerId_PersonalService_SummDiff()

                          UNION
                           SELECT DISTINCT CLO_Personal.ContainerId         AS ContainerId
                                         , CLO_PersonalServiceList.ObjectId AS PersonalServiceListId
                                         , CLO_Unit.ObjectId                AS UnitId
                                         , CLO_Personal.ObjectId            AS PersonalId
                                         , CLO_Position.ObjectId            AS PositionId
                                         , CLO_InfoMoney.ObjectId           AS InfoMoneyId
                           FROM (SELECT DISTINCT _tmpItem.PersonalServiceListId, _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.ObjectDescId = zc_Object_Personal()
                                                                                                                      AND _tmpItem.AnalyzerId <> zc_Enum_AnalyzerId_PersonalService_SummDiff()
                                ) AS tmp
                                INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                               ON CLO_PersonalServiceList.ObjectId    = tmp.PersonalServiceListId
                                                              AND CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                INNER JOIN ContainerLinkObject AS CLO_Personal
                                                               ON CLO_Personal.ContainerId = CLO_PersonalServiceList.ContainerId
                                                              AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                               ON CLO_ServiceDate.ContainerId = CLO_Personal.ContainerId
                                                              AND CLO_ServiceDate.DescId      = zc_ContainerLinkObject_ServiceDate()
                                                              AND CLO_ServiceDate.ObjectId    = vbServiceDateId
                                INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                               ON CLO_InfoMoney.ContainerId = CLO_Personal.ContainerId
                                                              AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                              AND CLO_InfoMoney.ObjectId    = tmp.InfoMoneyId
                                LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ContainerId = CLO_Personal.ContainerId
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                LEFT JOIN ContainerLinkObject AS CLO_Position
                                                              ON CLO_Position.ContainerId = CLO_Personal.ContainerId
                                                             AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()

                          )
   , tmpMIContainer AS (SELECT MIContainer.ContainerId
                             , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income()                      THEN  1 * MIContainer.Amount ELSE 0 END)  AS SummTransport
                             , SUM (CASE WHEN MIContainer.AnalyzerId     = zc_Enum_AnalyzerId_Transport_Add()        THEN -1 * MIContainer.Amount ELSE 0 END)  AS SummTransportAdd
                             , SUM (CASE WHEN MIContainer.AnalyzerId     = zc_Enum_AnalyzerId_Transport_AddLong()    THEN -1 * MIContainer.Amount ELSE 0 END)  AS SummTransportAddLong
                             , SUM (CASE WHEN MIContainer.AnalyzerId     = zc_Enum_AnalyzerId_Transport_Taxi()       THEN -1 * MIContainer.Amount ELSE 0 END)  AS SummTransportTaxi
                             , SUM (CASE WHEN MIContainer.AnalyzerId     = zc_Enum_AnalyzerId_MobileBills_Personal() THEN  1 * MIContainer.Amount ELSE 0 END)  AS SummPhone
                        FROM MovementItemContainer AS MIContainer
                        WHERE MIContainer.ContainerId IN (SELECT tmpListContainer.ContainerId FROM tmpListContainer)
                          AND MIContainer.OperDate >= DATE_TRUNC ('MONTH', (SELECT DISTINCT OperDate FROM _tmpItem
                                                                            WHERE _tmpItem.AnalyzerId <> zc_Enum_AnalyzerId_PersonalService_SummDiff()
                                                                           ) - INTERVAL '3 MONTH')
                        GROUP BY MIContainer.ContainerId
                       )
           -- Результат
           SELECT tmpMI.MovementItemId
                , tmpMI.OperSumm
                , tmpMI.SummSocialAdd
                , tmpMI.SummHouseAdd
                , tmpMI.SummNalog
                , tmpMI.SummNalogRet
                , tmpMI.SummChild
                , tmpMI.SummMinusExt
             -- , tmpMI.SummAddOth
                , COALESCE (SUM (CASE WHEN tmpMI.ObjectId = tmpMI.ObjectIntId_Analyzer THEN tmpMIContainer.SummTransport        ELSE 0 END), 0) AS SummTransport
                , COALESCE (SUM (CASE WHEN tmpMI.ObjectId = tmpMI.ObjectIntId_Analyzer THEN tmpMIContainer.SummTransportAdd     ELSE 0 END), 0) AS SummTransportAdd
                , COALESCE (SUM (CASE WHEN tmpMI.ObjectId = tmpMI.ObjectIntId_Analyzer THEN tmpMIContainer.SummTransportAddLong ELSE 0 END), 0) AS SummTransportAddLong
                , COALESCE (SUM (CASE WHEN tmpMI.ObjectId = tmpMI.ObjectIntId_Analyzer THEN tmpMIContainer.SummTransportTaxi    ELSE 0 END), 0) AS SummTransportTaxi
                , COALESCE (SUM (CASE WHEN tmpMI.ObjectId = tmpMI.ObjectIntId_Analyzer THEN tmpMIContainer.SummPhone            ELSE 0 END), 0) AS SummPhone
           FROM tmpMI
                LEFT JOIN tmpListContainer ON tmpListContainer.PersonalId            = tmpMI.ObjectId
                                          AND tmpListContainer.PersonalServiceListId = tmpMI.PersonalServiceListId
                                          AND tmpListContainer.UnitId                = tmpMI.UnitId
                                          AND tmpListContainer.PositionId            = tmpMI.PositionId
                                          AND tmpListContainer.InfoMoneyId           = tmpMI.InfoMoneyId
                LEFT JOIN tmpMIContainer ON tmpMIContainer.ContainerId = tmpListContainer.ContainerId
           GROUP BY tmpMI.MovementItemId
                  , tmpMI.OperSumm
                  , tmpMI.SummSocialAdd
                  , tmpMI.SummHouseAdd
                  , tmpMI.SummNalog
                  , tmpMI.SummNalogRet
                  , tmpMI.SummChild
                  , tmpMI.SummMinusExt
               -- , tmpMI.SummAddOth
          UNION ALL
           SELECT lpInsertUpdate_MovementItem_PersonalService_item (ioId                     := 0
                                                                  , inMovementId             := inMovementId
                                                                  , inPersonalId             := tmpMI.PersonalId
                                                                  , inIsMain                 := FALSE
                                                                  , inSummService            := 0 :: TFloat
                                                                  , inSummCardRecalc         := 0 :: TFloat
                                                                  , inSummCardSecondRecalc   := 0 :: TFloat
                                                                  , inSummCardSecondCash     := 0 :: TFloat
                                                                  , inSummNalogRecalc        := 0 :: TFloat
                                                                  , inSummNalogRetRecalc     := 0 :: TFloat
                                                                  , inSummMinus              := 0 :: TFloat
                                                                  , inSummAdd                := 0 :: TFloat
                                                                  , inSummAddOthRecalc       := 0 :: TFloat
                                                                  , inSummHoliday            := 0 :: TFloat
                                                                  , inSummSocialIn           := 0 :: TFloat
                                                                  , inSummSocialAdd          := 0 :: TFloat
                                                                  , inSummChildRecalc        := 0 :: TFloat
                                                                  , inSummMinusExtRecalc     := 0 :: TFloat
                                                                  , inSummFine               := 0 :: TFloat
                                                                  , inSummFineOthRecalc      := 0 :: TFloat
                                                                  , inSummHosp               := 0 :: TFloat
                                                                  , inSummHospOthRecalc      := 0 :: TFloat
                                                                  , inSummCompensationRecalc := 0 :: TFloat
                                                                  , inSummAuditAdd           := 0 :: TFloat
                                                                  , inSummHouseAdd           := 0 :: TFloat
                                                                  , inSummAvanceRecalc       := 0 :: TFloat
                                                                  , inNumber                 := ''
                                                                  , inComment                := ''
                                                                  , inInfoMoneyId            := tmpMI.InfoMoneyId
                                                                  , inUnitId                 := tmpMI.UnitId
                                                                  , inPositionId             := tmpMI.PositionId
                                                                  , inMemberId               := NULL
                                                                  , inPersonalServiceListId  := NULL
                                                                  , inUserId                 := inUserId
                                                                   ) AS MovementItemId
                , 0 AS OperSumm
                , 0 AS SummSocialAdd
                , 0 AS SummHouseAdd
                , 0 AS SummNalog
                , 0 AS SummNalogRet
                , 0 AS SummChild
                , 0 AS SummMinusExt
             -- , 0 AS SummAddOth
                , tmpMI.SummTransport
                , tmpMI.SummTransportAdd
                , tmpMI.SummTransportAddLong
                , tmpMI.SummTransportTaxi
                , tmpMI.SummPhone
           FROM (SELECT tmpListContainer.PersonalServiceListId
                      , tmpListContainer.UnitId
                      , tmpListContainer.PersonalId
                      , tmpListContainer.PositionId
                      , tmpListContainer.InfoMoneyId
                      , COALESCE (SUM (tmpMIContainer.SummTransport), 0)        AS SummTransport
                      , COALESCE (SUM (tmpMIContainer.SummTransportAdd), 0)     AS SummTransportAdd
                      , COALESCE (SUM (tmpMIContainer.SummTransportAddLong), 0) AS SummTransportAddLong
                      , COALESCE (SUM (tmpMIContainer.SummTransportTaxi), 0)    AS SummTransportTaxi
                      , COALESCE (SUM (tmpMIContainer.SummPhone), 0)            AS SummPhone
                 FROM tmpMIContainer
                      LEFT JOIN tmpListContainer ON tmpListContainer.ContainerId = tmpMIContainer.ContainerId
                      LEFT JOIN _tmpItem AS tmpMI ON tmpMI.ObjectId              = tmpListContainer.PersonalId
                                                 AND tmpMI.PersonalServiceListId = tmpListContainer.PersonalServiceListId
                                                 AND tmpMI.UnitId                = tmpListContainer.UnitId
                                                 AND tmpMI.PositionId            = tmpListContainer.PositionId
                                                 AND tmpMI.InfoMoneyId           = tmpListContainer.InfoMoneyId
                                                 AND tmpMI.AnalyzerId            <> zc_Enum_AnalyzerId_PersonalService_SummDiff()
                 WHERE tmpListContainer.InfoMoneyId = zc_Enum_InfoMoney_60101() -- Заработная плата
                   AND tmpMI.ObjectId IS NULL
                 GROUP BY tmpListContainer.PersonalServiceListId
                        , tmpListContainer.UnitId
                        , tmpListContainer.PersonalId
                        , tmpListContainer.PositionId
                        , tmpListContainer.InfoMoneyId
                ) AS tmpMI
           WHERE inUserId > 0
          ) AS tmpMovement
           ;

     --при проведении/перепроведении признак Mail ставим = FALSE
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Mail(), inMovementId, FALSE);

     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := ABS (inUserId)
                                         );

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PersonalService()
                                , inUserId     := inUserId
                                 );

     -- 6.1. ФИНИШ - пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.14                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalService (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
