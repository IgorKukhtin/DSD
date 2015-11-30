-- Function: gpInsertUpdate_Movement_Reprice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Reprice (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Reprice(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inUnitId                Integer    , -- От кого (подразделение)
    IN inGUID                  TVarChar   , -- GUID для определения текущей переоценки
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reprice());
    vbUserId := inSession;
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_Reprice (ioId          := ioId
                                        , inInvNumber   := inInvNumber
                                        , inOperDate    := inOperDate
                                        , inUnitId      := inUnitId
                                        , inGUID        := inGUID
                                        , inUserId      := vbUserId
                                        );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 27.11.15                                                                        *
*/