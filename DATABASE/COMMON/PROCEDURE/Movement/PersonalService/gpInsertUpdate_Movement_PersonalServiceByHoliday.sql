-- Function: gpInsertUpdate_Movement_PersonalServiceByHoliday()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalServiceByHoliday (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalServiceByHoliday (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalServiceByHoliday (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalServiceByHoliday (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalServiceByHoliday(
    IN inMovementId             Integer   , -- док. отпуска
    IN inMemberId               Integer   ,
    IN inPersonalId             Integer   ,
    IN inPersonalServiceListId  Integer   , --
    IN inMovementId_1           Integer   , --
    IN inMovementId_2           Integer   ,
    IN inSummHoliday1           TFloat    , --
    IN inSummHoliday2           TFloat    , --
    IN inAmountCompensation     TFloat    ,
    IN inServiceDate1           TDateTime , -- Месяц начислений
    IN inServiceDate2           TDateTime , -- Месяц начислений
    IN inUnitId                 Integer   , --
    IN inPositionId             Integer   ,
    IN inisMain                 Boolean   ,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSummHoliday1 TFloat;
   DECLARE vbSummHoliday2 TFloat;
   DECLARE vbSummHoliday1_calc TFloat;
   DECLARE vbSummHoliday2_calc TFloat;
   DECLARE vbBeginDateStart TDateTime;
   DECLARE vbBeginDateEnd   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());


     -- Проверка - 1
     /*IF COALESCE (inMovementId_1, 0) = 0 AND 1=1
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден документ начисления для%<%> %за <%>.'
                       , CHR (13)
                       , lfGet_Object_ValueData (inPersonalServiceListId)
                       , CHR (13)
                       , zfCalc_MonthName (inServiceDate1) || ' - ' || EXTRACT (YEAR FROM inServiceDate1)
                        ;
     END IF;*/

     -- Проверка - 1
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_1 AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- Распроводим Документ
         IF vbUserId = 5
         THEN PERFORM lpUnComplete_Movement (inMovementId := inMovementId_1
                                           , inUserId     := vbUserId
                                             );
         ELSE
             RAISE EXCEPTION 'Ошибка.Документ начисления для <%> %№ <%> от <%> %в статусе <%>.'
                           , lfGet_Object_ValueData (inPersonalServiceListId)
                           , CHR (13)
                           , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId_1)
                           , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId_1)
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId_1)
                            ;
         END IF;
     END IF;


     -- Проверка - 2
     /*IF COALESCE (inMovementId_2, 0) = 0 AND inSummHoliday2 > 0 AND 1=1
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден документ начисления для%<%> %за <%>.'
                       , CHR (13)
                       , lfGet_Object_ValueData (inPersonalServiceListId)
                       , CHR (13)
                       , zfCalc_MonthName (inServiceDate2) || ' - ' || EXTRACT (YEAR FROM inServiceDate2)
                        ;
     END IF;*/

     -- Проверка - 2
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_2 AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ начисления для <%> %№ <%> от <%> %в статусе <%>.'
                       , lfGet_Object_ValueData (inPersonalServiceListId)
                       , CHR (13)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId_2)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId_2)
                       , CHR (13)
                       , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId_2)
                        ;
     END IF;


     -- проверка были ли ручные правки, если да то ничего не делаем
     IF COALESCE (inMovementId_1, 0) <> 0 OR COALESCE (inMovementId_2, 0) <> 0
     THEN
         vbBeginDateStart:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_BeginDateStart());
         vbBeginDateEnd  := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_BeginDateEnd());

         -- сумма из док начисления - 1
         vbSummHoliday1 := (SELECT SUM (COALESCE (MIFloat_SummHoliday.ValueData,0) ) AS SummHoliday
                            FROM MovementItem
                                 INNER JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                              ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                                             AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
                            WHERE MovementItem.MovementId = inMovementId_1
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                              AND MovementItem.ObjectId = inPersonalId
                            );
         -- сумма из док начисления - 2
         vbSummHoliday2 := (SELECT SUM (COALESCE (MIFloat_SummHoliday.ValueData,0) ) AS SummHoliday
                            FROM MovementItem
                                 INNER JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                              ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                                             AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
                            WHERE MovementItem.MovementId = inMovementId_2
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                              AND MovementItem.ObjectId = inPersonalId
                            );
         -- расчет по "другим" отпускам для периода 1 и 2
         vbSummHoliday1_calc := (WITH -- все отпуска
                                      tmpMovementAll AS (SELECT tmp.Id, tmp.isLoad, tmp.Amount
                                                              , CASE -- если такой же первый период
                                                                     WHEN DATE_TRUNC ('MONTH', tmp.BeginDateStart) = DATE_TRUNC ('MONTH', vbBeginDateStart)
                                                                          THEN tmp.Day_holiday1

                                                                     -- если из предыдущего периода, но он там второй
                                                                     WHEN DATE_TRUNC ('MONTH', tmp.BeginDateEnd) = DATE_TRUNC ('MONTH', vbBeginDateStart)
                                                                          THEN tmp.Day_holiday2

                                                                     ELSE 0
                                                                END AS Day_holiday1

                                                              , CASE -- если такой же первый период
                                                                     WHEN DATE_TRUNC ('MONTH', tmp.BeginDateStart) = DATE_TRUNC ('MONTH', vbBeginDateStart)
                                                                          THEN zc_MovementFloat_MovementId()

                                                                     -- если из предыдущего периода, но он там второй
                                                                     WHEN DATE_TRUNC ('MONTH', tmp.BeginDateEnd) = DATE_TRUNC ('MONTH', vbBeginDateStart)
                                                                          THEN zc_MovementFloat_MovementItemId()

                                                                END AS DescId_calc

                                                         FROM gpSelect_Movement_MemberHoliday (inStartDate := DATE_TRUNC ('MONTH', inServiceDate1) - INTERVAL '1 MONTH'
                                                                                             , inEndDate   := DATE_TRUNC ('MONTH', inServiceDate2) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                                                                             , inIsErased  := FALSE
                                                                                             , inJuridicalBasisId:= 0
                                                                                             , inSession:= inSession) AS tmp
                                                         WHERE tmp.MemberId = inMemberId
                                                           -- !!!без текущего документа!!!
                                                           AND tmp.Id <> inMovementId
                                                           -- !!!
                                                           AND tmp.isLoad = TRUE
                                                           -- !!!
                                                           AND tmp.StatusId = zc_Enum_Status_Complete()
                                                         )
                                 -- получили все, где док начисления ЗП - inMovementId_1
                                 SELECT SUM (COALESCE (tmpMovementAll.Amount * tmpMovementAll.Day_holiday1,0)) AS SummHoliday_calc
                                 FROM tmpMovementAll
                                      INNER JOIN MovementFloat AS MovementFloat_MovementId
                                                               ON MovementFloat_MovementId.MovementId          = tmpMovementAll.Id
                                                              AND MovementFloat_MovementId.ValueData ::Integer = inMovementId_1
                                                              AND MovementFloat_MovementId.DescId              = tmpMovementAll.DescId_calc
                                );

         vbSummHoliday2_calc := (WITH -- все отпуска
                                      tmpMovementAll AS (SELECT tmp.Id, tmp.isLoad, tmp.Amount
                                                              , CASE -- если такой же второй период
                                                                     WHEN DATE_TRUNC ('MONTH', tmp.BeginDateEnd) = DATE_TRUNC ('MONTH', vbBeginDateEnd)
                                                                      AND tmp.Day_holiday2 > 0
                                                                           THEN tmp.Day_holiday2

                                                                     -- если нашли с таким началом = BeginDateEnd
                                                                     WHEN DATE_TRUNC ('MONTH', tmp.BeginDateStart) = DATE_TRUNC ('MONTH', vbBeginDateEnd)
                                                                      -- только для переходящего
                                                                      AND DATE_TRUNC ('MONTH', vbBeginDateStart) < DATE_TRUNC ('MONTH', vbBeginDateEnd)
                                                                          THEN tmp.Day_holiday1

                                                                     ELSE 0
                                                                END AS Day_holiday2

                                                              , CASE -- если такой же второй период
                                                                     WHEN DATE_TRUNC ('MONTH', tmp.BeginDateEnd) = DATE_TRUNC ('MONTH', vbBeginDateEnd)
                                                                      AND tmp.Day_holiday2 > 0
                                                                          THEN zc_MovementFloat_MovementItemId()

                                                                     -- если нашли с таким началом = BeginDateEnd
                                                                     WHEN DATE_TRUNC ('MONTH', tmp.BeginDateStart) = DATE_TRUNC ('MONTH', vbBeginDateEnd)
                                                                      -- только для переходящего
                                                                      AND DATE_TRUNC ('MONTH', vbBeginDateStart) < DATE_TRUNC ('MONTH', vbBeginDateEnd)
                                                                          THEN zc_MovementFloat_MovementId()

                                                                END AS DescId_calc

                                                         FROM gpSelect_Movement_MemberHoliday (inStartDate := DATE_TRUNC ('MONTH', inServiceDate1)
                                                                                             , inEndDate   := DATE_TRUNC ('MONTH', inServiceDate2) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                                                                             , inIsErased  := FALSE
                                                                                             , inJuridicalBasisId:= 0
                                                                                             , inSession:= inSession) AS tmp
                                                         WHERE tmp.MemberId = inMemberId
                                                           -- !!!без текущего документа!!!
                                                           AND tmp.Id <> inMovementId
                                                           -- !!!
                                                           -- AND tmp.isLoad = TRUE
                                                           -- !!!
                                                           AND tmp.StatusId = zc_Enum_Status_Complete()
                                                         )
                                 -- получили все, где док начисления ЗП - inMovementId_2
                                 SELECT SUM (COALESCE (tmpMovementAll.Amount * tmpMovementAll.Day_holiday2,0)) AS SummHoliday_calc
                                 FROM tmpMovementAll
                                      INNER JOIN MovementFloat AS MovementFloat_MovementId
                                                               ON MovementFloat_MovementId.MovementId          = tmpMovementAll.Id
                                                              AND MovementFloat_MovementId.ValueData ::Integer = inMovementId_2
                                                              AND MovementFloat_MovementId.DescId              = tmpMovementAll.DescId_calc
                                );
     END IF;


     IF vbUserId IN (5, 9457) AND 1=0
     THEN
         --
         RAISE EXCEPTION 'Test.сумма 1 период <%> + <%> , сумма 2 период <%> + <%>', inSummHoliday1, vbSummHoliday1, inSummHoliday2, vbSummHoliday2;
     END IF;

     -- если нулевая сумма - 1
     IF COALESCE (vbSummHoliday1, 0) = 0 OR vbSummHoliday1 <> inSummHoliday1 + COALESCE (vbSummHoliday1_calc,0)
     THEN
         IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpMI_1')
         THEN
             DELETE FROM tmpMI_1;
             -- Выбираем сохраненные данные из документа
             INSERT INTO tmpMI_1
                    SELECT tmp.*
                    FROM gpSelect_MovementItem_PersonalService (inMovementId_1, FALSE, FALSE, inSession) AS tmp
                   ;
         ELSE
             -- Выбираем сохраненные данные из документа
             CREATE TEMP TABLE tmpMI_1 ON COMMIT DROP AS
                    SELECT tmp.*
                    FROM gpSelect_MovementItem_PersonalService (inMovementId_1, FALSE, FALSE, inSession) AS tmp
                   ;
         END IF;


         IF COALESCE (inMovementId_1, 0) = 0
         THEN
             -- сохранили <Документ>
             inMovementId_1 := lpInsertUpdate_Movement_PersonalService (ioId                     := inMovementId_1
                                                                     , inInvNumber               := CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar)
                                                                     , inOperDate                := DATE_TRUNC ('MONTH', inServiceDate1) + INTERVAL '1 MONTH'
                                                                     , inServiceDate             := DATE_TRUNC ('MONTH', inServiceDate1)
                                                                     , inComment                 := '' ::TVarChar
                                                                     , inPersonalServiceListId   := inPersonalServiceListId
                                                                     , inJuridicalId             := 0
                                                                     , inUserId                  := vbUserId
                                                                      );
         END IF;

         --
         PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                    := COALESCE (tmpMI.Id,0)                                  ::Integer
                                                            , inMovementId            := inMovementId_1                                         ::Integer
                                                            , inPersonalId            := tmpMI.PersonalId                                       ::Integer
                                                            , inIsMain                := COALESCE (tmpMI.isMain, inisMain)                      ::Boolean
                                                            , inSummService           := COALESCE (tmpMI.SummService,0)                         ::TFloat
                                                            , inSummCardRecalc        := COALESCE (tmpMI.SummCardRecalc,0)                      ::TFloat
                                                            , inSummCardSecondRecalc  := COALESCE (tmpMI.SummCardSecondRecalc,0)                ::TFloat
                                                            , inSummCardSecondCash    := COALESCE (tmpMI.SummCardSecondCash,0)                  ::TFloat
                                                            , inSummNalogRecalc       := COALESCE (tmpMI.SummNalogRecalc,0)                     ::TFloat
                                                            , inSummNalogRetRecalc    := COALESCE (tmpMI.SummNalogRetRecalc,0)                  ::TFloat
                                                            , inSummMinus             := COALESCE (tmpMI.SummMinus,0)                           ::TFloat
                                                            , inSummAdd               := COALESCE (tmpMI.SummAdd,0)                             ::TFloat
                                                            , inSummAddOthRecalc      := COALESCE (tmpMI.SummAddOthRecalc,0)                    ::TFloat
                                                            , inSummHoliday           := (COALESCE (inSummHoliday1,0) + COALESCE (vbSummHoliday1_calc,0)) ::TFloat
                                                            , inSummSocialIn          := COALESCE (tmpMI.SummSocialIn,0)                        ::TFloat
                                                            , inSummSocialAdd         := COALESCE (tmpMI.SummSocialAdd,0)                       ::TFloat
                                                            , inSummChildRecalc       := COALESCE (tmpMI.SummChildRecalc,0)                     ::TFloat
                                                            , inSummMinusExtRecalc    := COALESCE (tmpMI.SummMinusExtRecalc,0)                  ::TFloat
                                                            , inSummFine              := COALESCE (tmpMI.SummFine,0)                            ::TFloat
                                                            , inSummFineOthRecalc     := COALESCE (tmpMI.SummFineOthRecalc,0)                   ::TFloat
                                                            , inSummHosp              := COALESCE (tmpMI.SummHosp,0)                            ::TFloat
                                                            , inSummHospOthRecalc     := COALESCE (tmpMI.SummHospOthRecalc,0)                   ::TFloat
                                                            , inSummCompensationRecalc:= COALESCE (tmpMI.SummCompensationRecalc,0)              ::TFloat
                                                            , inSummAuditAdd          := COALESCE (tmpMI.SummAuditAdd,0)                        ::TFloat
                                                            , inSummHouseAdd          := COALESCE (tmpMI.SummHouseAdd,0)                        ::TFloat
                                                            , inNumber                := COALESCE (tmpMI.Number, '')                            ::TVarChar
                                                            , inComment               := COALESCE (tmpMI.Comment, '')                           ::TVarChar
                                                            , inInfoMoneyId           := tmpMI.InfoMoneyId
                                                            , inUnitId                := tmpMI.UnitId
                                                            , inPositionId            := tmpMI.PositionId                                       ::Integer
                                                            , inMemberId              := 0                                                      ::Integer
                                                            , inPersonalServiceListId := tmpMI.PersonalServiceListId
                                                            , inFineSubjectId         := COALESCE (tmpMI.FineSubjectId,0)                       ::Integer
                                                            , inUnitFineSubjectId     := COALESCE (tmpMI.UnitFineSubjectId,0)                   ::Integer
                                                            , inUserId                := vbUserId
                                                             )
         FROM (SELECT tmp.MemberId
                    , COALESCE (tmpMI.PersonalId, tmp.PersonalId) AS PersonalId
                    , COALESCE (tmpMI.PositionId, tmp.PositionId) AS PositionId
                    , COALESCE (tmpMI.UnitId,     tmp.UnitId)     AS UnitId
                    , COALESCE (tmpMI.PersonalServiceListId, inPersonalServiceListId) AS PersonalServiceListId

                    , tmpMI.Id
                    , tmpMI.FineSubjectId
                    , tmpMI.UnitFineSubjectId
                    , COALESCE (tmpMI.InfoMoneyId, zc_Enum_InfoMoney_60101()) AS InfoMoneyId
                    , tmpMI.Number
                    , tmpMI.Comment
                    , COALESCE (tmpMI.isMain, inisMain) AS isMain
                    , tmpMI.SummService
                    , tmpMI.SummCardRecalc
                    , tmpMI.SummCardSecondRecalc
                    , tmpMI.SummCardSecondCash
                    , tmpMI.SummNalogRecalc
                    , tmpMI.SummNalogRetRecalc
                    , tmpMI.SummMinus
                    , tmpMI.SummAdd
                    , tmpMI.SummAddOthRecalc
                    , tmpMI.SummSocialIn
                    , tmpMI.SummSocialAdd
                    , tmpMI.SummChildRecalc
                    , tmpMI.SummMinusExtRecalc
                    , tmpMI.SummFine
                    , tmpMI.SummFineOthRecalc
                    , tmpMI.SummHosp
                    , tmpMI.SummHospOthRecalc
                    , tmpMI.SummCompensationRecalc
                    , tmpMI.SummAuditAdd
                    , tmpMI.SummHouseAdd

               FROM (SELECT inMemberId              AS MemberId
                          , inPersonalId            AS PersonalId
                          , inPositionId            AS PositionId
                          , inUnitId                AS UnitId
                    ) AS tmp
                    LEFT JOIN tmpMI_1 AS tmpMI ON tmpMI.MemberId_Personal = tmp.MemberId
               ORDER BY tmpMI.SummHoliday DESC, tmpMI.SummService DESC
               LIMIT 1
              ) AS tmpMI
         ;

     END IF;


     -- если нулевая сумма - 2
     IF (COALESCE (vbSummHoliday2, 0) = 0 OR vbSummHoliday2 <> inSummHoliday2 + COALESCE (vbSummHoliday2_calc,0)) AND (inSummHoliday2 > 0 OR inMovementId_2 > 0)
     THEN
         IF COALESCE (inMovementId_2, 0) = 0
         THEN
             -- сохранили <Документ>
             inMovementId_2 := lpInsertUpdate_Movement_PersonalService (ioId                     := inMovementId_2
                                                                     , inInvNumber               := CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar)
                                                                     , inOperDate                := DATE_TRUNC ('MONTH', inServiceDate2) + INTERVAL '1 MONTH'
                                                                     , inServiceDate             := DATE_TRUNC ('MONTH', inServiceDate2)
                                                                     , inComment                 := '' ::TVarChar
                                                                     , inPersonalServiceListId   := inPersonalServiceListId
                                                                     , inJuridicalId             := 0
                                                                     , inUserId                  := vbUserId
                                                                      );
         END IF;

         IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE 'tmpMI_2')
         THEN
             DELETE FROM tmpMI_2;
             -- Выбираем сохраненные данные из документа
             INSERT INTO tmpMI_2
                    SELECT *
                    FROM gpSelect_MovementItem_PersonalService (inMovementId_2, FALSE, FALSE, inSession) AS tmp
                   ;
         ELSE
             -- Выбираем сохраненные данные из документа
             CREATE TEMP TABLE tmpMI_2 ON COMMIT DROP AS
                    SELECT tmp.*
                    FROM gpSelect_MovementItem_PersonalService (inMovementId_2, FALSE, FALSE, inSession) AS tmp
                   ;
         END IF;

         --
         PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                    := COALESCE (tmpMI.Id,0)                                  ::Integer
                                                            , inMovementId            := inMovementId_2                                         ::Integer
                                                            , inPersonalId            := tmpMI.PersonalId                                       ::Integer
                                                            , inIsMain                := COALESCE (tmpMI.isMain, inisMain)                      ::Boolean
                                                            , inSummService           := COALESCE (tmpMI.SummService,0)                         ::TFloat
                                                            , inSummCardRecalc        := COALESCE (tmpMI.SummCardRecalc,0)                      ::TFloat
                                                            , inSummCardSecondRecalc  := COALESCE (tmpMI.SummCardSecondRecalc,0)                ::TFloat
                                                            , inSummCardSecondCash    := COALESCE (tmpMI.SummCardSecondCash,0)                  ::TFloat
                                                            , inSummNalogRecalc       := COALESCE (tmpMI.SummNalogRecalc,0)                     ::TFloat
                                                            , inSummNalogRetRecalc    := COALESCE (tmpMI.SummNalogRetRecalc,0)                  ::TFloat
                                                            , inSummMinus             := COALESCE (tmpMI.SummMinus,0)                           ::TFloat
                                                            , inSummAdd               := COALESCE (tmpMI.SummAdd,0)                             ::TFloat
                                                            , inSummAddOthRecalc      := COALESCE (tmpMI.SummAddOthRecalc,0)                    ::TFloat
                                                            , inSummHoliday           := (COALESCE (inSummHoliday2,0) + COALESCE (vbSummHoliday2_calc,0)) ::TFloat
                                                            , inSummSocialIn          := COALESCE (tmpMI.SummSocialIn,0)                        ::TFloat
                                                            , inSummSocialAdd         := COALESCE (tmpMI.SummSocialAdd,0)                       ::TFloat
                                                            , inSummChildRecalc       := COALESCE (tmpMI.SummChildRecalc,0)                     ::TFloat
                                                            , inSummMinusExtRecalc    := COALESCE (tmpMI.SummMinusExtRecalc,0)                  ::TFloat
                                                            , inSummFine              := COALESCE (tmpMI.SummFine,0)                            ::TFloat
                                                            , inSummFineOthRecalc     := COALESCE (tmpMI.SummFineOthRecalc,0)                   ::TFloat
                                                            , inSummHosp              := COALESCE (tmpMI.SummHosp,0)                            ::TFloat
                                                            , inSummHospOthRecalc     := COALESCE (tmpMI.SummHospOthRecalc,0)                   ::TFloat
                                                            , inSummCompensationRecalc:= COALESCE (tmpMI.SummCompensationRecalc,0)              ::TFloat
                                                            , inSummAuditAdd          := COALESCE (tmpMI.SummAuditAdd,0)                        ::TFloat
                                                            , inSummHouseAdd          := COALESCE (tmpMI.SummHouseAdd,0)                        ::TFloat
                                                            , inNumber                := COALESCE (tmpMI.Number, '')                            ::TVarChar
                                                            , inComment               := COALESCE (tmpMI.Comment, '')                           ::TVarChar
                                                            , inInfoMoneyId           := tmpMI.InfoMoneyId
                                                            , inUnitId                := tmpMI.UnitId
                                                            , inPositionId            := tmpMI.PositionId                                       ::Integer
                                                            , inMemberId              := 0                                                      ::Integer
                                                            , inPersonalServiceListId := tmpMI.PersonalServiceListId
                                                            , inFineSubjectId         := COALESCE (tmpMI.FineSubjectId,0)                       ::Integer
                                                            , inUnitFineSubjectId     := COALESCE (tmpMI.UnitFineSubjectId,0)                   ::Integer
                                                            , inUserId                := vbUserId
                                                             )
         FROM (SELECT tmp.MemberId
                    , COALESCE (tmpMI.PersonalId, tmp.PersonalId) AS PersonalId
                    , COALESCE (tmpMI.PositionId, tmp.PositionId) AS PositionId
                    , COALESCE (tmpMI.UnitId,     tmp.UnitId)     AS UnitId
                    , COALESCE (tmpMI.PersonalServiceListId, inPersonalServiceListId) AS PersonalServiceListId

                    , tmpMI.Id
                    , tmpMI.FineSubjectId
                    , tmpMI.UnitFineSubjectId
                    , COALESCE (tmpMI.InfoMoneyId, zc_Enum_InfoMoney_60101()) AS InfoMoneyId
                    , tmpMI.Number
                    , tmpMI.Comment
                    , COALESCE (tmpMI.isMain, inisMain) AS isMain
                    , tmpMI.SummService
                    , tmpMI.SummCardRecalc
                    , tmpMI.SummCardSecondRecalc
                    , tmpMI.SummCardSecondCash
                    , tmpMI.SummNalogRecalc
                    , tmpMI.SummNalogRetRecalc
                    , tmpMI.SummMinus
                    , tmpMI.SummAdd
                    , tmpMI.SummAddOthRecalc
                    , tmpMI.SummSocialIn
                    , tmpMI.SummSocialAdd
                    , tmpMI.SummChildRecalc
                    , tmpMI.SummMinusExtRecalc
                    , tmpMI.SummFine
                    , tmpMI.SummFineOthRecalc
                    , tmpMI.SummHosp
                    , tmpMI.SummHospOthRecalc
                    , tmpMI.SummCompensationRecalc
                    , tmpMI.SummAuditAdd
                    , tmpMI.SummHouseAdd

               FROM (SELECT inMemberId              AS MemberId
                          , inPersonalId            AS PersonalId
                          , inPositionId            AS PositionId
                          , inUnitId                AS UnitId
                    ) AS tmp
                    LEFT JOIN tmpMI_2 AS tmpMI ON tmpMI.MemberId_Personal = tmp.MemberId
               ORDER BY tmpMI.SummHoliday DESC, tmpMI.SummService DESC
               LIMIT 1
              ) AS tmpMI
         ;

     END IF;


     -- сохранили свойство <Ср.ЗП за день >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), inMovementId, inAmountCompensation);
     -- сохранили свойство <№ док Начисление зарплаты(первый период) 	>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementId(), inMovementId, inMovementId_1);

     -- сохранили свойство <№ док Начисление зарплаты(первый период) 	>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), inMovementId, CASE WHEN inSummHoliday1 > 0 OR inSummHoliday2 > 0 THEN TRUE ELSE FALSE END);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), inMovementId, CASE WHEN inSummHoliday2 > 0 THEN COALESCE (inMovementId_2, 0) ELSE 0 END);


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inMovementId, CURRENT_TIMESTAMP);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inMovementId, vbUserId);


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


     IF vbUserId IN (5, 9457)
     THEN
         --
         RAISE EXCEPTION 'Ошибка.Документ найден %<%>  %<%> %сумма 1 период = <%> %сумма 2 период <%>'
                       , CHR (13)
                       , (SELECT Movement.InvNumber||' от ' || zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId_1)
                       , CHR (13)
                       , (SELECT Movement.InvNumber||' от ' || zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId_2)
                       , CHR (13)
                       , (zfConvert_FloatToString (COALESCE (inSummHoliday1,0) + COALESCE (vbSummHoliday1_calc,0)))
                       , CHR (13)
                       , (zfConvert_FloatToString (COALESCE (inSummHoliday2,0) + COALESCE (vbSummHoliday2_calc,0)))
                        ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.07.23         *
*/

-- тест
--