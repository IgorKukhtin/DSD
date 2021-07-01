-- Function: gpSelectMobile_Object_Juridical (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Juridical (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Juridical (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer
             , ObjectCode       Integer  -- Код
             , ValueData        TVarChar -- Название
             , GUID             TVarChar -- Глобальный уникальный идентификатор. Для синхронизации с Главной БД
             , DebtSum          TFloat   -- Сумма долга (нам) - БН - т.к. БН долг формируется только в разрезе Юр Лиц + договоров
             , OverSum          TFloat   -- Сумма просроченного долга (нам) - БН - Просрочка наступает спустя определенное кол-во дней
             , OverDays         Integer  -- Кол-во дней просрочки (нам)
             , ContractId       Integer  -- Договор - все возможные договора...
             , JuridicalGroupId Integer  -- Группы юридических лиц
             , isErased         Boolean  -- Удаленный ли элемент
             , isSync           Boolean  -- Синхронизируется (да/нет)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
           RETURN QUERY
             WITH tmpJuridical AS (SELECT DISTINCT OJ.JuridicalId 
                                   FROM lfSelectMobile_Object_Partner (FALSE, inSession) AS OJ
                                  )
                , tmpContract AS (SELECT tmpJuridical.JuridicalId
                                       , ObjectLink_Contract_Juridical.ObjectId AS ContractId
                                  FROM tmpJuridical
                                       JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                       ON ObjectLink_Contract_Juridical.ChildObjectId = tmpJuridical.JuridicalId
                                                      AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                       JOIN Object AS Object_Contract
                                                   ON Object_Contract.Id = ObjectLink_Contract_Juridical.ObjectId
                                                  AND Object_Contract.isErased = false
                                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                                            ON ObjectLink_Contract_ContractStateKind.ObjectId = Object_Contract.Id
                                                           AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind()
                                                           AND ObjectLink_Contract_ContractStateKind.ChildObjectId = zc_Enum_ContractStateKind_Close()
                                  WHERE ObjectLink_Contract_ContractStateKind.ChildObjectId IS NULL
                                 )
            , tmpDayInfo_all AS (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId              AS ContractId
                                      , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                                      , tmpContract.JuridicalId
                                      , zfCalc_DetermentPaymentDate (ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                                                   , MIN (ObjectFloat_ContractCondition_Value.ValueData)::Integer
                                                                   , CURRENT_DATE)::Date AS ContractDate
                                      , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())  :: TDateTime AS StartDate
                                      , COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())      :: TDateTime AS EndDate
                                 FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                      JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                      ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                     AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                                                                                            , zc_Enum_ContractConditionKind_DelayDayBank()
                                                                                                                             )
                                      JOIN ObjectFloat AS ObjectFloat_ContractCondition_Value
                                                       ON ObjectFloat_ContractCondition_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                      AND ObjectFloat_ContractCondition_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                      AND ObjectFloat_ContractCondition_Value.ValueData <> 0.0

                                      JOIN tmpContract ON tmpContract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId

                                      -- убрали Удаленные
                                      JOIN Object AS Object_ContractCondition
                                                  ON Object_ContractCondition.Id       = ObjectLink_ContractCondition_Contract.ObjectId
                                                 AND Object_ContractCondition.isErased = FALSE

                                      LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                           ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                                                          AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractCondition_StartDate()
                                      LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                                           ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                                                          AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractCondition_EndDate()
                                 WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId
                                        , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                        , tmpContract.JuridicalId
                                        , ObjectDate_StartDate.ValueData
                                        , ObjectDate_EndDate.ValueData
                                )
                , tmpDayInfo AS (SELECT tmpDayInfo_all.*
                                 FROM tmpDayInfo_all
                                 WHERE CURRENT_DATE BETWEEN tmpDayInfo_all.StartDate AND tmpDayInfo_all.EndDate
                                )
                , tmpContainer AS (SELECT Container_Summ.Id      AS ContainerId
                                        , CLO_Juridical.ObjectId AS JuridicalId
                                        , CLO_Contract.ObjectId  AS ContractId
                                        , Container_Summ.Amount
                                        , COALESCE (tmpDayInfo.ContractDate, CURRENT_DATE)::Date AS ContractDate
                                   FROM Container AS Container_Summ
                                        JOIN ObjectLink AS ObjectLink_Account_AccountGroup
                                                        ON ObjectLink_Account_AccountGroup.ObjectId = Container_Summ.ObjectId
                                                       AND ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
                                                       AND ObjectLink_Account_AccountGroup.ChildObjectId = zc_Enum_AccountGroup_30000() -- Дебиторы
                                        JOIN ContainerLinkObject AS CLO_Juridical
                                                                 ON CLO_Juridical.ContainerId = Container_Summ.Id
                                                                AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                        JOIN ContainerLinkObject AS CLO_Contract
                                                                 ON CLO_Contract.ContainerId = Container_Summ.Id
                                                                AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                        JOIN tmpContract ON tmpContract.JuridicalId = CLO_Juridical.ObjectId
                                                        AND tmpContract.ContractId = CLO_Contract.ObjectId
                                        JOIN ContainerLinkObject AS CLO_PaidKind
                                                                 ON CLO_PaidKind.ContainerId = Container_Summ.Id
                                                                AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                AND CLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm() -- только БН
                                        LEFT JOIN tmpDayInfo ON tmpDayInfo.JuridicalId = CLO_Juridical.ObjectId
                                                            AND tmpDayInfo.ContractId = CLO_Contract.ObjectId
                                   WHERE Container_Summ.DescId = zc_Container_Summ()
                                     AND Container_Summ.Amount <> 0.0
                                  )
                , tmpMIContainer AS (SELECT MovementItemContainer.ContainerId
                                          , SUM (MovementItemContainer.Amount)::TFloat AS Summ
                                     FROM MovementItemContainer
                                          JOIN tmpContainer ON tmpContainer.ContainerId = MovementItemContainer.ContainerId
                                     WHERE MovementItemContainer.DescId = zc_MIContainer_Summ()
                                       AND (MovementItemContainer.MovementDescId = zc_Movement_Sale()
                                        OR (MovementItemContainer.MovementDescId = zc_Movement_TransferDebtOut() AND MovementItemContainer.isActive))
                                       AND MovementItemContainer.OperDate >= tmpContainer.ContractDate
                                     GROUP BY MovementItemContainer.ContainerId
                                    )
                , tmpDebtAll AS (SELECT tmpContainer.ContainerId
                                      , tmpContainer.JuridicalId
                                      , tmpContainer.ContractId
                                      , tmpContainer.Amount                                                 AS DebtSum
                                      , (tmpContainer.Amount - COALESCE (tmpMIContainer.Summ, 0.0)::TFloat) AS OverSum
                                      , (zfCalc_OverDayCount (tmpContainer.ContainerId, tmpContainer.Amount - COALESCE (tmpMIContainer.Summ, 0.0)::TFloat, tmpContainer.ContractDate)) AS OverDays
                                      , SUM (tmpContainer.Amount) OVER (PARTITION BY tmpContainer.JuridicalId, ABS (tmpContainer.Amount)) AS ResortSum
                                 FROM tmpContainer
                                      LEFT JOIN tmpMIContainer ON tmpContainer.ContainerId = tmpMIContainer.ContainerId
                                )
                , tmpDebt AS (SELECT tmpDebtAll.JuridicalId
                                   , tmpDebtAll.ContractId
                                   , SUM (tmpDebtAll.DebtSum)::TFloat AS DebtSum
                                   , SUM (tmpDebtAll.OverSum)::TFloat AS OverSum
                                   , MAX (tmpDebtAll.OverDays)        AS OverDays
                              FROM tmpDebtAll
                              WHERE tmpDebtAll.ResortSum <> 0.0
                              GROUP BY tmpDebtAll.JuridicalId
                                     , tmpDebtAll.ContractId
                             )
             SELECT Object_Juridical.Id
                  , Object_Juridical.ObjectCode
                  , Object_Juridical.ValueData
                  , ObjectString_Juridical_GUID.ValueData   AS GUID
                  , 0 /*COALESCE (tmpDebt.DebtSum, 0.0)*/ :: TFloat AS DebtSum -- !!!временно убрали долги БН!!!
                  , 0 /*COALESCE (tmpDebt.OverSum, 0.0)*/ :: TFloat AS OverSum -- !!!временно убрали долги БН!!!
                  , CASE WHEN COALESCE (tmpDebt.OverSum, 0.0) > 0.0 THEN COALESCE (tmpDebt.OverDays, 0)::Integer ELSE 0::Integer END AS OverDays
                  , tmpContract.ContractId
                  , ObjectLink_Juridical_JuridicalGroup.ChildObjectId AS JuridicalGroupId
                  , Object_Juridical.isErased
                  , CAST(true AS Boolean) AS isSync
             FROM Object AS Object_Juridical
                  JOIN tmpContract ON tmpContract.JuridicalId = Object_Juridical.Id
                  LEFT JOIN tmpDebt ON tmpDebt.JuridicalId = Object_Juridical.Id
                                   AND tmpDebt.ContractId = tmpContract.ContractId
                  LEFT JOIN ObjectString AS ObjectString_Juridical_GUID
                                         ON ObjectString_Juridical_GUID.ObjectId = Object_Juridical.Id
                                        AND ObjectString_Juridical_GUID.DescId = zc_ObjectString_Juridical_GUID()
                  LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                       ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                                      AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
             WHERE Object_Juridical.DescId   = zc_Object_Juridical()
               AND Object_Juridical.isErased = FALSE
           --LIMIT CASE WHEN vbUserId = 1072129 THEN 0 ELSE 500000 END
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;

      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_Juridical (inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelectMobile_Object_Juridical (inSyncDateIn := zc_DateStart(), inSession := '1071994')
