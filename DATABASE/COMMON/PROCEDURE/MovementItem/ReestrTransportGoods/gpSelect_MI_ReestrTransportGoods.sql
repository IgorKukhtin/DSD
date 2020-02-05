-- Function: gpSelect_MI_ReestrTransportGoods()

DROP FUNCTION IF EXISTS gpSelect_MI_ReestrTransportGoods(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ReestrTransportGoods(
    IN inMovementId         Integer   ,
    IN inIsErased           Boolean   , --
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE  (Id Integer, LineNum Integer
              , MemberId Integer, MemberCode Integer, MemberName TVarChar
              , InsertDate TDateTime
              , isErased Boolean
              , MovementId_TTN Integer, BarCode_TTN TVarChar
              , InvNumber_TTN TVarChar, OperDate_TTN TDateTime
              , StatusCode_TTN Integer, StatusName_TTN TVarChar
              , InvNumberMark TVarChar
              , TotalCountKg TFloat, TotalSumm TFloat
              , FromName TVarChar, ToName TVarChar
              , PaidKindName TVarChar
              , ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
              , JuridicalName_To TVarChar, OKPO_To TVarChar
              , MemberCode_driver Integer
              , MemberName_driver TVarChar
              , UnitName_driver TVarChar
              , PositionName_driver TVarChar
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
       WITH -- Member
        tmpMember AS (SELECT gpSelect.Id
                           , gpSelect.Code
                           , gpSelect.Name
                           , gpSelect.BranchName
                           , gpSelect.UnitCode
                           , gpSelect.UnitName
                           , gpSelect.PositionName
                      FROM gpSelect_Object_Member (inIsShowAll:= FALSE, inSession:= inSession) AS gpSelect
                     )
            -- строчная часть реестра
          , tmpMI AS (SELECT MovementItem.Id            AS MovementItemId
                           , MovementItem.ObjectId      AS MemberId
                           , MIDate_Insert.ValueData    AS InsertDate
                           , MovementFloat_MovementItemId.MovementId AS MovementId_TTN
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
           , Movement_TTN.Id                             AS MovementId_TTN
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_TTN.Id) AS BarCode_TTN
           , Movement_TTN.InvNumber                      AS InvNumber_TTN
           , Movement_TTN.OperDate                       AS OperDate_TTN
           , Object_Status.ObjectCode                     AS StatusCode_TTN
           , Object_Status.ValueData                      AS StatusName_TTN

           , MovementString_InvNumberMark.ValueData     AS InvNumberMark

           , MovementFloat_TotalCountKg.ValueData          AS TotalCountKg
           , MovementFloat_TotalSumm.ValueData             AS TotalSumm

           , Object_From.ValueData                     AS FromName
           , Object_To.ValueData                       AS ToName
           , Object_PaidKind.ValueData                 AS PaidKindName
           , View_Contract_InvNumber.ContractCode      AS ContractCode
           , View_Contract_InvNumber.InvNumber         AS ContractName
           , View_Contract_InvNumber.ContractTagName
           , Object_JuridicalTo.ValueData              AS JuridicalName_To
           , ObjectHistory_JuridicalDetails_View.OKPO  AS OKPO_To

           , tmpMember.Code         AS MemberCode_driver
           , tmpMember.Name         AS MemberName_driver
           , tmpMember.UnitName     AS UnitName_driver
           , tmpMember.PositionName AS PositionName_driver

           , Object_ReestrKind.ValueData       	       AS ReestrKindName

           , Object_Personal.ValueData                 AS PersonalName
           , Object_PersonalTrade.ValueData            AS PersonalTradeName
           , Object_UnitPersonal.ValueData             AS UnitName_Personal
           , Object_UnitPersonalTrade.ValueData        AS UnitName_PersonalTrade

       FROM tmpMI AS tmp
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmp.MemberId

            LEFT JOIN Movement AS Movement_TTN  ON Movement_TTN.Id = tmp.MovementId_TTN
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_TTN.StatusId

            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId = Movement_TTN.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()
            -- связь с док. продажа
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementChildId = Movement_TTN.Id 
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()

            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_TransportGoods.MovementId
                                               AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            ---

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_Sale.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId = Movement_Sale.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalTo.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_TTN.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement_TTN.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN tmpMember ON tmpMember.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                 ON ObjectLink_Partner_Personal.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Partner_Personal.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_UnitPersonal ON Object_UnitPersonal.Id = ObjectLink_Personal_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_To.Id
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
 01.02.20         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_ReestrTransportGoods (inMovementId:= 4353346, inIsErased:= True, inSession:= zfCalc_UserAdmin())
