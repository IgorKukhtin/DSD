-- Проверка закрытия периода
-- Function: lpCheckPeriodClose()

DROP FUNCTION IF EXISTS lpCheckPeriodClose (TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckPeriodClose(
    IN inOperDate        TDateTime , -- 
    IN inMovementId      Integer   , -- 
    IN inMovementDescId  Integer   , -- 
    IN inAccessKeyId     Integer   , -- 
    IN inUserId          Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$  
   DECLARE vbBranchId          Integer;
   DECLARE vbPeriodCloseId     Integer;
   DECLARE vbPeriodCloseId_two Integer;
   DECLARE vbCloseDate         TDateTime;
BEGIN
     -- !!!только Перепроведение с/с - НЕТ ограничений!!!
     IF inUserId IN (zc_Enum_Process_Auto_PrimeCost()
                   , zc_Enum_Process_Auto_ReComplete()
                   , zc_Enum_Process_Auto_Kopchenie(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_Send(), zc_Enum_Process_Auto_PartionClose()
                   -- , zc_Enum_Process_Auto_Defroster()
                   -- , zfCalc_UserAdmin() :: Integer -- временно: !!!для Админа - НЕТ ограничений!!!
                    )
        -- OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin()) -- временно: !!!для ВСЕХ Админов - НЕТ ограничений!!!
     THEN
          RETURN; -- !!!выход!!!
     END IF;
     -- по этим док-там !!!нет закрытия периода!!!
     IF inMovementDescId IN (zc_Movement_TransportGoods(), zc_Movement_QualityDoc(), zc_Movement_Invoice(), zc_Movement_IncomeAsset()
                           , zc_Movement_OrderExternal(), zc_Movement_StoreReal(), zc_Movement_Visit(), zc_Movement_Task(), zc_Movement_RouteMember()
                           , zc_Movement_Promo()
                           , zc_Movement_SheetWorkTimeClose()
                           , zc_Movement_PersonalGroupSummAdd()
                            )
     THEN
          RETURN; -- !!!выход!!!
     END IF;

     -- !!!Проверка закрытия периода только для <Технолог Днепр>!!!
     IF inUserId IN (439917, 300550) -- Маховская М.В. + Рыбалко В.В.
     THEN
         IF  (SELECT gpGet.OperDate FROM gpGet_Scale_OperDate (FALSE, 1, lfGet_User_Session (inUserId)) AS gpGet) - INTERVAL '6 DAY' > inOperDate
         THEN
             RAISE EXCEPTION 'Ошибка.Период закрыт до <%>.', zfConvert_DateToString ((SELECT gpGet.OperDate FROM gpGet_Scale_OperDate (FALSE, 1, lfGet_User_Session (inUserId)) AS gpGet) - INTERVAL '6 DAY');
         END IF;
     END IF;

     -- если вообще нет, тогда сразу выход - !!!но для PeriodClose.Period не будет работать!!!
     IF NOT EXISTS (SELECT 1 FROM PeriodClose WHERE PeriodClose.CloseDate > inOperDate)
     THEN
          RETURN; -- !!!выход!!!
     END IF;


     -- Определился филиал
     vbBranchId:= CASE WHEN inAccessKeyId > 0 THEN zfGet_Branch_AccessKey (inAccessKeyId) ELSE zc_Branch_Basis() END;

     -- !!!только для теста!!!
     -- IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpPeriodClose')) THEN DROP TABLE _tmpPeriodClose; END IF;
     -- !!!только для теста!!!

     -- если нет - создаем, иначе - !!!т.е. пользуемся "старой" инфой!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpPeriodClose'))
     THEN
         -- таблица
         CREATE TEMP TABLE _tmpPeriodClose_excl (PeriodCloseId Integer, UserId_excl Integer, CloseDate_excl TDateTime) ON COMMIT DROP;
         INSERT INTO _tmpPeriodClose_excl (PeriodCloseId, UserId_excl, CloseDate_excl)
             SELECT PeriodClose.Id AS PeriodCloseId
                  , ObjectLink_UserByGroupList_User.ChildObjectId AS UserId_excl
                  , PeriodClose.CloseDate_excl
             FROM PeriodClose
                  JOIN ObjectLink AS ObjectLink_UserByGroupList_UserByGroup
                                  ON ObjectLink_UserByGroupList_UserByGroup.ChildObjectId = PeriodClose.UserByGroupId_excl
                                 AND ObjectLink_UserByGroupList_UserByGroup.DescId        = zc_ObjectLink_UserByGroupList_UserByGroup()
                  JOIN Object AS Object_UserByGroupList ON Object_UserByGroupList.Id       = ObjectLink_UserByGroupList_UserByGroup.ObjectId
                                                       AND Object_UserByGroupList.isErased = FALSE
                  JOIN ObjectLink AS ObjectLink_UserByGroupList_User
                                  ON ObjectLink_UserByGroupList_User.ObjectId = ObjectLink_UserByGroupList_UserByGroup.ObjectId
                                 AND ObjectLink_UserByGroupList_User.DescId   = zc_ObjectLink_UserByGroupList_User()
             WHERE PeriodClose.UserByGroupId_excl > 0;

         -- таблица
         CREATE TEMP TABLE _tmpPeriodClose (PeriodCloseId Integer, Code Integer, Name TVarChar, CloseDate TDateTime, UserId Integer, UserId_excl Integer, MovementDescId Integer, MovementDescId_excl Integer, BranchId Integer, PaidKindId Integer, CloseDate_excl TDateTime) ON COMMIT DROP;
         -- получили ВСЕ данные из PeriodClose
         WITH tmpDesc AS (SELECT tmp.DescId, tmp.MovementDescId FROM lpSelect_PeriodClose_Desc (inUserId:= inUserId) AS tmp
                         )
            , tmpTable AS (SELECT tmp.*
                                , CASE WHEN tmp.Date1 > tmp.Date2 THEN tmp.Date1 ELSE tmp.Date2 END AS CloseDate_calc
                                , COALESCE (tmpDesc.MovementDescId, 0)      AS MovementDescId
                                , COALESCE (tmpDesc_excl.MovementDescId, 0) AS MovementDescId_excl
                           FROM (SELECT PeriodClose.*
                                        -- так для "Период закрыт до"
                                      , CASE WHEN PeriodClose.Period =  INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', PeriodClose.CloseDate) ELSE zc_DateStart() END AS Date1
                                        -- так для "Авто закрытие периода, кол-во дн."
                                      , CASE WHEN PeriodClose.Period <> INTERVAL '0 DAY' THEN DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) - PeriodClose.Period :: INTERVAL ELSE zc_DateStart() END AS Date2
                                 FROM PeriodClose
                                ) AS tmp
                                LEFT JOIN tmpDesc ON tmpDesc.DescId = tmp.DescId
                                LEFT JOIN tmpDesc AS tmpDesc_excl ON tmpDesc_excl.DescId = tmp.DescId_excl
                          )
            , tmpData AS (SELECT tmpTable.*
                               , COALESCE (ObjectLink_UserRole_User.ChildObjectId, 0) AS UserId_calc
                          FROM tmpTable
                               LEFT JOIN ObjectLink AS ObjectLink_UserRole_Role
                                                    ON ObjectLink_UserRole_Role.ChildObjectId = tmpTable.RoleId
                                                   AND ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                               LEFT JOIN ObjectLink AS ObjectLink_UserRole_User
                                                    ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                                                   AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
                          )
         -- Результат
         INSERT INTO _tmpPeriodClose (PeriodCloseId, Code, Name, CloseDate, UserId, UserId_excl, MovementDescId, MovementDescId_excl, BranchId, PaidKindId, CloseDate_excl)
            SELECT tmpData.Id             AS PeriodCloseId
                 , tmpData.Code
                 , tmpData.Name
                 , tmpData.CloseDate_calc AS CloseDate
                 , tmpData.UserId_calc    AS UserId
                 , tmpData.UserId_excl
                 , tmpData.MovementDescId
                 , tmpData.MovementDescId_excl
                 , COALESCE (tmpData.BranchId, 0)   AS BranchId
                 , COALESCE (tmpData.PaidKindId, 0) AS PaidKindId
                 , tmpData.CloseDate_excl
            FROM tmpData;
     END IF;


     -- 1.1. Поиск для "Индивидуальный"
     SELECT MAX (_tmpPeriodClose.PeriodCloseId) AS PeriodCloseId, MIN (_tmpPeriodClose.PeriodCloseId) AS vbPeriodCloseId_two, MAX (_tmpPeriodClose.CloseDate) AS CloseDate
            INTO vbPeriodCloseId, vbPeriodCloseId_two, vbCloseDate
     FROM _tmpPeriodClose
          LEFT JOIN (WITH tmpDesc AS (SELECT zc_MovementLinkObject_PaidKind() AS DescId UNION SELECT zc_MovementLinkObject_PaidKindFrom() WHERE inMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_TransferDebtOut()) UNION SELECT zc_MovementLinkObject_PaidKindTo() WHERE inMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_TransferDebtOut()))
                        , tmp1 AS (SELECT DISTINCT MovementLinkObject.ObjectId AS PaidKindId FROM MovementLinkObject JOIN tmpDesc ON tmpDesc.DescId = MovementLinkObject.DescId WHERE MovementLinkObject.MovementId = inMovementId)
                        , tmp2 AS (SELECT DISTINCT MovementItemLinkObject.ObjectId AS PaidKindId
                                   FROM MovementItem
                                        JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                                   AND MovementItemLinkObject.DescId = zc_MILinkObject_PaidKind()
                                   WHERE MovementItem.MovementId = inMovementId
                                     AND MovementItem.isErased = FALSE)
                        , tmp3 AS (SELECT zc_Enum_PaidKind_FirstForm()  AS PaidKindId WHERE inMovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Tax(), zc_Movement_TaxCorrective())  AND NOT EXISTS (SELECT 1 FROM tmp1) AND NOT EXISTS (SELECT 1 FROM tmp2)
                                  UNION ALL
                                   SELECT zc_Enum_PaidKind_SecondForm() AS PaidKindId WHERE inMovementDescId NOT IN (zc_Movement_BankAccount(), zc_Movement_Tax(), zc_Movement_TaxCorrective()) AND NOT EXISTS (SELECT 1 FROM tmp1) AND NOT EXISTS (SELECT 1 FROM tmp2))
                     -- подзапрос
                     SELECT tmp1.PaidKindId FROM tmp1 UNION SELECT tmp2.PaidKindId FROM tmp2 UNION SELECT tmp3.PaidKindId FROM tmp3
                    ) AS tmp ON tmp.PaidKindId = _tmpPeriodClose.PaidKindId
     WHERE _tmpPeriodClose.MovementDescId = inMovementDescId
       AND (_tmpPeriodClose.UserId = inUserId OR _tmpPeriodClose.UserId = 0)
       AND (_tmpPeriodClose.BranchId   = 0 OR _tmpPeriodClose.BranchId = vbBranchId)
       AND (_tmpPeriodClose.PaidKindId = 0 OR tmp.PaidKindId > 0);
     -- Проверка
     IF vbPeriodCloseId <> vbPeriodCloseId_two
     THEN
        RAISE EXCEPTION 'Ошибка1.Для пользователя <%> и вид документа <%> не определено закрытие периода <%> или <%>.'
                      , lfGet_Object_ValueData(inUserId)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId_two)
                       ;
     END IF;

     -- Проверка для "Индивидуальный"
     IF vbPeriodCloseId > 0
     THEN
         -- 1.2. Исключения
         IF EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE _tmpPeriodClose.PeriodCloseId = vbPeriodCloseId AND _tmpPeriodClose.UserId_excl = inUserId AND _tmpPeriodClose.CloseDate_excl <= inOperDate)
            OR EXISTS (SELECT 1 FROM _tmpPeriodClose_excl WHERE _tmpPeriodClose_excl.PeriodCloseId = vbPeriodCloseId AND _tmpPeriodClose_excl.UserId_excl = inUserId AND _tmpPeriodClose_excl.CloseDate_excl <= inOperDate)
         THEN -- !!!разрешили!!!
              RETURN;
         END IF;

         -- 1.3. Проверка
         IF inOperDate < vbCloseDate
         THEN 
             RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> до <%> закрыт период <%>.(%)(%)'
                           , (SELECT ItemName FROM MovementDesc WHERE Id = inMovementDescId)
                           , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                           , DATE (inOperDate)
                           , lfGet_Object_ValueData (inUserId)
                           , DATE (vbCloseDate)
                           , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                           , 1
                           , inMovementId
                            ;
         END IF;

         -- 1.4. !!!Проверка прошла успешно!!!
         RETURN;

     END IF; -- Проверка для "Индивидуальный"
     

     -- только НЕ Филиал
     IF vbBranchId = zc_Branch_Basis()
     THEN
     -- 2.1. Поиск для "Общий"
     WITH tmpData AS (WITH tmpDesc AS (SELECT zc_MovementLinkObject_PaidKind() AS DescId UNION SELECT zc_MovementLinkObject_PaidKindFrom() WHERE inMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_TransferDebtOut()) UNION SELECT zc_MovementLinkObject_PaidKindTo() WHERE inMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_TransferDebtOut()))
                            , tmp1 AS (SELECT DISTINCT MovementLinkObject.ObjectId AS PaidKindId FROM MovementLinkObject JOIN tmpDesc ON tmpDesc.DescId = MovementLinkObject.DescId WHERE MovementLinkObject.MovementId = inMovementId)
                            , tmp2 AS (SELECT DISTINCT MovementItemLinkObject.ObjectId AS PaidKindId
                                       FROM MovementItem
                                            JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                                       AND MovementItemLinkObject.DescId = zc_MILinkObject_PaidKind()
                                       WHERE MovementItem.MovementId = inMovementId
                                         AND MovementItem.isErased = FALSE)
                            , tmp3 AS (SELECT zc_Enum_PaidKind_FirstForm()  AS PaidKindId WHERE inMovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Tax(), zc_Movement_TaxCorrective())  AND NOT EXISTS (SELECT 1 FROM tmp1) AND NOT EXISTS (SELECT 1 FROM tmp2)
                                      UNION ALL
                                       SELECT zc_Enum_PaidKind_SecondForm() AS PaidKindId WHERE inMovementDescId NOT IN (zc_Movement_SendDebt(), zc_Movement_BankAccount(), zc_Movement_Tax(), zc_Movement_TaxCorrective()) AND NOT EXISTS (SELECT 1 FROM tmp1) AND NOT EXISTS (SELECT 1 FROM tmp2)
                                      UNION ALL
                                       -- индивидуально для zc_Movement_SendDebt, приоритет - НАЛ
                                       SELECT tmp_record.PaidKindId FROM (SELECT tmp2.PaidKindId FROM tmp2 WHERE inMovementDescId = zc_Movement_SendDebt() ORDER BY CASE WHEN tmp2.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN 0 ELSE 1 END LIMIT 1) AS tmp_record
                                      )
                         -- подзапрос
                         SELECT tmp1.PaidKindId FROM tmp1
                   UNION SELECT tmp2.PaidKindId FROM tmp2 WHERE inMovementDescId <> zc_Movement_SendDebt() 
                   UNION SELECT tmp3.PaidKindId FROM tmp3
                    )
     SELECT MAX (_tmpPeriodClose.PeriodCloseId) AS PeriodCloseId, MIN (_tmpPeriodClose.PeriodCloseId) AS vbPeriodCloseId_two, MAX (_tmpPeriodClose.CloseDate) AS CloseDate
            INTO vbPeriodCloseId, vbPeriodCloseId_two, vbCloseDate
     FROM _tmpPeriodClose
          -- если вдруг для альтернативной формы опл - такая же дата, тогда игнорируем
          LEFT JOIN _tmpPeriodClose AS _tmpPeriodClose_check
                                    ON _tmpPeriodClose_check.CloseDate      = _tmpPeriodClose.CloseDate
                                   AND _tmpPeriodClose_check.UserId         = _tmpPeriodClose.UserId
                                   AND _tmpPeriodClose_check.MovementDescId = _tmpPeriodClose.MovementDescId
                                   AND _tmpPeriodClose_check.BranchId       = _tmpPeriodClose.BranchId
                                   AND _tmpPeriodClose_check.PaidKindId     = CASE WHEN _tmpPeriodClose.PaidKindId = zc_Enum_PaidKind_FirstForm()  THEN zc_Enum_PaidKind_SecondForm()
                                                                                   WHEN _tmpPeriodClose.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN zc_Enum_PaidKind_FirstForm()
                                                                                   ELSE NULL
                                                                              END
                                   AND EXISTS (SELECT FROM tmpData WHERE tmpData.PaidKindId = zc_Enum_PaidKind_FirstForm())
                                   AND EXISTS (SELECT FROM tmpData WHERE tmpData.PaidKindId = zc_Enum_PaidKind_SecondForm())
          -- 
          LEFT JOIN tmpData AS tmp ON tmp.PaidKindId = _tmpPeriodClose.PaidKindId
     WHERE _tmpPeriodClose.MovementDescId = 0 AND _tmpPeriodClose.UserId = 0 AND _tmpPeriodClose.MovementDescId_excl <> inMovementDescId
       AND (_tmpPeriodClose.BranchId   = 0)
       AND (_tmpPeriodClose.PaidKindId = 0 OR tmp.PaidKindId > 0)
       AND (_tmpPeriodClose_check.PaidKindId IS NULL OR _tmpPeriodClose.PaidKindId = zc_Enum_PaidKind_SecondForm())
       ;

     -- Проверка - tmp
     IF inUserId = zc_Enum_Process_Auto_PrimeCost() THEN RAISE EXCEPTION 'Ошибка. ??? inUserId = zc_Enum_Process_Auto_PrimeCost() ???'; END IF;

     -- Проверка - 1
     IF vbPeriodCloseId <> vbPeriodCloseId_two
     THEN
        RAISE EXCEPTION 'Ошибка2.Для пользователя <%> и вид документа <%> не определено закрытие периода <%> или <%>.'
                      , lfGet_Object_ValueData(inUserId)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId_two)
                       ;
     END IF;
     -- Проверка - 2
     IF COALESCE (vbPeriodCloseId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка2.Для пользователя <%> и вид документа <%> не найдено закрытие периода.'
                      , lfGet_Object_ValueData(inUserId)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                       ;
     END IF;

     -- Проверка для "Общий"
     IF vbPeriodCloseId > 0
     THEN
         -- 2.2. Исключения
         IF EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE _tmpPeriodClose.PeriodCloseId = vbPeriodCloseId AND _tmpPeriodClose.UserId_excl = inUserId AND _tmpPeriodClose.CloseDate_excl <= inOperDate)
            OR EXISTS (SELECT 1 FROM _tmpPeriodClose_excl WHERE _tmpPeriodClose_excl.PeriodCloseId = vbPeriodCloseId AND _tmpPeriodClose_excl.UserId_excl = inUserId AND _tmpPeriodClose_excl.CloseDate_excl <= inOperDate)
         THEN -- !!!разрешили!!!
              RETURN;
         END IF;

         -- 2.3. Проверка
         IF inOperDate < vbCloseDate
         THEN 
             RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> до <%> закрыт период <%>.(%)(%)'
                           , (SELECT ItemName FROM MovementDesc WHERE Id = inMovementDescId)
                           , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                           , DATE (inOperDate)
                           , lfGet_Object_ValueData (inUserId)
                           , DATE (vbCloseDate)
                           , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                           , 2
                           , inMovementId
                            ;
         END IF;

         -- 2.4. !!!Проверка прошла успешно!!!
         -- RETURN;

     END IF; -- Проверка для "Общий"

     END IF; -- vbBranchId = zc_Branch_Basis() - только НЕ Филиал


     -- !!!Выход, т.к. НЕ Филиал!!!
     IF vbBranchId = zc_Branch_Basis()
     THEN
          RETURN; -- !!!выход!!!
     END IF;


     -- на всякий случай
     vbPeriodCloseId:= 0; vbPeriodCloseId_two:= 0;

     -- 3.1. Поиск для "Филиал"
     SELECT MAX (_tmpPeriodClose.PeriodCloseId) AS PeriodCloseId, MIN (_tmpPeriodClose.PeriodCloseId) AS vbPeriodCloseId_two, MAX (_tmpPeriodClose.CloseDate) AS CloseDate
            INTO vbPeriodCloseId, vbPeriodCloseId_two, vbCloseDate
     FROM _tmpPeriodClose
          LEFT JOIN (WITH tmpDesc AS (SELECT zc_MovementLinkObject_PaidKind() AS DescId UNION SELECT zc_MovementLinkObject_PaidKindFrom() WHERE inMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_TransferDebtOut()) UNION SELECT zc_MovementLinkObject_PaidKindTo() WHERE inMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_TransferDebtOut()))
                        , tmp1 AS (SELECT DISTINCT MovementLinkObject.ObjectId AS PaidKindId FROM MovementLinkObject JOIN tmpDesc ON tmpDesc.DescId = MovementLinkObject.DescId WHERE MovementLinkObject.MovementId = inMovementId)
                        , tmp2 AS (SELECT DISTINCT MovementItemLinkObject.ObjectId AS PaidKindId
                                   FROM MovementItem
                                        JOIN MovementItemLinkObject ON MovementItemLinkObject.MovementItemId = MovementItem.Id
                                                                   AND MovementItemLinkObject.DescId = zc_MILinkObject_PaidKind()
                                   WHERE MovementItem.MovementId = inMovementId
                                     AND MovementItem.isErased = FALSE)
                        , tmp3 AS (SELECT zc_Enum_PaidKind_FirstForm()  AS PaidKindId WHERE inMovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Tax(), zc_Movement_TaxCorrective())  AND NOT EXISTS (SELECT 1 FROM tmp1) AND NOT EXISTS (SELECT 1 FROM tmp2)
                                  UNION ALL
                                   SELECT zc_Enum_PaidKind_SecondForm() AS PaidKindId WHERE inMovementDescId NOT IN (zc_Movement_BankAccount(), zc_Movement_Tax(), zc_Movement_TaxCorrective()) AND NOT EXISTS (SELECT 1 FROM tmp1) AND NOT EXISTS (SELECT 1 FROM tmp2))
                     -- подзапрос
                     SELECT tmp1.PaidKindId FROM tmp1 UNION SELECT tmp2.PaidKindId FROM tmp2 UNION SELECT tmp3.PaidKindId FROM tmp3
                    ) AS tmp ON tmp.PaidKindId = _tmpPeriodClose.PaidKindId
     WHERE _tmpPeriodClose.MovementDescId = 0 AND _tmpPeriodClose.UserId = 0 AND _tmpPeriodClose.MovementDescId_excl <> inMovementDescId
       AND (_tmpPeriodClose.BranchId   = vbBranchId)
       AND (_tmpPeriodClose.PaidKindId = 0 OR tmp.PaidKindId > 0);
     -- Проверка - 1
     IF vbPeriodCloseId <> vbPeriodCloseId_two
     THEN
        RAISE EXCEPTION 'Ошибка3.Для пользователя <%> и вид документа <%> не определено закрытие периода <%> или <%>.'
                      , lfGet_Object_ValueData(inUserId)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                      , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId_two)
                       ;
     END IF;
     -- Проверка - 2
     IF COALESCE (vbPeriodCloseId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка3.Для пользователя <%> и вид документа <%> не найдено закрытие периода.'
                      , lfGet_Object_ValueData(inUserId)
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId)
                       ;
     END IF;

     -- Проверка для "Филиал"
     IF vbPeriodCloseId > 0
     THEN
         -- 3.2. Исключения
         IF EXISTS (SELECT 1 FROM _tmpPeriodClose WHERE _tmpPeriodClose.PeriodCloseId = vbPeriodCloseId AND _tmpPeriodClose.UserId_excl = inUserId AND _tmpPeriodClose.CloseDate_excl <= inOperDate)
            OR EXISTS (SELECT 1 FROM _tmpPeriodClose_excl WHERE _tmpPeriodClose_excl.PeriodCloseId = vbPeriodCloseId AND _tmpPeriodClose_excl.UserId_excl = inUserId AND _tmpPeriodClose_excl.CloseDate_excl <= inOperDate)
         THEN -- !!!разрешили!!!
              RETURN;
         END IF;

         -- 3.3. Проверка
         IF inOperDate < vbCloseDate
         THEN 
             RAISE EXCEPTION 'Ошибка.Изменения в документе <%> № <%> от <%> не возможны. Для пользователя <%> до <%> закрыт период <%>.(%)(%)'
                           , (SELECT ItemName FROM MovementDesc WHERE Id = inMovementDescId)
                           , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                           , DATE (inOperDate)
                           , lfGet_Object_ValueData (inUserId)
                           , DATE (vbCloseDate)
                           , (SELECT '(' || Code :: TVarChar || ')' || Name FROM PeriodClose WHERE Id = vbPeriodCloseId)
                           , 3
                           , inMovementId
                            ;
         END IF;

         -- 3.4. !!!Проверка прошла успешно!!!
         -- RETURN;

     END IF; -- Проверка для "Филиал"

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheckPeriodClose (TDateTime, Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.04.16                                        * ALL
 25.02.14                        *
*/

-- тест
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 81241), Movement.* FROM Movement WHERE Id = 3091408 -- Бухгалтер ДНЕПР - Марухно А.В.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 81241), Movement.* FROM Movement WHERE Id = 3067578 -- Всем БН - Марухно А.В.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 300547), Movement.* FROM Movement WHERE Id = 3424050 -- Всем БН - Комелева А.Л.
-- SELECT lpCheckPeriodClose (inOperDate:= OperDate, inMovementId:= Id, inMovementDescId:= DescId, inAccessKeyId:= AccessKeyId, inUserId:= 76913), Movement.* FROM Movement WHERE Id = 2802779  -- Начисления маркетинг - Земляная Л.Н
