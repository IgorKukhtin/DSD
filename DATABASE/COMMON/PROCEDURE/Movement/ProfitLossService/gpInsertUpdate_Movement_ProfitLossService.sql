-- Function: gpInsertUpdate_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_ProfitLossService (ioId               := ioId
                                                      , inInvNumber        := inInvNumber
                                                      , inOperDate         := inOperDate
                                                      , inUserId           := vbUserId
                                                       );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2');