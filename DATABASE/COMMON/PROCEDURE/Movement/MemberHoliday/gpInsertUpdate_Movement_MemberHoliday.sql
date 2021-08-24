-- Function: gpInsertUpdate_Movement_MemberHoliday ()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MemberHoliday (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MemberHoliday (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_MemberHoliday(
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
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_MemberHoliday());
     vbUserId:= lpGetUserBySession (inSession);

     --проверка свойство Тип отпуска должно быть заполнено
     IF COALESCE (inWorkTimeKindId,0) = 0
     THEN
          RAISE EXCEPTION 'Ошибка.<Тип отпуска> должен быть заполнен.';
     END IF;

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_MemberHoliday ( ioId              := ioId
                                                  , inInvNumber       := inInvNumber
                                                  , inOperDate        := inOperDate
                                                  , inOperDateStart   := inOperDateStart
                                                  , inOperDateEnd     := inOperDateEnd
                                                  , inBeginDateStart  := inBeginDateStart
                                                  , inBeginDateEnd    := inBeginDateEnd
                                                  , inMemberId        := inMemberId
                                                  , inMemberMainId    := inMemberMainId
                                                  , inWorkTimeKindId  := inWorkTimeKindId
                                                  , inUserId          := vbUserId
                                                   );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.18         *
*/

-- тест
--