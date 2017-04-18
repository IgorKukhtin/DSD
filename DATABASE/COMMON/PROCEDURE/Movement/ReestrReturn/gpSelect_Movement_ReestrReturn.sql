-- Function: gpSelect_Movement_ReestrReturn()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReestrReturn (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReestrReturn(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InsertName TVarChar, InsertDate TDateTime, UpdateDate TDateTime
            
             , ReestrKindId Integer, ReestrKindName TVarChar
             , InvNumber_ReturnIn TVarChar, OperDate_ReturnIn TDateTime
             , StatusCode_ReturnIn Integer, StatusName_ReturnIn TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , FromName TVarChar, ToName TVarChar
             , TotalCountKg  TFloat, TotalSumm TFloat
             , PaidKindName TVarChar
             , ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , JuridicalName_To TVarChar, OKPO_To TVarChar 

             , Date_Insert    TDateTime
             , Date_RemakeBuh TDateTime
             , Date_Buh       TDateTime

             , Member_Insert        TVarChar
             , Member_RemakeBuh     TVarChar
             , Member_Buh           TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Reestr());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , Object_Insert.ValueData           AS InsertName
           , MovementDate_Insert.ValueData     AS InsertDate
           , MovementDate_Update.ValueData     AS UpdateDate

           , Object_ReestrKind.Id                AS ReestrKindId
           , Object_ReestrKind.ValueData         AS ReestrKindName
           , Movement_ReturnIn.InvNumber         AS InvNumber_ReturnIn
           , Movement_ReturnIn.OperDate          AS OperDate_ReturnIn
           , Object_Status_ReturnIn.ObjectCode   AS StatusCode_ReturnIn
           , Object_Status_ReturnIn.ValueData    AS StatusName_ReturnIn

           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

           , Object_From.ValueData                     AS FromName
           , Object_To.ValueData                       AS ToName
           , MovementFloat_TotalCountKg.ValueData      AS TotalCountKg
           , MovementFloat_TotalSumm.ValueData         AS TotalSumm
           , Object_PaidKind.ValueData                 AS PaidKindName
           , View_Contract_InvNumber.ContractCode      AS ContractCode
           , View_Contract_InvNumber.InvNumber         AS ContractName
           , View_Contract_InvNumber.ContractTagName
           , Object_JuridicalTo.ValueData              AS JuridicalName_To
           , ObjectHistory_JuridicalDetails_View.OKPO  AS OKPO_To

           , MIDate_Insert.ValueData         AS Date_Insert
           , MIDate_RemakeBuh.ValueData      AS Date_RemakeBuh
           , MIDate_Buh.ValueData            AS Date_Buh

           , CASE WHEN MIDate_Insert.DescId IS NOT NULL THEN Object_ObjectMember.ValueData ELSE '' END :: TVarChar AS Member_Insert -- т.к. в "пустышках" - "криво" формируется это свойство
           , Object_RemakeBuh.ValueData      AS Member_RemakeBuh
           , Object_Buh.ValueData            AS Member_Buh

       FROM (SELECT Movement.Id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_ReestrReturn() AND Movement.StatusId = tmpStatus.StatusId
             ) AS tmpMovement

            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

            -- строчная часть реестра
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.isErased = False
            LEFT JOIN Object AS Object_ObjectMember ON Object_ObjectMember.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = MovementItem.Id
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_RemakeBuh
                                       ON MIDate_RemakeBuh.MovementItemId = MovementItem.Id
                                      AND MIDate_RemakeBuh.DescId = zc_MIDate_RemakeBuh()
            LEFT JOIN MovementItemDate AS MIDate_Buh
                                       ON MIDate_Buh.MovementItemId = MovementItem.Id
                                      AND MIDate_Buh.DescId = zc_MIDate_Buh()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_RemakeBuh
                                             ON MILinkObject_RemakeBuh.MovementItemId = MovementItem.Id
                                            AND MILinkObject_RemakeBuh.DescId = zc_MILinkObject_RemakeBuh()
            LEFT JOIN Object AS Object_RemakeBuh ON Object_RemakeBuh.Id = MILinkObject_RemakeBuh.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Buh
                                             ON MILinkObject_Buh.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Buh.DescId = zc_MILinkObject_Buh()
            LEFT JOIN Object AS Object_Buh ON Object_Buh.Id = MILinkObject_Buh.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.ValueData ::integer = MovementItem.Id -- tmpMI.MovementItemId
                                   AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
            LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = MovementFloat_MovementItemId.MovementId
            LEFT JOIN Object AS Object_Status_ReturnIn ON Object_Status_ReturnIn.Id = Movement_ReturnIn.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_ReturnIn.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_ReturnIn.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalTo.Id
           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
     ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.03.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReestrReturn (inStartDate:= '20.10.2016', inEndDate:= '25.10.2016', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
