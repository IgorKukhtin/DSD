-- Function: gpInsertUpdate_Movement_CompetitorMarkups()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CompetitorMarkups (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_CompetitorMarkups(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups());
    inOperDate := date_trunc('day', inOperDate);

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_CompetitorMarkups (ioId          := ioId
                                                     , inInvNumber       := inInvNumber
                                                     , inOperDate        := inOperDate
                                                     , inUserId          := vbUserId
                                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.05.22                                                        *
*/
