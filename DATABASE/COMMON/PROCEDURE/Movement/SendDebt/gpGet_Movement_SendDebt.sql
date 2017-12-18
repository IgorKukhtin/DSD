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
 
             , InfoMoneyFromId Integer, InfoMoneyFromName TVarChar
             , ContractFromId Integer, ContractFromName TVarChar
             , JuridicalFromId Integer, JuridicalFromName TVarChar
             , PartnerFromId Integer, PartnerFromName TVarChar

             , PaidKindFromId Integer, PaidKindFromName TVarChar
             , BranchFromId Integer, BranchFromName TVarChar

             , InfoMoneyToId Integer, InfoMoneyToName TVarChar
             , ContractToId Integer, ContractToName TVarChar
             , JuridicalToId Integer, JuridicalToName TVarChar
             , PartnerToId Integer, PartnerToName TVarChar

             , PaidKindToId Integer, PaidKindToName TVarChar
             , BranchToId Integer, BranchToName TVarChar
             
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

            , 0            AS InfoMoneyFromId
            , ''::TVarChar AS InfoMoneyFromName

            , 0            AS ContractFromId
            , ''::TVarChar AS ContractFromName

            , 0            AS JuridicalFromId
            , ''::TVarChar AS JuridicalFromName
            , 0                                AS PartnerFromId
            , CAST ('' as TVarChar)            AS PartnerFromName

            , 0            AS PaidKindFromId
            , ''::TVarChar AS PaidKindFromName

            , 0            AS BranchFromId
            , ''::TVarChar AS BranchFromName

            , 0            AS InfoMoneyToId
            , ''::TVarChar AS InfoMoneyToName

            , 0            AS ContractToId
            , ''::TVarChar AS ContractToName

            , 0            AS JuridicalToId
            , ''::TVarChar AS JuridicalToName
            , 0                                AS PartnerToId
            , CAST ('' as TVarChar)            AS PartnerToName

            , 0            AS PaidKindToId
            , ''::TVarChar AS PaidKindToName

            , 0            AS BranchToId
            , ''::TVarChar AS BranchToName

            , 0::TFloat  AS Amount
            , ''::TVarChar AS Comment

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
               LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = 9399
               LEFT JOIN Object AS Object_Business ON Object_Business.Id = 8370
       ;
     ELSE
     RETURN QUERY 
       WITH tmpMI AS (SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId)
          , tmpMILO AS (SELECT * FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))
          , tmpMIString AS (SELECT * FROM MovementItemString WHERE MovementItemString.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))
          , tmpInfoMoney AS (SELECT * FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyId IN (SELECT tmpMILO.ObjectId FROM tmpMILO))
          , tmpContract AS (SELECT * FROM Object_Contract_InvNumber_View WHERE Object_Contract_InvNumber_View.ContractId IN (SELECT tmpMILO.ObjectId FROM tmpMILO))
       SELECT
              Movement.Id
            , MI_Master.Id AS MI_MasterId
            , MI_Child.Id  AS MI_ChildId
           
             , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
            , Movement.OperDate
            , Object_Status.ObjectCode   AS StatusCode
            , Object_Status.ValueData    AS StatusName

            , View_InfoMoney_From.InfoMoneyId              AS InfoMoneyFromId
            , View_InfoMoney_From.InfoMoneyName_all        AS InfoMoneyFromName

            , View_Contract_InvNumber_From.ContractId  AS ContractFromId
            , View_Contract_InvNumber_From.InvNumber   AS ContractFromName

            , Object_Juridical_From.Id                 AS JuridicalFromId
            , Object_Juridical_From.ValueData          AS JuridicalFromName
            , Object_Partner_From.Id                   AS PartnerFromId
            , Object_Partner_From.ValueData            AS PartnerFromName

            , Object_PaidKind_From.Id                  AS PaidKindFromId
            , Object_PaidKind_From.ValueData           AS PaidKindFromName

            , Object_Branch_From.Id                    AS BranchFromId
            , Object_Branch_From.ValueData             AS BranchFromName

            , View_InfoMoney_To.InfoMoneyId              AS InfoMoneyToId
            , View_InfoMoney_To.InfoMoneyName_all        AS InfoMoneyToName

            , View_Contract_InvNumber_To.ContractId  AS ContractToId
            , View_Contract_InvNumber_To.InvNumber   AS ContractToName

            , Object_Juridical_To.Id                 AS JuridicalToId
            , Object_Juridical_To.ValueData          AS JuridicalToName
            , Object_Partner_To.Id                   AS PartnerToId
            , Object_Partner_To.ValueData            AS PartnerToName

            , Object_PaidKind_To.Id                  AS PaidKindToId
            , Object_PaidKind_To.ValueData           AS PaidKindToName

            , Object_Branch_To.Id                    AS BranchToId
            , Object_Branch_To.ValueData             AS BranchToName

            , MI_Master.Amount            AS Amount
            , MIString_Comment.ValueData  AS Comment
           
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                       
            LEFT JOIN tmpMI AS MI_Master ON MI_Master.MovementId = Movement.Id
                                        AND MI_Master.DescId     = zc_MI_Master()

            LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Juridical
                                 ON ObjectLink_PartnerFrom_Juridical.ObjectId = MI_Master.ObjectId
                                AND ObjectLink_PartnerFrom_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Partner_From ON Object_Partner_From.Id = ObjectLink_PartnerFrom_Juridical.ObjectId
            LEFT JOIN Object AS Object_Juridical_From ON Object_Juridical_From.Id = COALESCE (ObjectLink_PartnerFrom_Juridical.ChildObjectId, MI_Master.ObjectId)

            LEFT JOIN tmpMILO AS MILinkObject_InfoMoney_From
                              ON MILinkObject_InfoMoney_From.MovementItemId = MI_Master.Id
                             AND MILinkObject_InfoMoney_From.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN tmpInfoMoney AS View_InfoMoney_From ON View_InfoMoney_From.InfoMoneyId = MILinkObject_InfoMoney_From.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Contract_From
                                             ON MILinkObject_Contract_From.MovementItemId = MI_Master.Id
                                            AND MILinkObject_Contract_From.DescId = zc_MILinkObject_Contract()
            LEFT JOIN tmpContract AS View_Contract_InvNumber_From ON View_Contract_InvNumber_From.ContractId = MILinkObject_Contract_From.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_PaidKind_From
                                             ON MILinkObject_PaidKind_From.MovementItemId = MI_Master.Id
                                            AND MILinkObject_PaidKind_From.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind_From ON Object_PaidKind_From.Id = MILinkObject_PaidKind_From.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Branch_From
                                             ON MILinkObject_Branch_From.MovementItemId = MI_Master.Id
                                            AND MILinkObject_Branch_From.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch_From ON Object_Branch_From.Id = MILinkObject_Branch_From.ObjectId


            LEFT JOIN tmpMIString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MI_Master.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            
            LEFT JOIN tmpMI AS MI_Child ON MI_Child.MovementId = Movement.Id
                                         AND MI_Child.DescId     = zc_MI_Child()
                                         
            LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Juridical
                                 ON ObjectLink_PartnerTo_Juridical.ObjectId = MI_Child.ObjectId
                                AND ObjectLink_PartnerTo_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Partner_To ON Object_Partner_To.Id = ObjectLink_PartnerTo_Juridical.ObjectId
            LEFT JOIN Object AS Object_Juridical_To ON Object_Juridical_To.Id = COALESCE (ObjectLink_PartnerTo_Juridical.ChildObjectId, MI_Child.ObjectId)

            LEFT JOIN tmpMILO AS MILinkObject_InfoMoney_To
                                             ON MILinkObject_InfoMoney_To.MovementItemId = MI_Child.Id
                                            AND MILinkObject_InfoMoney_To.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN tmpInfoMoney AS View_InfoMoney_To ON View_InfoMoney_To.InfoMoneyId = MILinkObject_InfoMoney_To.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Contract_To
                                             ON MILinkObject_Contract_To.MovementItemId = MI_Child.Id
                                            AND MILinkObject_Contract_To.DescId = zc_MILinkObject_Contract()
            LEFT JOIN tmpContract AS View_Contract_InvNumber_To ON View_Contract_InvNumber_To.ContractId = MILinkObject_Contract_To.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_PaidKind_To
                                             ON MILinkObject_PaidKind_To.MovementItemId = MI_Child.Id
                                            AND MILinkObject_PaidKind_To.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind_To ON Object_PaidKind_To.Id = MILinkObject_PaidKind_To.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Branch_To
                                             ON MILinkObject_Branch_To.MovementItemId = MI_Child.Id
                                            AND MILinkObject_Branch_To.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch_To ON Object_Branch_To.Id = MILinkObject_Branch_To.ObjectId

                                    
       WHERE Movement.Id     =  inMovementId
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
-- SELECT * FROM gpGet_Movement_SendDebt (inMovementId:= 1, inOperDate:= NULL, inSession:= zfCalc_UserAdmin())
