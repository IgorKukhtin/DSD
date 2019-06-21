-- Function: gpUnComplete_Movement_SendPartionDate (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_SendPartionDate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_SendPartionDate(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_SendPartionDate());

    IF EXISTS(SELECT 1 FROM Movement AS MovementCurr
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitCurr
                                              ON MovementLinkObject_UnitCurr.MovementId = MovementCurr.Id
                                             AND MovementLinkObject_UnitCurr.DescId = zc_MovementLinkObject_Unit()

                 INNER JOIN Movement AS MovementNext
                                     ON MovementNext.OperDate >= MovementCurr.OperDate
                                    AND MovementNext.DescId = zc_Movement_SendPartionDate()
                                    AND MovementNext.StatusId = zc_Enum_Status_Complete()
                                    AND MovementNext.ID <> inMovementId
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitNext
                                              ON MovementLinkObject_UnitNext.MovementId = MovementNext.Id
                                             AND MovementLinkObject_UnitNext.DescId = zc_MovementLinkObject_Unit()
                                             AND MovementLinkObject_UnitNext.ObjectId = MovementLinkObject_UnitCurr.ObjectId

              WHERE MovementCurr.ID = inMovementId
                AND MovementCurr.StatusId = zc_Enum_Status_Complete()
             )
    THEN
        RAISE EXCEPTION 'Ошибка.Распроводить можно только последний документ по подразделению...';
    END IF;

    -- проверка - если <Master> Удален, то <Ошибка>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    --пересчитываем сумму документа по приходным ценам
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);    
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.08.18                                                       *
 15.08.18         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_SendPartionDate (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())