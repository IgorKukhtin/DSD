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
   DECLARE vbMovementId1 Integer;
   DECLARE vbMovementId2 Integer;
   DECLARE vbMI_Id1  Integer;
   DECLARE vbMI_Id2  Integer;
   DECLARE vbSummHoliday1 TFloat;
   DECLARE vbSummHoliday2 TFloat;
   DECLARE vbInvNumber1 TVarChar;
   DECLARE vbInvNumber2 TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());

     --проверка біли ли ручные правки, если да то ничего не делаем
     IF COALESCE (inMovementId_1,0) <> 0 OR COALESCE (inMovementId_1,0) <> 0
     THEN
    -- RAISE EXCEPTION 'Ошибка. COALESCE (inMovementId_1,0) <> 0 OR COALESCE (inMovementId_1,0) <> 0';
      
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
         IF COALESCE (vbSummHoliday1,0) <> inSummHoliday1 
           OR (COALESCE( inSummHoliday2,0) <> 0 AND COALESCE (vbSummHoliday2,0) <> inSummHoliday2)
         THEN 
         -- RAISE EXCEPTION 'Ошибка.COALESCE (vbSummHoliday1,0) <> inSummHoliday1 ';
             RETURN;
         END IF; 
     END IF;
     
     IF COALESCE (vbSummHoliday1,0) = 0
     THEN 
     --RAISE EXCEPTION 'Ошибка.COALESCE (vbSummHoliday1,0) = 0';
     
     --пробуем найти уже созданній док по inPersonalServiceListId
      SELECT MovementDate_ServiceDate.MovementId
           , Movement.InvNumber
   INTO vbMovementId1, vbInvNumber1
      FROM MovementDate AS MovementDate_ServiceDate
           INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                              AND Movement.DescId = zc_Movement_PersonalService()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()   --<> zc_Enum_Status_Erased()
           INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
      WHERE MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', inServiceDate1) AND (DATE_TRUNC ('MONTH', inServiceDate1) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
        AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
        AND MovementLinkObject_PersonalServiceList.ObjectId = inPersonalServiceListId
        ;

         -- сохранили <Документ>
     vbMovementId1 := lpInsertUpdate_Movement_PersonalService (ioId                      := COALESCE (vbMovementId1,0)
                                                             , inInvNumber               := COALESCE (vbInvNumber1, CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar) )
                                                             , inOperDate                := (inServiceDate1+ INTERVAL '1 Month') ::TDateTime
                                                             , inServiceDate             := inServiceDate1
                                                             , inComment                 := '' ::TVarChar
                                                             , inPersonalServiceListId   := inPersonalServiceListId 
                                                             , inJuridicalId             := 0
                                                             , inUserId                  := vbUserId
                                                              );
     -- Выбираем сохраненные данные из документа
     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
            SELECT tmp.*
            FROM gpSelect_MovementItem_PersonalService(vbMovementId1, FALSE, FALSE, inSession) AS tmp
            ;
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                    := COALESCE (tmpMI.Id,0)                                  ::Integer
                                                        , inMovementId            := vbMovementId1                                          ::Integer
                                                        , inPersonalId            := tmp.PersonalId                              ::Integer
                                                        , inIsMain                := COALESCE (tmpMI.isMain, inisMain)         ::Boolean
                                                        , inSummService           := COALESCE (tmpMI.SummService,0)                         ::TFloat
                                                        , inSummCardRecalc        := COALESCE (tmpMI.SummCardRecalc,0)                      ::TFloat
                                                        , inSummCardSecondRecalc  := COALESCE (tmpMI.SummCardSecondRecalc,0)                ::TFloat
                                                        , inSummCardSecondCash    := COALESCE (tmpMI.SummCardSecondCash,0)                  ::TFloat
                                                        , inSummNalogRecalc       := COALESCE (tmpMI.SummNalogRecalc,0)                     ::TFloat
                                                        , inSummNalogRetRecalc    := COALESCE (tmpMI.SummNalogRetRecalc,0)                ::TFloat
                                                        , inSummMinus             := COALESCE (tmpMI.SummMinus,0)                           ::TFloat
                                                        , inSummAdd               := COALESCE (tmpMI.SummAdd,0)                             ::TFloat
                                                        , inSummAddOthRecalc      := COALESCE (tmpMI.SummAddOthRecalc,0)                    ::TFloat
                                                        , inSummHoliday           := tmp.SummHoliday                         ::TFloat
                                                        , inSummSocialIn          := COALESCE (tmpMI.SummSocialIn,0)                        ::TFloat
                                                        , inSummSocialAdd         := COALESCE (tmpMI.SummSocialAdd,0)                       ::TFloat
                                                        , inSummChildRecalc       := COALESCE (tmpMI.SummChildRecalc,0)            ::TFloat
                                                        , inSummMinusExtRecalc    := COALESCE (tmpMI.SummMinusExtRecalc,0)         ::TFloat
                                                        , inSummFine              := COALESCE (tmpMI.SummFine,0)                            ::TFloat
                                                        , inSummFineOthRecalc     := COALESCE (tmpMI.SummFineOthRecalc,0)                   ::TFloat
                                                        , inSummHosp              := COALESCE (tmpMI.SummHosp,0)                            ::TFloat
                                                        , inSummHospOthRecalc     := COALESCE (tmpMI.SummHospOthRecalc,0)                   ::TFloat
                                                        , inSummCompensationRecalc:= COALESCE (tmpMI.SummCompensationRecalc,0)              ::TFloat
                                                        , inSummAuditAdd          := COALESCE (tmpMI.SummAuditAdd,0)                        ::TFloat
                                                        , inSummHouseAdd          := COALESCE (tmpMI.SummHouseAdd,0)                        ::TFloat
                                                        , inNumber                := COALESCE (tmpMI.Number, '')     ::TVarChar
                                                        , inComment               := COALESCE (tmpMI.Comment, '')                           ::TVarChar
                                                        , inInfoMoneyId           := COALESCE (tmpMI.InfoMoneyId, zc_Enum_InfoMoney_60101()) ::Integer
                                                        , inUnitId                := COALESCE (tmp.UnitId, tmpMI.UnitId)                    ::Integer
                                                        , inPositionId            := tmp.PositionId                                         ::Integer
                                                        , inMemberId              := 0                                                      ::Integer 
                                                        , inPersonalServiceListId := COALESCE (tmp.PersonalServiceListId, tmpMI.PersonalServiceListId) :: Integer
                                                        , inFineSubjectId         := COALESCE (tmpMI.FineSubjectId,0)                       ::Integer
                                                        , inUnitFineSubjectId     := COALESCE (tmpMI.UnitFineSubjectId,0)                   ::Integer
                                                        , inUserId                := vbUserId
                                                      ) 
     FROM (SELECT inMemberId   AS MemberId
                , inPersonalId AS PersonalId
                , inPositionId AS PositionId
                , inUnitId     AS UnitId       
                , inPersonalServiceListId AS PersonalServiceListId
                , inSummHoliday1 AS SummHoliday
          ) AS tmp         
          LEFT JOIN tmpMI ON tmpMI.PersonalId = tmp.PersonalId
                         AND tmpMI.MemberId = tmp.MemberId
                         AND tmpMI.PositionId = tmp.PositionId
     ;
     END IF;
     
     --если переходящий отпуск то сохраняем 2 документ
     IF COALESCE (vbSummHoliday2,0) = 0  AND COALESCE (inSummHoliday2,0) <> 0 AND inServiceDate1 <> inServiceDate2 
     THEN   
     --RAISE EXCEPTION 'Ошибка.COALESCE (vbSummHoliday2,0) = 0';
     
     --пробуем найти уже созданній док по inPersonalServiceListId
     SELECT MovementDate_ServiceDate.MovementId
           , Movement.InvNumber
   INTO vbMovementId2, vbInvNumber2
      FROM MovementDate AS MovementDate_ServiceDate
           INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                              AND Movement.DescId = zc_Movement_PersonalService()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete() ---<> zc_Enum_Status_Erased()
           INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
      WHERE MovementDate_ServiceDate.ValueData BETWEEN DATE_TRUNC ('MONTH', inServiceDate2) AND (DATE_TRUNC ('MONTH', inServiceDate2) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
        AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
        AND MovementLinkObject_PersonalServiceList.ObjectId = inPersonalServiceListId
        ;


         -- сохранили <Документ>
     vbMovementId2 := lpInsertUpdate_Movement_PersonalService (ioId                      := COALESCE (vbMovementId2,0)
                                                             , inInvNumber               := COALESCE (vbInvNumber2, CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar))
                                                             , inOperDate                := (inServiceDate1 + INERVAL '1 Month') ::TDateTime
                                                             , inServiceDate             := inServiceDate2
                                                             , inComment                 := '' ::TVarChar
                                                             , inPersonalServiceListId   := inPersonalServiceListId 
                                                             , inJuridicalId             := 0
                                                             , inUserId                  := vbUserId
                                                              );
         
     -- Выбираем сохраненные данные из документа
     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
            SELECT tmp.*
            FROM gpSelect_MovementItem_PersonalService(vbMovementId2, FALSE, FALSE, inSession) AS tmp
            ;
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                    := COALESCE (tmpMI.Id,0)                                  ::Integer
                                                        , inMovementId            := vbMovementId2                                          ::Integer
                                                        , inPersonalId            := tmp.PersonalId                              ::Integer
                                                        , inIsMain                := COALESCE (tmpMI.isMain, inisMain)         ::Boolean
                                                        , inSummService           := COALESCE (tmpMI.SummService,0)                         ::TFloat
                                                        , inSummCardRecalc        := COALESCE (tmpMI.SummCardRecalc,0)                      ::TFloat
                                                        , inSummCardSecondRecalc  := COALESCE (tmpMI.SummCardSecondRecalc,0)                ::TFloat
                                                        , inSummCardSecondCash    := COALESCE (tmpMI.SummCardSecondCash,0)                  ::TFloat
                                                        , inSummNalogRecalc       := COALESCE (tmpMI.SummNalogRecalc,0)                     ::TFloat
                                                        , inSummNalogRetRecalc    := COALESCE (tmpMI.SummNalogRetRecalc,0)                ::TFloat
                                                        , inSummMinus             := COALESCE (tmpMI.SummMinus,0)                           ::TFloat
                                                        , inSummAdd               := COALESCE (tmpMI.SummAdd,0)                             ::TFloat
                                                        , inSummAddOthRecalc      := COALESCE (tmpMI.SummAddOthRecalc,0)                    ::TFloat
                                                        , inSummHoliday           := tmp.SummHoliday                         ::TFloat
                                                        , inSummSocialIn          := COALESCE (tmpMI.SummSocialIn,0)                        ::TFloat
                                                        , inSummSocialAdd         := COALESCE (tmpMI.SummSocialAdd,0)                       ::TFloat
                                                        , inSummChildRecalc       := COALESCE (tmpMI.SummChildRecalc,0)            ::TFloat
                                                        , inSummMinusExtRecalc    := COALESCE (tmpMI.SummMinusExtRecalc,0)         ::TFloat
                                                        , inSummFine              := COALESCE (tmpMI.SummFine,0)                            ::TFloat
                                                        , inSummFineOthRecalc     := COALESCE (tmpMI.SummFineOthRecalc,0)                   ::TFloat
                                                        , inSummHosp              := COALESCE (tmpMI.SummHosp,0)                            ::TFloat
                                                        , inSummHospOthRecalc     := COALESCE (tmpMI.SummHospOthRecalc,0)                   ::TFloat
                                                        , inSummCompensationRecalc:= COALESCE (tmpMI.SummCompensationRecalc,0)              ::TFloat
                                                        , inSummAuditAdd          := COALESCE (tmpMI.SummAuditAdd,0)                        ::TFloat
                                                        , inSummHouseAdd          := COALESCE (tmpMI.SummHouseAdd,0)                        ::TFloat
                                                        , inNumber                := COALESCE (tmpMI.Number, '')                            ::TVarChar
                                                        , inComment               := COALESCE (tmpMI.Comment, '')                           ::TVarChar
                                                        , inInfoMoneyId           := COALESCE (tmpMI.InfoMoneyId, zc_Enum_InfoMoney_60101()) ::Integer
                                                        , inUnitId                := COALESCE (tmp.UnitId, tmpMI.UnitId)                    ::Integer
                                                        , inPositionId            := tmp.PositionId                                         ::Integer
                                                        , inMemberId              := 0                                                      ::Integer 
                                                        , inPersonalServiceListId := COALESCE (tmp.PersonalServiceListId, tmpMI.PersonalServiceListId) :: Integer
                                                        , inFineSubjectId         := COALESCE (tmpMI.FineSubjectId,0)                       ::Integer
                                                        , inUnitFineSubjectId     := COALESCE (tmpMI.UnitFineSubjectId,0)                   ::Integer
                                                        , inUserId                := vbUserId
                                                      ) 
     FROM (SELECT inMemberId   AS MemberId
                , inPersonalId AS PersonalId
                , inPositionId AS PositionId
                , inUnitId     AS UnitId       
                , inPersonalServiceListId AS PersonalServiceListId
                , inSummHoliday2 AS SummHoliday
          ) AS tmp         
          LEFT JOIN tmpMI ON tmpMI.PersonalId = tmp.PersonalId
                         AND tmpMI.MemberId = tmp.MemberId
                         AND tmpMI.PositionId = tmp.PositionId
     ;
     END IF;


     -- сохранили свойство <Ср.ЗП за день >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), inMovementId, inAmountCompensation);
     -- сохранили свойство <№ док Начисление зарплаты(первый период) 	>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementId(), inMovementId, vbMovementId1); 
     
     IF COALESCE (vbMovementId2,0) <> 0
     THEN
         -- сохранили свойство <№ док Начисление зарплаты(второй период)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), inMovementId, vbMovementId2);
     END IF;
   
   
     IF vbUserId = '9457' 
     THEN
         --
         RAISE EXCEPTION 'Ошибка.Документ создан <%>', (SELECT Movement.InvNumber||' от' || Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId1);
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