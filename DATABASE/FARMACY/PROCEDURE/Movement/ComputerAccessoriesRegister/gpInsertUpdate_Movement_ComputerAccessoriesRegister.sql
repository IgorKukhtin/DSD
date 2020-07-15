-- Function: gpInsertUpdate_Movement_ComputerAccessoriesRegister()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ComputerAccessoriesRegister (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ComputerAccessoriesRegister(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , --
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession;
      
     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
       RAISE EXCEPTION 'Разрешено только системному администратору';
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_ComputerAccessoriesRegister (ioId               := ioId
                                                             , inInvNumber        := inInvNumber
                                                             , inOperDate         := inOperDate
                                                             , inUnitId           := inUnitId
                                                             , inComment          := inComment
                                                             , inUserId           := vbUserId
                                                              );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.07.20                                                       *
*/

-- тест
-- 
