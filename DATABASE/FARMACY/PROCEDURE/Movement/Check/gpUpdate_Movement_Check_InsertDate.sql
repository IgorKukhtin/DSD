-- Function: gpUpdate_Movement_Check_InsertDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_InsertDate (Integer, TDateTime, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_InsertDate(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inOperDate          TDateTime , -- Дата/время документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpGetUserBySession (inSession);
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_InsertDate());

    IF inOperDate is null
    THEN
        RAISE EXCEPTION 'Дата не определена.';
    END IF;
    
    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    /*IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inId AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
        RETURN;
    END IF;
    */

    -- сохранили свойство <Дата создания>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), inId, inOperDate);
    -- RAISE EXCEPTION 'Дата <%>', inOperDate;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.11.22         *
*/
-- тест
--