-- Function: gpSelectMobile_Object_Contract (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Contract (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Contract (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id               Integer
             , ObjectCode       Integer   -- Код
             , ValueData        TVarChar  -- Название
             , ContractTagName  TVarChar  -- Признак договора
             , InfoMoneyName    TVarChar  -- УП статья
             , Comment          TVarChar  -- Примечание
             , PaidKindId       Integer   -- Форма оплаты
             , StartDate        TDateTime -- Дата с которой действует договор
             , EndDate          TDateTime -- Дата до которой действует договор
             , ChangePercent    TFloat    -- (-)% Скидки (+)% Наценки - для Скидки - отрицателеное значение, для Наценки - положительное
             , DelayDayCalendar TFloat    -- Отсрочка в календарных днях
             , DelayDayBank     TFloat    -- Отсрочка в банковских днях
             , isErased         Boolean   -- Удаленный ли элемент
             , isSync           Boolean   -- Синхронизируется (да/нет)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- !!!ВРЕМЕННО!!!
      inSyncDateIn:= zc_DateStart();


      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
           RETURN QUERY
             WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS ContractId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                  FROM ObjectProtocol
                                       JOIN Object AS Object_Contract
                                                   ON Object_Contract.Id = ObjectProtocol.ObjectId
                                                  AND Object_Contract.DescId = zc_Object_Contract()
                                  WHERE inSyncDateIn > zc_DateStart()
                                    AND ObjectProtocol.OperDate > inSyncDateIn
                                  GROUP BY ObjectProtocol.ObjectId
                                 )
               , tmpJuridical AS (SELECT DISTINCT lfSelect.JuridicalId AS JuridicalId FROM lfSelectMobile_Object_Partner (FALSE, inSession) AS lfSelect
                                 )
                , tmpContract AS (SELECT DISTINCT ObjectLink_Contract_Juridical.ObjectId AS ContractId
                                  FROM tmpJuridical
                                       JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                       ON ObjectLink_Contract_Juridical.ChildObjectId = tmpJuridical.JuridicalId
                                                      AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
                                       -- убрали Удаленные
                                       JOIN Object AS Object_Contract
                                                   ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                                  AND Object_Contract.isErased = FALSE
                                       -- убрали Закрытые
                                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                                            ON ObjectLink_Contract_ContractStateKind.ObjectId      = ObjectLink_Contract_Juridical.ObjectId
                                                           AND ObjectLink_Contract_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()
                                                           AND ObjectLink_Contract_ContractStateKind.ChildObjectId = zc_Enum_ContractStateKind_Close()
                                  -- убрали Закрытые
                                  WHERE ObjectLink_Contract_ContractStateKind.ChildObjectId IS NULL
                                 )
                , tmpFilter AS (SELECT tmpProtocol.ContractId FROM tmpProtocol
                                UNION
                                SELECT tmpContract.ContractId FROM tmpContract WHERE inSyncDateIn <= zc_DateStart()
                               )
            , tmpContractCondition_all AS (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId              AS ContractId
                                                , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                                                , CASE WHEN ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                                                        AND MIN (ObjectFloat_ContractCondition_Value.ValueData) < 0.0
                                                            THEN (MIN (ABS (ObjectFloat_ContractCondition_Value.ValueData)) * -1.0)::TFloat
                                                            ELSE MIN (ObjectFloat_ContractCondition_Value.ValueData)::TFloat
                                                  END AS ContractConditionKindValue
                                                , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())  :: TDateTime AS StartDate
                                                , COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())      :: TDateTime AS EndDate
                                           FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                                                JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                                ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                               AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                               AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_ChangePercent()
                                                                                                                                      , zc_Enum_ContractConditionKind_DelayDayCalendar()
                                                                                                                                      , zc_Enum_ContractConditionKind_DelayDayBank()
                                                                                                                                       )
                                                JOIN ObjectFloat AS ObjectFloat_ContractCondition_Value
                                                                 ON ObjectFloat_ContractCondition_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                                AND ObjectFloat_ContractCondition_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                                AND ObjectFloat_ContractCondition_Value.ValueData <> 0.0
                                                JOIN Object AS Object_ContractCondition
                                                            ON Object_ContractCondition.Id = ObjectLink_ContractCondition_Contract.ObjectId
                                                           AND Object_ContractCondition.isErased = FALSE
                                                JOIN Object AS Object_Contract
                                                            ON Object_Contract.Id = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                           AND Object_Contract.isErased = FALSE
                                                JOIN tmpContract ON tmpContract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                                     ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                                                                    AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractCondition_StartDate()
                                                LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                                                     ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                                                                    AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractCondition_EndDate()
                                           WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                           GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId
                                                  , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                                  , ObjectDate_StartDate.ValueData
                                                  , ObjectDate_EndDate.ValueData
                                          )
            , tmpContractCondition AS (SELECT tmpContractCondition_all.*
                                       FROM tmpContractCondition_all
                                       WHERE CURRENT_DATE BETWEEN tmpContractCondition_all.StartDate AND tmpContractCondition_all.EndDate
                                      )
             SELECT Object_Contract.Id
                  , Object_Contract.ObjectCode
                  , Object_Contract.ValueData
                  , Object_ContractTag.ValueData               AS ContractTagName
                  , Object_InfoMoney.ValueData                 AS InfoMoneyName
                  , ObjectString_Contract_Comment.ValueData    AS Comment
                  , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId
                  , ObjectDate_Contract_Start.ValueData        AS StartDate
                  , ObjectDate_Contract_End.ValueData          AS EndDate
                  , COALESCE (tmpChangePercent.ContractConditionKindValue, 0.0)::TFloat    AS ChangePercent
                  , COALESCE (tmpDelayDayCalendar.ContractConditionKindValue, 0.0)::TFloat AS DelayDayCalendar
                  , COALESCE (tmpDelayDayBank.ContractConditionKindValue, 0.0)::TFloat     AS DelayDayBank
                  , Object_Contract.isErased
                  , CASE WHEN -- Ограничим - если удален
                              Object_Contract.isErased = TRUE
                              -- Ограничим - если Завершен
                           OR COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) = zc_Enum_ContractStateKind_Close()
                              -- Ограничим - если НЕ ГП
                           OR COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) <> zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                              THEN FALSE

                         WHEN tmpContract.ContractId IS NULL
                              THEN FALSE

                         ELSE TRUE

                    END :: Boolean AS isSync

             FROM Object AS Object_Contract
                  JOIN tmpFilter ON tmpFilter.ContractId = Object_Contract.Id

                  -- Ограничим - если Состояние договора - НЕ Завершен
                  LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                       ON ObjectLink_Contract_ContractStateKind.ObjectId = Object_Contract.Id
                                      AND ObjectLink_Contract_ContractStateKind.DescId   = zc_ObjectLink_Contract_ContractStateKind()
                  -- Ограничим - ТОЛЬКО если ГП
                  LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                       ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                      AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                  LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

                  LEFT JOIN tmpContract ON tmpContract.ContractId = Object_Contract.Id
                  LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                       ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                      AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                  LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
                  LEFT JOIN ObjectString AS ObjectString_Contract_Comment
                                         ON ObjectString_Contract_Comment.ObjectId = Object_Contract.Id
                                        AND ObjectString_Contract_Comment.DescId = zc_ObjectString_Contract_Comment()
                  LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                       ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                                      AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                  LEFT JOIN ObjectDate AS ObjectDate_Contract_Start
                                       ON ObjectDate_Contract_Start.ObjectId = Object_Contract.Id
                                      AND ObjectDate_Contract_Start.DescId = zc_ObjectDate_Contract_Start()
                  LEFT JOIN ObjectDate AS ObjectDate_Contract_End
                                       ON ObjectDate_Contract_End.ObjectId = Object_Contract.Id
                                      AND ObjectDate_Contract_End.DescId = zc_ObjectDate_Contract_End()
                  LEFT JOIN tmpContractCondition AS tmpChangePercent
                                                 ON tmpChangePercent.ContractId = Object_Contract.Id
                                                AND tmpChangePercent.ContractConditionKindId = zc_Enum_ContractConditionKind_ChangePercent()
                  LEFT JOIN tmpContractCondition AS tmpDelayDayCalendar
                                                 ON tmpDelayDayCalendar.ContractId = Object_Contract.Id
                                                AND tmpDelayDayCalendar.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendar()
                  LEFT JOIN tmpContractCondition AS tmpDelayDayBank
                                                 ON tmpDelayDayBank.ContractId = Object_Contract.Id
                                                AND tmpDelayDayBank.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBank()
             WHERE Object_Contract.DescId   = zc_Object_Contract()
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
-- SELECT * FROM gpSelectMobile_Object_Contract (inSyncDateIn := zc_DateStart(), inSession := '347628') -- Киюк С.М.
-- SELECT * FROM gpSelectMobile_Object_Contract (inSyncDateIn := zc_DateStart(), inSession := '1000167') WHERE ObjectCode in (4859, 4572, 4532) -- Зенченко Ю.Д.
-- SELECT * FROM gpSelectMobile_Object_Contract (inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelectMobile_Object_Contract (inSyncDateIn := zc_DateStart(), inSession := '1839161')
