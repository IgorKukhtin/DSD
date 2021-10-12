-- Function: gpSelect_Movement_GoodsSP_Cash()

DROP FUNCTION IF EXISTS gpSelect_Movement_GoodsSP_Cash (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_GoodsSP_Cash(
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
             , MedicalProgramSPId Integer, MedicalProgramSPCode Integer, MedicalProgramSPName TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       ),
          tmpMedicalProgramSP AS (SELECT DISTINCT ObjectLink_MedicalProgramSP.ChildObjectId AS MedicalProgramSPId
                                  FROM Object AS Object_MedicalProgramSPLink
                                       LEFT JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                                                            ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                                                           AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
                                       LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                                           AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                                  WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()   
                                    AND Object_MedicalProgramSPLink.isErased = False        
                                    AND ObjectLink_Unit.ChildObjectId = vbUnitId
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

       FROM tmpStatus
            LEFT JOIN Movement ON Movement.DescId = zc_Movement_GoodsSP()
                              AND Movement.StatusId = tmpStatus.StatusId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                         ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                        AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
            LEFT JOIN Object AS Object_MedicalProgramSP ON Object_MedicalProgramSP.Id = MLO_MedicalProgramSP.ObjectId  

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
            INNER JOIN tmpMedicalProgramSP ON tmpMedicalProgramSP.MedicalProgramSPId = MLO_MedicalProgramSP.ObjectId
            
       WHERE MovementDate_OperDateStart.ValueData <= CURRENT_DATE
         AND MovementDate_OperDateEnd.ValueData >= CURRENT_DATE 
            
            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.19         * период ограничивать нач/оконч действия СП
 13.08.18         *
*/

-- тест
--
 SELECT * FROM gpSelect_Movement_GoodsSP_Cash (inIsErased := FALSE, inSession:= '3')