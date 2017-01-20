-- Function: gpUpdate_Movement_Check_OperDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_OperDate (Integer, TDateTime, TVarChar, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_OperDate(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inOperDate          TDateTime , -- Дата/время документа
    IN inInvNumber         TVarChar  , -- Номер чека
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpGetUserBySession (inSession);
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    IF inOperDate is null
    THEN
        RAISE EXCEPTION 'Дата не определена.';
    END IF;
    
    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    -- сохранили <Документ>
    inId := lpInsertUpdate_Movement (inId, zc_Movement_Check(), inInvNumber::TVarChar, inOperDate, NULL);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 19.01.17         *
*/
-- тест
-- SELECT * FROM gpUpdate_Movement_Check_OperDate (inId := 0, inOperDate := NULL::TDateTime, inInvNumber:= '12345'::TVarChar, inSession := '3'::TVarChar); 
