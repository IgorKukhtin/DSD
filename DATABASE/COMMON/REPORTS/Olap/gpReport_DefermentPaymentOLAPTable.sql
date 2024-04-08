-- Function: gpReport_DefermentPaymentOLAPTable()

DROP FUNCTION IF EXISTS gpReport_DefermentDebtOLAPTable (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_DefermentDebtOLAPTable (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_DefermentPaymentOLAPTable (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_DefermentPaymentOLAPTable (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inAccountId          Integer   ,
    IN inBranchId           Integer   ,
    IN inRetailId           Integer   ,
    IN inJuridicalId        Integer   , -- юр.лицо
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , MonthDate TDateTime

             , BranchName TVarChar
             , AccountId Integer, AccountCode Integer, AccountName TVarChar
             , RetailId Integer, RetailName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , StartContractDate TDateTime
             , ContractTagGroupName TVarChar
             , ContractTagName TVarChar
             , PaidKindName TVarChar
             
             , DebtRemains TFloat
             , SaleSumm TFloat
             , DefermentPaymentRemains TFloat
             , DebtRemains_month TFloat
             , SaleSumm_month TFloat
             , DefermentPaymentRemains_month TFloat
             , Condition TVarChar
             )   
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- Ограничения по товару
--    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
--    CREATE TEMP TABLE _tmpFromGroup (FromId Integer) ON COMMIT DROP;

    -- Результат
    RETURN QUERY
      WITH 
      tmpReport AS (SELECT tmpData.OperDate
                         , tmpData.AccountId
                         , tmpData.BranchId
                         , tmpData.JuridicalId
                         , tmpData.PartnerId
                         , tmpData.PaidKindId
                         , tmpData.ContractId
                         , tmpData.StartContractDate
                         , tmpData.DebtRemains
                         , tmpData.SaleSumm
                         , (COALESCE (tmpData.DebtRemains,0) - COALESCE (tmpData.SaleSumm,0)) :: TFloat AS DefermentPaymentRemains
                         , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                    FROM DefermentPaymentOLAPTable AS tmpData
                         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = tmpData.JuridicalId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                    WHERE tmpData.OperDate BETWEEN inStartDate AND inEndDate
                      AND (tmpData.BranchId = inBranchId OR inBranchId = 0)
                      AND (tmpData.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                      AND (tmpData.AccountId = inAccountId OR inAccountId = 0)
                      AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                      
                    )

    , tmpContractCondition_View AS (SELECT Object_ContractCondition_View.*
                                    FROM Object_ContractCondition_View
                                    WHERE Object_ContractCondition_View.ContractId IN (SELECT DISTINCT tmpReport.ContractId FROM tmpReport)
                                    )
                                    
    , tmpContractParam AS (SELECT tmpView.ContractId
                                , tmpView.ContractCode
                                , tmpView.InvNumber AS ContractName
                                , tmpView.ContractTagGroupId
                                , tmpView.ContractTagGroupCode
                                , tmpView.ContractTagGroupName
                                , tmpView.ContractTagId
                                , tmpView.ContractTagCode
                                , tmpView.ContractTagName
                                , ContractCondition_DefermentPayment.ContractConditionKindId
                                , COALESCE (ContractCondition_DefermentPayment.DayCount, 0) AS DayCount
                                , COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) AS ContractStateKindId
                                , tmpView.isErased
                           FROM (SELECT DISTINCT tmpReport.ContractId FROM tmpReport) AS tmpContract
                                LEFT JOIN Object_Contract_InvNumber_View AS tmpView ON tmpView.ContractId = tmpContract.ContractId

                       -- !!!Группируем Договора!!!
                       LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = tmpContract.ContractId
         
                       LEFT JOIN (SELECT Object_ContractCondition_View.ContractId
                                       , zfCalc_DetermentPaymentDate (COALESCE (ContractConditionKindId, 0), Value :: Integer, inStartDate) :: Date AS ContractDate
                                       , ContractConditionKindId
                                       , Value :: Integer AS DayCount
                                    FROM tmpContractCondition_View AS Object_ContractCondition_View
                                         INNER JOIN Object_ContractCondition_DefermentPaymentView 
                                                 ON Object_ContractCondition_DefermentPaymentView.ConditionKindId = Object_ContractCondition_View.ContractConditionKindId
                                    WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                                      AND Value <> 0
                                      AND inStartDate BETWEEN Object_ContractCondition_View.StartDate AND Object_ContractCondition_View.EndDate
                                 ) AS ContractCondition_DefermentPayment
                                   ON ContractCondition_DefermentPayment.ContractId = View_Contract_ContractKey.ContractId_Key -- CLO_Contract.ObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                            ON ObjectLink_Contract_ContractStateKind.ObjectId = tmpContract.ContractId
                                           AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind()
                                        
                           )

      -- Результат
      SELECT tmpReport.OperDate
           , DATE_TRUNC ('Month', tmpReport.OperDate) ::TDateTime AS MonthDate
           , Object_Branch.ValueData :: TVarChar AS BranchName
           , Object_Account.Id           AS AccountId
           , Object_Account.ObjectCode   AS AccountCode
           --, Object_Account.ValueData    AS AccountName
           , CAST ((CASE WHEN Object_Account.ObjectCode < 100000 THEN '' ELSE '' END || Object_Account.ObjectCode || ' ' || Object_Account.ValueData) AS TVarChar) AS AccountName
           
           , Object_Retail.Id            AS RetailId
           , Object_Retail.ValueData     AS RetailName
           
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ObjectCode AS JuridicalCode
           , Object_Juridical.ValueData  AS JuridicalName
           
           , Object_Partner.Id           AS PartnerId
           , Object_Partner.ObjectCode   AS PartnerCode
           , Object_Partner.ValueData    AS PartnerName
           
           , tmpContractParam.ContractId
           , tmpContractParam.ContractCode
           , tmpContractParam.ContractName
           , tmpReport.StartContractDate ::TDateTime

           , tmpContractParam.ContractTagGroupName
           , tmpContractParam.ContractTagName
           , Object_PaidKind.ValueData   AS PaidKindName

           , tmpReport.DebtRemains  :: TFloat
           , tmpReport.SaleSumm     :: TFloat
           , CASE WHEN COALESCE (tmpReport.DefermentPaymentRemains,0) < 0 THEN 0 ELSE COALESCE (tmpReport.DefermentPaymentRemains,0) END ::TFloat AS DefermentPaymentRemains
           
           , CASE WHEN tmpReport.OperDate = DATE_TRUNC ('Month', tmpReport.OperDate) THEN tmpReport.DebtRemains ELSE 0 END ::TFloat AS DebtRemains_month
           , CASE WHEN tmpReport.OperDate = DATE_TRUNC ('Month', tmpReport.OperDate) THEN tmpReport.SaleSumm ELSE 0 END ::TFloat AS SaleSumm_month
           , CASE WHEN tmpReport.OperDate = DATE_TRUNC ('Month', tmpReport.OperDate)
                      THEN CASE WHEN COALESCE (tmpReport.DefermentPaymentRemains,0) < 0 THEN 0 ELSE COALESCE (tmpReport.DefermentPaymentRemains,0) END 
                  ELSE 0
             END ::TFloat AS DefermentPaymentRemains_month

            , (tmpContractParam.DayCount
              ||' '|| CASE WHEN tmpContractParam.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendar()
                                THEN 'К.дн.'
                           WHEN tmpContractParam.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBank()
                                THEN 'Б.дн.'
                           ELSE ''
                      END
              ||' '|| CASE WHEN CASE WHEN tmpContractParam.IsErased = FALSE AND tmpContractParam.ContractStateKindId <> zc_Enum_ContractStateKind_Close() THEN COALESCE (ContractCondition_CreditLimit.DelayCreditLimit, 0) ELSE 0 END <> 0
                                THEN '+ ' || TRIM (to_char (CASE WHEN tmpContractParam.IsErased = FALSE AND tmpContractParam.ContractStateKindId <> zc_Enum_ContractStateKind_Close() THEN COALESCE (ContractCondition_CreditLimit.DelayCreditLimit, 0) ELSE 0 END, '999 999 999 999 999D99')) || 'грн.'
                           ELSE ''
                      END
               )::TVarChar AS Condition

        FROM tmpReport
             LEFT JOIN Object AS Object_Account ON Object_Account.Id = tmpReport.AccountId
             LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpReport.BranchId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpReport.JuridicalId
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpReport.PartnerId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpReport.PaidKindId
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpReport.RetailId

             LEFT JOIN tmpContractParam ON tmpContractParam.ContractId = tmpReport.ContractId


             LEFT JOIN (SELECT Object_ContractCondition_View.ContractId
                             , Object_ContractCondition_View.PaidKindId
                             , Value AS DelayCreditLimit
                        FROM tmpContractCondition_View AS Object_ContractCondition_View
                        WHERE Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayCreditLimit()
                       ) AS ContractCondition_CreditLimit
                         ON ContractCondition_CreditLimit.ContractId = tmpReport.ContractId
                        AND ContractCondition_CreditLimit.PaidKindId = tmpReport.PaidKindId
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.01.21         *
*/

-- тест-
-- SELECT * FROM gpReport_DefermentPaymentOLAPTable (inStartDate:= '01.06.2020', inEndDate:= '01.06.2020', inAccountId:=0, inBranchId:= 0, inRetailId:=0, inJuridicalId:= 0, inSession:= zfCalc_UserAdmin()) limit 1;