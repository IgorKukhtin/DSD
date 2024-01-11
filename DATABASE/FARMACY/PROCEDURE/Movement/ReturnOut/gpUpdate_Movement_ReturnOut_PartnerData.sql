-- Function: gpUpdate_Movement_ReturnOut_PartnerData()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnOut_PartnerData (Integer, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnOut_PartnerData (Integer, TVarChar, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnOut_PartnerData(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumberPartner    TVarChar  , -- Номер документа
    IN inOperDatePartner     TDateTime , -- Дата документа
    IN inAdjustingOurDate    TDateTime , -- Корректировка нашей даты
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbNeedComplete Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := inSession;
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ReturnOut_PartnerData());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());
    
    IF COALESCE (inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен!';
    END IF;

    -- Если документ проведен - распроводим его и отмечаем что в конце нужено его провести
    IF EXISTS(SELECT 1 FROM Movement Where Id = inMovementId AND StatusId = zc_Enum_Status_Complete())
    THEN
        PERFORM gpUnComplete_Movement_ReturnOut (inMovementId := inMovementId, inSession := inSession);
        vbNeedComplete := TRUE;
    ELSE
        vbNeedComplete := FALSE;
    END IF;
    
    --Сохранили Корректировка нашей даты
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_AdjustingOurDate(), inMovementId, CASE WHEN inAdjustingOurDate > '01.01.2000' THEN inAdjustingOurDate ELSE NULL END);
    
    --Сохранили дату партнера
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), inMovementId, CASE WHEN TRIM (inInvNumberPartner) <> '' AND inOperDatePartner > '01.01.2000' THEN inOperDatePartner ELSE NULL END);

    -- Сохранили № документа партнера
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), inMovementId, inInvNumberPartner);

    -- Если документ был распроведен - то проводим его
    IF vbNeedComplete = TRUE
    THEN
        PERFORM gpComplete_Movement_ReturnOut (inMovementId := inMovementId, inSession := inSession);
    END IF;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 29.05.18                                                                                     * 
 12.01.16                                                                        *

*/
