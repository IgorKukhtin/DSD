-- Function: gpInsertUpdate_Movement_RetutnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_RetutnIn (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_RetutnIn(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inUnitId                Integer    , -- От кого (подразделение)
    IN inCashRegisterId        Integer    , -- 
    IN inFiscalCheckNumber     TVarChar   , -- 
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_RetutnIn());
    vbUserId := inSession;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_RetutnIn (ioId                 := ioId
                                            , inInvNumber          := inInvNumber
                                            , inOperDate           := inOperDate
                                            , inUnitId             := inUnitId
                                            , inCashRegisterId     := inCashRegisterId
                                            , inFiscalCheckNumber  := inFiscalCheckNumber
                                            , inUserId             := vbUserId
                                            );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.01.19         *
*/