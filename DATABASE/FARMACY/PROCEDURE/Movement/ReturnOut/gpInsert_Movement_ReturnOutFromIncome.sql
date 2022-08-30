-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpInsert_Movement_ReturnOutFromIncome
   (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_ReturnOutFromIncome(
   OUT outId                 Integer   , -- Ключ объекта <Документ Перемещение>
    IN inParentId            Integer   , -- Приходная накладная
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());
    --vbUserId := inSession;
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%>', inSession;
    END IF;   

    SELECT lpInsertUpdate_Movement_ReturnOut(0, CAST (NEXTVAL ('movement_ReturnOut_seq') AS TVarChar)
                                             , Current_Date        --inOperDate
                                             , NULL::TVarChar
                                             --, NULL::TDateTime   --inOperDatePartner
                                             , Movement_Income.PriceWithVAT
                                             , Movement_Income.ToId
                                             , Movement_Income.FromId
                                             , Movement_Income.NDSKindId
                                             , inParentId
                                             , NULL
                                             , NULL
                                             , NULL
                                             , NULL :: TVarChar
                                             , vbUserId)
   INTO outId
     FROM  Movement_Income_View AS Movement_Income 
     WHERE Movement_Income.Id = inParentId;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 22.11.19         *
 28.05.18                                                                     * 
 15.06.16         * 
 10.02.15                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ReturnOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
