-- Function: gpSelect_Movement_AsinoPharmaSP()

DROP FUNCTION IF EXISTS gpSelect_Movement_AsinoPharmaSP (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_AsinoPharmaSP(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_AsinoPharmaSP());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
 
       SELECT Movement.Id                           AS Id
            , Movement.InvNumber                    AS InvNumber
            , Movement.OperDate                     AS OperDate
            , Object_Status.ObjectCode              AS StatusCode
            , Object_Status.ValueData               AS StatusName
            , MovementDate_OperDateStart.ValueData  AS OperDateStart
            , MovementDate_OperDateEnd.ValueData    AS OperDateEnd
            , Object_MedicalProgramSP.Id            AS MedicalProgramSPId
            , Object_MedicalProgramSP.ObjectCode    AS MedicalProgramSPCode
            , Object_MedicalProgramSP.ValueData     AS MedicalProgramSPName
            , MovementFloat_PercentMarkup.ValueData AS PercentMarkup

       FROM tmpStatus
            LEFT JOIN Movement ON Movement.DescId = zc_Movement_AsinoPharmaSP()
                              AND Movement.StatusId = tmpStatus.StatusId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()


       WHERE MovementDate_OperDateStart.ValueData <=inEndDate
         AND MovementDate_OperDateEnd.ValueData >= inStartDate 
            
            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.02.23                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_AsinoPharmaSP (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '3')