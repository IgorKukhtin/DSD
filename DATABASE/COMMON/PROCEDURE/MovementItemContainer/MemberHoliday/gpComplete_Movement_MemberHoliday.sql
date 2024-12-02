-- Function: gpComplete_Movement_MemberHoliday (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_MemberHoliday (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_MemberHoliday(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_MemberHoliday());

     --проверка  по дням список бригады, если его внесли в какой-то день выдавать ошибку что он есть  документе № дата и т.д.
     PERFORM gpGet_MemberHoliday_Check_byPersonalGroup (inMovementId, inSession);

     IF vbUserId <> 5
     THEN
         -- автоматом проставляем в zc_Movement_SheetWorkTime сотруднику за период соответсвующий WorkTimeKind - при распроведении или удалении - в табеле удаляется WorkTimeKind
         PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(inMovementId, FALSE, (-1 * vbUserId)::TVarChar);
     END IF;


    -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_MemberHoliday()
                                , inUserId     := vbUserId
                                 );

     -- если свойство <№ док Начисление зарплаты (1 период)> + <№ док Начисление зарплаты (2 период)>
     IF EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementId()     AND MF.ValueData > 0)
     OR EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_MovementItemId() AND MF.ValueData > 0)
     THEN
         PERFORM gpInsertUpdate_Movement_PersonalServiceByHoliday (inMovementId             := inMovementId
                                                                 , inMemberId               := gpGet.MemberId
                                                                 , inPersonalId             := gpGet.PersonalId
                                                                 , inPersonalServiceListId  := gpGet.PersonalServiceListId
                                                                 , inMovementId_1           := gpGet.MovementId_PersonalService1
                                                                 , inMovementId_2           := gpGet.MovementId_PersonalService2
                                                                 , inSummHoliday1           := gpGet.SummHoliday1_calc
                                                                 , inSummHoliday2           := gpGet.SummHoliday2_calc
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

-- !!! ВРЕМЕННО !!!
IF vbUserId = 5 AND 1=0 THEN
    RAISE EXCEPTION 'Admin - Test = OK';
END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.18         *
*/

-- тест
-- SELECT * FROM gpComplete_Movement_MemberHoliday (inMovementId:= -1, inSession:= zfCalc_UserAdmin())
