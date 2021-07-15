-- Function: gpInsertUpdate_Movement_TestingTuning()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TestingTuning (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TestingTuning(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Списания>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inTimeTest            Integer   , -- Время на тест (сек)
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession::Integer;
	 
     -- сохранили <Документ>
     -- Разрешаем только сотрудникам с правами админа    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin()))
    THEN
      RAISE EXCEPTION 'Вым запрещено изменять настройки тестирования';
    END IF;
    
    
    ioId := lpInsertUpdate_Movement_TestingTuning (ioId                 := ioId
                                                 , inInvNumber          := inInvNumber
                                                 , inOperDate           := inOperDate
                                                 , inTimeTest           := inTimeTest
                                                 , inComment            := inComment
                                                 , inUserId             := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_TestingTuning (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.07.21                                                       *
 */

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TestingTuning (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inArticleTestingTuningId = 1, inComment = '', inSession:= '3')