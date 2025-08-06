-- Function: gpInsert_MI_PersonalService_byHospitalDoc()

--DROP FUNCTION IF EXISTS gpInsert_MI_PersonalService_byHospitalDoc (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_MI_PersonalService_byHospitalDoc (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_PersonalService_byHospitalDoc(
    IN inMovementId_hd       Integer   , -- Ключ объекта <Документа Больничный 1С>
    IN inisDeleted           Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbPersonalId  Integer;
           vbMovementId  Integer;
           vbServiceDate TDateTime;
           vbPersonalServiceListId Integer;
           vbSummHospOthRecalc     TFloat;
           

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     --RAISE EXCEPTION 'Сотрудник <%> не найден с ИНН = <%> и суммой <%> .', inFIO, inINN, inSummMinusExtRecalc;
     --RAISE EXCEPTION 'Ошибка. Документ не сохранен';
 
     IF COALESCE (inMovementId_hd,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не выбран';
     END IF;

     vbServiceDate := (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId_hd AND MovementDate.DescId = zc_MovementDate_ServiceDate());
     vbPersonalId  := (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId_hd AND MovementLinkObject.DescId = zc_MovementLinkObject_Personal());
     vbSummHospOthRecalc := (SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId_hd AND MovementFloat.DescId = zc_MovementFloat_SummStart());

     --если сумма 0 пропустить
     IF COALESCE (vbSummHospOthRecalc,0) = 0
     THEN
         RETURN;
     END IF;
            
     --Данные для ведомости  Id = 4409664; Code = 269; Name = "Відомість Лікарняні за рахунок підприємства" 
     vbPersonalServiceListId := 4409664;
     
     -- Находим докумнт Начисления
     vbMovementId := (SELECT Movement.Id
                      FROM MovementDate AS MovementDate_ServiceDate 
                          INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                             AND Movement.DescId = zc_Movement_PersonalService()
                                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                          INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                        ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                       AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                       AND MovementLinkObject_PersonalServiceList.ObjectId   = vbPersonalServiceListId
                      WHERE MovementDate_ServiceDate.ValueData = vbServiceDate
                        AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                      );
     IF COALESCE (vbMovementId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ для ведомости <Відомість Лікарняні за рахунок підприємства> не найден.';
     END IF;

     IF zc_Enum_Status_Complete() = (SELECT StatusId FROM Movement WHERE Id = vbMovementId)
     THEN
         RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> Проведен.'
                         , (SELECT ItemName FROM MovementDesc WHERE Id = (SELECT DescId FROM Movement WHERE Id = vbMovementId))
                         , (SELECT InvNumber FROM Movement WHERE Id = vbMovementId)
                         , (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId);
     END IF;
                 
     
     -- сохранили, в случае если сотрудника не было в ведомости сохраним его
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                  := COALESCE (gpSelect.Id,0)
                                                        , inMovementId          := vbMovementId
                                                        , inPersonalId          := tmpPersonal.PersonalId
                                                        , inIsMain              := COALESCE (gpSelect.IsMain, tmpPersonal.IsMain) ::Boolean
                                                        , inSummService         := COALESCE (gpSelect.SummService, 0)             ::TFloat
                                                        , inSummCardRecalc      := COALESCE (gpSelect.SummCardRecalc, 0)          ::TFloat
                                                        , inSummCardSecondRecalc:= COALESCE (gpSelect.SummCardSecondRecalc, 0)    ::TFloat
                                                        , inSummCardSecondCash  := COALESCE (gpSelect.SummCardSecondCash,0)       ::TFloat
                                                        , inSummNalogRecalc     := COALESCE (gpSelect.SummNalogRecalc, 0)         ::TFloat
                                                        , inSummNalogRetRecalc  := COALESCE (gpSelect.SummNalogRetRecalc, 0)      ::TFloat
                                                        , inSummMinus           := COALESCE (gpSelect.SummMinus, 0)               ::TFloat
                                                        , inSummAdd             := COALESCE (gpSelect.SummAdd, 0)                 ::TFloat
                                                        , inSummAddOthRecalc    := COALESCE (gpSelect.SummAddOthRecalc, 0)        ::TFloat
                                                        , inSummHoliday         := COALESCE (gpSelect.SummHoliday, 0)             ::TFloat
                                                        , inSummSocialIn        := COALESCE (gpSelect.SummSocialIn, 0)            ::TFloat
                                                        , inSummSocialAdd       := COALESCE (gpSelect.SummSocialAdd, 0)           ::TFloat
                                                        , inSummChildRecalc     := COALESCE (gpSelect.SummChildRecalc, 0)         ::TFloat
                                                        , inSummMinusExtRecalc  := COALESCE (gpSelect.SummMinusExtRecalc, 0)      ::TFloat
                                                        , inSummFine            := COALESCE (gpSelect.SummFine, 0)                ::TFloat
                                                        , inSummFineOthRecalc   := COALESCE (gpSelect.Amount, 0)                  ::TFloat  
                                                        , inSummHosp            := COALESCE (gpSelect.SummHosp, 0)                ::TFloat
                                                        , inSummHospOthRecalc   := CASE WHEN inisDeleted = TRUE THEN 0 
                                                                                        ELSE COALESCE (gpSelect.SummHospOthRecalc,0) + COALESCE (vbSummHospOthRecalc,0) 
                                                                                   END ::TFloat     --сотрудникам обнулим , затем с накопление загрузим все больничные (в случае если их несколько)
                                                        , inSummCompensationRecalc := COALESCE (gpSelect.SummCompensationRecalc, 0) ::TFloat
                                                        , inSummAuditAdd        := COALESCE (gpSelect.SummAuditAdd,0)             ::TFloat
                                                        , inSummHouseAdd        := COALESCE (gpSelect.SummHouseAdd,0)             ::TFloat
                                                        , inSummAvanceRecalc    := COALESCE (gpSelect.SummAvance,0)               ::TFloat
                                                        , inNumber              := COALESCE (gpSelect.Number, '')                 ::TVarChar
                                                        , inComment             := COALESCE (gpSelect.Comment, '')                ::TVarChar
                                                        , inInfoMoneyId         := COALESCE (gpSelect.InfoMoneyId, zc_Enum_InfoMoney_60101())  ::Integer-- 60101 Заработная плата + Заработная плата
                                                        , inUnitId              := tmpPersonal.UnitId                             ::Integer
                                                        , inPositionId          := tmpPersonal.PositionId                         ::Integer
                                                        , inMemberId               := gpSelect.MemberId                           ::Integer         
                                                        , inPersonalServiceListId  :=COALESCE (gpSelect.PersonalServiceListId, tmpPersonal.PersonalServiceListId)  ::Integer
                                                        , inFineSubjectId          := COALESCE (gpSelect.FineSubjectId,0)         ::Integer
                                                        , inUnitFineSubjectId      := COALESCE (gpSelect.UnitFineSubjectId,0)     ::Integer
                                                        , inUserId              :=vbUserId                                        ::Integer
                                                         )
      FROM (SELECT View_Personal.PersonalId
                 , View_Personal.UnitId
                 , View_Personal.PositionId
                 , View_Personal.IsMain 
                 , ObjectLink_PersonalServiceList.ChildObjectId AS PersonalServiceListId
            FROM Object_Personal_View AS View_Personal 
                 LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                                      ON ObjectLink_PersonalServiceList.ObjectId = View_Personal.PersonalId
                                     AND ObjectLink_PersonalServiceList.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
            WHERE View_Personal.PersonalId = vbPersonalId
           ) AS tmpPersonal
           LEFT JOIN gpSelect_MovementItem_PersonalService (vbMovementId, FALSE, FALSE, inSession) AS gpSelect
                                                                                                   ON gpSelect.PersonalId = tmpPersonal.PersonalId
                                                                                                  AND gpSelect.UnitId     = tmpPersonal.UnitId
                                                                                                  AND gpSelect.PositionId = tmpPersonal.PositionId                                                                              
      LIMIT 1; 
           
    
    -- !!! ВРЕМЕННО !!!
    IF  vbUserId = 9457 THEN
        RAISE EXCEPTION 'Admin - Test = OK <%>', vbSummHospOthRecalc;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 06.08.25         * add inisDeleted
 28.07.25         *
*/

-- тест
--
