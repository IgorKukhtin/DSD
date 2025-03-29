-- Function: gpSetErased_Movement_MemberHoliday (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_MemberHoliday (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_MemberHoliday(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbBeginDateStart TDateTime;
  DECLARE vbBeginDateEnd TDateTime;
  DECLARE vbMemberId Integer;
  DECLARE vbWorkTimeKindId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MemberHoliday());
     
     
     SELECT gpGet.OperDate
          , gpGet.BeginDateStart, gpGet.BeginDateEnd
          , gpGet.MemberId
          , gpGet.WorkTimeKindId
            INTO vbOperDate
               , vbBeginDateStart, vbBeginDateEnd
               , vbMemberId
               , vbWorkTimeKindId
     FROM gpGet_Movement_MemberHoliday (inMovementId, CURRENT_DATE, inSession) AS gpGet
    ;
              

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     -- при распроведении или удалении - в табеле автоматом  удаляется WorkTimeKind
     IF vbUserId <> 5 AND NOT EXISTS (SELECT 1
                                      FROM Movement
                                           INNER JOIN MovementDate AS MovementDate_BeginDateStart
                                                                   ON MovementDate_BeginDateStart.MovementId = Movement.Id
                                                                  AND MovementDate_BeginDateStart.DescId     = zc_MovementDate_BeginDateStart()
                                                                  AND MovementDate_BeginDateStart.ValueData  = vbBeginDateStart
            
                                           INNER JOIN MovementDate AS MovementDate_BeginDateEnd
                                                                   ON MovementDate_BeginDateEnd.MovementId = Movement.Id
                                                                  AND MovementDate_BeginDateEnd.DescId     = zc_MovementDate_BeginDateEnd()
                                                                  AND MovementDate_BeginDateEnd.ValueData  = vbBeginDateEnd
            
                                           INNER JOIN MovementLinkObject AS MovementLinkObject_WorkTimeKind
                                                                         ON MovementLinkObject_WorkTimeKind.MovementId = Movement.Id
                                                                        AND MovementLinkObject_WorkTimeKind.DescId     = zc_MovementLinkObject_WorkTimeKind()
                                                                        AND MovementLinkObject_WorkTimeKind.ObjectId   = vbWorkTimeKindId
            
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                                        ON MovementLinkObject_Member.MovementId = Movement.Id
                                                                       AND MovementLinkObject_Member.DescId     = zc_MovementLinkObject_Member()
                                                                       AND MovementLinkObject_Member.ObjectId   = vbMemberId
                                      WHERE Movement.DescId = zc_Movement_MemberHoliday()
                                        AND Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', vbOperDate) AND (DATE_TRUNC ('MONTH', vbOperDate + INTERVAL '1 MONTH') - INTERVAL '1 DAY')
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                     )
     THEN
         PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, TRUE, inSession);
     END IF;


     -- если свойство <№ док Начисление зарплаты (1 период)> + <№ док Начисление зарплаты (2 период)>
     IF (EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementId()     AND MF.ValueData > 0)
      OR EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementItemId() AND MF.ValueData > 0)
        )
     AND NOT EXISTS (SELECT 1
                     FROM Movement
                          INNER JOIN MovementDate AS MovementDate_BeginDateStart
                                                  ON MovementDate_BeginDateStart.MovementId = Movement.Id
                                                 AND MovementDate_BeginDateStart.DescId     = zc_MovementDate_BeginDateStart()
                                                 AND MovementDate_BeginDateStart.ValueData  = vbBeginDateStart
     
                          INNER JOIN MovementDate AS MovementDate_BeginDateEnd
                                                  ON MovementDate_BeginDateEnd.MovementId = Movement.Id
                                                 AND MovementDate_BeginDateEnd.DescId     = zc_MovementDate_BeginDateEnd()
                                                 AND MovementDate_BeginDateEnd.ValueData  = vbBeginDateEnd
     
                          INNER JOIN MovementLinkObject AS MovementLinkObject_WorkTimeKind
                                                        ON MovementLinkObject_WorkTimeKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_WorkTimeKind.DescId     = zc_MovementLinkObject_WorkTimeKind()
                                                       AND MovementLinkObject_WorkTimeKind.ObjectId   = vbWorkTimeKindId
     
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                       ON MovementLinkObject_Member.MovementId = Movement.Id
                                                      AND MovementLinkObject_Member.DescId     = zc_MovementLinkObject_Member()
                                                      AND MovementLinkObject_Member.ObjectId   = vbMemberId
                     WHERE Movement.DescId = zc_Movement_MemberHoliday()
                       AND Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', vbOperDate) AND (DATE_TRUNC ('MONTH', vbOperDate + INTERVAL '1 MONTH') - INTERVAL '1 DAY')
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                    )
     THEN
         -- Обнулили
         PERFORM gpInsertUpdate_Movement_PersonalServiceByHoliday (inMovementId             := inMovementId
                                                                 , inMemberId               := gpGet.MemberId
                                                                 , inPersonalId             := gpGet.PersonalId
                                                                 , inPersonalServiceListId  := gpGet.PersonalServiceListId
                                                                 , inMovementId_1           := (SELECT MF.ValueData :: Integer FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementId())
                                                                 , inMovementId_2           := (SELECT MF.ValueData :: Integer FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementItemId())
                                                                 , inSummHoliday1           := 0
                                                                 , inSummHoliday2           := 0
                                                                 , inAmountCompensation     := gpGet.AmountCompensation
                                                                 , inServiceDate1           := gpGet.ServiceDateStart
                                                                 , inServiceDate2           := gpGet.ServiceDateEnd
                                                                 , inUnitId                 := gpGet.UnitId
                                                                 , inPositionId             := gpGet.PositionId
                                                                 , inisMain                 := gpGet.IsMain
                                                                 , inSession                := inSession
                                                                  )
         FROM gpGet_Movement_MemberHolidayForPersonalService (inMovementId := inMovementId, inSession:= inSession) AS gpGet;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.18         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_MemberHoliday (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
