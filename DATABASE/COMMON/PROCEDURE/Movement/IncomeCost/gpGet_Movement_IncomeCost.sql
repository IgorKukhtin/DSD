---- Function: gpGet_Movement_IncomeCost()

DROP FUNCTION IF EXISTS gpGet_Movement_IncomeCost (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_IncomeCost(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , Comment TVarChar
             , MovementId_Master integer, InvNumber_Master_Full TVarChar, ItemName_Master TVarChar
             , MovementId_Income Integer, InvNumber_Income_Full TVarChar
             , ToId_Income Integer, ToName_Income TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN 
          -- Результат
     RETURN QUERY
         SELECT  0                                  AS Id
               , CAST (NEXTVAL ('Movement_IncomeCost_seq') AS TVarChar) AS InvNumber
               , inOperDate                         AS OperDate
               , CAST ('' as TVarChar) 		    AS Comment
              
               , 0                                  AS MovementId_Master
               , ''                    :: TVarChar  AS InvNumber_Master_Full
               , 'Документ затрат'     :: TVarChar  AS ItemName_Master

               , 0                                  AS MovementId_Income
               , ''                    :: TVarChar  AS InvNumber_Income_Full

               , 0                                  AS ToId_Income
               , ''                    :: TVarChar  AS ToName_Income
               ;
     ELSE
     -- Результат
     RETURN QUERY
         SELECT  Movement.Id                                   AS Id
               , Movement.InvNumber                            AS InvNumber
               , Movement.OperDate                             AS OperDate
               , MovementString_Comment.ValueData              AS Comment
              
               , Movement_Master.Id                            AS MovementId_Master
               , (' № ' || Movement_Master.InvNumber || ' от ' || Movement_Master.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Master_Full
               , MovementDescMaster.ItemName                   AS ItemName_Master

               , Movement_Income.Id                            AS MovementId_Income
               , ('№ ' || Movement_Income.InvNumber || ' от ' || Movement_Income.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Income_Full

               , Object_To.Id                                AS ToId_Income
               , Object_To.ValueData                         AS ToName_Income
          FROM Movement
             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
  
             LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                     ON MovementFloat_MovementId.MovementId = Movement.Id
                                    AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()

             LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = MovementFloat_MovementId.ValueData :: Integer

             LEFT JOIN MovementDesc AS MovementDescMaster ON MovementDescMaster.Id = Movement_Master.DescId

             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement_Master.Id
                                   AND MovementItem.DescId = zc_MI_Master()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId

             LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = Movement.ParentId
             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
             LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          WHERE Movement.DescId = zc_Movement_IncomeCost()
            AND Movement.Id = inMovementId
      ;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.02.19         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_IncomeCost (inMovementId := 12325439 , inOperDate:= '01.01.2018', inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpGet_Movement_IncomeCost (inMovementId := 0 , inOperDate:= '01.01.2018', inSession:= zfCalc_UserAdmin())
