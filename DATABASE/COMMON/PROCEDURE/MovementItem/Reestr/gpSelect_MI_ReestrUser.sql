-- Function: gpSelect_MI_ReestrUser()

DROP FUNCTION IF EXISTS gpSelect_MI_ReestrUser(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ReestrUser(
    IN inStartDate          TDateTime , 
    IN inEndDate            TDateTime , 
    IN inReestrKindId       Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE ( Id Integer, LineNum Integer
              , StatusCode Integer, StatusName TVarChar
              , OperDate TDateTime, InvNumber TVarChar
              , CarName TVarChar
              , PersonalDriverName TVarChar
              , MemberName TVarChar
              , UpdateName TVarChar, UpdateDate TDateTime

              , InvNumber_Transport TVarChar, OperDate_Transport TDateTime
              , Date_Insert TDateTime, MemberName_Insert TVarChar
              
              , BarCode_Sale Integer, OperDate_Sale TDateTime, InvNumber_Sale TVarChar
              
              , OperDatePartner TDateTime, InvNumberPartner TVarChar
              , TotalSumm TFloat
             
              , FromName TVarChar, ToName TVarChar
            
              , ReestrKindName TVarChar

              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDateDescId Integer;
   DECLARE vbMILinkObjectId Integer;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     vbDateDescId := (SELECT CASE WHEN inReestrKindId = zc_Enum_ReestrKind_PartnerIn() THEN zc_MIDate_PartnerIn()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeIn()  THEN zc_MIDate_RemakeIn()  
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeBuh() THEN zc_MIDate_RemakeBuh()
                                  WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeBuh() THEN zc_MIDate_RemakeBuh() 
                             END AS DateDescId
                      );
     vbMILinkObjectId := (SELECT CASE WHEN inReestrKindId = zc_Enum_ReestrKind_PartnerIn() THEN zc_MILinkObject_PartnerInTo()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeIn()  THEN zc_MILinkObject_RemakeInTo()  
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeBuh() THEN zc_MILinkObject_RemakeBuh()
                                      WHEN inReestrKindId = zc_Enum_ReestrKind_RemakeBuh() THEN zc_MILinkObject_RemakeBuh() 
                                 END AS MILinkObjectId
                      );
     -- Результат
     RETURN QUERY
     WITH
         tmpMI AS (SELECT MIDate.MovementItemId 
                        , MovementFloat_MovementItemId.MovementId AS MovementId_Sale
                   FROM MovementItemDate AS MIDate
                        INNER JOIN MovementItemLinkObject AS MILinkObject_PartnerIn
                                ON MILinkObject_PartnerIn.MovementItemId = MIDate.MovementItemId
                               AND MILinkObject_PartnerIn.DescId = vbMILinkObjectId --zc_MILinkObject_PartnerInTo()
                        LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                ON MovementFloat_MovementItemId.ValueData ::integer = MIDate.MovementItemId  -- tmpMI.MovementItemId
                                               AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                   WHERE MIDate.DescId = vbDateDescId --zc_MIDate_Insert() --zc_MIDate_PartnerIn()
                     AND date_trunc('day', MIDate.ValueData) BETWEEN inStartDate AND inEndDate
                   )

       SELECT MovementItem.Id
            , CAST (ROW_NUMBER() OVER (ORDER BY MovementItem.Id) AS Integer) AS LineNum
            , Object_Status.ObjectCode          AS StatusCode
            , Object_Status.ValueData           AS StatusName
            , Movement_Reestr.OperDate                  AS OperDate
            , Movement_Reestr.InvNumber                 AS InvNumber
            , Object_Reestr_Car.ValueData               AS CarName
            , Object_Reestr_Personal.ValueData          AS PersonalDriverName
            , Object_Reestr_Member.ValueData            AS MemberName

            , Object_Update.ValueData           AS UpdateName
            , MovementDate_Update.ValueData     AS UpdateDate

            , Movement_Reestr_Transport.InvNumber      AS InvNumber_Transport
            , Movement_Reestr_Transport.OperDate       AS OperDate_Transport
  
            , MIDate_Insert.ValueData                   AS Date_Insert
            , Object_Member.ValueData                   AS MemberName_Insert

            , Movement_Sale.Id                          AS BarCode_Sale
            , Movement_Sale.OperDate                    AS OperDate_Sale
            , Movement_Sale.InvNumber                   AS InvNumber_Sale
            , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
            , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

            , MovementFloat_TotalSumm.ValueData         AS TotalSumm

            , Object_From.ValueData                     AS FromName
            , Object_To.ValueData                       AS ToName   

            , Object_ReestrKind.ValueData               AS ReestrKindName      

       FROM tmpMI
            LEFT JOIN MovementItem ON MovementItem.Id = tmpMI.MovementItemId
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementItem.ObjectId
            LEFT JOIN Movement AS Movement_Reestr ON Movement_Reestr.Id = MovementItem.MovementId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Reestr.StatusId
            
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement_Reestr.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement_Reestr.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId  

            LEFT JOIN MovementLinkMovement AS MLM_Reestr_Transpor
                                           ON MLM_Reestr_Transpor.MovementId = Movement_Reestr.Id
                                          AND MLM_Reestr_Transpor.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Reestr_Transport ON Movement_Reestr_Transport.Id = MLM_Reestr_Transpor.MovementChildId

            LEFT JOIN MovementLinkObject AS MLO_Reestr_Car
                                         ON MLO_Reestr_Car.MovementId = Movement_Reestr.Id
                                        AND MLO_Reestr_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Reestr_Car ON Object_Reestr_Car.Id = MLO_Reestr_Car.ObjectId

            LEFT JOIN MovementLinkObject AS MLO_Reestr_PersonalDriver
                                         ON MLO_Reestr_PersonalDriver.MovementId = Movement_Reestr.Id
                                        AND MLO_Reestr_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_Reestr_Personal ON Object_Reestr_Personal.Id = MLO_Reestr_PersonalDriver.ObjectId
            --LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN MovementLinkObject AS MLO_Reestr_Member
                                         ON MLO_Reestr_Member.MovementId = Movement_Reestr.Id
                                        AND MLO_Reestr_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Reestr_Member ON Object_Reestr_Member.Id = MLO_Reestr_Member.ObjectId


            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            --
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.id = tmpMI.MovementId_Sale  -- док. продажи
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_Sale.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_Sale.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_Sale.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId
  
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.10.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_ReestrUser (inMovementId:= 4353346, inIsErased:= True, inSession:= zfCalc_UserAdmin())
--select * from gpSelect_MI_ReestrUser(instartdate := ('24.10.2016')::TDateTime , inenddate := ('24.10.2016')::TDateTime , inReestrKindId := 736914 ,  inSession := '5');