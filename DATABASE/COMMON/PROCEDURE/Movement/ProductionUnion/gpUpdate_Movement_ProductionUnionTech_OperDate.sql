-- Function: gpUpdate_Movement_ProductionUnionTech_OperDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnionTech_OperDate(Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnionTech_OperDate(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbStatusId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnionTech_OperDate());

    -- vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_Update_Movement_ProductionUnionTech_OperDate());


    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен!';
    END IF;

    IF inOperDate IS NOT NULL
    THEN
        vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

        IF vbStatusId = zc_Enum_Status_Complete()
        THEN
            -- распроводим
            PERFORM gpUnComplete_Movement_ProductionUnion (inMovementId:= inMovementId, inSession:= inSession);
        END IF;

        -- сохранили <Документ> c новой датой
        PERFORM lpInsertUpdate_Movement (inMovementId, Movement.DescId, Movement.InvNumber, inOperDate, NULL, Movement.AccessKeyId)
        FROM Movement
        WHERE Movement.Id = inMovementId;


        IF vbStatusId = zc_Enum_Status_Complete()
        THEN
            --если документ был проведен тогда проводим
            PERFORM gpComplete_Movement_ProductionUnion (inMovementId:= inMovementId, inIsLastComplete:= FALSE, inSession:= inSession);
        END IF;

        -- сохранили протокол
        PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

    END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.20         *

*/
