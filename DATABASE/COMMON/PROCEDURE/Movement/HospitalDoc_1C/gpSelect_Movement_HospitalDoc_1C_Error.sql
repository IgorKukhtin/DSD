-- Function: gpSelect_Movement_HospitalDoc_1C_Error()

DROP FUNCTION IF EXISTS gpSelect_Movement_HospitalDoc_1C_Error (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_HospitalDoc_1C_Error(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Error_text TBlob
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsAccessKey_HospitalDoc_1C Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_HospitalDoc_1C());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                             JOIN Movement ON Movement.DescId = zc_Movement_HospitalDoc_1C()
                                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                          AND Movement.StatusId = tmpStatus.StatusId
                        )
 
        , tmpMovementString AS (SELECT * 
                                FROM MovementString 
                                WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementString.DescId IN (zc_MovementString_Error()
                                                               )
                                )

        , tmpMLO AS (SELECT * 
                     FROM MovementLinkObject 
                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementLinkObject.DescId IN (zc_MovementLinkObject_Personal()
                                                        )
                         )
        
       -- Результат
       SELECT STRING_AGG (Object_Personal.ValueData||' - '|| MovementString_Error.ValueData, CHR (13)) ::TBlob AS Error_text
       FROM tmpMovement AS Movement
            INNER JOIN tmpMovementString AS MovementString_Error
                                         ON MovementString_Error.MovementId = Movement.Id
                                        AND MovementString_Error.DescId = zc_MovementString_Error()

            LEFT JOIN tmpMLO AS MovementLinkObject_Personal
                             ON MovementLinkObject_Personal.MovementId = Movement.Id
                            AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_HospitalDoc_1C_Error (inStartDate:= '01.05.2025', inEndDate:= '01.08.2025', inIsErased:=true, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
