-- Function: gpInsertUpdate_Movement_RepriceChange()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_RepriceChange (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_RepriceChange(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inRetailId              Integer    , -- От кого (торг.сеть)
    IN inGUID                  TVarChar   , -- GUID для определения текущей переоценки
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_RepriceChange());
    vbUserId := inSession;
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_RepriceChange (ioId          := ioId
                                                 , inInvNumber   := inInvNumber
                                                 , inOperDate    := inOperDate
                                                 , inRetailId    := inRetailId
                                                 , inGUID        := inGUID
                                                 , inUserId      := vbUserId
                                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.18         *
*/