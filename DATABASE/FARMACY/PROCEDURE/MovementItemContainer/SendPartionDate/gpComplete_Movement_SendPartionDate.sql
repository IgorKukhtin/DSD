-- Function: gpComplete_Movement_SendPartionDate()

DROP FUNCTION IF EXISTS gpComplete_Movement_SendPartionDate  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SendPartionDate(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
    vbUserId:= inSession;
    
  -- пересчитали Итоговые суммы
  --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
  
  IF EXISTS(SELECT 1 FROM Movement AS MovementCurr
               LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitCurr
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
               LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitNext
                                            ON MovementLinkObject_UnitNext.MovementId = MovementNext.Id
                                           AND MovementLinkObject_UnitNext.DescId = zc_MovementLinkObject_Unit()
                                           AND MovementLinkObject_UnitNext.ObjectId = MovementLinkObject_UnitCurr.ObjectId
               LEFT JOIN MovementBoolean AS MovementBoolean_TransferNext
                                         ON MovementBoolean_TransferNext.MovementId = MovementNext.Id
                                         AND MovementBoolean_TransferNext.DescId = zc_MovementBoolean_Transfer()
            WHERE MovementCurr.ID = inMovementId
              AND COALESCE (MovementBoolean_Transfer.ValueData, False) = False
              AND COALESCE (MovementBoolean_TransferNext.ValueData, False) = False
           )
  THEN
      RAISE EXCEPTION 'Ошибка.Есть проведеннын документы датой более даты документа...';
  END IF;

  -- собственно проводки
  PERFORM lpComplete_Movement_SendPartionDate(inMovementId, -- ключ Документа
                                        vbUserId);    -- Пользователь 
                         
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

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
-- SELECT * FROM gpComplete_Movement_SendPartionDate (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')
