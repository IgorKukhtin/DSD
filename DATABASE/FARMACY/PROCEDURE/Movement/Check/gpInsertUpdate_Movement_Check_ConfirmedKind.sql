-- Function: gpInsertUpdate_Movement_Check_ConfirmedKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ConfirmedKind (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_ConfirmedKind(
    IN inMovementId         Integer  , -- 
    IN inisComplete         Boolean  , --
   OUT outConfirmedKindName TVarChar , -- 
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbConfirmedKindId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    IF inisComplete = TRUE 
       THEN
           vbConfirmedKindId:= (SELECT zc_Enum_ConfirmedKind_Complete());
           outConfirmedKindName:= COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = vbConfirmedKindId), '');
       ELSE
           vbConfirmedKindId:= (SELECT zc_Enum_ConfirmedKind_UnComplete());
           outConfirmedKindName:= COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = vbConfirmedKindId), '');
    END IF;

    -- сохранили связь
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), inMovementId, vbConfirmedKindId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.10.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Check_ConfirmedKind (inSession:= zfCalc_UserAdmin())
