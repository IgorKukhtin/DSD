-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummPacker TFloat, TotalSummSpending TFloat, TotalSummVAT TFloat
             , FromName TVarChar, ToName TVarChar
             , PaidKindName TVarChar, ContractName TVarChar
             , PersonalPackerName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY 
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

           , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData          AS VATPercent
           , MovementFloat_ChangePercent.ValueData       AS ChangePercent

           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData       AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData       AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData           AS TotalSumm
           , MovementFloat_TotalSummPacker.ValueData     AS TotalSummPacker
           , MovementFloat_TotalSummSpending.ValueData   AS TotalSummSpending
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT


           , Object_From.ValueData             AS FromName
           , Object_To.ValueData               AS ToName
           , Object_PaidKind.ValueData         AS PaidKindName
           , Object_Contract.ValueData         AS ContractName
           , View_PersonalPacker.PersonalName  AS PersonalPackerName
       FROM Movement
            -- JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPacker
                                    ON MovementFloat_TotalSummPacker.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPacker.DescId = zc_MovementFloat_TotalSummPacker()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSpending
                                    ON MovementFloat_TotalSummSpending.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummSpending.DescId = zc_MovementFloat_TotalSummSpending()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalPacker
                                         ON MovementLinkObject_PersonalPacker.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()
            LEFT JOIN Object_Personal_View AS View_PersonalPacker ON View_PersonalPacker.PersonalId = MovementLinkObject_PersonalPacker.ObjectId

       WHERE Movement.DescId = zc_Movement_Income()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Income (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.12.13                                        * del Object_RoleAccessKey_View
 14.12.13                                        * add Object_RoleAccessKey_View
 23.10.13                                        * add zfConvert_StringToNumber
 07.10.13                                        * add lpCheckRight
 30.09.13                                        * add Object_Personal_View
 30.09.13                                        * del zc_MovementLinkObject_PersonalDriver
 27.09.13                                        * del zc_MovementLinkObject_Car
 07.07.13                                        *
 30.06.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= zfCalc_UserAdmin())
