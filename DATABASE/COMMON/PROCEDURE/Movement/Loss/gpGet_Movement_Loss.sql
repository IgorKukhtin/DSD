-- Function: gpGet_Movement_Loss()

DROP FUNCTION IF EXISTS gpGet_Movement_Loss (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Loss(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , ArticleLossId Integer, ArticleLossName TVarChar
             , Comment TVarChar
             , Checked Boolean
             , MovementId_Income Integer, InvNumber_IncomeFull TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Loss());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , CAST (0 AS TFloat)                               AS TotalCount
             , 0                     		                AS FromId
             , CAST ('' AS TVarChar) 	                        AS FromName
             , 0                     	 	                AS ToId
             , CAST ('' AS TVarChar) 	 	                AS ToName
             , 0                     		                AS ArticleLossId
             , CAST ('' AS TVarChar) 		                AS ArticleLossName
             , CAST ('' as TVarChar) 		                AS Comment
             , CAST (FALSE AS Boolean)         		        AS Checked
             , 0                                                AS MovementId_Income
             , CAST ('' AS TVarChar) 		                AS InvNumber_IncomeFull
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , Object_From.Id                                     AS FromId
           , Object_From.ValueData                              AS FromName
           , Object_To.Id                                       AS ToId
           , (Object_To.ValueData || CASE WHEN Object_Unit_CarTo.ValueData <> '' THEN ' (' || Object_Unit_CarTo.ValueData ||')' ELSE '' END) :: TVarChar AS ToName
           , Object_ArticleLoss.Id                              AS ArticleLossId
           , Object_ArticleLoss.ValueData                       AS ArticleLossName
           , MovementString_Comment.ValueData                   AS Comment
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked
           , COALESCE(Movement_Income.Id, -1)                         AS MovementId_Income
           , zfCalc_PartionMovementName (Movement_Income.DescId, MovementDesc_Income.ItemName, Movement_Income.InvNumber, Movement_Income.OperDate) :: TVarChar      AS InvNumber_IncomeFull
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId = Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CarTo_Unit
                                 ON ObjectLink_CarTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_CarTo_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object AS Object_Unit_CarTo ON Object_Unit_CarTo.Id = ObjectLink_CarTo_Unit.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Income
                                           ON MovementLinkMovement_Income.MovementId = Movement.Id
                                          AND MovementLinkMovement_Income.DescId     = zc_MovementLinkMovement_Income()
            LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MovementLinkMovement_Income.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Loss();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.02.17         *
 02.09.14                                                        *
 26.05.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Loss (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
