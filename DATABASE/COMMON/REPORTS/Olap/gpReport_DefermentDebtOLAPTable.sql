-- Function: gpReport_DefermentDebtOLAPTable()

DROP FUNCTION IF EXISTS gpReport_DefermentDebtOLAPTable (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_DefermentDebtOLAPTable (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inBranchId           Integer   ,
    IN inJuridicalId        Integer   , -- юр.лицо
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , MonthDate TDateTime

             , BranchName TVarChar
             , AccountId Integer, AccountCode Integer, AccountName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , StartContractDate TDateTime
             , ContractTagGroupName TVarChar
             , ContractTagName TVarChar
             , PaidKindName TVarChar
             
             , DebtRemains TFloat
             , SaleSumm TFloat
             )   
AS
$BODY$
BEGIN

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
                    FROM DefermentDebtOLAPTable AS tmpData
                    WHERE tmpData.OperDate BETWEEN inStartDate AND inEndDate
                      AND (tmpData.BranchId = inBranchId OR inBranchId = 0)
                      AND (tmpData.JuridicalId = inJuridicalId OR inJuridicalId = 0)
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
                           FROM (SELECT DISTINCT tmpReport.ContractId FROM tmpReport) AS tmpContract
                                LEFT JOIN Object_Contract_InvNumber_View AS tmpView ON tmpView.ContractId = tmpContract.ContractId
                           )

      -- Результат
      SELECT tmpReport.OperDate
           , DATE_TRUNC ('Month', tmpReport.OperDate) ::TDateTime AS MonthDate
           , Object_Branch.ValueData :: TVarChar AS BranchName
           , Object_Account.Id AS AccountId
           , Object_Account.ObjectCode AS AccountCode
           , Object_Account.ValueData AS AccountName
           
           , Object_Juridical.Id AS JuridicalId
           , Object_Juridical.ObjectCode AS JuridicalCode
           , Object_Juridical.ValueData AS JuridicalName
           
           , Object_Partner.Id AS PartnerId
           , Object_Partner.ObjectCode AS PartnerCode
           , Object_Partner.ValueData AS PartnerName
           
           , tmpContractParam.ContractId
           , tmpContractParam.ContractCode
           , tmpContractParam.ContractName
           , tmpReport.StartContractDate ::TDateTime

           , tmpContractParam.ContractTagGroupName
           , tmpContractParam.ContractTagName
           , Object_PaidKind.ValueData AS PaidKindName

           , tmpReport.DebtRemains  :: TFloat
           , tmpReport.SaleSumm     :: TFloat

        FROM tmpReport
             LEFT JOIN Object AS Object_Account ON Object_Account.Id = tmpReport.AccountId
             LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpReport.BranchId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpReport.JuridicalId
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpReport.PartnerId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpReport.PaidKindId

             LEFT JOIN tmpContractParam ON tmpContractParam.ContractId = tmpReport.ContractId
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
-- SELECT * FROM gpReport_DefermentDebtOLAPTable (inStartDate:= '01.06.2020', inEndDate:= '01.06.2020', inBranchId:= 0, inJuridicalId:= 0, inSession:= zfCalc_UserAdmin()) limit 1;