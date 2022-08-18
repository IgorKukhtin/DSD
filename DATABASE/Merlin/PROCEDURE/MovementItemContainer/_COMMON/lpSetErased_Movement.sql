-- Function: lpSetErased_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS gpSetErased_Movement (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpSetErased_Movement (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_Movement(
    IN inMovementId        Integer  , -- ключ объекта <Документ>
    IN inUserId            Integer    -- Пользователь
)                              
  RETURNS VOID
AS
$BODY$
  DECLARE vbStatusId_old Integer;
  DECLARE vbOperDate     TDateTime;
  DECLARE vbDescId       Integer;
  DECLARE vbAccessKeyId  Integer;
BEGIN

  -- 0. Проверка
  IF COALESCE (inMovementId, 0) = 0
  THEN
      RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
  END IF;

  -- 1.0.
  vbStatusId_old:= (SELECT StatusId FROM Movement WHERE Id = inMovementId);

  -- 1.1. Проверки на "распроведение" / "удаление"
  --IF vbStatusId_old = zc_Enum_Status_Complete() THEN PERFORM lpCheck_Movement_Status (inMovementId, inUserId); END IF;

  -- 1.2. Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() WHERE Id = inMovementId
  RETURNING OperDate, DescId, AccessKeyId INTO vbOperDate, vbDescId, vbAccessKeyId;


  -- 1.3. ПРОВЕРКА - Закрытый период + проверка пользователя
  IF vbStatusId_old = zc_Enum_Status_Complete()
  THEN 
      IF inUserId > 0 OR vbOperDate < '01.02.2022'
      THEN
          PERFORM lpCheckPeriodClose (inOperDate      := vbOperDate
                                    , inMovementId    := inMovementId
                                    , inMovementDescId:= vbDescId
                                    , inAccessKeyId   := vbAccessKeyId
                                    , inUserId        := inUserId
                                     );
      END IF;
  END IF;


  -- 3.1. Удаляем все проводки
  PERFORM lpDelete_MovementItemContainer (inMovementId);


  -- 4. сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, ABS (inUserId), FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.14                                        * add vbAccessKeyId
 05.09.14                                        * add lpCheck_Movement_Status
 25.05.14                                        * add проверка прав для <Закрытие периода>
 10.05.14                                        * add проверка <Зарегестрирован>
 10.05.14                                        * add lpInsert_MovementProtocol
 06.10.13                                        * add inUserId
 01.09.13                                        * add lpDelete_MovementItemReport
*/

-- тест
-- SELECT * FROM lpSetErased_Movement (inMovementId:= 55, inSession:= '2')
