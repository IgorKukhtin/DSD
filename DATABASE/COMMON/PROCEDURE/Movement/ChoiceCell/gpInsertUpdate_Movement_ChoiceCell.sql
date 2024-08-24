-- Function: gpInsertUpdate_Movement_ChoiceCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChoiceCell (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ChoiceCell(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата(склад)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ChoiceCell());

     --vbUserId:=:= (CASE WHEN vbUserId = 5 THEN 140094 ELSE vbUserId);

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_ChoiceCell
                                       (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inOperDate         := inOperDate
                                      , inPersonalTradeId  := inPersonalTradeId
                                      , inUserId           := vbUserId
                                       )AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.08.24         *
*/

-- тест
--