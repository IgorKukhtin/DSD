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

  -- Удаляем все проводки
  PERFORM lpDelete_MovementItemContainer (inMovementId);

  -- Удаляем все проводки для отчета
  PERFORM lpDelete_MovementItemReport (inMovementId);

  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() WHERE Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSetErased_Movement (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.13                                        * add inUserId
 01.09.13                                        * add lpDelete_MovementItemReport
*/

-- тест
-- SELECT * FROM lpSetErased_Movement (inMovementId:= 55, inSession:= '2')
