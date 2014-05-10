-- Function: lpSetErased_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetErased_Movement (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_Movement(
    IN inMovementId        Integer  , -- ключ объекта <Документ>
    IN inUserId            Integer    -- Пользователь
)                              
  RETURNS void
AS
$BODY$
BEGIN
  -- проверка
  IF EXISTS (SELECT MovementId FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Registered())
  THEN
      RAISE EXCEPTION 'Ошибка.Документ зарегестрирован.Удаление невозможно.';
  END IF;

  -- Удаляем все проводки
  PERFORM lpDelete_MovementItemContainer (inMovementId);

  -- Удаляем все проводки для отчета
  PERFORM lpDelete_MovementItemReport (inMovementId);

  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() WHERE Id = inMovementId;

  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSetErased_Movement (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.14                                        * add проверка
 10.05.14                                        * add lpInsert_MovementProtocol
 06.10.13                                        * add inUserId
 01.09.13                                        * add lpDelete_MovementItemReport
*/

-- тест
-- SELECT * FROM lpSetErased_Movement (inMovementId:= 55, inSession:= '2')
