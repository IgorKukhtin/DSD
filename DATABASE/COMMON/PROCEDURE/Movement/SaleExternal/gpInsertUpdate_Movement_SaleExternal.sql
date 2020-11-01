-- Function: gpInsertUpdate_Movement_SaleExternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SaleExternal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SaleExternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inGoodsPropertyId     Integer   , -- 
    In inComment             TVarChar  , -- примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SaleExternal());

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_SaleExternal
                                       (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inOperDate         := inOperDate
                                      , inFromId           := inFromId
                                      , inGoodsPropertyId  := inGoodsPropertyId
                                      , inComment          := inComment
                                      , inUserId           := vbUserId
                                       )AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
31.10.20          *
*/

-- тест
--