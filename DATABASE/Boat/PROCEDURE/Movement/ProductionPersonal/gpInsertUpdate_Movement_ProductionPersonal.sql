-- Function: gpInsertUpdate_Movement_ProductionPersonal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionPersonal(Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionPersonal(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделение
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionPersonal());
    vbUserId := lpGetUserBySession (inSession);

    --
    ioId := lpInsertUpdate_Movement_ProductionPersonal(ioId
                                                     , inInvNumber
                                                     , inOperDate
                                                     , inUnitId
                                                     , inComment
                                                     , vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.21         *
*/

-- тест
--