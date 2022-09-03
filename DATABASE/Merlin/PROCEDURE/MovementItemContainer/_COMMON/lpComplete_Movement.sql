-- Function: lpComplete_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement(
    IN inMovementId        Integer  , -- ключ объекта <Документ>
    IN inDescId            Integer  , -- 
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS
VOID
AS
$BODY$
  DECLARE vbOperDate     TDateTime;
  DECLARE vbDescId       Integer;
  DECLARE vbAccessKeyId  Integer;
BEGIN
  -- 0.1. Проверка
  IF COALESCE (inMovementId, 0) = 0
  THEN
      RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
  END IF;

  -- 0.1. Проверка
  /*IF EXISTS (SELECT MovementId FROM MovementItemContainer WHERE MovementId = inMovementId)
  THEN
      RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
  END IF;*/


  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
  RETURNING OperDate, DescId, AccessKeyId, StatusId INTO vbOperDate, vbDescId, vbAccessKeyId;


  -- 1.1. Проверка
  IF COALESCE (vbDescId, -1) <> COALESCE (inDescId, -2)
  THEN
      RAISE EXCEPTION 'Ошибка.Вид документа не определен.<%><%><%><%>', vbDescId, inDescId, inMovementId, (SELECT lfGet_Object_ValueData_sh (StatusId) FROM Movement WHERE Id = inMovementId);
  END IF;
  
  IF inUserId > 0 OR (vbOperDate < '01.02.2022' AND vbDescId NOT IN (zc_Movement_Service(), zc_Movement_ServiceItemAdd()))
  THEN
      -- 1.2. Проверка
      PERFORM lpCheckPeriodClose (inOperDate      := vbOperDate
                                , inMovementId    := inMovementId
                                , inMovementDescId:= vbDescId
                                , inAccessKeyId   := vbAccessKeyId
                                , inUserId        := inUserId
                                 );
  END IF;


  -- сохранили протокол
  IF 1=1 -- AND ABS (inUserId) <> 5
  THEN
      PERFORM lpInsert_MovementProtocol (inMovementId, ABS (inUserId), FALSE);
  END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpComplete_Movement (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.14                                        * add vbAccessKeyId
 20.10.14                                        * add !!!временно если не НАЛ!!!
 23.09.14                                        * add Object_Role_MovementDesc_View
 25.05.14                                        * add проверка прав для <Закрытие периода>
 10.05.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement (inMovementId:= 55, inUserId:= 2)
