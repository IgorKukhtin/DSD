-- Function: gpInsertUpdate_Movement_EmployeeScheduleVIP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EmployeeScheduleVIP (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EmployeeScheduleVIP(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
 INOUT ioOperDate              TDateTime  , -- Дата документа
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EmployeeScheduleVIP());
    vbUserId := inSession;
    ioOperDate := date_trunc('month', ioOperDate);

    -- проверка прав пользователя на вызов процедуры
    IF vbUserId NOT IN (3, 4183126, 235009)
    THEN
      RAISE EXCEPTION 'Изменение <График работы VIP менеджеров> вам запрещено.';
    END IF;

    IF COALESCE (ioId, 0) = 0 AND
       EXISTS(SELECT 1 FROM Movement
              WHERE Movement.DescId = zc_Movement_EmployeeScheduleVIP()
                AND Movement.OperDate = ioOperDate)
    THEN
       SELECT Movement.ID 
       INTO ioId
       FROM Movement
       WHERE Movement.DescId = zc_Movement_EmployeeScheduleVIP()
         AND Movement.OperDate = ioOperDate;
    END IF;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_EmployeeScheduleVIP (ioId          := ioId
                                        , inInvNumber       := inInvNumber
                                        , inOperDate        := ioOperDate
                                        , inUserId          := vbUserId
                                        );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.09.21                                                        *
*/
