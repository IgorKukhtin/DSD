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
      RAISE EXCEPTION 'Ошибка.Существуют проводки.Проведение невозможно.';
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
  IF inDescId NOT IN (zc_Movement_TransportGoods(), zc_Movement_QualityDoc())
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
         AND inUserId <> 6131893
         AND inUserId <> 2030723
      THEN
          RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на проведение документа № <%> от <%> филиал <%>.', lfGet_Object_ValueData (inUserId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_Branch()));
      END IF;
  ELSE
  IF inDescId = zc_Movement_ReturnIn() AND NOT (lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ReturnIn()) = zc_Enum_Process_AccessKey_DocumentDnepr() AND vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentKrRog())
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

  -- есть !!!НОВАЯ СХЕМА ПРОВЕРКИ - Закрытый период!!!, поэтому все что дальше - не надо
  /*
  -- !!!временно!!!
  IF inUserId NOT IN (-1 -- 128491 -- Хохлова Е.Ю. !!!временно!!!
                    -- , 5
                    -- , zc_Enum_Process_Auto_Pack()
                     )
  THEN
  -- !!!временно если БН начисления маркетинг!!!
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = 82392) -- Начисления(п.б.)-ввод документов
     AND inDescId IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
  THEN
      -- 3.1. определяется дата для <Закрытие периода>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                          AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 7 -- БН начисления маркетинг
           ) AS tmp;
      -- 3.2. проверка <Закрытие периода>
      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION 'Ошибка.Изменения в документе № <%> от <%> не возможны. Для роли <%> период закрыт до <%>. (%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), vbRoleName, DATE (vbCloseDate), inMovementId;
      END IF;

  ELSE
  -- !!!временно если ФИЛИАЛ НАЛ + БН!!!
  IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!Админу временно можно!!!
     AND inUserId <> 12120 -- Нагорнова Т.С. !!!временно!!!
     AND (EXISTS (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0)
          OR vbAccessKeyId <> zc_Enum_Process_AccessKey_DocumentDnepr()
         )
  THEN
      -- 3.1. определяется дата для <Закрытие периода>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                           AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 5 -- Закрытие периода Филиал НАЛ + БН
           ) AS tmp;
      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> период закрыт до <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
      END IF;

  ELSE
  -- !!!временно если НАЛОГОВЫЕ!!!
  IF inDescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective())
  THEN
      -- 3.1. определяется дата для <Закрытие периода>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                           AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 3 -- Налоговые + корректировки
           ) AS tmp;

      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> период закрыт до <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
      END IF;

  ELSE
  -- !!!временно если ВСЕ НАЛ!!!
  IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!Админу временно можно!!!
     AND (EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom(), zc_MovementLinkObject_PaidKindTo()) AND ObjectId = zc_Enum_PaidKind_SecondForm())
       OR inDescId IN (zc_Movement_Cash(), zc_Movement_FounderService(), zc_Movement_PersonalAccount(), zc_Movement_PersonalReport(), zc_Movement_PersonalSendCash(), zc_Movement_PersonalService()
                     , zc_Movement_Inventory(), zc_Movement_Loss(), zc_Movement_ProductionSeparate(), zc_Movement_ProductionUnion(), zc_Movement_Send(), zc_Movement_SendOnPrice()
                     , zc_Movement_Transport(), zc_Movement_TransportService())
       OR EXISTS (SELECT MovementItem.MovementId
                  FROM MovementItem
                       JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                  AND MovementItemLinkObject.DescId = zc_MILinkObject_PaidKind()
                                                  AND MovementItemLinkObject.ObjectId = zc_Enum_PaidKind_SecondForm()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.isErased = FALSE
                 )
         )
  THEN
      -- 3.1. определяется дата для <Закрытие периода>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                          AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                 , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , MAX (PeriodClose.Name) AS RoleName
            FROM PeriodClose
            WHERE PeriodClose.Id = 4 -- Закрытие периода ВСЕМ НАЛ
           ) AS tmp;
      -- 3.2. проверка <Закрытие периода>
      IF vbOperDate < vbCloseDate
      THEN 
          RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> период закрыт до <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
      END IF;

  ELSE
  -- !!!временно если не НАЛ!!!
  IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!Админу временно можно!!!
     AND NOT EXISTS (SELECT MovementId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PaidKind() AND ObjectId = zc_Enum_PaidKind_SecondForm())
     AND EXISTS (SELECT 1 FROM PeriodClose JOIN ObjectLink_UserRole_View AS View_UserRole ON View_UserRole.RoleId = PeriodClose.RoleId AND View_UserRole.UserId = inUserId
                 -- WHERE PeriodClose.RoleId IN (SELECT RoleId FROM Object_Role_MovementDesc_View WHERE MovementDescId = inDescId)
                )
  THEN
      -- 3.1. определяется дата для <Закрытие периода>
      SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
           , tmp.RoleName                                                                           AS RoleName
             INTO vbCloseDate, vbRoleName
      FROM (SELECT (CASE WHEN PeriodClose.Period  = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate)                ELSE zc_DateStart() END) AS CloseDate
                 , (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                 , (PeriodClose.Name) AS RoleName
            FROM PeriodClose
                 INNER JOIN ObjectLink_UserRole_View AS View_UserRole
                                                     ON View_UserRole.RoleId = PeriodClose.RoleId
                                                    AND View_UserRole.UserId = inUserId
            -- WHERE PeriodClose.RoleId IN (SELECT RoleId FROM Object_Role_MovementDesc_View WHERE MovementDescId = inDescId)
            WHERE PeriodClose.Id <= 7
            ORDER BY 1 DESC, 2 DESC
            LIMIT 1
           ) AS tmp;
      -- 3.2. проверка прав для <Закрытие периода>
      IF vbOperDate < vbCloseDate
      THEN 
          -- RAISE EXCEPTION 'Ошибка.Изменения в документе № <%> от <%> не возможны.Для роли <%> период закрыт до <%>.(%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), TO_CHAR (vbOperDate, 'DD.MM.YYYY'), vbRoleName, TO_CHAR (vbCloseDate, 'DD.MM.YYYY'), inMovementId;
          RAISE EXCEPTION 'Ошибка.Изменения в документе № <%> от <%> не возможны. Для роли <%> период закрыт до <%>. (%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), vbRoleName, DATE (vbCloseDate), inMovementId;
      END IF;

  ELSE
         IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) -- !!!Админу временно можно!!!
         THEN
             -- !!!временно если ВСЕ НЕ НАЛ!!!
             -- 3.1. определяется дата для <Закрытие периода>
             SELECT CASE WHEN tmp.CloseDate > tmp.ClosePeriod THEN tmp.CloseDate ELSE tmp.ClosePeriod END AS CloseDate
                  , tmp.RoleName                                                                           AS RoleName
                    INTO vbCloseDate, vbRoleName
             FROM (SELECT MAX (CASE WHEN PeriodClose.Period = INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END) AS CloseDate
                        , MAX (CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - INTERVAL '1 day' ELSE zc_DateStart() END) AS ClosePeriod
                        , MAX (PeriodClose.Name) AS RoleName
                   FROM PeriodClose
                   WHERE PeriodClose.Id = 6 -- Закрытие периода ВСЕМ БН
                  ) AS tmp;
             -- 3.2. проверка прав для <Закрытие периода>
             IF vbOperDate < vbCloseDate
             THEN 
                 RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> период закрыт до <%>. (% - %)', (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE (vbOperDate), lfGet_Object_ValueData (inUserId), DATE (vbCloseDate), vbRoleName, inMovementId;
             END IF;
         END IF;

  END IF; -- !!!временно если ФИЛИАЛ НАЛ + БН!!!
  END IF; -- !!!временно если НАЛОГОВЫЕ!!!
  END IF; -- !!!временно если ВСЕ НАЛ!!!
  END IF; -- !!!временно если БН начисления маркетинг!!!
  END IF; -- !!!временно если не НАЛ!!! ELSE !!!временно если ВСЕ НЕ НАЛ!!!

  END IF; -- !!!временно!!!
  */

  END IF; -- по этим док-там !!!нет закрытия периода!!!


  -- сохранили протокол
  IF inUserId <> 5 OR 1=1
  THEN
      PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);
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
