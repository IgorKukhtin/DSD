-- Function: gpSelect_MI_ReestrIncome()

DROP FUNCTION IF EXISTS gpSelect_MI_ReestrIncome(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ReestrIncome(
    IN inMovementId         Integer   ,
    IN inIsErased           Boolean   , --
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE  (Id Integer, LineNum Integer, MemberId Integer, MemberCode Integer, MemberName TVarChar, InsertDate TDateTime, isErased Boolean
              , MovementId_Income Integer, BarCode_Income TVarChar, InvNumber_Income TVarChar, OperDate_Income TDateTime, StatusCode_Income Integer, StatusName_Income TVarChar
              , Checked Boolean

              , OperDatePartner TDateTime, InvNumberPartner TVarChar
              , TotalCountPartner TFloat, TotalSumm TFloat

              , FromName TVarChar, ToName TVarChar
              , PaidKindName TVarChar
              , ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
              , JuridicalName_from TVarChar, OKPO_To TVarChar 
              , ReestrKindName TVarChar
              , PersonalName            TVarChar
              , PersonalTradeName       TVarChar
              , UnitName_Personal       TVarChar
              , UnitName_PersonalTrade  TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH -- строчная часть реестра
            tmpMI AS (SELECT MovementItem.Id            AS MovementItemId
                           , MovementItem.ObjectId      AS MemberId
                           , MIDate_Insert.ValueData    AS InsertDate
                           , MovementFloat_MovementItemId.MovementId AS MovementId_Income
                           , MovementItem.isErased      AS isErased
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemDate AS MIDate_Insert
                                                      ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                     AND MIDate_Insert.DescId = zc_MIDate_Insert()
                           LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                   ON MovementFloat_MovementItemId.ValueData = MovementItem.Id
                                                  AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                      )
       -- Результат
     SELECT  tmp.MovementItemId                           AS Id
           , CAST (ROW_NUMBER() OVER (ORDER BY tmp.MovementItemId) AS Integer) AS LineNum
           , tmp.MemberId                                 AS MemberId
           , Object_Member.ObjectCode                     AS MemberCode
           , Object_Member.ValueData                      AS MemberName
           , tmp.InsertDate                               AS InsertDate
           , tmp.isErased                                 AS isErased
           , Movement_Income.Id                           AS MovementId_Income
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_Income.Id) AS BarCode_Income
           , Movement_Income.InvNumber                    AS InvNumber_Income
           , Movement_Income.OperDate                     AS OperDate_Income
           , Object_Status.ObjectCode                     AS StatusCode_Income
           , Object_Status.ValueData                      AS StatusName_Income

           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) AS Checked

           , MovementDate_OperDatePartner.ValueData        AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData     AS InvNumberPartner

           , MovementFloat_TotalCountPartner.ValueData     AS TotalCountPartner
           , MovementFloat_TotalSumm.ValueData             AS TotalSumm

           , Object_From.ValueData                     AS FromName
           , Object_To.ValueData                       AS ToName
           , Object_PaidKind.ValueData                 AS PaidKindName
           , View_Contract_InvNumber.ContractCode      AS ContractCode
           , View_Contract_InvNumber.InvNumber         AS ContractName
           , View_Contract_InvNumber.ContractTagName
           , Object_JuridicalFrom.ValueData            AS JuridicalName_from
           , ObjectHistory_JuridicalDetails_View.OKPO  AS OKPO_To

           , Object_ReestrKind.ValueData       	       AS ReestrKindName

           , Object_Personal.ValueData                 AS PersonalName
           , Object_PersonalTrade.ValueData            AS PersonalTradeName
           , Object_UnitPersonal.ValueData             AS UnitName_Personal
           , Object_UnitPersonalTrade.ValueData        AS UnitName_PersonalTrade

       FROM tmpMI AS tmp
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmp.MemberId

            LEFT JOIN Movement AS Movement_Income  ON Movement_Income.Id = tmp.MovementId_Income
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Income.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement_Income.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_Income.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_Income.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId = Movement_Income.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalFrom.Id
           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                 ON ObjectLink_Partner_Personal.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Partner_Personal.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_UnitPersonal ON Object_UnitPersonal.Id = ObjectLink_Personal_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = ObjectLink_Partner_PersonalTrade.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                                 ON ObjectLink_PersonalTrade_Unit.ObjectId = Object_PersonalTrade.Id
                                AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_UnitPersonalTrade ON Object_UnitPersonalTrade.Id = ObjectLink_PersonalTrade_Unit.ChildObjectId
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.12.20         *
 31.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_ReestrIncome (inMovementId:= 4353346, inIsErased:= True, inSession:= zfCalc_UserAdmin())
