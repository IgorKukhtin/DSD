-- Function: gpInsertUpdate_Movement_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SheetWorkTimeClose (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SheetWorkTimeClose(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата начала периода
    IN inOperDateEnd         TDateTime , -- Дата окончания периода
    IN inTimeClose           TDateTime , -- Дата, Время авто закрытия 
    IN inUnitId              Integer   , -- Подразделение(Исключение)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SheetWorkTimeClose());


     -- Проверка
     IF DATE_TRUNC ('DAY', inTimeClose) <= inOperDateEnd
     THEN
         RAISE EXCEPTION 'Ошибка. Дата+время авто закрытия не может быть раньше <%>.', zfConvert_DateToString (inOperDateEnd + INTERVAL '1 DAY');
     END IF;

     -- 1. если  update
     IF ioId > 0 AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.StatusId <> zc_Enum_Status_UnComplete())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId
                                       );
     END IF;

     -- сохранили <Документ>
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_Movement_SheetWorkTimeClose (ioId           := ioId
                                                    , inInvNumber    := inInvNumber
                                                    , inOperDate     := inOperDate
                                                    , inOperDateEnd  := inOperDateEnd
                                                    , inTimeClose    := inTimeClose -- (DATE_TRUNC ('DAY', inOperDateEnd) + INTERVAL '1 DAY' + (inTimeClose - DATE_TRUNC ('DAY', inTimeClose))  :: INTERVAL) :: TDateTime
                                                    , inUnitId       := inUnitId
                                                    , inUserId       := vbUserId
                                                     ) AS tmp;

     -- проводим Документ
     PERFORM lpComplete_Movement (inMovementId := ioId
                                , inDescId     := zc_Movement_SheetWorkTimeClose()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.02.24         *
 10.08.21         *
*/

-- тест
--