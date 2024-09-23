-- Function: gpSelect_Movement_ProfitLossService_ContractChild ()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossService_ContractChild (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProfitLossService_ContractChild (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , -- 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , ContractChildId Integer, ContractChildCode Integer, ContractChildInvNumber TVarChar                --договор база 
             , JuridicalId_Child Integer, JuridicalCode_Child Integer, JuridicalName_Child TVarChar
             , ContractId Integer, ContractCode Integer, ContractInvNumber TVarChar    
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar     
             , InfoMoneyId                Integer
             , InfoMoneyCode              Integer
             , InfoMoneyName              TVarChar
             , InfoMoneyName_all          TVarChar
             , InfoMoneyId_Child          Integer
             , InfoMoneyCode_Child        Integer
             , InfoMoneyName_Child        TVarChar
             , InfoMoneyName_all_Child    TVarChar
             , PaidKindId_Child           Integer
             , PaidKindName_Child         TVarChar
             ) 

AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
      WITH 
      --вібираем все документы
      tmpMovementFull AS (SELECT Movement.*
                          FROM Movement
                               LEFT JOIN MovementLinkMovement AS MLM_Doc
                                                              ON MLM_Doc.MovementId = Movement.Id
                                                             AND MLM_Doc.DescId = zc_MovementLinkMovement_Doc() 
     
                               LEFT JOIN MovementLinkObject AS MLO_TradeMark
                                                            ON MLO_TradeMark.MovementId = Movement.Id
                                                           AND MLO_TradeMark.DescId = zc_MovementLinkObject_TradeMark()
                                                    
                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.DescId = zc_Movement_ProfitLossService()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND COALESCE (MLM_Doc.MovementChildId, 0) = 0
                            AND COALESCE (MLO_TradeMark.ObjectId, 0) = 0
                          )
    
    --
    , tmpData AS (SELECT COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId, 0) AS JuridicalId 
                       , MILinkObject_ContractChild.ObjectId          AS ContractChildId
                       --, MILinkObject_Juridical.ObjectId              AS JuridicalId_child
                       , MILinkObject_Contract.ObjectId               AS ContractId
                       , MILinkObject_ContractConditionKind.ObjectId  AS ContractConditionKindId
                       , ROW_Number() OVER (PARTITION BY MILinkObject_ContractChild.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId, 0)) AS Ord
                  FROM tmpMovementFull AS Movement
                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id 

                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                    /*  LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                                          ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                     */
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                   ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()

                      LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                       ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()  
                      INNER JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                          ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()  
                                                         AND MILinkObject_ContractConditionKind.ObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                           , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()) 
                  )
  
             SELECT Object_Juridical.Id             AS JuridicalId
                  , Object_Juridical.ObjectCode     AS JuridicalCode
                  , Object_Juridical.ValueData      AS JuridicalName
                  , Object_ContractChild.Id         AS ContractChildId
                  , Object_ContractChild.ObjectCode AS ContractChildCode
                  , Object_ContractChild.ValueData  AS ContractChildInvNumber 
                  , Object_Juridical_Child.Id         AS JuridicalId_Child
                  , Object_Juridical_Child.ObjectCode AS JuridicalCode_Child
                  , Object_Juridical_Child.ValueData  AS JuridicalName_Child 
                  , Object_Contract.Id              AS ContractId
                  , Object_Contract.ObjectCode      AS ContractCode
                  , Object_Contract.ValueData       AS ContractInvNumber  
                  , Object_ContractConditionKind.Id        AS ContractConditionKindId
                  , Object_ContractConditionKind.ValueData AS ContractConditionKindName 
                  , Object_InfoMoney_View.InfoMoneyId              AS InfoMoneyId
                  , Object_InfoMoney_View.InfoMoneyCode            AS InfoMoneyCode
                  , Object_InfoMoney_View.InfoMoneyName            AS InfoMoneyName
                  , Object_InfoMoney_View.InfoMoneyName_all        AS InfoMoneyName_all
                  , Object_InfoMoneyChild_View.InfoMoneyId              AS InfoMoneyId_Child
                  , Object_InfoMoneyChild_View.InfoMoneyCode            AS InfoMoneyCode_Child
                  , Object_InfoMoneyChild_View.InfoMoneyName            AS InfoMoneyName_Child
                  , Object_InfoMoneyChild_View.InfoMoneyName_all        AS InfoMoneyName_all_Child 
                  , Object_PaidKind_Child.Id                   AS PaidKindId_Child
                  , Object_PaidKind_Child.ValueData ::TVarChar AS PaidKindName_Child
             FROM tmpData 
                LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
               -- LEFT JOIN Object AS Object_Juridical_Child ON Object_Juridical_Child.Id = tmpData.JuridicalId_child
                LEFT JOIN Object AS Object_ContractChild ON Object_ContractChild.Id = tmpData.ContractChildId
                LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpData.ContractId
                LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpData.ContractConditionKindId 

                LEFT JOIN ObjectLink AS ObjectLink_ContractChild_Juridical
                                     ON ObjectLink_ContractChild_Juridical.ObjectId = tmpData.ContractChildId
                                    AND ObjectLink_ContractChild_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                LEFT JOIN Object AS Object_Juridical_Child ON Object_Juridical_Child.Id = ObjectLink_ContractChild_Juridical.ChildObjectId 
 
                LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                     ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                    AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Contract_InfoMoney.ChildObjectId
         
                LEFT JOIN ObjectLink AS ObjectLink_ContractChild_InfoMoney
                                     ON ObjectLink_ContractChild_InfoMoney.ObjectId = Object_ContractChild.Id
                                    AND ObjectLink_ContractChild_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                LEFT JOIN Object_InfoMoney_View AS Object_InfoMoneyChild_View ON Object_InfoMoneyChild_View.InfoMoneyId = ObjectLink_ContractChild_InfoMoney.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_ContractChild_PaidKind
                                     ON ObjectLink_ContractChild_PaidKind.ObjectId = Object_ContractChild.Id
                                    AND ObjectLink_ContractChild_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                LEFT JOIN Object AS Object_PaidKind_Child ON Object_PaidKind_Child.Id = ObjectLink_ContractChild_PaidKind.ChildObjectId
             WHERE tmpData.Ord = 1
            ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.09.24         *
*/

-- тест
--SELECT * FROM gpSelect_Movement_ProfitLossService_ContractChild (inStartDate:= '01.08.2024', inEndDate:= '01.10.2024', inSession:= zfCalc_UserAdmin());