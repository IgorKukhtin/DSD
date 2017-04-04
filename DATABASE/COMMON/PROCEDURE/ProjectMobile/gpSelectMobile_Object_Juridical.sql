-- Function: gpSelectMobile_Object_Juridical (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Juridical (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Juridical (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- Код
             , ValueData  TVarChar -- Название
             , GUID       TVarChar -- Глобальный уникальный идентификатор. Для синхронизации с Главной БД
             , DebtSum    TFloat   -- Сумма долга (нам) - БН - т.к. БН долг формируется только в разрезе Юр Лиц + договоров
             , OverSum    TFloat   -- Сумма просроченного долга (нам) - БН - Просрочка наступает спустя определенное кол-во дней
             , OverDays   Integer  -- Кол-во дней просрочки (нам)
             , ContractId Integer  -- Договор - все возможные договора...
             , isErased   Boolean  -- Удаленный ли элемент
             , isSync     Boolean  -- Синхронизируется (да/нет)
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
             WITH tmpJuridical AS (SELECT DISTINCT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                   FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                                        JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                   WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                     AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                  )
                , tmpDayInfo AS (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId              AS ContractId
                                      , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                                      , ObjectLink_Contract_Juridical.ChildObjectId                      AS JuridicalId
                                      , zfCalc_DetermentPaymentDate (ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                                                   , MIN (ObjectFloat_ContractCondition_Value.ValueData)::Integer
                                                                   , CURRENT_DATE)::Date AS ContractDate
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
                                      JOIN Object AS Object_ContractCondition
                                                  ON Object_ContractCondition.Id = ObjectLink_ContractCondition_Contract.ObjectId
                                                 AND NOT Object_ContractCondition.isErased 
                                      JOIN Object AS Object_Contract
                                                  ON Object_Contract.Id = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                 AND NOT Object_Contract.isErased 
                                      JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                      ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                     AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical() 
                                      JOIN tmpJuridical ON tmpJuridical.JuridicalId = ObjectLink_Contract_Juridical.ChildObjectId
                                 WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                 GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId
                                        , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                        , ObjectLink_Contract_Juridical.ChildObjectId
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
                                        JOIN tmpJuridical ON tmpJuridical.JuridicalId = CLO_Juridical.ObjectId
                                        JOIN ContainerLinkObject AS CLO_Contract
                                                                 ON CLO_Contract.ContainerId = Container_Summ.Id
                                                                AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
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
                , tmpDebt AS (SELECT tmpContainer.JuridicalId
                                   , tmpContainer.ContractId
                                   , SUM (tmpContainer.Amount)::TFloat                                               AS DebtSum
                                   , SUM (tmpContainer.Amount - COALESCE (tmpMIContainer.Summ, 0.0)::TFloat)::TFloat AS OverSum
                                   , MAX (zfCalc_OverDayCount (tmpContainer.ContainerId, tmpContainer.Amount - COALESCE (tmpMIContainer.Summ, 0.0)::TFloat, tmpContainer.ContractDate)) AS OverDays
                              FROM tmpContainer
                                   LEFT JOIN tmpMIContainer ON tmpContainer.ContainerId = tmpMIContainer.ContainerId
                              GROUP BY tmpContainer.JuridicalId
                                     , tmpContainer.ContractId
                             )
             SELECT Object_Juridical.Id
                  , Object_Juridical.ObjectCode
                  , Object_Juridical.ValueData
                  , ObjectString_Juridical_GUID.ValueData   AS GUID
                  , COALESCE (tmpDebt.DebtSum, 0.0)::TFloat AS DebtSum
                  , COALESCE (tmpDebt.OverSum, 0.0)::TFloat AS OverSum
                  , COALESCE (tmpDebt.OverDays, 0)::Integer AS OverDays
                  , ObjectLink_Contract_Juridical.ObjectId  AS ContractId
                  , Object_Juridical.isErased
                  , CAST(true AS Boolean) AS isSync
             FROM Object AS Object_Juridical
                  JOIN tmpJuridical ON tmpJuridical.JuridicalId = Object_Juridical.Id 
                  JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                  ON ObjectLink_Contract_Juridical.ChildObjectId = Object_Juridical.Id
                                 AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                  LEFT JOIN tmpDebt ON tmpDebt.JuridicalId = Object_Juridical.Id
                                   AND tmpDebt.ContractId = ObjectLink_Contract_Juridical.ObjectId
                  LEFT JOIN ObjectString AS ObjectString_Juridical_GUID
                                         ON ObjectString_Juridical_GUID.ObjectId = Object_Juridical.Id
                                        AND ObjectString_Juridical_GUID.DescId = zc_ObjectString_Juridical_GUID()
             WHERE Object_Juridical.DescId = zc_Object_Juridical()
               AND NOT Object_Juridical.isErased;
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
-- SELECT * FROM gpSelectMobile_Object_Juridical(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
