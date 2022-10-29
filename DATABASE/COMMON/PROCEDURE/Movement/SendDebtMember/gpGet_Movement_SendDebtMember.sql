-- Function: gpGet_Movement_SendDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_SendDebtMember (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SendDebtMember(
    IN inMovementId        Integer   , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, MI_MasterId Integer, MI_ChildId Integer
             , InvNumber Integer, OperDate TDateTime
             , Comment TVarChar
 
             , InfoMoneyFromId Integer, InfoMoneyFromName TVarChar
             , MemberFromId Integer, MemberFromName TVarChar
             , CarFromId Integer, CarFromName TVarChar
             , BranchFromId Integer, BranchFromName TVarChar 
             , JuridicalBasisFromId Integer, JuridicalBasisFromName TVarChar

             , InfoMoneyToId Integer, InfoMoneyToName TVarChar
             , MemberToId Integer, MemberToName TVarChar
             , CarToId Integer, CarToName TVarChar
             , BranchToId Integer, BranchToName TVarChar
             , JuridicalBasisToId Integer, JuridicalBasisToName TVarChar

             , Amount TFloat

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_SendDebtMember());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT
              0 AS Id
            , 0 AS MI_MasterId
            , 0 AS MI_ChildId
            , CAST (NEXTVAL ('Movement_SendDebtMember_seq') as Integer) AS InvNumber
            , inOperDate    AS OperDate

            , ''::TVarChar AS Comment
            
            , 0            AS InfoMoneyFromId
            , ''::TVarChar AS InfoMoneyFromName

            , 0            AS MemberFromId
            , ''::TVarChar AS MemberFromName

            , 0            AS CarFromId
            , ''::TVarChar AS CarFromName

            , 0            AS BranchFromId
            , ''::TVarChar AS BranchFromName

            , 0            AS JuridicalBasisFromId
            , ''::TVarChar AS JuridicalBasisFromName

            , 0            AS InfoMoneyToId
            , ''::TVarChar AS InfoMoneyToName

            , 0            AS MemberToId
            , ''::TVarChar AS MemberToName

            , 0            AS CarToId
            , ''::TVarChar AS CarToName

            , 0            AS BranchToId
            , ''::TVarChar AS BranchToName

            , 0            AS JuridicalBasisToId
            , ''::TVarChar AS JuridicalBasisToName

            , 0 :: TFloat  AS Amount

         FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
               LEFT JOIN Object AS Object_MemberBasis ON Object_MemberBasis.Id = 9399
               LEFT JOIN Object AS Object_Business ON Object_Business.Id = 8370
       ;
     ELSE
     RETURN QUERY 
       WITH tmpMI AS (SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId)
          , tmpMILO     AS (SELECT * FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))
          , tmpMIFloat  AS (SELECT * FROM MovementItemFloat      WHERE MovementItemFloat.MovementItemId      IN (SELECT tmpMI.Id FROM tmpMI))
          , tmpInfoMoney AS (SELECT * FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyId     IN (SELECT tmpMILO.ObjectId FROM tmpMILO))
       SELECT
              Movement.Id
            , MI_Master.Id AS MI_MasterId
            , MI_Child.Id  AS MI_ChildId
           
             , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
            , Movement.OperDate
            , MovementString_Comment.ValueData      AS Comment

            , View_InfoMoney_From.InfoMoneyId       AS InfoMoneyFromId
            , View_InfoMoney_From.InfoMoneyName_all AS InfoMoneyFromName

            , Object_Member_From.Id                 AS MemberFromId
            , Object_Member_From.ValueData          AS MemberFromName

            , Object_Car_From.Id                    AS CarFromId
            , Object_Car_From.ValueData             AS CarFromName

            , Object_Branch_From.Id                 AS BranchFromId
            , Object_Branch_From.ValueData          AS BranchFromName

            , Object_JuridicalBasis_From.Id         AS JuridicalBasisFromId
            , Object_JuridicalBasis_From.ValueData  AS JuridicalBasisFromName
            
            , View_InfoMoney_To.InfoMoneyId         AS InfoMoneyToId
            , View_InfoMoney_To.InfoMoneyName_all   AS InfoMoneyToName

            , Object_Member_To.Id                   AS MemberToId
            , Object_Member_To.ValueData            AS MemberToName

            , Object_Car_To.Id                      AS CarToId
            , Object_Car_To.ValueData               AS CarToName

            , Object_Branch_To.Id                   AS BranchToId
            , Object_Branch_To.ValueData            AS BranchToName

            , Object_JuridicalBasis_To.Id           AS JuridicalBasisToId
            , Object_JuridicalBasis_To.ValueData    AS JuridicalBasisToName

            , MI_Master.Amount            :: TFloat AS Amount
           
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
   
            LEFT JOIN tmpMI AS MI_Master ON MI_Master.MovementId = Movement.Id
                                        AND MI_Master.DescId     = zc_MI_Master()

            LEFT JOIN Object AS Object_Member_From ON Object_Member_From.Id = MI_Master.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_InfoMoney_From
                              ON MILinkObject_InfoMoney_From.MovementItemId = MI_Master.Id
                             AND MILinkObject_InfoMoney_From.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN tmpInfoMoney AS View_InfoMoney_From ON View_InfoMoney_From.InfoMoneyId = MILinkObject_InfoMoney_From.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Car_From
                              ON MILinkObject_Car_From.MovementItemId = MI_Master.Id
                             AND MILinkObject_Car_From.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car_From ON Object_Car_From.Id = MILinkObject_Car_From.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Branch_From
                              ON MILinkObject_Branch_From.MovementItemId = MI_Master.Id
                             AND MILinkObject_Branch_From.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch_From ON Object_Branch_From.Id = MILinkObject_Branch_From.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_JuridicalBasis_From
                              ON MILinkObject_JuridicalBasis_From.MovementItemId = MI_Master.Id
                             AND MILinkObject_JuridicalBasis_From.DescId = zc_MILinkObject_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis_From ON Object_JuridicalBasis_From.Id = MILinkObject_JuridicalBasis_From.ObjectId

            LEFT JOIN tmpMI AS MI_Child ON MI_Child.MovementId = Movement.Id
                                       AND MI_Child.DescId     = zc_MI_Child()
            LEFT JOIN Object AS Object_Member_To ON Object_Member_To.Id = MI_Child.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_InfoMoney_To
                              ON MILinkObject_InfoMoney_To.MovementItemId = MI_Child.Id
                             AND MILinkObject_InfoMoney_To.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN tmpInfoMoney AS View_InfoMoney_To ON View_InfoMoney_To.InfoMoneyId = MILinkObject_InfoMoney_To.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Car_To
                              ON MILinkObject_Car_To.MovementItemId = MI_Child.Id
                             AND MILinkObject_Car_To.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car_To ON Object_Car_To.Id = MILinkObject_Car_To.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_Branch_To
                              ON MILinkObject_Branch_To.MovementItemId = MI_Child.Id
                             AND MILinkObject_Branch_To.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch_To ON Object_Branch_To.Id = MILinkObject_Branch_To.ObjectId

            LEFT JOIN tmpMILO AS MILinkObject_JuridicalBasis_To
                              ON MILinkObject_JuridicalBasis_To.MovementItemId = MI_Child.Id
                             AND MILinkObject_JuridicalBasis_To.DescId = zc_MILinkObject_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis_To ON Object_JuridicalBasis_To.Id = MILinkObject_JuridicalBasis_To.ObjectId

       WHERE Movement.Id     =  inMovementId
         AND Movement.DescId = zc_Movement_SendDebtMember();

     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_SendDebtMember (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.01.14         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_SendDebtMember (inMovementId:= 1, inOperDate:= NULL, inSession:= zfCalc_UserAdmin())
