-- Function: gpInsertUpdate_Movement_EmployeeSchedule()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WagesVIP (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WagesVIP(
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
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WagesVIP());
    ioOperDate := date_trunc('month', ioOperDate);

    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1 FROM Movement WHERE Movement.OperDate = ioOperDate AND Movement.DescId = zc_Movement_WagesVIP())
      THEN
        SELECT Movement.ID
        INTO ioId  
        FROM Movement 
        WHERE Movement.OperDate = ioOperDate 
          AND Movement.DescId = zc_Movement_WagesVIP();
      END IF;
    END IF;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_WagesVIP (ioId          := ioId
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
 17.09.21                                                        *
*/
