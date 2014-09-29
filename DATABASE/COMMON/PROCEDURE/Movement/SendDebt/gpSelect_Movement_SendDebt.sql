-- Function: gpSelect_Movement_SendDebt()

DROP FUNCTION IF EXISTS gpSelect_Movement_SendDebt (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendDebt(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalSumm TFloat

             , InfoMoneyGroupFromName TVarChar
             , InfoMoneyDestinationFromName TVarChar
             , InfoMoneyFromId Integer, InfoMoneyFromCode Integer, InfoMoneyFromName TVarChar, InfoMoneyFromName_all TVarChar
             , ContractFromId Integer, ContractFromName TVarChar, ContractTagFromName TVarChar
             , JuridicalFromId Integer, JuridicalFromCode Integer, JuridicalFromName TVarChar
             , ItemFromName TVarChar, FromOKPO TVarChar
             , PaidKindFromId Integer, PaidKindFromName TVarChar

             , InfoMoneyGroupToName TVarChar
             , InfoMoneyDestinationToName TVarChar
             , InfoMoneyToId Integer, InfoMoneyToCode Integer, InfoMoneyToName TVarChar, InfoMoneyToName_all TVarChar
             , ContractToId Integer, ContractToName TVarChar, ContractTagToName TVarChar
             , JuridicalToId Integer, JuridicalToCode Integer, JuridicalToName TVarChar
             , ItemToName TVarChar, ToOKPO TVarChar
             , PaidKindToId Integer, PaidKindToName TVarChar
             
             , Amount TFloat
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SendDebt());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT
              Movement.Id
            , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
            , Movement.OperDate
            , Object_Status.ObjectCode   AS StatusCode
            , Object_Status.ValueData    AS StatusName

            , MovementFloat_TotalSumm.ValueData AS TotalSumm
                      
            , View_InfoMoney_From.InfoMoneyGroupName       AS InfoMoneyGroupFromName
            , View_InfoMoney_From.InfoMoneyDestinationName AS InfoMoneyDestinationFromName
            , View_InfoMoney_From.InfoMoneyId              AS InfoMoneyFromId
            , View_InfoMoney_From.InfoMoneyCode            AS InfoMoneyFromCode
            , View_InfoMoney_From.InfoMoneyName            AS InfoMoneyFromName
            , View_InfoMoney_From.InfoMoneyName_all        AS InfoMoneyFromName_all

            , View_Contract_InvNumber_From.ContractId  AS ContractFromId
            , View_Contract_InvNumber_From.InvNumber   AS ContractFromName
            , View_Contract_InvNumber_From.ContractTagName AS ContractTagFromName

            , Object_Juridical_From.Id                 AS JuridicalFromId
            , Object_Juridical_From.ObjectCode         AS JuridicalFromCode
            , Object_Juridical_From.ValueData          AS JuridicalFromName
            , ObjectFromDesc.ItemName                  AS ItemFromName
            , ObjectHistory_JuridicalDetails_From.OKPO AS FromOKPO
            , Object_PaidKind_From.Id                  AS PaidKindFromId
            , Object_PaidKind_From.ValueData           AS PaidKindFromName

            , View_InfoMoney_To.InfoMoneyGroupName       AS InfoMoneyGroupToName
            , View_InfoMoney_To.InfoMoneyDestinationName AS InfoMoneyDestinationToName
            , View_InfoMoney_To.InfoMoneyId              AS InfoMoneyToId
            , View_InfoMoney_To.InfoMoneyCode            AS InfoMoneyToCode
            , View_InfoMoney_To.InfoMoneyName            AS InfoMoneyToName
            , View_InfoMoney_To.InfoMoneyName_all        AS InfoMoneyToName_all

            , View_Contract_InvNumber_To.ContractId  AS ContractToId
            , View_Contract_InvNumber_To.InvNumber   AS ContractToName
            , View_Contract_InvNumber_To.ContractTagName AS ContractTagToName

            , Object_Juridical_To.Id                 AS JuridicalToId
            , Object_Juridical_To.ObjectCode         AS JuridicalToCode
            , Object_Juridical_To.ValueData          AS JuridicalToName
            , ObjectToDesc.ItemName                  AS ItemToName
            , ObjectHistory_JuridicalDetails_To.OKPO AS ToOKPO
            , Object_PaidKind_To.Id                  AS PaidKindToId
            , Object_PaidKind_To.ValueData           AS PaidKindToName

            , MI_Master.Amount             AS Amount
            , MIString_Comment.ValueData  AS Comment
            
       FROM Movement
            -- JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementItem AS MI_Master ON MI_Master.MovementId = Movement.Id
                                         AND MI_Master.DescId     = zc_MI_Master()

            LEFT JOIN Object AS Object_Juridical_From ON Object_Juridical_From.Id = MI_Master.ObjectId
            LEFT JOIN ObjectDesc AS ObjectFromDesc ON ObjectFromDesc.Id = Object_Juridical_From.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_JuridicalFrom
                                 ON ObjectLink_Partner_JuridicalFrom.ObjectId = MI_Master.ObjectId
                                AND ObjectLink_Partner_JuridicalFrom.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS ObjectHistory_JuridicalDetails_From ON ObjectHistory_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Partner_JuridicalFrom.ChildObjectId, Object_Juridical_From.Id)

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney_From
                                             ON MILinkObject_InfoMoney_From.MovementItemId = MI_Master.Id
                                            AND MILinkObject_InfoMoney_From.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_From ON View_InfoMoney_From.InfoMoneyId = MILinkObject_InfoMoney_From.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract_From
                                             ON MILinkObject_Contract_From.MovementItemId = MI_Master.Id
                                            AND MILinkObject_Contract_From.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_From ON View_Contract_InvNumber_From.ContractId = MILinkObject_Contract_From.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind_From
                                             ON MILinkObject_PaidKind_From.MovementItemId = MI_Master.Id
                                            AND MILinkObject_PaidKind_From.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind_From ON Object_PaidKind_From.Id = MILinkObject_PaidKind_From.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MI_Master.Id 
                                        AND MIString_Comment.DescId = zc_MIString_Comment()


            LEFT JOIN MovementItem AS MI_Child ON MI_Child.MovementId = Movement.Id
                                              AND MI_Child.DescId     = zc_MI_Child()
                                         
            LEFT JOIN Object AS Object_Juridical_To ON Object_Juridical_To.Id = MI_Child.ObjectId
            LEFT JOIN ObjectDesc AS ObjectToDesc ON ObjectToDesc.Id = Object_Juridical_To.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_JuridicalTo
                                 ON ObjectLink_Partner_JuridicalTo.ObjectId = MI_Child.ObjectId
                                AND ObjectLink_Partner_JuridicalTo.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS ObjectHistory_JuridicalDetails_To ON ObjectHistory_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_JuridicalTo.ChildObjectId, Object_Juridical_To.Id)

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney_To
                                             ON MILinkObject_InfoMoney_To.MovementItemId = MI_Child.Id
                                            AND MILinkObject_InfoMoney_To.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_To ON View_InfoMoney_To.InfoMoneyId = MILinkObject_InfoMoney_To.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract_To
                                             ON MILinkObject_Contract_To.MovementItemId = MI_Child.Id
                                            AND MILinkObject_Contract_To.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_To ON View_Contract_InvNumber_To.ContractId = MILinkObject_Contract_To.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind_To
                                             ON MILinkObject_PaidKind_To.MovementItemId = MI_Child.Id
                                            AND MILinkObject_PaidKind_To.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind_To ON Object_PaidKind_To.Id = MILinkObject_PaidKind_To.ObjectId
            
      WHERE Movement.DescId = zc_Movement_SendDebt()
        AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_SendDebt (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.01.14         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_SendDebt (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= zfCalc_UserAdmin())
