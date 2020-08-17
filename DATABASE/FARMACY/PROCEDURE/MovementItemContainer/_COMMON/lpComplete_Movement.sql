-- Function: lpComplete_Movement ()

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
  DECLARE vbCloseDate TDateTime;
  DECLARE vbRoleId Integer;
  DECLARE vbAccessKeyId Integer;
BEGIN
  -- проверка
  /*IF EXISTS (SELECT MovementId FROM MovementItemContainer WHERE MovementId = inMovementId)
  THEN
      RAISE EXCEPTION 'Ошибка.Существуют проводки.Проведение невозможно.';
  END IF;*/


  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = inDescId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
  RETURNING OperDate, AccessKeyId INTO vbOperDate, vbAccessKeyId;


  -- для Админа  - Все Права
  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
  THEN 
  -- проверка прав для <AccessKey>
  IF inDescId = zc_Movement_Sale()
  THEN 
      IF lpGetAccessKey (inUserId, COALESCE ((SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Sale(), zc_Enum_Process_InsertUpdate_Movement_Sale_Partner())), zc_Enum_Process_InsertUpdate_Movement_Sale()))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав для изменения в документе № <%> от <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate);
      END IF;
  ELSE
  IF inDescId = zc_Movement_Tax()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_Tax())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав для изменения в документе № <%> от <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate);
      END IF;
  ELSE
  IF inDescId = zc_Movement_TaxCorrective()
  THEN 
      IF lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective()) -- (SELECT ProcessId FROM Object_Process_User_View WHERE UserId = inUserId AND ProcessId IN (zc_Enum_Process_InsertUpdate_Movement_TaxCorrective())))
         <> vbAccessKeyId AND COALESCE (vbAccessKeyId, 0) <> 0
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав для изменения в документе № <%> от <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate);
      END IF;
  END IF;
  END IF;
  END IF;
  END IF;


  -- !!!проверка прав для <Закрытие периода> - временно если не НАЛ!!!
  IF NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PaidKind() AND ObjectId = zc_Enum_PaidKind_SecondForm())
  THEN
  -- определяется дата для <Закрытие периода>
  SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END
       , tmp.RoleId
         INTO vbCloseDate, vbRoleId
  FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
             , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
             , MAX (PeriodClose.RoleId) AS RoleId
        FROM PeriodClose
             LEFT JOIN ObjectLink_UserRole_View AS View_UserRole
                                                ON View_UserRole.RoleId = PeriodClose.RoleId
                                               AND View_UserRole.UserId = inUserId
                                               -- AND inDescId NOT IN (zc_Movement_PersonalService(), zc_Movement_Service(), zc_Movement_SendDebt())
        WHERE View_UserRole.UserId = inUserId -- OR PeriodClose.RoleId IS NULL
          AND PeriodClose.RoleId IN (SELECT RoleId FROM Object_Role_MovementDesc_View WHERE MovementDescId = inDescId)
       ) AS tmp;


  -- проверка прав для <Закрытие периода>
  IF vbOperDate < vbCloseDate
  THEN 
      -- RAISE EXCEPTION 'Ошибка.Изменения за <%> не возможны.Для роли <%> период закрыт до <%>.', TO_CHAR (vbOperDate, 'DD.MM.YYYY'), lfGet_Object_ValueData (vbRoleId), TO_CHAR (vbCloseDate, 'DD.MM.YYYY');
      RAISE EXCEPTION 'Ошибка.Изменения в документе № <%> от <%> не возможны.Для роли <%> период закрыт до <%>.(%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (vbRoleId), DATE (vbCloseDate), inMovementId;
  END IF;

  END IF; -- !!!временно если не НАЛ!!!

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
