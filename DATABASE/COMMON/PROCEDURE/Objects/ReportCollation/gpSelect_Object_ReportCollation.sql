-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_ReportCollation (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ReportCollation (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_ReportCollation(
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inJuridicalId         Integer,      --
    IN inPartnerId           Integer,      --
    IN inContractId          Integer,      --
    IN inPaidKindId          Integer,      --
    IN inInfoMoneyId         Integer,      --
    IN inIsShowAll           Boolean,  
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ObjectCode Integer, idBarCode TVarChar
             , StartDate  TDateTime
             , EndDate    TDateTime
             , JuridicalId   Integer
             , JuridicalName TVarChar
             , OKPO          TVarChar
             , PersonalName  TVarChar
             , UnitName      TVarChar
             , PositionName  TVarChar
             , BranchName_personal TVarChar         -- филиал ответственного
             , PartnerId     Integer
             , PartnerName   TVarChar
             , ContractId    Integer
             , ContractName  TVarChar
             , PaidKindId    Integer
             , PaidKindName  TVarChar
             , InfoMoneyId   Integer
             , InfoMoneyName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , BuhName TVarChar
             , BuhDate TDateTime
             , StartRemainsRep TFloat
             , EndRemainsRep TFloat
             , StartRemains TFloat
             , EndRemains TFloat
             , StartRemainsCalc TFloat
             , EndRemainsCalc TFloat
             , isStartRemainsRep Boolean
             , isEndRemainsRep Boolean
             , isBuh Boolean
             , isDiff Boolean
             , isErased Boolean

             , ReCalcName TVarChar
             , ReCalcDate TDateTime
             
             , AreaContractName TVarChar
             , BranchName       TVarChar       --филиал AreaContract
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Contract());
   vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY
   WITH 
       tmpJuridicalDetails AS (SELECT * FROM ObjectHistory_JuridicalDetails_View)

     , tmpData AS (SELECT Object_ReportCollation.Id
                        , Object_ReportCollation.ObjectCode
                        , (zfFormat_BarCode (zc_BarCodePref_Object(), Object_ReportCollation.Id) || '0') ::TVarChar AS idBarCode
                        , ObjectDate_Start.ValueData      AS StartDate
                        , ObjectDate_End.ValueData        AS EndDate
                        , Object_Juridical.ValueData      AS JuridicalName
                        , Object_Partner.ValueData        AS PartnerName
                        , Object_Contract.ValueData       AS ContractName
                        , Object_PaidKind.ValueData       AS PaidKindName
                        , Object_InfoMoney.ValueData      AS InfoMoneyName

                        , Object_Insert.ValueData         AS InsertName
                        , ObjectDate_Insert.ValueData     AS InsertDate

                        , Object_Buh.ValueData            AS BuhName
                        , ObjectDate_Buh.ValueData        AS BuhDate

                        , COALESCE (ObjectBoolean_Buh.ValueData, FALSE) ::Boolean  AS isBuh
                        , Object_ReportCollation.isErased

                        , COALESCE (ObjectLink_ReportCollation_PaidKind.ChildObjectId , 0) AS PaidKindId
                        , COALESCE (ObjectLink_ReportCollation_Contract.ChildObjectId,  0) AS ContractId
                        , COALESCE (ObjectLink_ReportCollation_Partner.ChildObjectId,   0) AS PartnerId
                        , COALESCE (ObjectLink_ReportCollation_Juridical.ChildObjectId, 0) AS JuridicalId
                        , COALESCE (ObjectLink_ReportCollation_InfoMoney.ChildObjectId, 0) AS InfoMoneyId
                        
                        , COALESCE (ObjectFloat_StartRemainsRep.ValueData, 0)     AS StartRemainsRep
                        , COALESCE (ObjectFloat_EndRemainsRep.ValueData, 0)       AS EndRemainsRep
                        , COALESCE (ObjectFloat_StartRemains.ValueData, 0)        AS StartRemains
                        , COALESCE (ObjectFloat_EndRemains.ValueData, 0)          AS EndRemains
                        , COALESCE (ObjectFloat_StartRemainsCalc.ValueData, 0)    AS StartRemainsCalc
                        , COALESCE (ObjectFloat_EndRemainsCalc.ValueData, 0)      AS EndRemainsCalc

                    FROM Object AS Object_ReportCollation
                       LEFT JOIN ObjectDate AS ObjectDate_Start
                                            ON ObjectDate_Start.ObjectId = Object_ReportCollation.Id
                                           AND ObjectDate_Start.DescId = zc_ObjectDate_ReportCollation_Start()
                       LEFT JOIN ObjectDate AS ObjectDate_End
                                             ON ObjectDate_End.ObjectId = Object_ReportCollation.Id
                                            AND ObjectDate_End.DescId = zc_ObjectDate_ReportCollation_End()

                       LEFT JOIN ObjectDate AS ObjectDate_Insert
                                            ON ObjectDate_Insert.ObjectId = Object_ReportCollation.Id
                                           AND ObjectDate_Insert.DescId = zc_ObjectDate_ReportCollation_Insert()

                       LEFT JOIN ObjectDate AS ObjectDate_Buh
                                            ON ObjectDate_Buh.ObjectId = Object_ReportCollation.Id
                                           AND ObjectDate_Buh.DescId = zc_ObjectDate_ReportCollation_Buh()

                       LEFT JOIN ObjectBoolean AS ObjectBoolean_Buh
                                               ON ObjectBoolean_Buh.ObjectId = Object_ReportCollation.Id
                                              AND ObjectBoolean_Buh.DescId = zc_ObjectBoolean_ReportCollation_Buh()

                       LEFT JOIN ObjectFloat AS ObjectFloat_StartRemainsRep
                                             ON ObjectFloat_StartRemainsRep.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_StartRemainsRep.DescId = zc_ObjectFloat_ReportCollation_StartRemainsRep()
                       LEFT JOIN ObjectFloat AS ObjectFloat_EndRemainsRep
                                             ON ObjectFloat_EndRemainsRep.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_EndRemainsRep.DescId = zc_ObjectFloat_ReportCollation_EndRemainsRep()
                       LEFT JOIN ObjectFloat AS ObjectFloat_StartRemains
                                             ON ObjectFloat_StartRemains.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_StartRemains.DescId = zc_ObjectFloat_ReportCollation_StartRemains()
                       LEFT JOIN ObjectFloat AS ObjectFloat_EndRemains
                                             ON ObjectFloat_EndRemains.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_EndRemains.DescId = zc_ObjectFloat_ReportCollation_EndRemains()
                       LEFT JOIN ObjectFloat AS ObjectFloat_StartRemainsCalc
                                             ON ObjectFloat_StartRemainsCalc.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_StartRemainsCalc.DescId = zc_ObjectFloat_ReportCollation_StartRemainsCalc()
                       LEFT JOIN ObjectFloat AS ObjectFloat_EndRemainsCalc
                                             ON ObjectFloat_EndRemainsCalc.ObjectId = Object_ReportCollation.Id
                                            AND ObjectFloat_EndRemainsCalc.DescId = zc_ObjectFloat_ReportCollation_EndRemainsCalc()
                                  
                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_PaidKind
                                            ON ObjectLink_ReportCollation_PaidKind.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_ReportCollation_PaidKind.DescId = zc_ObjectLink_ReportCollation_PaidKind()
                       LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_ReportCollation_PaidKind.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Juridical
                                            ON ObjectLink_ReportCollation_Juridical.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_ReportCollation_Juridical.DescId = zc_ObjectLink_ReportCollation_Juridical()
                       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_ReportCollation_Juridical.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Partner
                                            ON ObjectLink_ReportCollation_Partner.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_ReportCollation_Partner.DescId = zc_ObjectLink_ReportCollation_Partner()
                       LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ReportCollation_Partner.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_Contract
                                            ON ObjectLink_ReportCollation_Contract.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_ReportCollation_Contract.DescId = zc_ObjectLink_ReportCollation_Contract()
                       LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ReportCollation_Contract.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_ReportCollation_InfoMoney
                                            ON ObjectLink_ReportCollation_InfoMoney.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_ReportCollation_InfoMoney.DescId = zc_ObjectLink_ReportCollation_InfoMoney()
                       LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_ReportCollation_InfoMoney.ChildObjectId
                                                           AND Object_InfoMoney.DescId = zc_Object_InfoMoney()
                       

                       LEFT JOIN ObjectLink AS ObjectLink_Insert
                                            ON ObjectLink_Insert.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_Insert.DescId = zc_ObjectLink_ReportCollation_Insert()
                       LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Buh
                                            ON ObjectLink_Buh.ObjectId = Object_ReportCollation.Id
                                           AND ObjectLink_Buh.DescId = zc_ObjectLink_ReportCollation_Buh()
                       LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = ObjectLink_Buh.ChildObjectId
      
                   WHERE Object_ReportCollation.DescId = zc_Object_ReportCollation()
                     AND ObjectDate_Start.ValueData >= inStartDate
                     AND ObjectDate_End.ValueData   <= inEndDate
                     AND (Object_ReportCollation.isErased = FALSE OR inIsShowAll = TRUE)
                     AND (COALESCE (ObjectLink_ReportCollation_Juridical.ChildObjectId, 0) = inJuridicalId OR inJuridicalId = 0)
                     AND (COALESCE (ObjectLink_ReportCollation_Partner.ChildObjectId, 0)   = inPartnerId   OR inPartnerId = 0)
                     AND (COALESCE (ObjectLink_ReportCollation_Contract.ChildObjectId, 0)  = inContractId  OR inContractId = 0)
                     AND (COALESCE (ObjectLink_ReportCollation_PaidKind.ChildObjectId, 0)  = inPaidKindId  OR inPaidKindId = 0)
                     AND (COALESCE (ObjectLink_ReportCollation_InfoMoney.ChildObjectId, 0) = inInfoMoneyId OR inInfoMoneyId = 0)
                   )
                   
      SELECT tmpData.Id
           , tmpData.ObjectCode
           , tmpData.idBarCode
           , tmpData.StartDate
           , tmpData.EndDate
           , tmpData.JuridicalId
           , tmpData.JuridicalName
           , tmpJuridicalDetails.OKPO    AS OKPO
           , Object_Personal.ValueData   AS PersonalName  -- ответственный за договор
           , Object_Unit.ValueData       AS UnitName      -- подразделение ответственный за договор
           , Object_Position.ValueData   AS PositionName  -- должность ответственный за договор
           , Object_Branch_personal.ValueData AS BranchName_personal
           , tmpData.PartnerId
           , tmpData.PartnerName
           , tmpData.ContractId
           , tmpData.ContractName
           , tmpData.PaidKindId
           , tmpData.PaidKindName
           , tmpData.InfoMoneyId
           , tmpData.InfoMoneyName

           , tmpData.InsertName
           , tmpData.InsertDate

           , tmpData.BuhName
           , tmpData.BuhDate

           , tmpData.StartRemainsRep  :: TFloat  AS StartRemainsRep
           , tmpData.EndRemainsRep    :: TFloat  AS EndRemainsRep
           , tmpData.StartRemains     :: TFloat  AS StartRemains
           , tmpData.EndRemains       :: TFloat  AS EndRemains
           , tmpData.StartRemainsCalc :: TFloat  AS StartRemainsCalc
           , tmpData.EndRemainsCalc   :: TFloat  AS EndRemainsCalc

           , CASE WHEN COALESCE (tmpData.StartRemainsRep, 0) <> 0 AND tmpData.StartRemainsCalc <> tmpData.StartRemainsRep THEN TRUE ELSE FALSE END :: Boolean AS isStartRemainsRep
           , CASE WHEN COALESCE (tmpData.EndRemainsRep, 0) <> 0   AND tmpData.EndRemainsCalc <> tmpData.EndRemainsRep THEN TRUE ELSE FALSE END     :: Boolean AS isEndRemainsRep
           
           , tmpData.isBuh

           , CASE WHEN tmpData.ObjectCode > 1 AND tmpData_old.EndDate <> tmpData.StartDate - INTERVAL '1 DAY' THEN TRUE ELSE FALSE END :: Boolean AS isDiff
           
           , tmpData.isErased

           , Object_ReCalc.ValueData              AS ReCalcName
           , ObjectDate_Protocol_ReCalc.ValueData AS ReCalcDate
          
           , Object_AreaContract.ValueData                AS AreaContractName
           , Object_Branch.ValueData                      AS BranchName
           
           
      FROM tmpData
           LEFT JOIN tmpData AS	 tmpData_old ON tmpData_old.PaidKindId  = tmpData.PaidKindId
                                            AND tmpData_old.ContractId  = tmpData.ContractId
                                            AND tmpData_old.PartnerId   = tmpData.PartnerId
                                            AND tmpData_old.JuridicalId = tmpData.JuridicalId
                                            AND tmpData_old.ObjectCode  = tmpData.ObjectCode - 1
           LEFT JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalId = tmpData.JuridicalId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                ON ObjectLink_Contract_Personal.ObjectId = tmpData.ContractId
                               AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
           LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Contract_Personal.ChildObjectId 

           LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Contract_Personal.ChildObjectId
                               AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Contract_Personal.ChildObjectId
                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                               AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
           LEFT JOIN Object AS Object_Branch_personal ON Object_Branch_personal.Id = ObjectLink_Unit_Branch.ChildObjectId

           LEFT JOIN ObjectDate AS ObjectDate_Protocol_ReCalc
                                ON ObjectDate_Protocol_ReCalc.ObjectId = tmpData.Id
                               AND ObjectDate_Protocol_ReCalc.DescId = zc_ObjectDate_Protocol_ReCalc()
 
           LEFT JOIN ObjectLink AS ObjectLink_ReCalc
                                ON ObjectLink_ReCalc.ObjectId = tmpData.Id
                               AND ObjectLink_ReCalc.DescId = zc_ObjectLink_Protocol_ReCalc()
           LEFT JOIN Object AS Object_ReCalc ON Object_ReCalc.Id = ObjectLink_ReCalc.ChildObjectId           

           LEFT JOIN ObjectLink AS ObjectLink_Contract_AreaContract
                                ON ObjectLink_Contract_AreaContract.ObjectId = tmpData.ContractId
                               AND ObjectLink_Contract_AreaContract.DescId = zc_ObjectLink_Contract_AreaContract()
                               AND tmpData.PaidKindId = zc_Enum_PaidKind_FirstForm()
           LEFT JOIN Object AS Object_AreaContract ON Object_AreaContract.Id = ObjectLink_Contract_AreaContract.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_AreaContract_Branch
                                ON ObjectLink_AreaContract_Branch.ObjectId = ObjectLink_Contract_AreaContract.ChildObjectId
                               AND ObjectLink_AreaContract_Branch.DescId = zc_ObjectLink_AreaContract_Branch()
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_AreaContract_Branch.ChildObjectId

       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.11.18         * add inInfoMoneyId
 14.10.18         * 
 20.01.17         *
*/

-- тест
-- select * from gpSelect_Object_ReportCollation(inStartDate := ('01.10.2018')::TDateTime , inEndDate := ('03.11.2018')::TDateTime , inJuridicalId := 112824 , inPartnerId := 0 , inContractId := 0 , inPaidKindId := 0 , inInfoMoneyId := 0 , inIsShowAll := 'False' ,  inSession := '5');
