-- Function: gpSetErased_Movement_SendPartionDate (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_SendPartionDate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_SendPartionDate(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_SendPartionDate());

    IF EXISTS(SELECT 1 FROM Movement AS MovementCurr
                 INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCurr
                                               ON MovementLinkObject_UnitCurr.MovementId = MovementCurr.Id
                                              AND MovementLinkObject_UnitCurr.DescId = zc_MovementLinkObject_Unit()
                 LEFT JOIN MovementBoolean AS MovementBoolean_Transfer
                                           ON MovementBoolean_Transfer.MovementId = MovementCurr.Id
                                          AND MovementBoolean_Transfer.DescId = zc_MovementBoolean_Transfer()

                 INNER JOIN Movement AS MovementNext
                                     ON MovementNext.OperDate >= MovementCurr.OperDate
                                    AND MovementNext.DescId = zc_Movement_SendPartionDate()
                                    AND MovementNext.StatusId = zc_Enum_Status_Complete()
                                    AND MovementNext.ID <> inMovementId
                 INNER JOIN MovementLinkObject AS MovementLinkObject_UnitNext
                                               ON MovementLinkObject_UnitNext.MovementId = MovementNext.Id
                                              AND MovementLinkObject_UnitNext.DescId = zc_MovementLinkObject_Unit()
                                              AND MovementLinkObject_UnitNext.ObjectId = MovementLinkObject_UnitCurr.ObjectId

                 LEFT JOIN MovementBoolean AS MovementBoolean_TransferNext
                                           ON MovementBoolean_TransferNext.MovementId = MovementNext.Id
                                           AND MovementBoolean_TransferNext.DescId = zc_MovementBoolean_Transfer()
              WHERE MovementCurr.ID = inMovementId
                AND COALESCE (MovementBoolean_Transfer.ValueData, False) = False
                AND COALESCE (MovementBoolean_TransferNext.ValueData, False) = False
                AND MovementCurr.StatusId = zc_Enum_Status_Complete()
             )
    THEN
        RAISE EXCEPTION 'Ошибка.Распроводить можно только последний документ по подразделению...';
    END IF;

     -- проверка - если <Master> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- проверка - если есть <Child> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

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
-- SELECT * FROM gpSetErased_Movement_SendPartionDate (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
