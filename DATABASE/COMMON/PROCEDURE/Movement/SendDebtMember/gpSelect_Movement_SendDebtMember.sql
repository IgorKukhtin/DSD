-- Function: gpSelect_Movement_SendDebtMember()

--DROP FUNCTION IF EXISTS gpSelect_Movement_SendDebtMember (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_SendDebtMember (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendDebtMember(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо 
    IN inIsErased         Boolean   , -- показывать удаленные Да/Нет
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalSumm TFloat
             , Comment TVarChar

             , InfoMoneyGroupFromName TVarChar
             , InfoMoneyDestinationFromName TVarChar
             , InfoMoneyFromId Integer, InfoMoneyFromCode Integer, InfoMoneyFromName TVarChar, InfoMoneyFromName_all TVarChar
             , MemberFromId Integer, MemberFromCode Integer, MemberFromName TVarChar
             , ItemFromName TVarChar
             , CarFromId Integer, CarFromName TVarChar
             , BranchFromId Integer, BranchFromName TVarChar
             , JuridicalBasisFromId Integer, JuridicalBasisFromName TVarChar
             
             , InfoMoneyGroupToName TVarChar
             , InfoMoneyDestinationToName TVarChar
             , InfoMoneyToId Integer, InfoMoneyToCode Integer, InfoMoneyToName TVarChar, InfoMoneyToName_all TVarChar
             , MemberToId Integer, MemberToCode Integer, MemberToName TVarChar
             , ItemToName TVarChar
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
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SendDebtMember());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                    UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                    UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                         )
          , tmpInfoMoney AS (SELECT * FROM Object_InfoMoney_View)
          , tmpMovement AS (SELECT Movement.* 
                            FROM Movement 
                                JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate AND Movement.DescId = zc_Movement_SendDebtMember())
          , tmpMI AS (SELECT * FROM MovementItem WHERE MovementItem.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement))
          , tmpMILO AS (SELECT * FROM MovementItemLinkObject WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))
          , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI))
          
       SELECT
              Movement.Id
            , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
            , Movement.OperDate
            , Object_Status.ObjectCode   AS StatusCode
            , Object_Status.ValueData    AS StatusName

            , MovementFloat_TotalSumm.ValueData AS TotalSumm
            , MovementString_Comment.ValueData  AS Comment
                      
            , View_InfoMoney_From.InfoMoneyGroupName       AS InfoMoneyGroupFromName
            , View_InfoMoney_From.InfoMoneyDestinationName AS InfoMoneyDestinationFromName
            , View_InfoMoney_From.InfoMoneyId              AS InfoMoneyFromId
            , View_InfoMoney_From.InfoMoneyCode            AS InfoMoneyFromCode
            , View_InfoMoney_From.InfoMoneyName            AS InfoMoneyFromName
            , View_InfoMoney_From.InfoMoneyName_all        AS InfoMoneyFromName_all

            , Object_Member_From.Id                        AS MemberFromId
            , Object_Member_From.ObjectCode                AS MemberFromCode
            , Object_Member_From.ValueData                 AS MemberFromName
            , ObjectFromDesc.ItemName                      AS ItemFromName
            , Object_Car_From.Id                           AS CarFromId
            , Object_Car_From.ValueData                    AS CarFromName
            , Object_Branch_From.Id                        AS BranchFromId
            , Object_Branch_From.ValueData                 AS BranchFromName
            , Object_JuridicalBasis_From.Id                AS JuridicalBasisFromId
            , Object_JuridicalBasis_From.ValueData         AS JuridicalBasisFromName

            , View_InfoMoney_To.InfoMoneyGroupName         AS InfoMoneyGroupToName
            , View_InfoMoney_To.InfoMoneyDestinationName   AS InfoMoneyDestinationToName
            , View_InfoMoney_To.InfoMoneyId                AS InfoMoneyToId
            , View_InfoMoney_To.InfoMoneyCode              AS InfoMoneyToCode
            , View_InfoMoney_To.InfoMoneyName              AS InfoMoneyToName
            , View_InfoMoney_To.InfoMoneyName_all          AS InfoMoneyToName_all

            , Object_Member_To.Id                          AS MemberToId
            , Object_Member_To.ObjectCode                  AS MemberToCode
            , Object_Member_To.ValueData                   AS MemberToName
            , ObjectToDesc.ItemName                        AS ItemToName
            , Object_Car_To.Id                             AS CarToId
            , Object_Car_To.ValueData                      AS CarToName
            , Object_Branch_To.Id                          AS BranchToId
            , Object_Branch_To.ValueData                   AS BranchToName
            , Object_JuridicalBasis_To.Id                  AS JuridicalBasisToId
            , Object_JuridicalBasis_To.ValueData           AS JuridicalBasisToName

            , MI_Master.Amount                   :: TFloat AS Amount
           
       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN tmpMI AS MI_Master 
                            ON MI_Master.MovementId = Movement.Id
                           AND MI_Master.DescId     = zc_MI_Master()

            LEFT JOIN Object AS Object_Member_From ON Object_Member_From.Id = MI_Master.ObjectId
            LEFT JOIN ObjectDesc AS ObjectFromDesc ON ObjectFromDesc.Id = Object_Member_From.DescId

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

            LEFT JOIN tmpMI AS MI_Child 
                            ON MI_Child.MovementId = Movement.Id
                           AND MI_Child.DescId     = zc_MI_Child()
                                         
            LEFT JOIN Object AS Object_Member_To ON Object_Member_To.Id = MI_Child.ObjectId
            LEFT JOIN ObjectDesc AS ObjectToDesc ON ObjectToDesc.Id = Object_Member_To.DescId

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

      WHERE Movement.DescId = zc_Movement_SendDebtMember()
        AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.22         * add inIsErased
 27.10.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_SendDebtMember (inStartDate:= '01.10.2022', inEndDate:= '01.12.2022', inJuridicalBasisId:= 0, inIsErased:= false, inSession:= zfCalc_UserAdmin())