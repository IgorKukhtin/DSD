-- Function: gpInsertUpdate_Movement_ProfitLossResult()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossResult (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossResult(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inAccountId           Integer   , -- 
    IN inisCorrective        Boolean   , -- 
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossResult());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_ProfitLossResult (ioId           := ioId
                                                     , inInvNumber    := inInvNumber
                                                     , inOperDate     := inOperDate
                                                     , inAccountId    := inAccountId
                                                     , inisCorrective := inisCorrective
                                                     , inComment      := inComment
                                                     , inUserId       := vbUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.03.21         *
*/

-- тест
--