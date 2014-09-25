-- Function: gpGet_Movement_SendDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_SendDebt (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SendDebt(
    IN inMovementId        Integer   , -- ���� ���������
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, MI_MasterId Integer, MI_ChildId Integer
             , InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
 
             , InfoMoneyFromId Integer, InfoMoneyFromName TVarChar
             , ContractFromId Integer, ContractFromName TVarChar
             , JuridicalFromId Integer, JuridicalFromName TVarChar
             , PartnerFromId Integer, PartnerFromName TVarChar

             , PaidKindFromId Integer, PaidKindFromName TVarChar

             , InfoMoneyToId Integer, InfoMoneyToName TVarChar
             , ContractToId Integer, ContractToName TVarChar
             , JuridicalToId Integer, JuridicalToName TVarChar
             , PartnerToId Integer, PartnerToName TVarChar

             , PaidKindToId Integer, PaidKindToName TVarChar
             
             , Amount TFloat
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
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

            , MI_Master.Amount            AS Amount
            , MIString_Comment.ValueData  AS Comment
           
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                       
            LEFT JOIN MovementItem AS MI_Master ON MI_Master.MovementId = Movement.Id
                                         AND MI_Master.DescId     = zc_MI_Master()

            LEFT JOIN ObjectLink AS ObjectLink_PartnerFrom_Juridical
                                 ON ObjectLink_PartnerFrom_Juridical.ObjectId = MI_Master.ObjectId
                                AND ObjectLink_PartnerFrom_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Partner_From ON Object_Partner_From.Id = ObjectLink_PartnerFrom_Juridical.ObjectId
            LEFT JOIN Object AS Object_Juridical_From ON Object_Juridical_From.Id = COALESCE (ObjectLink_PartnerFrom_Juridical.ChildObjectId, MI_Master.ObjectId)

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
                                         
            LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Juridical
                                 ON ObjectLink_PartnerTo_Juridical.ObjectId = MI_Child.ObjectId
                                AND ObjectLink_PartnerTo_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Partner_To ON Object_Partner_To.Id = ObjectLink_PartnerTo_Juridical.ObjectId
            LEFT JOIN Object AS Object_Juridical_To ON Object_Juridical_To.Id = COALESCE (ObjectLink_PartnerTo_Juridical.ChildObjectId, MI_Child.ObjectId)

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

 
                                    
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_SendDebt();

     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_SendDebt (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 24.01.14         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_SendDebt (inMovementId:= 0, inOperDate:= NULL, inSession:= zfCalc_UserAdmin())
