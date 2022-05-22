-- Function: lpComplete_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement(
    IN inMovementId        Integer  , -- ключ объекта <Документ>
    IN inDescId            Integer  , -- 
    IN inUserId            Integer    -- Пользователь
)                              
  RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbDescId Integer;
   DECLARE vbCloseDate TDateTime;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbStatusId Integer;

   DECLARE vbRoleName TVarChar;
BEGIN
  -- проверка
  /*IF EXISTS (SELECT MovementId FROM MovementItemContainer WHERE MovementId = inMovementId)
  THEN
      RAISE EXCEPTION 'Ошибка.Существуют проводки.Проведение не возможно.';
  END IF;*/

  -- 0. Проверка
  IF COALESCE (inMovementId, 0) = 0
  THEN
      RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
  END IF;

  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
  RETURNING OperDate, DescId, AccessKeyId, StatusId INTO vbOperDate, vbDescId, vbAccessKeyId, vbStatusId;


  -- 1.1. Проверка
  IF COALESCE (vbDescId, -1) <> COALESCE (inDescId, -2)
  THEN
      RAISE EXCEPTION 'Ошибка.Вид документа не определен.<%><%>', vbDescId, inDescId;
  END IF;
  -- 1.2. Проверка
  /*IF COALESCE (vbStatusId, 0) NOT IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
  THEN
      RAISE EXCEPTION 'Ошибка.Документа № <%> от <%> уже проведен.<%><%>', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), vbStatusId, inMovementId;
  END IF;*/


  -- по этим док-там !!!нет закрытия периода!!!
  /*IF inDescId NOT IN (zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
  THEN

  -- для Админа  - Все Права
  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
  THEN 
  -- проверка прав для <AccessKey>
  IF inDescId = zc_Movement_Sale()
  THEN 
      IF lpGetAccessKey (inUserId, COALESCE ((SELECT MAX (ProcessId) FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Sale(), zc_Enum_Process_InsertUpdate_Movement_Sale_Partner())), zc_Enum_Process_InsertUpdate_Movement_Sale()))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 128491 -- Хохлова Е.Ю. !!!временно!!!
         AND inUserId <> 12120 -- Нагорнова Т.С. !!!временно!!!
         -- AND inUserId <> 442559 -- Богатикова Н.В. -- 409618 -- Скрипник А.В. !!!временно!!!
         -- AND inUserId <> 81707 -- Неграш О.В.
         AND inUserId <> 131160 -- Удовик Е.Е. !!!временно!!!
         -- AND inUserId <> 81241 -- Марухно А.В. !!!временно!!!
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на проведение документа № <%> от <%> филиал <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_ReturnIn()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_ReturnIn())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 128491 -- Хохлова Е.Ю. !!!временно!!!
         AND inUserId <> 12120 -- Нагорнова Т.С. !!!временно!!!
         -- AND inUserId <> 442559 -- Богатикова Н.В. -- 409618 -- Скрипник А.В. !!!временно!!!
         -- AND inUserId <> 81707 -- Неграш О.В.
         AND inUserId <> 131160 -- Удовик Е.Е. !!!временно!!!
         -- AND inUserId <> 81241 -- Марухно А.В. !!!временно!!!
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на проведение документа № <%> от <%> филиал <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_Tax()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Tax())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 12120 -- Нагорнова Т.С. !!!временно!!!
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на проведение документа <%> № <%> от <%> филиал <%>.', lfGet_Object_ValueData (inUserId), (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_TaxCorrective()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_TaxCorrective())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         AND inUserId <> 12120 -- Нагорнова Т.С. !!!временно!!!
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на проведение документа <%> № <%> от <%> филиал <%>.', lfGet_Object_ValueData (inUserId), (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  END IF;
  END IF;
  END IF;
  END IF;
  END IF;


  -- !!!НОВАЯ СХЕМА ПРОВЕРКИ - Закрытый период!!!
  PERFORM lpCheckPeriodClose (inOperDate      := vbOperDate
                            , inMovementId    := inMovementId
                            , inMovementDescId:= inDescId
                            , inAccessKeyId   := vbAccessKeyId
                            , inUserId        := inUserId
                             );

  END IF; -- по этим док-там !!!нет закрытия периода!!!
*/

  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

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
