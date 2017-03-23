-- Function: gpSelect_Movement_Invoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalSumm TFloat
             , JuridicalId Integer
             , JuridicalName TVarChar
             , PartnerMedicalId Integer
             , PartnerMedicalName TVarChar
             , ContractId Integer
             , ContractName TVarChar

             , OperDateStart TDateTime
             , OperDateEnd TDateTime

             , DateRegistered TDateTime
             , InvNumberRegistered TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbContractId Integer;   
BEGIN

     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     -- Ограничение - если роль Кассир аптеки
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 308121 AND UserId = vbUserId)
     THEN
         vbContractId:= zfConvert_StringToNumber (lpGet_DefaultValue ('zc_Object_Contract', vbUserId));
     ELSE
         vbContractId:= 0;
     END IF;


     -- Результат
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        -- Результат
    SELECT     
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , Object_Status.ObjectCode                               AS StatusCode
      , Object_Status.ValueData                                AS StatusName
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat  AS TotalSumm
      , MovementLinkObject_Juridical.ObjectId                  AS JuridicalId
      , Object_Juridical.ValueData                             AS JuridicalName
      , Object_PartnerMedical.Id                               AS PartnerMedicalId  
      , Object_PartnerMedical.ValueData                        AS PartnerMedicalName 
      , MovementLinkObject_Contract.ObjectId                   AS ContractId
      , Object_Contract.ValueData                              AS ContractName
      , MovementDate_OperDateStart.ValueData                   AS OperDateStart
      , MovementDate_OperDateEnd.ValueData                     AS OperDateStart

      , MovementDate_DateRegistered.ValueData                  AS DateRegistered
      , MovementString_InvNumberRegistered.ValueData           AS InvNumberRegistered
    FROM tmpStatus
        INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                           AND Movement.DescId = zc_Movement_Invoice()
                           AND Movement.OperDate >= inStartDate AND Movement.OperDate <inEndDate + interval '1 day'
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
        
        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                               ON MovementDate_OperDateStart.MovementId = Movement.Id
                              AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                               ON MovementDate_OperDateEnd.MovementId = Movement.Id
                              AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

        LEFT JOIN MovementDate AS MovementDate_DateRegistered
                               ON MovementDate_DateRegistered.MovementId = Movement.Id
                              AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

        LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                 ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                     ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                    AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
        LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Invoice (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 22.03.17         *
*/

-- тест
--SELECT * FROM gpSelect_Movement_Invoice (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin());