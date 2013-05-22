-- Function: gpUnComplete_Movement()

-- DROP FUNCTION gpUnComplete_Movement(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement(
   IN inMovementId        Integer,   	/* ключ объекта <Документ> */
   IN inSession           TVarChar       /* текущий пользователь */
)                              
  RETURNS void AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

  -- Удаляем все проводки
  PERFORM lpDelete_MovementItemContainer(inMovementId);

  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Object_Status_UnComplete() WHERE Id = inMovementId;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            