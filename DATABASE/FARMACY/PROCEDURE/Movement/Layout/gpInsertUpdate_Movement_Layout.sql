-- Function: gpInsertUpdate_Movement_Layout()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Layout (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Layout(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Списания>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inLayoutId            Integer   , -- название выкладки
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Layout());
     vbUserId:= lpGetUserBySession (inSession);
	 
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Layout (ioId           := ioId
                                           , inInvNumber    := inInvNumber
                                           , inOperDate     := inOperDate
                                           , inLayoutId     := inLayoutId
                                           , inComment      := inComment
                                           , inUserId       := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.20         *
 */

-- тест
--