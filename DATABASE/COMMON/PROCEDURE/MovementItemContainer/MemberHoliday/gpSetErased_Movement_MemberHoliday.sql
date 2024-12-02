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
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MemberHoliday());

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

     -- при распроведении или удалении - в табеле автоматом  удаляется WorkTimeKind
     IF vbUserId <> 5
     THEN
         PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, TRUE, inSession);
     END IF;


     -- если свойство <№ док Начисление зарплаты (1 период)> + <№ док Начисление зарплаты (2 период)>
     IF EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementId()     AND MF.ValueData > 0)
     OR EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementItemId() AND MF.ValueData > 0)
     THEN
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
