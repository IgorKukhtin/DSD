-- Function: gpInsert_TelegramBot_Protocol(TVarChar)

DROP FUNCTION IF EXISTS gpInsert_TelegramBot_Protocol(Boolean,integer,TVarChar,BOOLEAN,TBLOB,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_TelegramBot_Protocol(
    IN inisInsert           Boolean,   -- Писать лог
    IN inObjectId           Integer,   -- Подразделение или сотрудник  
    IN inTelegramId         TVarChar,  -- Id отправки
    IN inisError            BOOLEAN,   -- Признак ошибка
    IN inMessage            TBLOB,     -- Текст сообщения
    IN inError              TVarChar,  -- Признак ошибка
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());

  vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE(inisInsert, FALSE) <> TRUE
  THEN
    RETURN;
  END IF;

  INSERT INTO Log_Send_Telegram (DateSend, ObjectId, TelegramId, isError, Message, Error, UserId)
  VALUES (CURRENT_TIMESTAMP, inObjectId, inTelegramId, inisError, inMessage, inError, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.11.21                                                       *

*/

-- SELECT * FROM gpInsert_TelegramBot_Protocol(inMovementID := 25504550  ,inSession := '3')