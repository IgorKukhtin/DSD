-- Function: gpGet_Movement_ProductionUnion()

-- DROP FUNCTION gpGet_Movement_ProductionUnion (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProductionUnion (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProductionUnion (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ProductionUnion(
    IN inMovementId  Integer,       -- ключ Документа
    IN inOperDate    TDateTime,     -- дата Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , isAuto Boolean, InsertDate TDateTime
             , MovementId_Master Integer, InvNumber_MasterFull TVarChar
               )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProductionUnion());
     vbUserId := inSession;
     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_productionunion_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                     			        AS FromId
             , CAST ('' AS TVarChar) 			        AS FromName
             , 0                     			        AS ToId
             , CAST ('' AS TVarChar) 				AS ToName
             , 0                                                AS DocumentKindId
             , CAST ('' AS TVarChar) 				AS DocumentKindName
             , CAST (False as Boolean)                          AS isAuto
             , Null:: TDateTime                                 AS InsertDate

             , 0                                                AS MovementId_Master
             , CAST ('' AS TVarChar) 				AS InvNumber_MasterFull

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     RETURN QUERY
     SELECT
           Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , Object_Status.ObjectCode                 AS StatusCode
         , Object_Status.ValueData                  AS StatusName
         , Object_From.Id                           AS FromId
         , Object_From.ValueData                    AS FromName
         , Object_To.Id                             AS ToId
         , Object_To.ValueData                      AS ToName
         , Object_DocumentKind.Id                   AS DocumentKindId
         , Object_DocumentKind.ValueData            AS DocumentKindName
         , COALESCE(MovementBoolean_isAuto.ValueData, False)         AS isAuto
         , COALESCE(MovementDate_Insert.ValueData,  Null:: TDateTime) AS InsertDate

         , Movement_DocumentMaster.Id               AS MovementId_Master
         , zfCalc_PartionMovementName (Movement_DocumentMaster.DescId, MovementDesc_Master.ItemName, Movement_DocumentMaster.InvNumber, Movement_DocumentMaster.OperDate) AS InvNumber_MasterFull

     FROM Movement
          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                       ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                      AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
          LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

          LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                    ON MovementBoolean_isAuto.MovementId = Movement.Id
                                   AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

          LEFT JOIN MovementDate AS MovementDate_Insert
                                 ON MovementDate_Insert.MovementId = Movement.Id
                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementId = Movement.Id
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
          LEFT JOIN MovementDesc AS MovementDesc_Master ON MovementDesc_Master.Id = Movement_DocumentMaster.DescId

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ProductionUnion();

     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_ProductionUnion (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.06.16         *
 13.06.16         *
 23.06.14                                                        *
 16.07.13         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_ProductionUnion (inMovementId := 0, inOperDate := '01.01.2014', inSession:= '2')