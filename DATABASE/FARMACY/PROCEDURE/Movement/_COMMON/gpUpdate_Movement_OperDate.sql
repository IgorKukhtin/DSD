-- Function: gpUpdate_Movement_Income_BranchDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OperDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OperDate (
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbDescId     Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Income_BranchDate());
    vbUserId := inSession;

    IF COALESCE (inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен!';
    END IF;

    -- проверка
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
    END IF;

    -- определяем вид документа,  номер документа
    SELECT Movement.DescId    AS DescId
         , Movement.InvNumber AS InvNumber
           INTO vbDescId, vbInvNumber
    FROM Movement
    WHERE Movement.Id = inMovementId;
    
    -- сохранили <Документ> c новой датой 
    PERFORM lpInsertUpdate_Movement (inMovementId, vbDescId, vbInvNumber, inOperDate, NULL);
    
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.07.17         *

*/
