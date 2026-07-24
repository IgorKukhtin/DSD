-- Function: gpInsertUpdate_Movement_SaleCommerc()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SaleCommerc (Integer, TVarChar, TDateTime, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SaleCommerc(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inComment             TVarChar   , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SaleCommerc());


     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_SaleCommerc (ioId               := ioId
                                                 , inInvNumber        := inInvNumber
                                                 , inOperDate         := inOperDate
                                                 , inComment          := inComment
                                                 , inUserId           := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.26         *
*/

-- тест
--