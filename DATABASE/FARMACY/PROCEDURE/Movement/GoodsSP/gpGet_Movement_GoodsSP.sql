-- Function: gpGet_Movement_GoodsSP()

DROP FUNCTION IF EXISTS gpGet_Movement_GoodsSP (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_GoodsSP (Integer, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_GoodsSP(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMask              Boolean  ,
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
             , MedicalProgramSPId Integer, MedicalProgramSPCode Integer, MedicalProgramSPName TVarChar
             , PercentMarkup TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession;

     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_GoodsSP_Mask (ioId        := inMovementId
                                                   , inOperDate  := inOperDate
                                                   , inSession   := inSession); 
     END IF;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT 0                            AS Id
              , CAST (NEXTVAL ('Movement_GoodsSP_seq') AS TVarChar) AS InvNumber
              , CURRENT_DATE::TDateTime      AS OperDate
              , Object_Status.Code           AS StatusCode
              , Object_Status.Name           AS StatusName
              , CURRENT_DATE::TDateTime      AS OperDateStart
              , CURRENT_DATE::TDateTime      AS OperDateEnd
              , 0                            AS MedicalProgramSPId
              , 0                            AS MedicalProgramSPCode
              , ''::TVarChar                 AS MedicalProgramSPName
              , 0::TFloat                    AS PercentMarkup
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     
     RETURN QUERY
         SELECT Movement.Id                            AS Id
              , Movement.InvNumber                     AS InvNumber
              , Movement.OperDate                      AS OperDate
              , Object_Status.ObjectCode               AS StatusCode
              , Object_Status.ValueData                AS StatusName
              , MovementDate_OperDateStart.ValueData   AS OperDateStart
              , MovementDate_OperDateEnd.ValueData     AS OperDateEnd
              , Object_MedicalProgramSP.Id            AS MedicalProgramSPId
              , Object_MedicalProgramSP.ObjectCode    AS MedicalProgramSPCode
              , Object_MedicalProgramSP.ValueData     AS MedicalProgramSPName
              , MovementFloat_PercentMarkup.ValueData AS PercentMarkup
  
         FROM Movement
               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
   
               LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                      ON MovementDate_OperDateStart.MovementId = Movement.Id
                                     AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
   
               LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                      ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                     AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

               LEFT JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                            ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                           AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
               LEFT JOIN Object AS Object_MedicalProgramSP ON Object_MedicalProgramSP.Id = MLO_MedicalProgramSP.ObjectId  

               LEFT JOIN MovementFloat AS MovementFloat_PercentMarkup
                                       ON MovementFloat_PercentMarkup.MovementId = Movement.Id
                                      AND MovementFloat_PercentMarkup.DescId = zc_MovementFloat_PercentMarkup()
                                      
         WHERE Movement.Id = inMovementId
           AND Movement.DescId = zc_Movement_GoodsSP();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.08.18         *
 */

-- тест
-- SELECT * FROM gpGet_Movement_GoodsSP (inMovementId:= 1, inOperDate:= '01.01.2018', inSession:= '3')