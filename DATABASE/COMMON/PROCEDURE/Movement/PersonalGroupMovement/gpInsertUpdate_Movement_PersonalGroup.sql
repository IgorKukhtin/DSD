-- Function: gpInsertUpdate_Movement_PersonalGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalGroup (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalGroup(
 INOUT ioId                  Integer   , -- Ключ объекта <>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата()
    IN inUnitId              Integer   , -- 
    IN inPersonalGroupId     Integer   , -- 
    IN inPairDayId           Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalGroup());

     --vbUserId:=:= (CASE WHEN vbUserId = 5 THEN 140094 ELSE vbUserId);

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_PersonalGroup (ioId              := ioId
                                                 , inInvNumber       := inInvNumber
                                                 , inOperDate        := inOperDate
                                                 , inUnitId          := inUnitId
                                                 , inPersonalGroupId := inPersonalGroupId
                                                 , inPairDayId       := inPairDayId
                                                 , inUserId          := vbUserId
                                                  )AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.21         *
*/

-- тест
--