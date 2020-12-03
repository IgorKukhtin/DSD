-- Function: gpSelect_MI_ReestrTransportGoodsUser()

DROP FUNCTION IF EXISTS gpSelect_MI_ReestrTransportGoodsUser(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ReestrTransportGoodsUser(
    IN inStartDate          TDateTime ,
    IN inEndDate            TDateTime ,
    IN inReestrKindId       Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE ( Id Integer, MovementId Integer, LineNum Integer
              , StatusCode Integer, StatusName TVarChar
              , OperDate TDateTime, InvNumber TVarChar
              , UpdateName TVarChar, UpdateDate TDateTime
              , Date_Insert TDateTime, MemberName_Insert TVarChar
              , Date_Log TDateTime, Date_PartnerIn TDateTime, Date_Buh TDateTime
              , Member_Log TVarChar, Member_PartnerInTo TVarChar, Member_Buh TVarChar
              , BarCode_TTN TVarChar, OperDate_TTN TDateTime, InvNumber_TTN TVarChar
              , InvNumberMark TVarChar, StatusCode_TTN Integer, StatusName_TTN TVarChar
              , TotalCountKg TFloat, TotalSumm TFloat
              , FromName TVarChar, ToName TVarChar
              , PaidKindName TVarChar
              , ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
              , JuridicalName_To TVarChar, OKPO_To TVarChar
              , MemberCode_driver Integer
              , MemberName_driver TVarChar
              , UnitName_driver TVarChar
              , PositionName_driver TVarChar
              , ReestrKindName      TVarChar
              , PersonalName            TVarChar
              , PersonalTradeName       TVarChar
              , UnitName_Personal       TVarChar
              , UnitName_PersonalTrade  TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCount Integer;

   DECLARE vbMemberId_user  Integer;
   DECLARE vbDateDescId     Integer;
   DECLARE vbMILinkObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


-- if vbUserId = 3263818 then return; end if;

     -- Определяется
     vbDateDescId := (SELECT CASE WHEN inReestrKindId = zc_Enum_ReestrKind_PartnerIn()   THEN zc_MIDate_PartnerIn()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeIn()    THEN zc_MIDate_RemakeIn()  
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeBuh()   THEN zc_MIDate_RemakeBuh()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Remake()      THEN zc_MIDate_Remake()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Econom()      THEN zc_MIDate_Econom()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Buh()         THEN zc_MIDate_Buh()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_TransferIn()  THEN zc_MIDate_TransferIn()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_TransferOut() THEN zc_MIDate_TransferOut()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_Log()         THEN zc_MIDate_Log()
                             END AS DateDescId
                      );
     -- Определяется
     vbMILinkObjectId := (SELECT CASE WHEN inReestrKindId = zc_Enum_ReestrKind_PartnerIn()   THEN zc_MILinkObject_PartnerInTo()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeIn()    THEN zc_MILinkObject_RemakeInTo()  
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeBuh()   THEN zc_MILinkObject_RemakeBuh()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Remake()      THEN zc_MILinkObject_Remake() 
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Econom()      THEN zc_MILinkObject_Econom()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Buh()         THEN zc_MILinkObject_Buh()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_TransferIn()  THEN zc_MILinkObject_TransferIn()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_TransferOut() THEN zc_MILinkObject_TransferOut()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_Log()         THEN zc_MILinkObject_Log()
                                 END AS MILinkObjectId
                      );

     -- Определяется <Физическое лицо> - кто сформировал визу inReestrKindId
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
     -- Проверка
     IF COALESCE (vbMemberId_user, 0) = 0
     THEN
          RAISE EXCEPTION 'Ошибка.У пользователя <%> не определно значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
     END IF;

if vbUserId <> 3263818 OR 1=1
then 


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
         -- строчная часть реестра - для Одного пользователя
       , tmpMI AS (SELECT MIDate.MovementItemId
                        , MovementFloat_MovementItemId.MovementId AS MovementId_TTN
                   FROM MovementItemDate AS MIDate
                        INNER JOIN MovementItemLinkObject AS MILinkObject_PartnerInTo
                                                          ON MILinkObject_PartnerInTo.MovementItemId = MIDate.MovementItemId
                                                         AND MILinkObject_PartnerInTo.DescId         = vbMILinkObjectId
                                                         AND MILinkObject_PartnerInTo.ObjectId       = vbMemberId_user
                                           
                        LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                ON MovementFloat_MovementItemId.ValueData = MIDate.MovementItemId
                                               AND MovementFloat_MovementItemId.DescId    = zc_MovementFloat_MovementItemId()
                   WHERE MIDate.DescId = vbDateDescId
                     AND MIDate.ValueData >= inStartDate AND MIDate.ValueData < inEndDate + INTERVAL '1 DAY'
                   )
       -- Результат
       SELECT MovementItem.Id
            , MovementItem.MovementId           AS MovementId
            , CAST (ROW_NUMBER() OVER (ORDER BY MovementItem.Id) AS Integer) AS LineNum
            , Object_Status.ObjectCode          AS StatusCode
            , Object_Status.ValueData           AS StatusName
            , Movement_Reestr.OperDate          AS OperDate
            , Movement_Reestr.InvNumber         AS InvNumber

            , Object_Update.ValueData           AS UpdateName
            , MovementDate_Update.ValueData     AS UpdateDate

            , MIDate_Insert.ValueData           AS Date_Insert
            , Object_Member.ValueData           AS MemberName_Insert

            , MIDate_Log.ValueData              AS Date_Log
            , MIDate_PartnerIn.ValueData        AS Date_PartnerIn
            , MIDate_Buh.ValueData              AS Date_Buh
            , Object_Log.ValueData              AS Member_Log
            , Object_PartnerInTo.ValueData      AS Member_PartnerInTo
            , Object_Buh.ValueData              AS Member_Buh

            , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_TTN.Id) AS BarCode_TTN
            , Movement_TTN.OperDate                AS OperDate_TTN
            , Movement_TTN.InvNumber               AS InvNumber_TTN
            , MovementString_InvNumberMark.ValueData AS InvNumberMark
            , Object_Status_TTN.ObjectCode         AS StatusCode_TTN
            , Object_Status_TTN.ValueData          AS StatusName_TTN

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

            , tmpMember.Code         AS MemberCode_driver
            , tmpMember.Name         AS MemberName_driver
            , tmpMember.UnitName     AS UnitName_driver
            , tmpMember.PositionName AS PositionName_driver

            , Object_ReestrKind.ValueData               AS ReestrKindName

            , Object_Personal.ValueData                 AS PersonalName
            , Object_PersonalTrade.ValueData            AS PersonalTradeName
            , Object_UnitPersonal.ValueData             AS UnitName_Personal
            , Object_UnitPersonalTrade.ValueData        AS UnitName_PersonalTrade

       FROM tmpMI
            LEFT JOIN MovementItem ON MovementItem.Id = tmpMI.MovementItemId

            INNER JOIN Movement AS Movement_Reestr
                    ON Movement_Reestr.Id = MovementItem.MovementId
                   AND Movement_Reestr.DescId = zc_Movement_ReestrTransportGoods()
                                           
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementItem.ObjectId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Reestr.StatusId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement_Reestr.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement_Reestr.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            --
            LEFT JOIN MovementItemDate AS MIDate_PartnerIn
                                       ON MIDate_PartnerIn.MovementItemId = MovementItem.Id
                                      AND MIDate_PartnerIn.DescId = zc_MIDate_PartnerIn()
            LEFT JOIN MovementItemDate AS MIDate_Buh
                                       ON MIDate_Buh.MovementItemId = MovementItem.Id
                                      AND MIDate_Buh.DescId = zc_MIDate_Buh()
            LEFT JOIN MovementItemDate AS MIDate_Log
                                       ON MIDate_Log.MovementItemId = MovementItem.Id
                                      AND MIDate_Log.DescId = zc_MIDate_Log()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartnerInTo
                                             ON MILinkObject_PartnerInTo.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartnerInTo.DescId = zc_MILinkObject_PartnerInTo()
            LEFT JOIN Object AS Object_PartnerInTo ON Object_PartnerInTo.Id = MILinkObject_PartnerInTo.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Buh
                                             ON MILinkObject_Buh.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Log
                                             ON MILinkObject_Log.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Log.DescId = zc_MILinkObject_Log()
            LEFT JOIN Object AS Object_Log ON Object_Log.Id = MILinkObject_Log.ObjectId
            --
            LEFT JOIN Movement AS Movement_TTN ON Movement_TTN.Id = tmpMI.MovementId_TTN  -- док. возврата
            LEFT JOIN Object AS Object_Status_TTN ON Object_Status_TTN.Id = Movement_TTN.StatusId

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

ELSE


     -- Результат
     vbCount:= COALESCE ((SELECT COUNT(*)
                          FROM MovementItemDate AS MIDate
                               INNER JOIN MovementItemLinkObject AS MILinkObject_PartnerInTo
                                                                 ON MILinkObject_PartnerInTo.MovementItemId = MIDate.MovementItemId
                                                                AND MILinkObject_PartnerInTo.DescId         = vbMILinkObjectId
                                                                AND MILinkObject_PartnerInTo.ObjectId       = vbMemberId_user
                                                  
                               LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                       ON MovementFloat_MovementItemId.ValueData = MIDate.MovementItemId
                                                      AND MovementFloat_MovementItemId.DescId    = zc_MovementFloat_MovementItemId()
                          WHERE MIDate.DescId = vbDateDescId
                            AND MIDate.ValueData >= inStartDate AND MIDate.ValueData < inEndDate + INTERVAL '1 DAY'
                         ) - 1, 1);
     --
     IF vbCount <=0 THEN vbCount:= 1; END IF;

   CREATE TEMP TABLE _tmpRes ON COMMIT DROP AS (
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
         -- строчная часть реестра - для Одного пользователя
       , tmpMI AS (SELECT MIDate.MovementItemId
                        , MovementFloat_MovementItemId.MovementId AS MovementId_TTN
                   FROM MovementItemDate AS MIDate
                        INNER JOIN MovementItemLinkObject AS MILinkObject_PartnerInTo
                                                          ON MILinkObject_PartnerInTo.MovementItemId = MIDate.MovementItemId
                                                         AND MILinkObject_PartnerInTo.DescId         = vbMILinkObjectId
                                                         AND MILinkObject_PartnerInTo.ObjectId       = vbMemberId_user
                                           
                        LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                ON MovementFloat_MovementItemId.ValueData = MIDate.MovementItemId
                                               AND MovementFloat_MovementItemId.DescId    = zc_MovementFloat_MovementItemId()
                   WHERE MIDate.DescId = vbDateDescId
                     AND MIDate.ValueData >= inStartDate AND MIDate.ValueData < inEndDate + INTERVAL '1 DAY'
                   )
       -- Результат
, tmpRes_all AS
    (  SELECT MovementItem.Id
            , MovementItem.MovementId           AS MovementId
            , CAST (ROW_NUMBER() OVER (ORDER BY MovementItem.Id) AS Integer) AS LineNum
            , Object_Status.ObjectCode          AS StatusCode
            , Object_Status.ValueData           AS StatusName
            , Movement_Reestr.OperDate          AS OperDate
            , Movement_Reestr.InvNumber         AS InvNumber

            , Object_Update.ValueData           AS UpdateName
            , MovementDate_Update.ValueData     AS UpdateDate

            , MIDate_Insert.ValueData           AS Date_Insert
            , Object_Member.ValueData           AS MemberName_Insert

            , MIDate_Log.ValueData              AS Date_Log
            , MIDate_PartnerIn.ValueData        AS Date_PartnerIn
            , MIDate_Buh.ValueData              AS Date_Buh
            , Object_Log.ValueData              AS Member_Log
            , Object_PartnerInTo.ValueData      AS Member_PartnerInTo
            , Object_Buh.ValueData              AS Member_Buh

            , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_TTN.Id) AS BarCode_TTN
            , Movement_TTN.OperDate                AS OperDate_TTN
            , Movement_TTN.InvNumber               AS InvNumber_TTN
            , MovementString_InvNumberMark.ValueData AS InvNumberMark
            , Object_Status_TTN.ObjectCode         AS StatusCode_TTN
            , Object_Status_TTN.ValueData          AS StatusName_TTN

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

            , tmpMember.Code         AS MemberCode_driver
            , tmpMember.Name         AS MemberName_driver
            , tmpMember.UnitName     AS UnitName_driver
            , tmpMember.PositionName AS PositionName_driver

            , Object_ReestrKind.ValueData               AS ReestrKindName

            , Object_Personal.ValueData                 AS PersonalName
            , Object_PersonalTrade.ValueData            AS PersonalTradeName
            , Object_UnitPersonal.ValueData             AS UnitName_Personal
            , Object_UnitPersonalTrade.ValueData        AS UnitName_PersonalTrade

       FROM tmpMI
            LEFT JOIN MovementItem ON MovementItem.Id = tmpMI.MovementItemId

            INNER JOIN Movement AS Movement_Reestr
                    ON Movement_Reestr.Id = MovementItem.MovementId
                   AND Movement_Reestr.DescId = zc_Movement_ReestrTransportGoods()
                                           
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementItem.ObjectId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Reestr.StatusId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement_Reestr.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement_Reestr.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            --
            LEFT JOIN MovementItemDate AS MIDate_PartnerIn
                                       ON MIDate_PartnerIn.MovementItemId = MovementItem.Id
                                      AND MIDate_PartnerIn.DescId = zc_MIDate_PartnerIn()
            LEFT JOIN MovementItemDate AS MIDate_Buh
                                       ON MIDate_Buh.MovementItemId = MovementItem.Id
                                      AND MIDate_Buh.DescId = zc_MIDate_Buh()
            LEFT JOIN MovementItemDate AS MIDate_Log
                                       ON MIDate_Log.MovementItemId = MovementItem.Id
                                      AND MIDate_Log.DescId = zc_MIDate_Log()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartnerInTo
                                             ON MILinkObject_PartnerInTo.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartnerInTo.DescId = zc_MILinkObject_PartnerInTo()
            LEFT JOIN Object AS Object_PartnerInTo ON Object_PartnerInTo.Id = MILinkObject_PartnerInTo.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Buh
                                             ON MILinkObject_Buh.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Log
                                             ON MILinkObject_Log.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Log.DescId = zc_MILinkObject_Log()
            LEFT JOIN Object AS Object_Log ON Object_Log.Id = MILinkObject_Log.ObjectId
            --
            LEFT JOIN Movement AS Movement_TTN ON Movement_TTN.Id = tmpMI.MovementId_TTN  -- док. возврата
            LEFT JOIN Object AS Object_Status_TTN ON Object_Status_TTN.Id = Movement_TTN.StatusId

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
      -- WHERE vbUserId <> 3263818
      )
--    , tmpRes1 AS (SELECT * FROM tmpRes_all ORDER BY tmpRes_all.Id ASC  LIMIT vbCount)
--    , tmpRes2 AS (SELECT * FROM tmpRes_all ORDER BY tmpRes_all.Id DESC LIMIT 1)
     -- Результат
--     SELECT * FROM tmpRes1
--    UNION ALL
--     SELECT * FROM tmpRes2
     SELECT * FROM tmpRes_all
     )
    ;

    -- RAISE EXCEPTION 'Ошибка.<%>', (select count(*) from _tmpRes);

     -- Результат
     RETURN QUERY
     SELECT * FROM _tmpRes ORDER BY _tmpRes.Id DESC LIMIT vbCount;

 END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.20         * log
 01.02.20         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_ReestrTransportGoodsUser (inStartDate:= '24.10.2016', inEndDate:= '24.10.2016', inReestrKindId:= 736914,  inSession := '5');
