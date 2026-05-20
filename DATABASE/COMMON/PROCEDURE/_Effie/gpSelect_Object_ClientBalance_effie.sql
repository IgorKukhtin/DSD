-- Function: gpSelect_Object_ClientBalance_effie

DROP FUNCTION IF EXISTS gpSelect_Object_ClientBalance_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ClientBalance_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (ExtId                TVarChar   -- Идентификатор записи по долгам
             , employeeExtId        TVarChar   -- Идентификатор сотрудников
             , ttExtId              TVarChar   -- Идентификатор торговой точки
             , clientExtId          TVarChar   -- Идентификатор контрагента
             , contractHeaderExtId  TVarChar   -- Уникальный идентификатор контракта
             , balanceValue         TFloat     -- Текущая задолженность, Должно быть больше или равно чем balanceOverdue
             , balanceOverdue       TFloat     -- Просроченная задолженность
             , balanceDate          TVarChar   -- Дата формирования сальдо = current date (текущий РАБОЧИЙ день)
             , limitOverdue         Boolean    -- Превышение лимита по баллансу (false - отгрузка разрешена, true - блокировка отгрузок)
             , PaidKindId           Integer    -- Форма оплата - для внутреннего использования
             , PaidKindName         TVarChar   -- Форма оплата - для внутреннего использования
             , ContainerId          Integer    -- для теста
             , ContractDate         TDateTime  -- для теста
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     

     -- временная таблица Contract_Client
     CREATE TEMP TABLE _tmpContract_Client (PartnerId            Integer
                                          , ContractId           Integer
                                          , PaidKindId           Integer
                                          , PaidKindName         TVarChar
                                           ) ON COMMIT DROP;

     -- Данные Contract_Client
     INSERT INTO _tmpContract_Client (PartnerId, ContractId, PaidKindId, PaidKindName)
        SELECT DISTINCT
               gpSelect.clientExtId         :: Integer AS PartnerId
             , gpSelect.contractHeaderExtId :: Integer AS ContractId
             , gpSelect.PaidKindId
             , gpSelect.PaidKindName
        FROM gpSelect_Object_ContractHeaderClients_effie (inSession) AS gpSelect
       ;
          

     -- Формируются НОВЫЕ ключи
     INSERT INTO Object_ClientBalance_effie (PartnerId, ContractId, PaidKindId, InsertDate)
     SELECT _tmpContract_Client.PartnerId
          , _tmpContract_Client.ContractId
          , _tmpContract_Client.PaidKindId
          , CURRENT_TIMESTAMP AS InsertDate
      FROM _tmpContract_Client
           LEFT JOIN Object_ClientBalance_effie ON Object_ClientBalance_effie.PartnerId  = _tmpContract_Client.PartnerId
                                               AND Object_ClientBalance_effie.ContractId = _tmpContract_Client.ContractId
                                               AND Object_ClientBalance_effie.PaidKindId = _tmpContract_Client.PaidKindId
     WHERE Object_ClientBalance_effie.Id IS NULL
    ;


     --
     RETURN QUERY
     WITH tmpContainer_all AS (SELECT Container.Id AS ContainerId
                                    , Container.Amount
                                    , Object_ClientBalance_effie.PartnerId
                                    , Object_ClientBalance_effie.ContractId
                                    , Object_ClientBalance_effie.PaidKindId
                               FROM Object_ClientBalance_effie
                                    INNER JOIN ContainerLinkObject AS CLO_Partner
                                                                   ON CLO_Partner.ObjectId = Object_ClientBalance_effie.PartnerId
                                                                  AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                    INNER JOIN ContainerLinkObject AS CLO_Contract
                                                                   ON CLO_Contract.ContainerId = CLO_Partner.ContainerId
                                                                  AND CLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                                                                  AND CLO_Contract.ObjectId    = Object_ClientBalance_effie.ContractId
                                    INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                                   ON CLO_PaidKind.ContainerId = CLO_Partner.ContainerId
                                                                  AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                                                  AND CLO_PaidKind.ObjectId    = Object_ClientBalance_effie.PaidKindId
                                    INNER JOIN Container ON Container.Id = CLO_Partner.ContainerId
    
                               -- Только НАЛ
                               WHERE Object_ClientBalance_effie.PaidKindId = zc_Enum_PaidKind_SecondForm()
                                  AND Container.Amount <> 0
                              )
        , tmpTwins AS (SELECT gpSelect.ttExtId     :: Integer AS ttExtId
                            , gpSelect.clientExtId :: Integer AS PartnerId
                       FROM gpSelect_Object_Twins_effie (inSession) AS gpSelect
                      )

              , tmpContainer AS (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId              AS ContractId
                                      , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                                      , tmpContainer_all.ContainerId
                                      , tmpContainer_all.PartnerId
                                      , tmpContainer_all.PaidKindId
                                      , tmpContainer_all.Amount
                                      , zfCalc_DetermentPaymentDate (ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                                                   , MIN (ObjectFloat_ContractCondition_Value.ValueData)::Integer
                                                                   , CURRENT_DATE)::Date AS ContractDate
                                 FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                      -- выбрали оригинал"
                                      JOIN tmpContainer_all ON tmpContainer_all.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                      -- выбрали по "главному"
                                      -- JOIN tmpContainer_all ON tmpContainer_all.ContractId_Key = ObjectLink_ContractCondition_Contract.ChildObjectId
                                      -- выбираем только ДВА условия
                                      JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                      ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId   = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                                                                                            , zc_Enum_ContractConditionKind_DelayDayBank()
                                                                                                                             )
                                      JOIN ObjectFloat AS ObjectFloat_ContractCondition_Value
                                                       ON ObjectFloat_ContractCondition_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                      AND ObjectFloat_ContractCondition_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                      AND ObjectFloat_ContractCondition_Value.ValueData <> 0.0
                                      -- убрали Удаленные
                                      JOIN Object AS Object_ContractCondition
                                                  ON Object_ContractCondition.Id       = ObjectLink_ContractCondition_Contract.ObjectId
                                                 AND Object_ContractCondition.isErased = FALSE

                                 WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId
                                        , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                        , tmpContainer_all.ContainerId
                                        , tmpContainer_all.PartnerId
                                        , tmpContainer_all.PaidKindId
                                        , tmpContainer_all.Amount
                                )
                , tmpMIContainer AS (SELECT MovementItemContainer.ContainerId
                                          , SUM (MovementItemContainer.Amount)::TFloat AS Summ
                                     FROM MovementItemContainer
                                          JOIN tmpContainer ON tmpContainer.ContainerId = MovementItemContainer.ContainerId
                                     WHERE MovementItemContainer.DescId = zc_MIContainer_Summ()
                                       AND (MovementItemContainer.MovementDescId  = zc_Movement_Sale()
                                         OR (MovementItemContainer.MovementDescId = zc_Movement_TransferDebtOut()
                                         AND MovementItemContainer.isActive = TRUE)
                                           )
                                       AND MovementItemContainer.OperDate > tmpContainer.ContractDate
                                       AND MovementItemContainer.OperDate < CURRENT_DATE
                                     GROUP BY MovementItemContainer.ContainerId
                                    )
                , tmpMIContainerNow AS (SELECT MovementItemContainer.ContainerId
                                             , SUM (MovementItemContainer.Amount)::TFloat AS Summ
                                        FROM MovementItemContainer
                                             JOIN tmpContainer ON tmpContainer.ContainerId = MovementItemContainer.ContainerId
                                        WHERE MovementItemContainer.DescId = zc_MIContainer_Summ()
                                          AND MovementItemContainer.OperDate >= CURRENT_DATE
                                        GROUP BY MovementItemContainer.ContainerId
                                       )
                , tmpDebtAll AS (SELECT tmpContainer.ContainerId
                                      , tmpContainer.PartnerId
                                      , tmpContainer.ContractId
                                      , tmpContainer.PaidKindId
                                      , (tmpContainer.Amount - COALESCE (tmpMIContainerNow.Summ, 0.0)::TFloat) AS DebtSum
                                      , (tmpContainer.Amount - COALESCE (tmpMIContainerNow.Summ, 0.0)::TFloat - COALESCE (tmpMIContainer.Summ, 0.0)::TFloat) AS OverSum
                                   -- , (zfCalc_OverDayCount (tmpContainer.ContainerId, tmpContainer.Amount - COALESCE (tmpMIContainerNow.Summ, 0.0)::TFloat - COALESCE (tmpMIContainer.Summ, 0.0)::TFloat, tmpContainer.ContractDate)) AS OverDays
                                   -- , (zfCalc_OverDayCount2 (tmpContainer.ContainerId, tmpContainer.Amount, tmpContainer.ContractDate)) AS OverDays2
                                      , SUM (tmpContainer.Amount) OVER (PARTITION BY tmpContainer.PartnerId, ABS (tmpContainer.Amount)) AS ResortSum
                                      , tmpContainer.ContractDate
                                 FROM tmpContainer
                                      LEFT JOIN tmpMIContainer    ON tmpMIContainer.ContainerId    = tmpContainer.ContainerId
                                      LEFT JOIN tmpMIContainerNow ON tmpMIContainerNow.ContainerId = tmpContainer.ContainerId
                                )

         , tmpDebtAll_all AS (SELECT CASE WHEN 1=0 /*inSession = '489010'*/ THEN tmpDebtAll.ContainerId ELSE 0 END AS ContainerId
                                   , tmpDebtAll.PartnerId
                                     -- объединили по "главному"
                                   --, tmpDebtAll.ContractId_Key AS ContractId
                                     -- оставили "оригинал"
                                   , tmpDebtAll.ContractId
                                     --
                                   , tmpDebtAll.PaidKindId
                                   , MIN (tmpDebtAll.ContractDate)  AS ContractDate
                                   , SUM (tmpDebtAll.DebtSum)::TFloat AS DebtSum
                                   , SUM (tmpDebtAll.OverSum)::TFloat AS OverSum
                              FROM tmpDebtAll
                              WHERE tmpDebtAll.ResortSum <> 0.0
                              GROUP BY CASE WHEN 1=0 /*inSession = '489010'*/ THEN tmpDebtAll.ContainerId ELSE 0 END
                                     , tmpDebtAll.PartnerId
                                     --, tmpDebtAll.ContractId_Key
                                     , tmpDebtAll.ContractId
                                     , tmpDebtAll.PaidKindId
                             )
     -- Результат
     SELECT Object_ClientBalance_effie.Id          :: TVarChar AS ExtId
          , Object_Member.Id                       :: TVarChar AS employeeExtId
          , tmpTwins.ttExtId                       :: TVarChar AS ttExtId
          , Object_ClientBalance_effie.PartnerId   :: TVarChar AS clientExtId
          , Object_ClientBalance_effie.ContractId  :: TVarChar AS contractHeaderExtId

            -- Текущая задолженность, Должно быть больше или равно чем balanceOverdue
          , COALESCE (tmpDebtAll_all.DebtSum, 0)                                        :: TFloat AS balanceValue
            -- Просроченная задолженность
          , CASE WHEN tmpDebtAll_all.OverSum > 0 THEN tmpDebtAll_all.OverSum ELSE tmpDebtAll_all.OverSum END :: TFloat AS balanceOverdue

          , zfConvert_DateToString (CURRENT_DATE)  :: TVarChar AS balanceDate

            -- Превышение лимита по баллансу (false - отгрузка разрешена, true - блокировка отгрузок)
          , FALSE                                  :: Boolean  AS limitOverdue

          , _tmpContract_Client.PaidKindId
          , _tmpContract_Client.PaidKindName

          , tmpDebtAll_all.ContainerId  :: Integer
          , tmpDebtAll_all.ContractDate :: TDateTime

     FROM Object_ClientBalance_effie
          -- информативно
          LEFT JOIN _tmpContract_Client ON _tmpContract_Client.PartnerId  = Object_ClientBalance_effie.PartnerId
                                       AND _tmpContract_Client.ContractId = Object_ClientBalance_effie.ContractId 
                                       AND _tmpContract_Client.PaidKindId = Object_ClientBalance_effie.PaidKindId 
          -- Долги
          LEFT JOIN tmpDebtAll_all ON tmpDebtAll_all.PartnerId  = Object_ClientBalance_effie.PartnerId
                                  AND tmpDebtAll_all.ContractId = Object_ClientBalance_effie.ContractId 
                                  AND tmpDebtAll_all.PaidKindId = Object_ClientBalance_effie.PaidKindId 
          -- нашли ТТ
          LEFT JOIN tmpTwins ON tmpTwins.PartnerId = Object_ClientBalance_effie.PartnerId

          -- нашли Сотрудника
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                               ON ObjectLink_Partner_Personal.ObjectId = _tmpContract_Client.PartnerId
                              AND ObjectLink_Partner_Personal.DescId IN (zc_ObjectLink_Partner_Personal()
                                                                     --, zc_ObjectLink_Partner_PersonalTrade()
                                                                     --, zc_ObjectLink_Partner_PersonalMerch()
                                                                        )
          INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Partner_Personal.ChildObjectId
                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                               AND ObjectLink_Personal_Member.ChildObjectId  > 0
          -- Сотрудник не удален
          INNER JOIN Object AS Object_Member ON Object_Member.Id       = ObjectLink_Personal_Member.ChildObjectId
                                            AND Object_Member.isErased = FALSE
     WHERE (tmpDebtAll_all.DebtSum <> 0 OR tmpDebtAll_all.OverSum <> 0) AND tmpTwins.ttExtId :: Integer > 0
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ClientBalance_effie (zfCalc_UserAdmin()::TVarChar);
