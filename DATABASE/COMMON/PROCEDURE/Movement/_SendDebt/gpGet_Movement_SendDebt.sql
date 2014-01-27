-- Function: gpGet_Movement_SendDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_SendDebt (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SendDebt(
    IN inMovementId        Integer   , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, MI_MasterId Integer, MI_ChildId Integer
             , InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
 
             , InfoMoneyGroupFromName TVarChar
             , InfoMoneyFromId Integer, InfoMoneyFromCode Integer, InfoMoneyFromName TVarChar
             , ContractFromId Integer, ContractFromName TVarChar
             , JuridicalFromId Integer, JuridicalFromCode Integer, JuridicalFromName TVarChar
             , FromOKPO TVarChar
             , PaidKindFromId Integer, PaidKindFromName TVarChar

             , InfoMoneyGroupToName TVarChar
             , InfoMoneyToId Integer, InfoMoneyToCode Integer, InfoMoneyToName TVarChar
             , ContractToId Integer, ContractToName TVarChar
             , JuridicalToId Integer, JuridicalToCode Integer, JuridicalToName TVarChar
             , ToOKPO TVarChar
             , PaidKindToId Integer, PaidKindToName TVarChar
             
             , Amount TFloat
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_SendDebt());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT
              0 AS Id
            , 0 AS MI_MasterId
            , 0 AS MI_ChildId
            , CAST (NEXTVAL ('Movement_SendDebt_seq') as Integer) AS InvNumber
            , inOperDate    AS OperDate
            , 0             AS StatusCode
            , ''::TVarChar  AS StatusName

            , ''::TVarChar AS InfoMoneyGroupFromName
            , 0            AS InfoMoneyFromId
            , 0            AS InfoMoneyFromCode
            , ''::TVarChar AS InfoMoneyFromName

            , 0            AS ContractFromId
            , ''::TVarChar AS ContractFromName

            , 0            AS JuridicalFromId
            , 0            AS JuridicalFromCode
            , ''::TVarChar AS JuridicalFromName
            , ''::TVarChar AS FromOKPO
            , 0            AS PaidKindFromId
            , ''::TVarChar AS PaidKindFromName


            , ''::TVarChar AS InfoMoneyGroupToName
            , 0            AS InfoMoneyToId
            , 0            AS InfoMoneyToCode
            , ''::TVarChar AS InfoMoneyToName

            , 0            AS ContractToId
            , ''::TVarChar AS ContractToName

            , 0            AS JuridicalToId
            , 0            AS JuridicalToCode
            , ''::TVarChar AS JuridicalToName
            , ''::TVarChar AS ToOKPO
            , 0            AS PaidKindToId
            , ''::TVarChar AS PaidKindToName

            , 0::TFloat  AS Amount
            , ''::TVarChar AS Comment

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
               LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = 9399
               LEFT JOIN Object AS Object_Business ON Object_Business.Id = 8370
       ;
     ELSE
     RETURN QUERY 
       SELECT
              Movement.Id
            , MI_Master.Id AS MI_MasterId
            , MI_Child.Id  AS MI_ChildId
           
             , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
            , Movement.OperDate
            , Object_Status.ObjectCode   AS StatusCode
            , Object_Status.ValueData    AS StatusName

            , View_InfoMoney_From.InfoMoneyGroupName       AS InfoMoneyGroupFromName
            , View_InfoMoney_From.InfoMoneyId              AS InfoMoneyFromId
            , View_InfoMoney_From.InfoMoneyCode            AS InfoMoneyFromCode
            , View_InfoMoney_From.InfoMoneyName            AS InfoMoneyFromName

            , View_Contract_InvNumber_From.ContractId  AS ContractFromId
            , View_Contract_InvNumber_From.InvNumber   AS ContractFromName

            , Object_Juridical_From.Id                 AS JuridicalFromId
            , Object_Juridical_From.ObjectCode         AS JuridicalFromCode
            , Object_Juridical_From.ValueData          AS JuridicalFromName
            , ObjectHistory_JuridicalDetails_From.OKPO AS FromOKPO
            , Object_PaidKind_From.Id                  AS PaidKindFromId
            , Object_PaidKind_From.ValueData           AS PaidKindFromName


            , View_InfoMoney_To.InfoMoneyGroupName       AS InfoMoneyGroupToName
            , View_InfoMoney_To.InfoMoneyId              AS InfoMoneyToId
            , View_InfoMoney_To.InfoMoneyCode            AS InfoMoneyToCode
            , View_InfoMoney_To.InfoMoneyName            AS InfoMoneyToName

            , View_Contract_InvNumber_To.ContractId  AS ContractToId
            , View_Contract_InvNumber_To.InvNumber   AS ContractToName

            , Object_Juridical_To.Id                 AS JuridicalToId
            , Object_Juridical_To.ObjectCode         AS JuridicalToCode
            , Object_Juridical_To.ValueData          AS JuridicalToName
            , ObjectHistory_JuridicalDetails_To.OKPO AS ToOKPO
            , Object_PaidKind_To.Id                  AS PaidKindToId
            , Object_PaidKind_To.ValueData           AS PaidKindToName

            , MI_Master.Amount         AS Amount
            , MovementString_Comment.ValueData      AS Comment
           
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                       
            LEFT JOIN MovementItem AS MI_Master ON MI_Master.MovementId = Movement.Id
                                         AND MI_Master.DescId     = zc_MI_Master()

            LEFT JOIN Object AS Object_Juridical_From ON Object_Juridical_From.Id = MI_Master.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS ObjectHistory_JuridicalDetails_From ON ObjectHistory_JuridicalDetails_From.JuridicalId = Object_Juridical_From.Id 

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

            
            LEFT JOIN MovementItem AS MI_Child ON MI_Child.MovementId = Movement.Id
                                         AND MI_Child.DescId     = zc_MI_Child()
                                         
            LEFT JOIN Object AS Object_Juridical_To ON Object_Juridical_To.Id = MI_Child.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS ObjectHistory_JuridicalDetails_To ON ObjectHistory_JuridicalDetails_To.JuridicalId = Object_Juridical_To.Id 

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

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId =  Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                    
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_SendDebt();

     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_SendDebt (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.01.14         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_SendDebt (inMovementId:= 0, inSession:= zfCalc_UserAdmin())
