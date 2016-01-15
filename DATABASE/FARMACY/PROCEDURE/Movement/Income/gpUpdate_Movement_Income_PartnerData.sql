-- Function: gpUpdate_Movement_Income_PartnerData()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_PartnerData(Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_PartnerData(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- № документа
    IN inPaymentDate         TDateTime , -- Дата оплаты
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
    vbUserId := inSession;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен!';
    END IF;

    IF EXISTS(SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.InvNumber <> inInvNumber)
    THEN
        UPDATE Movement SET
            InvNumber = inInvNumber
        WHERE
            Id = inMovementId;
    END IF;
    
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Payment(), inMovementId, inPaymentDate);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.05.15                         *

*/
