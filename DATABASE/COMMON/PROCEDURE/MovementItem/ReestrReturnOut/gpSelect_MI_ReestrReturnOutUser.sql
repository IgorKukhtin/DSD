-- Function: gpSelect_MI_ReestrReturnOutUser()

DROP FUNCTION IF EXISTS gpSelect_MI_ReestrReturnOutUser(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ReestrReturnOutUser(
    IN inStartDate          TDateTime , 
    IN inEndDate            TDateTime , 
    IN inReestrKindId       Integer   ,
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE ( Id Integer, MovementId Integer, LineNum Integer
              , StatusCode Integer, StatusName TVarChar
              , OperDate TDateTime, InvNumber TVarChar
              , UpdateName TVarChar, UpdateDate TDateTime

              , Date_Insert TDateTime, MemberName_Insert TVarChar
              , Date_Snab TDateTime, Date_SnabRe TDateTime
              , Date_Remake TDateTime, Date_Econom TDateTime, Date_Buh TDateTime, Date_EconomIn TDateTime, Date_EconomOut TDateTime
              , Member_Snab TVarChar, Member_SnabRe TVarChar, Member_Remake TVarChar
              , Member_Econom TVarChar, Member_Buh TVarChar, Member_EconomIn TVarChar, Member_EconomOut TVarChar

              , BarCode_ReturnOut TVarChar, OperDate_ReturnOut TDateTime, InvNumber_ReturnOut TVarChar
              , OperDatePartner TDateTime, InvNumberPartner TVarChar, StatusCode_ReturnOut Integer, StatusName_ReturnOut TVarChar
              , TotalCountKg TFloat, TotalSumm TFloat
              , FromName TVarChar, ToName TVarChar
              , PaidKindName TVarChar
              , ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
              , JuridicalName_To TVarChar, OKPO_To TVarChar 
              , ReestrKindName TVarChar

              , PersonalName            TVarChar
              , PersonalTradeName       TVarChar
              , UnitName_Personal       TVarChar
              , UnitName_PersonalTrade  TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMemberId_user  Integer;
   DECLARE vbDateDescId     Integer;
   DECLARE vbMILinkObjectId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ������������
     vbDateDescId := (SELECT CASE WHEN inReestrKindId = zc_Enum_ReestrKind_Snab()      THEN zc_MIDate_Snab()  
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_SnabRe()    THEN zc_MIDate_SnabRe()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Remake()    THEN zc_MIDate_Remake()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Econom()    THEN zc_MIDate_Econom()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Buh()       THEN zc_MIDate_Buh()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_EconomIn()  THEN zc_MIDate_EconomIn()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_EconomOut() THEN zc_MIDate_EconomOut()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_PartnerIn()   THEN zc_MIDate_PartnerIn()
                             END AS DateDescId
                      );
     -- ������������
     vbMILinkObjectId := (SELECT CASE WHEN inReestrKindId = zc_Enum_ReestrKind_Snab()      THEN zc_MILinkObject_Snab()  
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_SnabRe()    THEN zc_MILinkObject_SnabRe()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Remake()    THEN zc_MILinkObject_Remake() 
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Econom()    THEN zc_MILinkObject_Econom()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Buh()       THEN zc_MILinkObject_Buh()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_EconomIn()  THEN zc_MILinkObject_EconomIn()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_EconomOut() THEN zc_MILinkObject_EconomOut()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_PartnerIn()   THEN zc_MILinkObject_PartnerInTo()
                                 END AS MILinkObjectId
                      );

     -- ������������ <���������� ����> - ��� ����������� ���� inReestrKindId
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
     -- ��������
     IF COALESCE (vbMemberId_user, 0) = 0
     THEN 
          RAISE EXCEPTION '������.� ������������ <%> �� ��������� �������� <���.����>.', lfGet_Object_ValueData (vbUserId);
     END IF;


     -- ���������
     RETURN QUERY
     WITH
         -- �������� ����� ������� - ��� ������ ������������
         tmpMI AS (SELECT MIDate.MovementItemId 
                        , MovementFloat_MovementItemId.MovementId AS MovementId_ReturnOut
                   FROM MovementItemDate AS MIDate
                        INNER JOIN MovementItemLinkObject AS MILinkObject_PartnerIn
                                                          ON MILinkObject_PartnerIn.MovementItemId = MIDate.MovementItemId
                                                         AND MILinkObject_PartnerIn.DescId         = vbMILinkObjectId 
                                                         AND MILinkObject_PartnerIn.ObjectId       = vbMemberId_user 
                        LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                ON MovementFloat_MovementItemId.ValueData = MIDate.MovementItemId  
                                               AND MovementFloat_MovementItemId.DescId    = zc_MovementFloat_MovementItemId()
                   WHERE MIDate.DescId = vbDateDescId 
                     AND MIDate.ValueData >= inStartDate AND MIDate.ValueData < inEndDate + INTERVAL '1 DAY'
                   )
       -- ���������
       SELECT MovementItem.Id
            , MovementItem.MovementId           AS MovementId
            , CAST (ROW_NUMBER() OVER (ORDER BY MovementItem.Id) AS Integer) AS LineNum
            , Object_Status.ObjectCode          AS StatusCode
            , Object_Status.ValueData           AS StatusName
            , Movement_ReestrReturnOut.OperDate            AS OperDate
            , Movement_ReestrReturnOut.InvNumber           AS InvNumber

            , Object_Update.ValueData                   AS UpdateName
            , MovementDate_Update.ValueData             AS UpdateDate

            , MIDate_Insert.ValueData                   AS Date_Insert
            , Object_Member.ValueData                   AS MemberName_Insert

            , MIDate_Snab.ValueData                     AS Date_Snab
            , MIDate_SnabRe.ValueData                   AS Date_SnabRe
            , MIDate_Remake.ValueData                   AS Date_Remake
            , MIDate_Econom.ValueData                   AS Date_Econom
            , MIDate_Buh.ValueData                      AS Date_Buh
            , MIDate_EconomIn.ValueData                 AS Date_EconomIn
            , MIDate_EconomOut.ValueData                AS Date_EconomOut
            
            , Object_Snab.ValueData                   AS Member_Snab
            , Object_SnabRe.ValueData                 AS Member_SnabRe
            , Object_Remake.ValueData                 AS Member_Remake
            , Object_Econom.ValueData                 AS Member_Econom
            , Object_Buh.ValueData                    AS Member_Buh
            , Object_EconomIn.ValueData               AS Member_EconomIn
            , Object_EconomOut.ValueData              AS Member_EconomOut

            , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_ReturnOut.Id) AS BarCode_ReturnOut
            , Movement_ReturnOut.OperDate                    AS OperDate_ReturnOut
            , Movement_ReturnOut.InvNumber                   AS InvNumber_ReturnOut
            , MovementDate_OperDatePartner.ValueData      AS OperDatePartner
            , MovementString_InvNumberPartner.ValueData   AS InvNumberPartner
            , Object_Status_ReturnOut.ObjectCode             AS StatusCode_ReturnOut
            , Object_Status_ReturnOut.ValueData              AS StatusName_ReturnOut
    
            , MovementFloat_TotalCountKg.ValueData      AS TotalCountKg
            , MovementFloat_TotalSumm.ValueData         AS TotalSumm

            , Object_From.ValueData                     AS FromName
            , Object_To.ValueData                       AS ToName   
            , Object_PaidKind.ValueData                 AS PaidKindName
            , View_Contract_InvNumber.ContractCode      AS ContractCode
            , View_Contract_InvNumber.InvNumber         AS ContractName
            , View_Contract_InvNumber.ContractTagName
            , Object_JuridicalTo.ValueData              AS JuridicalName_To
            , ObjectHistory_JuridicalDetails_View.OKPO  AS OKPO_To

            , Object_ReestrKind.ValueData               AS ReestrKindName    

            , Object_Personal.ValueData                 AS PersonalName
            , Object_PersonalTrade.ValueData            AS PersonalTradeName
            , Object_UnitPersonal.ValueData             AS UnitName_Personal
            , Object_UnitPersonalTrade.ValueData        AS UnitName_PersonalTrade

       FROM tmpMI
            LEFT JOIN MovementItem ON MovementItem.Id = tmpMI.MovementItemId
            INNER JOIN Movement AS Movement_ReestrReturnOut
                                ON Movement_ReestrReturnOut.Id = MovementItem.MovementId
                               AND Movement_ReestrReturnOut.DescId = zc_Movement_ReestrReturnOut()
            
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementItem.ObjectId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_ReestrReturnOut.StatusId
            
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement_ReestrReturnOut.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement_ReestrReturnOut.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId  

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            --
            LEFT JOIN MovementItemDate AS MIDate_Snab
                                       ON MIDate_Snab.MovementItemId = MovementItem.Id
                                      AND MIDate_Snab.DescId = zc_MIDate_Snab()
            LEFT JOIN MovementItemDate AS MIDate_SnabRe
                                       ON MIDate_SnabRe.MovementItemId = MovementItem.Id
                                      AND MIDate_SnabRe.DescId = zc_MIDate_SnabRe()

            LEFT JOIN MovementItemDate AS MIDate_Remake
                                       ON MIDate_Remake.MovementItemId = MovementItem.Id
                                      AND MIDate_Remake.DescId = zc_MIDate_Remake()
            LEFT JOIN MovementItemDate AS MIDate_Econom
                                       ON MIDate_Econom.MovementItemId = MovementItem.Id
                                      AND MIDate_Econom.DescId = zc_MIDate_Econom()                                      
            LEFT JOIN MovementItemDate AS MIDate_Buh
                                       ON MIDate_Buh.MovementItemId = MovementItem.Id
                                      AND MIDate_Buh.DescId = zc_MIDate_Buh()

            LEFT JOIN MovementItemDate AS MIDate_EconomIn
                                       ON MIDate_EconomIn.MovementItemId = MovementItem.Id
                                      AND MIDate_EconomIn.DescId = zc_MIDate_EconomIn()
            LEFT JOIN MovementItemDate AS MIDate_EconomOut
                                       ON MIDate_EconomOut.MovementItemId = MovementItem.Id
                                      AND MIDate_EconomOut.DescId = zc_MIDate_EconomOut()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_EconomIn
                                             ON MILinkObject_EconomIn.MovementItemId = MovementItem.Id
                                            AND MILinkObject_EconomIn.DescId = zc_MILinkObject_EconomIn()
            LEFT JOIN Object AS Object_EconomIn ON Object_EconomIn.Id = MILinkObject_EconomIn.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_EconomOut
                                             ON MILinkObject_EconomOut.MovementItemId = MovementItem.Id
                                            AND MILinkObject_EconomOut.DescId = zc_MILinkObject_EconomOut()
            LEFT JOIN Object AS Object_EconomOut ON Object_EconomOut.Id = MILinkObject_EconomOut.ObjectId     

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Snab
                                             ON MILinkObject_Snab.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Snab.DescId = zc_MILinkObject_Snab()
            LEFT JOIN Object AS Object_Snab ON Object_Snab.Id = MILinkObject_Snab.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_SnabRe
                                             ON MILinkObject_SnabRe.MovementItemId = MovementItem.Id
                                            AND MILinkObject_SnabRe.DescId = zc_MILinkObject_SnabRe()
            LEFT JOIN Object AS Object_SnabRe ON Object_SnabRe.Id = MILinkObject_SnabRe.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Remake
                                             ON MILinkObject_Remake.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Remake.DescId = zc_MILinkObject_Remake()
            LEFT JOIN Object AS Object_Remake ON Object_Remake.Id = MILinkObject_Remake.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Econom
                                             ON MILinkObject_Econom.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Econom.DescId = zc_MILinkObject_Econom()
            LEFT JOIN Object AS Object_Econom ON Object_Econom.Id = MILinkObject_Econom.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Buh
                                             ON MILinkObject_Buh.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId

            --
            LEFT JOIN Movement AS Movement_ReturnOut ON Movement_ReturnOut.id = tmpMI.MovementId_ReturnOut  -- ���. �������
            LEFT JOIN Object AS Object_Status_ReturnOut ON Object_Status_ReturnOut.Id = Movement_ReturnOut.StatusId
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_ReturnOut.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_ReturnOut.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_ReturnOut.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId = Movement_ReturnOut.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalTo.Id
           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_ReturnOut.Id
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.21         *
*/

-- ����
-- SELECT * FROM gpSelect_MI_ReestrReturnOutUser (inStartDate:= '24.10.2016', inEndDate:= '24.10.2016', inReestrKindId:= 736914,  inSession := '5');
