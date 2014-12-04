-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_Movement_Income (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Income());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_Income_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , CAST (False as Boolean)                          AS PriceWithVAT
             , 0                     				            AS FromId
             , CAST ('' AS TVarChar) 				            AS FromName
             , 0                     				            AS ToId
             , CAST ('' AS TVarChar) 				            AS ToName
             , 0                     				            AS NDSKindId
             , CAST ('' AS TVarChar) 				            AS NDSKindName

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementBoolean_PriceWithVAT.ValueData             AS PriceWithVAT
           , Object_From.Id                                     AS FromId
           , Object_From.ValueData                              AS FromName
           , Object_To.Id                                       AS ToId
           , Object_To.ValueData                                AS ToName
           , Object_NDSKind.Id                                  AS NDSKindId
           , Object_NDSKind.ValueData                           AS NDSKindName

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                         ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()

            LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId


            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()


       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Income();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Income (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.07.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Income (inMovementId:= 1, inSession:= '9818')