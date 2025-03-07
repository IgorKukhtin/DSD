-- Function: lpUnComplete_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpUnComplete_Movement (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUnComplete_Movement(
    IN inMovementId        Integer  , -- ключ объекта <Документ>
    IN inUserId            Integer    -- Пользователь
)                              
  RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate        TDateTime;
  DECLARE vbOperDatePartner TDateTime;
  DECLARE vbDescId          Integer;
  DECLARE vbAccessKeyId     Integer;
  DECLARE vbStatusId_old    Integer;
  DECLARE vbUserId_save     Integer;
BEGIN

  -- сохранили
  vbUserId_save:= inUserId;
  -- заменили
  inUserId:= ABS (inUserId);


  -- !!!Только просмотр Аудитор!!!
  PERFORM lpCheckPeriodClose_auditor (NULL, NULL, inMovementId, NULL, NULL, inUserId);


  -- 0. Проверка
  IF COALESCE (inMovementId, 0) = 0
  THEN
      RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
  END IF;

  -- 1.0.1.
  vbStatusId_old:= (SELECT StatusId FROM Movement WHERE Id = inMovementId);

  -- 1.1. Проверки на "распроведение" / "удаление"
  IF vbStatusId_old = zc_Enum_Status_Complete() THEN PERFORM lpCheck_Movement_Status (inMovementId, inUserId); END IF;

  -- 1.2. Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete(), StatusId_next = zc_Enum_Status_UnComplete() WHERE Id = inMovementId
  RETURNING OperDate, DescId, AccessKeyId INTO vbOperDate, vbDescId, vbAccessKeyId;

  -- !!! zc_Enum_Process_Auto_PrimeCost
  IF vbStatusId_old = zc_Enum_Status_Erased() AND vbDescId = zc_Movement_Transport() AND inUserId = zc_Enum_Process_Auto_PrimeCost()
  THEN
      RAISE EXCEPTION 'Ошибка.UnComplete zc_Movement_Transport AND zc_Enum_Process_Auto_PrimeCost where MovementId = <%>', inMovementId;
  END IF;
      

  -- 1.0.2.
  vbOperDatePartner:= (SELECT MovementDate.ValueData
                       FROM MovementDate
                       WHERE MovementDate.MovementId = inMovementId
                         AND MovementDate.DescId     = zc_MovementDate_OperDatePartner()
                         AND vbDescId                <> zc_Movement_Service()
                      );

  -- Проверка - Гриневич К.А.
  IF inUserId IN (9031170) OR vbDescId = zc_Movement_Cash()
     -- Ограничение 7 дней пр-во (Гриневич)
     OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  AS UserRole_View WHERE UserRole_View.UserId = inUserId AND UserRole_View.RoleId = 11841068)
  THEN
      PERFORM lpCheckPeriodClose_local (vbOperDate, inMovementId, vbDescId, inUserId);
  END IF;


  IF vbUserId_save > 0 OR COALESCE (vbDescId, 0) <> zc_Movement_PersonalService()
  THEN
      -- 1.3. !!!НОВАЯ СХЕМА ПРОВЕРКИ - Закрытый период!!!
      IF vbStatusId_old = zc_Enum_Status_Complete()
      THEN PERFORM lpCheckPeriodClose (inOperDate      := vbOperDate
                                     , inMovementId    := inMovementId
                                     , inMovementDescId:= vbDescId
                                     , inAccessKeyId   := vbAccessKeyId
                                     , inUserId        := inUserId
                                      );
           -- если есть эта дата, тогда еще раз
           IF vbOperDatePartner IS NOT NULL
           THEN
               -- !!!НОВАЯ СХЕМА ПРОВЕРКИ - Закрытый период!!!
               PERFORM lpCheckPeriodClose (inOperDate      := vbOperDatePartner
                                         , inMovementId    := inMovementId
                                         , inMovementDescId:= vbDescId
                                         , inAccessKeyId   := vbAccessKeyId
                                         , inUserId        := inUserId
                                          );
           END IF;
      END IF;

  END IF;


  -- для Админа  - Все Права
  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
  THEN 
  -- проверка прав для <AccessKey>
  IF vbDescId = zc_Movement_Sale()
  THEN 
      IF lpGetAccessKey (inUserId, COALESCE ((SELECT MAX (ProcessId)FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Sale(), zc_Enum_Process_InsertUpdate_Movement_Sale_Partner())), zc_Enum_Process_InsertUpdate_Movement_Sale()))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         -- Проведение документов - нет проверки по филиалу
         AND NOT EXISTS  (SELECT 1 FROM Object_Role_Process_View WHERE Object_Role_Process_View.ProcessId = zc_Enum_Process_UpdateMovement_Branch() AND Object_Role_Process_View.UserId = inUserId)
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на распроведение документа № <%> от <%> филиал <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF vbDescId = zc_Movement_ReturnIn() AND NOT (lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn()) = zc_Enum_Process_AccessKey_DocumentDnepr() AND vbAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentKrRog(), zc_Enum_Process_AccessKey_DocumentZaporozhye()))
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_ReturnIn())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         -- Проведение документов - нет проверки по филиалу
         AND NOT EXISTS (SELECT 1 FROM Object_Role_Process_View WHERE Object_Role_Process_View.ProcessId = zc_Enum_Process_UpdateMovement_Branch() AND Object_Role_Process_View.UserId = inUserId)
         -- Проведение возврат - все филиалы
         AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11539194)
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на распроведение документа № <%> от <%> филиал <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF vbDescId = zc_Movement_Tax()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Tax())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         -- Проведение документов - нет проверки по филиалу
         AND NOT EXISTS  (SELECT 1 FROM Object_Role_Process_View WHERE Object_Role_Process_View.ProcessId = zc_Enum_Process_UpdateMovement_Branch() AND Object_Role_Process_View.UserId = inUserId)
         -- Проведение возврат - все филиалы
         AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11539194)
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на распроведение документа <%> № <%> от <%> филиал <%>.', lfGet_Object_ValueData (inUserId), (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF vbDescId = zc_Movement_TaxCorrective()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_TaxCorrective())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
         -- Проведение документов - нет проверки по филиалу
         AND NOT EXISTS  (SELECT 1 FROM Object_Role_Process_View WHERE Object_Role_Process_View.ProcessId = zc_Enum_Process_UpdateMovement_Branch() AND Object_Role_Process_View.UserId = inUserId)
         -- Проведение возврат - все филиалы
         AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 11539194)
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на распроведение документа <%> № <%> от <%> филиал <%>.', lfGet_Object_ValueData (inUserId), (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  END IF;
  END IF;
  END IF;
  END IF;
  END IF;


  -- 3.1. Удаляем все проводки
  PERFORM lpDelete_MovementItemContainer (inMovementId);
  -- 3.2. Удаляем все проводки для отчета
  PERFORM lpDelete_MovementItemReport (inMovementId);

  -- 4. сохранили протокол
  IF inMovementId <> 0 --AND inUserId <> 5
  THEN
      PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpUnComplete_Movement (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.09.14                                        * add lpCheck_Movement_Status
 25.05.14                                        * add проверка прав для <Закрытие периода>
 10.05.14                                        * add проверка <Зарегестрирован>
 10.05.14                                        * add lpInsert_MovementProtocol
 06.10.13                                        * add inUserId
 29.08.13                                        * add lpDelete_MovementItemReport
 08.07.13                                        * rename to zc_Enum_Status_UnComplete
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 55, inUserId:= 2)
