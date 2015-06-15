-- Function: gpInsertUpdate_Movement_ProductionSeparate()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionSeparate (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionSeparate(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionSeparate());

   -- сохранили <Документ>
   ioId := lpInsertUpdate_Movement_ProductionSeparate (ioId          := ioId
                                                     , inInvNumber   := inInvNumber
                                                     , inOperDate    := inOperDate
                                                     , inFromId      := inFromId
                                                     , inToId        := inToId
                                                     , inPartionGoods:= inPartionGoods
                                                     , inUserId      := vbUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.06.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProductionSeparate (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
