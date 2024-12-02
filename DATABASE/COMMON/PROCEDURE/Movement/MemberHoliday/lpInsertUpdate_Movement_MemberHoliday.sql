-- Function: lpInsertUpdate_Movement_MemberHoliday ()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_MemberHoliday (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_MemberHoliday (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_MemberHoliday(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDateStart       TDateTime   , -- 
    IN inOperDateEnd         TDateTime  , -- 
    IN inBeginDateStart      TDateTime   , --
    IN inBeginDateEnd        TDateTime   , --
    IN inMemberId            Integer   , -- 
    IN inMemberMainId        Integer   , -- 
    IN inWorkTimeKindId      Integer   , -- Тип отпуска
    IN inUserId              Integer     -- Пользователь
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_MemberHoliday());

     -- 1. Распроводим Документ
     IF ioId > 0
     THEN
         -- сначала распроведение
         PERFORM gpUnComplete_Movement_MemberHoliday (inMovementId := ioId
                                                    , inSession    := inUserId :: TVarChar
                                                     );
         -- потом удаление - в табеле удаляется WorkTimeKind
         --IF inUserId <> 5 THEN PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(ioId, TRUE, (inUserId)::TVarChar);
         --END IF;
     END IF;
     
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_MemberHoliday(), inInvNumber, inOperDate, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_BeginDateStart(), ioId, inBeginDateStart);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_BeginDateEnd(), ioId, inBeginDateEnd);
     
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), ioId, inMemberId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberMain(), ioId, inMemberMainId);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_WorkTimeKind(), ioId, inWorkTimeKindId);
     
     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;

  
     -- 5.1. сначала проставляем в zc_Movement_SheetWorkTime сотруднику за период соответсвующий WorkTimeKind - при распроведении или удалении - в табеле удаляется WorkTimeKind
     -- IF inUserId <> 5 THEN PERFORM gpInsertUpdate_MovementItem_SheetWorkTime_byMemberHoliday(ioId, FALSE, (-1 * inUserId)::TVarChar);
     -- END IF;

     -- 5.2. потом проводим Документ + сохранили протокол
     PERFORM gpComplete_Movement_MemberHoliday (inMovementId := ioId
                                              , inSession    := inUserId :: TVarChar
                                               );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.21         * inWorkTimeKindId
 20.12.18         *
*/

-- тест
--