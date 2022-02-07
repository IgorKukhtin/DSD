-- Function: gpInsertUpdate_Movement_LayoutFile()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LayoutFile (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LayoutFile(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Списания>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inStartPromo          TDateTime , -- Дата начала показа
    IN inEndPromo            TDateTime , -- Дата окончания показа
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_LayoutFile());
     vbUserId:= lpGetUserBySession (inSession);

     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_LayoutFile (ioId              := ioId
                                               , inInvNumber       := inInvNumber
                                               , inOperDate        := inOperDate
                                               , inStartPromo      := inStartPromo
                                               , inEndPromo        := inEndPromo
                                               , inComment         := inComment
                                               , inUserId          := vbUserId
                                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.02.22                                                       *
 */

-- тест
--